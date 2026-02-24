# prepare_upload.ps1 (TEMPLATE)
# Stages agent files for upload to Claude.ai, Copilot agent knowledge, and Copilot Studio.
# Auto-syncs retrieval files to Azure Blob for MCP access by both agents.
#
# CONFIGURATION REQUIRED: Replace all {ORG} placeholders with your organization prefix.
# Update storage account name, resource group, and platform config paths.
#
# Three upload targets:
#   1. Claude.ai project knowledge - 6 kernel .md files (manual upload)
#   2. Copilot agent knowledge    - 6 kernel .txt files (manual upload, generated from .md)
#   3. Azure Blob                 - all retrieval .md files (auto-synced)
#
# Plus two paste targets extracted from platform config files:
#   - Claude.ai project instructions (from {ORG}-CLAUDE-PLATFORM-CONFIG.md)
#   - Copilot Studio description + instructions (from {ORG}-COPILOT-PLATFORM-CONFIG.md)
#
# Usage: .\scripts\prepare_upload.ps1
# Run from the project root directory at end of work session.

param(
    [switch]$SkipBlob   # Skip Azure Blob sync (use when Azure CLI not available)
)

$ErrorActionPreference = "Stop"
$AgentDir = Split-Path -Parent $PSScriptRoot
$UploadDir = Join-Path $AgentDir "upload"

# === Clean and recreate upload/ ===
if (Test-Path $UploadDir) { Remove-Item $UploadDir -Recurse -Force }
New-Item -ItemType Directory -Path $UploadDir | Out-Null

# === CONFIGURATION: Kernel file manifest ===
# 6 files loaded into Claude.ai project knowledge (.md) AND Copilot agent knowledge (.txt)
# MOSAIC-REASONING.md = shared reasoning kernel (company-agnostic, versioned independently)
# Remaining 5 = instance files (company-specific)
# Claude gets {ORG}-CLAUDE-BEHAVIORS; Copilot gets {ORG}-COPILOT-BEHAVIORS

$SharedKernelFiles = @(
    "MOSAIC-REASONING.md",
    "{ORG}-INDEX.md",
    "kernel\{ORG}-TAXONOMY-QUICK.md",
    "kernel\{ORG}-A2A-QUICK.md",
    "kernel\{ORG}-DOMAIN-ROUTER.md"
)

$ClaudeBehaviors = "kernel\{ORG}-CLAUDE-BEHAVIORS.md"
$CopilotBehaviors = "agent\{ORG}-COPILOT-BEHAVIORS.md"

# === CONFIGURATION: Azure Blob settings ===
$storageAccount = "{org}mcpstore"       # Your Azure Storage account name
$container = "reference-files"
$resourceGroup = "{org}-mcp"            # Your Azure resource group

# Files that should NOT be synced to blob (kernel-only files)
$blobExcludes = @(
    "MOSAIC-REASONING.md",
    "{ORG}-INDEX.md",
    "{ORG}-DOMAIN-ROUTER.md",
    "{ORG}-TAXONOMY-QUICK.md",
    "{ORG}-A2A-QUICK.md"
)

# === 1. Claude.ai staging (6 kernel .md files) ===
Write-Host "`n=== Claude.ai Project Knowledge (6 .md files) ===" -ForegroundColor Cyan
$claudeDir = Join-Path $UploadDir "Claude.ai"
New-Item -ItemType Directory -Path $claudeDir | Out-Null

$allClaudeFiles = $SharedKernelFiles + @($ClaudeBehaviors)
foreach ($relPath in $allClaudeFiles) {
    $src = Join-Path $AgentDir $relPath
    if (Test-Path $src) {
        $name = Split-Path $src -Leaf
        Copy-Item $src (Join-Path $claudeDir $name)
        $size = [math]::Round((Get-Item $src).Length / 1024, 1)
        Write-Host "  $name - $size KB"
    } else {
        Write-Warning "  MISSING: $relPath"
    }
}

# === 2. Copilot agent knowledge staging (6 kernel .txt files, generated from .md) ===
Write-Host "`n=== Copilot Agent Knowledge (6 .txt files) ===" -ForegroundColor Cyan
$copilotDir = Join-Path $UploadDir "Copilot"
New-Item -ItemType Directory -Path $copilotDir | Out-Null

