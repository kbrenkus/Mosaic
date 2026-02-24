import azure.functions as func
import json
import logging
import os
import re
from azure.storage.blob import BlobServiceClient

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

STORAGE_CONN_STR = os.environ.get("AZURE_STORAGE_CONNECTION_STRING", "")
CONTAINER_NAME = "reference-files"

# ---------------------------------------------------------------------------
# Blob helpers
# ---------------------------------------------------------------------------

def get_blob_client():
    return BlobServiceClient.from_connection_string(STORAGE_CONN_STR)


def list_available_files() -> list[str]:
    try:
        client = get_blob_client()
        container = client.get_container_client(CONTAINER_NAME)
        return sorted(b.name for b in container.list_blobs())
    except Exception as exc:
        logging.error("list_available_files error: %s", exc)
        return []


def read_file(file_name: str) -> str | None:
    """Return file content, or None if not found."""
    try:
        client = get_blob_client()
        blob = client.get_blob_client(container=CONTAINER_NAME, blob=file_name)
        return blob.download_blob().readall().decode("utf-8")
    except Exception:
        return None


# ---------------------------------------------------------------------------
# Section parser
# ---------------------------------------------------------------------------

# Matches numbered headers in two formats:
#   ## 1. Title          (most reference files)
#   ### 1.1 Title        (subsections)
#   ## §1 Title          (§ prefix variant, kept for compat)
# Captures the number without trailing period.
_HEADER_RE = re.compile(
    r"^(#{2,4})\s*[§S]?\s*(\d[\d.]*?)\.?\s+(.+)$",
    re.MULTILINE,
)


def _header_depth(hashes: str) -> int:
    return len(hashes)


def parse_sections(text: str) -> list[dict]:
    """
    Returns a list of dicts:
      { "ref": "1.2", "title": "Some Title", "level": 3, "start": char_pos, "end": char_pos }
    """
    sections = []
    for m in _HEADER_RE.finditer(text):
        sections.append({
            "ref": m.group(2),
            "title": m.group(3).strip(),
            "level": _header_depth(m.group(1)),
            "start": m.start(),
            "match_end": m.end(),
        })

    # Compute end of each section = start of next header at same or higher level (lower number)
    for i, sec in enumerate(sections):
        end = len(text)
        for j in range(i + 1, len(sections)):
            if sections[j]["level"] <= sec["level"]:
                end = sections[j]["start"]
                break
        sec["end"] = end

    return sections


def get_section(file_name: str, section_ref: str) -> dict:
    """
    Returns {"content": str} on success.
    Returns {"error": str, "available_files"|"available_sections": list} on failure.
    """
    # Normalize file name — accept with or without extension, always resolve to .md
    if file_name.endswith(".txt"):
        file_name = file_name[:-4] + ".md"
    elif not file_name.endswith(".md"):
        file_name = file_name + ".md"

    text = read_file(file_name)
    if text is None:
        available = list_available_files()
        return {
            "error": f"File '{file_name}' not found.",
            "available_files": available,
        }

    sections = parse_sections(text)

    # Match section_ref — normalize whitespace and leading zeros
    target = section_ref.strip()

    matched = None
    for sec in sections:
        if sec["ref"] == target:
            matched = sec
            break

    if matched is None:
        available_refs = [f"§{s['ref']} {s['title']}" for s in sections]
        return {
            "error": f"Section '{section_ref}' not found in '{file_name}'.",
            "available_sections": available_refs,
        }

    # Extract the section content (include the header line)
    content = text[matched["start"]:matched["end"]].strip()

    # Guard against huge sections (unlikely but defensive)
    if len(content) > 8000:
        content = content[:8000] + "\n\n[... truncated — request a more specific sub-section]"

    return {"content": content}


# ---------------------------------------------------------------------------
# MCP protocol handlers
# ---------------------------------------------------------------------------

MCP_TOOLS = [
    {
        "name": "get_section",
        "description": (
            "Retrieve a specific section from a Mosaic reference file stored in Azure Blob Storage. "
            "Use this instead of loading entire files. Specify the file name (without path) and the "
            "section reference number (e.g. '1', '2.3', '4.1.2'). "
            "Returns the section text. If the file or section is not found, returns helpful context "
            "listing available files or sections."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "file_name": {
                    "type": "string",
                    "description": "File name in the reference-files container, e.g. 'ORG-CLIENTS'. The .md extension is optional.",
                },
                "section_ref": {
                    "type": "string",
                    "description": "Section number such as '1', '2', '1.1', or '3.2'. Use just the number — no § symbol, no trailing period. To discover section numbers, call get_section with any value and the error response will list available sections.",
                },
            },
            "required": ["file_name", "section_ref"],
        },
    }
]


def handle_initialize(req_id, params):
    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "result": {
            "protocolVersion": "2024-11-05",
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "mosaic-mcp-server", "version": "1.0.0"},
        },
    }


def handle_list_tools(req_id, params):
    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "result": {"tools": MCP_TOOLS},
    }


def handle_call_tool(req_id, params):
    tool_name = params.get("name")
    arguments = params.get("arguments", {})

    if tool_name == "get_section":
        file_name = arguments.get("file_name", "")
        section_ref = arguments.get("section_ref", "")
        if not file_name or not section_ref:
            return _error_response(req_id, -32602, "Missing required arguments: file_name and section_ref")
        result = get_section(file_name, section_ref)
        text_out = json.dumps(result, ensure_ascii=False)
    else:
        return _error_response(req_id, -32601, f"Unknown tool: {tool_name}")

    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "result": {
            "content": [{"type": "text", "text": text_out}],
            "isError": "error" in result,
        },
    }


def _error_response(req_id, code: int, message: str):
    return {
        "jsonrpc": "2.0",
        "id": req_id,
        "error": {"code": code, "message": message},
    }


HANDLERS = {
    "initialize": handle_initialize,
    "tools/list": handle_list_tools,
    "tools/call": handle_call_tool,
}


# ---------------------------------------------------------------------------
# Azure Function HTTP trigger
# ---------------------------------------------------------------------------

@app.route(route="mcp", methods=["POST"])
def mcp_endpoint(req: func.HttpRequest) -> func.HttpResponse:
    try:
        body = req.get_json()
    except ValueError:
        return func.HttpResponse(
            json.dumps({"error": "Invalid JSON"}),
            status_code=400,
            mimetype="application/json",
        )

    method = body.get("method")
    req_id = body.get("id")
    params = body.get("params", {})

    handler = HANDLERS.get(method)
    if handler is None:
        response = _error_response(req_id, -32601, f"Method not found: {method}")
    else:
        try:
            response = handler(req_id, params)
        except Exception as exc:
            logging.exception("Handler error for method %s", method)
            response = _error_response(req_id, -32603, f"Internal error: {exc}")

    return func.HttpResponse(
        json.dumps(response, ensure_ascii=False),
        status_code=200,
        mimetype="application/json",
    )
