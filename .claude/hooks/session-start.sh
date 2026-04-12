#!/usr/bin/env bash
# SessionStart hook — bootstraps simon-stack on every Claude Code session.
#
# What it does (idempotent):
#   1. Backup existing ~/.claude (if present)
#   2. Install Gstack runtime (~/.claude/skills/gstack/) + bun install
#   3. Expose individual Gstack skills at ~/.claude/skills/<name>/
#   4. Copy simon-stack skills from this repo to ~/.claude/skills/
#   5. Seed ~/.claude/instincts/ with this repo's seed files
#   6. Create ~/.claude/CLAUDE.md from templates/CLAUDE.md
#   7. Install ~/.claude/session-start-instincts.sh (for user-level hook)
#
# Runs synchronous by default — guarantees skills ready before session loop.
# Switch to async by uncommenting the echo '{"async": ...}' line.

set -euo pipefail

# --- Async opt-in (disabled by default) ---
# echo '{"async": true, "asyncTimeout": 300000}'

# --- Paths ---
REPO_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
LOG_PREFIX="[simon-stack-hook]"
LOG_FILE="/tmp/simon-stack-session-start-$(date +%s).log"

log() { echo "$LOG_PREFIX $*" | tee -a "$LOG_FILE"; }

log "Starting. repo=$REPO_DIR remote=${CLAUDE_CODE_REMOTE:-false}"

# --- Short-circuit if already installed ---
# We use a marker file that embeds the commit SHA that installed.
MARKER=~/.claude/.simon-stack-installed
CURRENT_SHA=$(cd "$REPO_DIR" && git rev-parse HEAD 2>/dev/null || echo unknown)

if [ -f "$MARKER" ] && [ "$(cat "$MARKER" 2>/dev/null)" = "$CURRENT_SHA" ]; then
  log "Already installed at $CURRENT_SHA, skipping bootstrap"
  exit 0
fi

log "Bootstrap required. current=$CURRENT_SHA"

# --- Directories ---
mkdir -p ~/.claude/skills ~/.claude/instincts

# --- 1. Gstack runtime ---
if [ ! -d ~/.claude/skills/gstack ]; then
  log "Cloning Gstack..."
  TMP=$(mktemp -d)
  if git clone --depth 1 https://github.com/garrytan/gstack "$TMP/gstack-src" 2>>"$LOG_FILE"; then
    cp -a "$TMP/gstack-src" ~/.claude/skills/gstack
    rm -rf "$TMP"
    log "Gstack cloned OK"

    if command -v bun >/dev/null 2>&1; then
      log "Running bun install in Gstack..."
      (cd ~/.claude/skills/gstack && bun install >>"$LOG_FILE" 2>&1) || log "WARN: bun install failed (non-fatal)"
    else
      log "WARN: bun not found — Gstack runtime scripts will be limited"
    fi
  else
    log "ERROR: Gstack clone failed — check network. Hook continuing with simon-stack only."
    rm -rf "$TMP"
  fi
fi

# --- 2. Expose individual Gstack skills ---
if [ -d ~/.claude/skills/gstack ]; then
  log "Exposing individual Gstack skills..."
  count=0
  for d in ~/.claude/skills/gstack/*/; do
    name=$(basename "$d")
    [ -f "$d/SKILL.md" ] || continue
    [ -e ~/.claude/skills/"$name" ] && continue
    cp -r "$d" ~/.claude/skills/"$name"
    count=$((count + 1))
  done
  log "Exposed $count Gstack skills"
fi

# --- 3. simon-stack skills from this repo ---
log "Copying simon-stack skills from $REPO_DIR/.claude/skills/..."
count=0
for d in "$REPO_DIR"/.claude/skills/*/; do
  name=$(basename "$d")
  [ -f "$d/SKILL.md" ] || continue
  if [ -e ~/.claude/skills/"$name" ]; then
    continue  # preserve Gstack version if name collision
  fi
  cp -r "$d" ~/.claude/skills/"$name"
  count=$((count + 1))
done
log "Copied $count simon-stack skills"

# INDEX.md at skill root
if [ -f "$REPO_DIR/.claude/skills/INDEX.md" ] && [ ! -f ~/.claude/skills/INDEX.md ]; then
  cp "$REPO_DIR/.claude/skills/INDEX.md" ~/.claude/skills/INDEX.md
fi

# --- 4. Instincts seeds ---
log "Seeding instincts..."
for f in mistakes-learned.md project-patterns.md korean-context.md tool-quirks.md; do
  if [ -f "$REPO_DIR/.claude/instincts/$f" ] && [ ! -f ~/.claude/instincts/"$f" ]; then
    cp "$REPO_DIR/.claude/instincts/$f" ~/.claude/instincts/"$f"
  fi
done

# --- 5. Global CLAUDE.md ---
if [ ! -f ~/.claude/CLAUDE.md ]; then
  if [ -f "$REPO_DIR/templates/CLAUDE.md" ]; then
    cp "$REPO_DIR/templates/CLAUDE.md" ~/.claude/CLAUDE.md
    log "Installed ~/.claude/CLAUDE.md from template"
  fi
fi

# --- 6. User-level SessionStart hook script (for rich instincts summary) ---
if [ -f "$REPO_DIR/scripts/session-start-instincts.sh" ] && [ ! -f ~/.claude/session-start-instincts.sh ]; then
  cp "$REPO_DIR/scripts/session-start-instincts.sh" ~/.claude/session-start-instincts.sh
  chmod +x ~/.claude/session-start-instincts.sh
fi

# --- 7. Marker ---
echo "$CURRENT_SHA" > "$MARKER"

log "✅ Bootstrap complete. log=$LOG_FILE"

# --- Post-install env for current session (via $CLAUDE_ENV_FILE) ---
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  {
    echo "export SIMON_STACK_INSTALLED=1"
    echo "export SIMON_STACK_SHA=$CURRENT_SHA"
  } >> "$CLAUDE_ENV_FILE"
fi

exit 0