$allCopilotFiles = $SharedKernelFiles + @($CopilotBehaviors)
foreach ($relPath in $allCopilotFiles) {
    $src = Join-Path $AgentDir $relPath
    if (Test-Path $src) {
        $mdName = Split-Path $src -Leaf
        $txtName = [System.IO.Path]::ChangeExtension($mdName, ".txt")
        $dest = Join-Path $copilotDir $txtName
        Copy-Item $src $dest
        $size = [math]::Round((Get-Item $src).Length / 1024, 1)
        Write-Host "  $txtName - $size KB (from $mdName)"
    } else {
        Write-Warning "  MISSING: $relPath"
    }
}

# === 3. Azure Blob sync (MCP server reference files) ===
if ($SkipBlob) {
    Write-Host "`n=== Azure Blob Sync ===" -ForegroundColor Cyan
    Write-Host "  SKIPPED (-SkipBlob flag). Commit and push to git; run full sync later."
} else {
    Write-Host "`n=== Azure Blob Sync (MCP server) ===" -ForegroundColor Cyan
    # CONFIGURATION: Update az CLI path if needed
    $azCmd = "az"
    # If az is not in PATH, use full path:
    # $azCmd = "C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"
    $azFound = $false
    try { & $azCmd --version 2>&1 | Out-Null; $azFound = $true } catch {}
    if ($azFound) {
        $blobKey = & $azCmd storage account keys list `
            --account-name $storageAccount `
            --resource-group $resourceGroup `
            --query "[0].value" --output tsv 2>&1

        if ($blobKey -and $blobKey -notmatch "ERROR") {
            # CONFIGURATION: Update paths to match your directory structure
            $blobFiles = Get-ChildItem -Path @(
                "$AgentDir\reference\*.md",
                "$AgentDir\clients\intelligence\*.md",
                "$AgentDir\clients\profiles\*.md"
            ) -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $blobExcludes }
            $blobCount = 0
            $prevPref = $ErrorActionPreference
            $ErrorActionPreference = "Continue"
            foreach ($bf in $blobFiles) {
                & $azCmd storage blob upload --account-name $storageAccount --container-name $container --name $bf.Name --file $bf.FullName --account-key $blobKey --overwrite --output none 2>$null
                $blobCount++
            }
            $ErrorActionPreference = $prevPref
            Write-Host ("  " + $blobCount + " files synced to blob storage (" + $storageAccount + "/" + $container + ")")
        } else {
            Write-Warning "  Blob sync skipped - could not retrieve storage account key"
        }
    } else {
        Write-Warning "  Blob sync skipped - az CLI not found"
        Write-Host "  Install Azure CLI or set the full path to az.cmd in this script"
    }
}

# === 4. Copilot Studio agent config ===
Write-Host "`n=== Copilot Studio Agent Config ===" -ForegroundColor Cyan
$csDir = Join-Path $UploadDir "Copilot Studio"
New-Item -ItemType Directory -Path $csDir | Out-Null

# CONFIGURATION: Update platform config path
$agentConfig = Join-Path $AgentDir "agent\platform-config\{ORG}-COPILOT-PLATFORM-CONFIG.md"
if (Test-Path $agentConfig) {
    $content = Get-Content $agentConfig -Raw
    $marker = "=== COPILOT STUDIO: INSTRUCTIONS ==="
    $markerIdx = $content.IndexOf($marker)
    if ($markerIdx -ge 0) {
        $descMarker = "=== COPILOT STUDIO: DESCRIPTION ==="
        $descStart = $content.IndexOf($descMarker)
        if ($descStart -ge 0) {
            $descText = $content.Substring($descStart + $descMarker.Length, $markerIdx - $descStart - $descMarker.Length).Trim()
        } else {
            $descText = ""
        }
        $instrText = $content.Substring($markerIdx + $marker.Length).Trim()
        $descFile = Join-Path $csDir "agent-description.txt"
        $instrFile = Join-Path $csDir "agent-instructions.txt"
        Set-Content $descFile $descText -NoNewline
        Set-Content $instrFile $instrText -NoNewline
        $descCount = $descText.Length
        $instrCount = $instrText.Length
        Write-Host "  agent-description.txt ($descCount chars) -- paste into Description field"
        Write-Host "  agent-instructions.txt ($instrCount / 8,000 chars) -- paste into Instructions field"
        if ($instrCount -gt 8000) {
            Write-Warning "  OVER LIMIT: Instructions $instrCount chars exceeds 8,000 char limit!"
        }
    } else {
        $outFile = Join-Path $csDir "agent-config.txt"
        Set-Content $outFile $content -NoNewline
        $charCount = $content.Length
        Write-Host "  agent-config.txt ($charCount / 8,000 chars)"
        Write-Warning "  No section markers found -- outputting as single file"
        if ($charCount -gt 8000) {
            Write-Warning "  OVER LIMIT: $charCount chars exceeds 8,000 char Copilot Studio limit!"
        }
    }
} else {
    Write-Warning ("  MISSING: agent\platform-config\{ORG}-COPILOT-PLATFORM-CONFIG.md")
}

# === 5. Claude.ai project instructions ===
Write-Host "`n=== Claude.ai Project Config ===" -ForegroundColor Cyan
$cpDir = Join-Path $UploadDir "Claude.ai Project"
New-Item -ItemType Directory -Path $cpDir | Out-Null

# CONFIGURATION: Update platform config path
$claudeProject = Join-Path $AgentDir "agent\platform-config\{ORG}-CLAUDE-PLATFORM-CONFIG.md"
if (Test-Path $claudeProject) {
    $content = Get-Content $claudeProject -Raw
    $marker = "=== CLAUDE.AI PROJECT: INSTRUCTIONS ==="
    $markerIdx = $content.IndexOf($marker)
    if ($markerIdx -ge 0) {
        $instrText = $content.Substring($markerIdx + $marker.Length).Trim()
        $instrFile = Join-Path $cpDir "project-instructions.txt"
        Set-Content $instrFile $instrText -NoNewline
        $instrCount = $instrText.Length
        Write-Host "  project-instructions.txt ($instrCount chars) -- paste into project instructions"
    } else {
        $outFile = Join-Path $cpDir "project-instructions.txt"
        $text = $content.Trim()
        Set-Content $outFile $text -NoNewline
        Write-Host "  project-instructions.txt ($($text.Length) chars)"
        Write-Warning "  No section marker found -- outputting full file"
    }
} else {
    Write-Warning ("  MISSING: agent\platform-config\{ORG}-CLAUDE-PLATFORM-CONFIG.md")
}

# === 6. Summary ===
Write-Host "`n=== Upload Summary ===" -ForegroundColor Green
Write-Host "Upload folder: $UploadDir"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Claude.ai:      Upload 6 .md files from upload\Claude.ai\ to project knowledge"
Write-Host "                     Paste upload\Claude.ai Project\project-instructions.txt into project instructions"
Write-Host "  2. Copilot:        Upload 6 .txt files from upload\Copilot\ to agent knowledge"
Write-Host "  3. Copilot Studio: Paste upload\Copilot Studio\agent-description.txt into Description"
Write-Host "                     Paste upload\Copilot Studio\agent-instructions.txt into Instructions"
if ($SkipBlob) {
    Write-Host "  4. Blob:           DEFERRED -- run without -SkipBlob when Azure CLI is available"
} else {
    Write-Host "  4. Blob:           Auto-synced (done)"
}
Write-Host ""

# Show recently modified source files (last 24 hours)
Write-Host "--- Recently Modified Source Files (last 24h) ---" -ForegroundColor Yellow
$cutoff = (Get-Date).AddHours(-24)
Get-ChildItem $AgentDir -Recurse -Filter "*.md" |
    Where-Object { $_.LastWriteTime -gt $cutoff -and $_.DirectoryName -notlike "*upload*" } |
    Sort-Object LastWriteTime -Descending |
    ForEach-Object {
        $rel = $_.FullName.Replace($AgentDir, "").TrimStart("\")
        $time = $_.LastWriteTime.ToString("HH:mm")
        $size = [math]::Round($_.Length / 1024, 1)
        Write-Host "  $time  $size KB  $rel"
    }

# Total size check
Write-Host "`n--- Claude.ai Budget Check ---" -ForegroundColor Yellow
$totalKB = 0
Get-ChildItem (Join-Path $UploadDir "Claude.ai") -Filter "*.md" | ForEach-Object {
    $totalKB += $_.Length / 1024
}
$totalKB = [math]::Round($totalKB, 1)
Write-Host "  Total project knowledge: $totalKB KB (budget: ~200 KB)"
if ($totalKB -gt 200) {
    Write-Warning ("  OVER BUDGET by " + [math]::Round($totalKB - 200, 1) + " KB")
}
