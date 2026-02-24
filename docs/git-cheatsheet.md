# Git Cheat Sheet

A plain-language reference for common git operations in a Mosaic workflow. Two repos are involved:

- **Instance repo** (private) — your day-to-day workspace
- **Shared repo** (public) — the Mosaic methodology, updated less frequently

## Starting a Session

```bash
# Pull latest changes before doing any work
cd your-instance/
git pull
```

If `git pull` says "Already up to date" — you're good. If it pulls changes, review what changed:

```bash
git log --oneline -5    # See recent commits
```

## Saving Your Work

```bash
# 1. See what changed
git status

# 2. Stage specific files (preferred over "git add .")
git add reference/ORG-TEAMS.md kernel/ORG-DOMAIN-ROUTER.md

# 3. Commit with a descriptive message
git commit -m "Update ORG-TEAMS with new hire data, bump DOMAIN-ROUTER routing"

# 4. Push to remote
git push
```

**Tip:** Stage specific files by name rather than `git add .` or `git add -A`. This prevents accidentally committing sensitive files, large binaries, or work-in-progress changes.

## Checking What Changed

```bash
# What files are modified/untracked?
git status

# What are the actual changes? (unstaged)
git diff

# What's already staged for commit?
git diff --staged

# Recent commit history
git log --oneline -10

# What changed in a specific commit?
git show abc1234
```

## Getting Updates from the Shared Repo

When the shared Mosaic repo has a new version of the reasoning kernel:

```bash
# 1. Pull the latest shared repo
cd Mosaic/
git pull

# 2. Check the version
head -5 core/MOSAIC-REASONING.md

# 3. Copy to your instance
cp core/MOSAIC-REASONING.md ../your-instance/MOSAIC-REASONING.md

# 4. Commit in your instance
cd ../your-instance/
git add MOSAIC-REASONING.md
git commit -m "Update MOSAIC-REASONING to v1.4"
git push
```

Then upload the new file to Claude.ai project knowledge and update your maintenance manifest.

## When Something Goes Wrong

### "I committed but haven't pushed yet and want to undo"

```bash
# Undo the last commit but keep the changes as unstaged
git reset --soft HEAD~1
```

### "I have uncommitted changes I want to discard"

```bash
# Discard changes to a specific file
git checkout -- reference/ORG-TEAMS.md

# Discard ALL uncommitted changes (careful!)
git checkout .
```

### "I got a merge conflict"

This happens when both you and someone else changed the same file. Git marks the conflicts:

```
<<<<<<< HEAD
Your version of the line
=======
The other version of the line
>>>>>>> origin/main
```

To resolve:
1. Open the file and decide which version to keep (or combine them)
2. Remove the `<<<<<<<`, `=======`, and `>>>>>>>` markers
3. Stage and commit the resolved file

**Ask Claude Code for help** — it can read the conflict markers and suggest resolutions.

### "Git says 'divergent branches' on pull"

```bash
# Merge remote changes into your local branch
git pull --no-rebase
```

If conflicts appear, resolve them as described above.

## What NEVER to Do

| Command | Why It's Dangerous |
|---------|-------------------|
| `git push --force` | Overwrites remote history. Other tools/sessions may lose work. |
| `git reset --hard` | Permanently deletes uncommitted changes. No recovery. |
| `rm -rf .git/` | Destroys the entire repository history. |
| `git rebase` (on shared branches) | Rewrites history that others may depend on. |
| `git clean -f` | Permanently deletes untracked files. |

**If git gives you an error you don't understand, stop and ask.** Claude Code can diagnose and suggest safe fixes. Forcing through errors usually makes things worse.

## Quick Reference

| Task | Command |
|------|---------|
| Start session | `git pull` |
| See changes | `git status` |
| Stage files | `git add file1.md file2.md` |
| Commit | `git commit -m "description"` |
| Push | `git push` |
| View history | `git log --oneline -10` |
| Undo last commit (not pushed) | `git reset --soft HEAD~1` |
| Discard file changes | `git checkout -- filename` |
