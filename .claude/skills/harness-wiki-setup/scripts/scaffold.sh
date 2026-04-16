#!/usr/bin/env bash
# scaffold.sh — Create .harness/wiki/ directory structure (idempotent)
# Usage: bash .claude/skills/harness-wiki-setup/scripts/scaffold.sh [project_root]
set -euo pipefail

ROOT="${1:-$(pwd)}"
HARNESS="$ROOT/.harness"
WIKI="$HARNESS/wiki"
MARKER=".harness/*.local.*"

created=0
skipped=0

log() { echo "[harness-wiki] $1"; }

ensure_dir() {
  if [ -d "$1" ]; then
    log "SKIP dir exists: $1"
    ((skipped++))
  else
    mkdir -p "$1"
    log "CREATE dir: $1"
    ((created++))
  fi
}

ensure_file() {
  local path="$1"
  local content="$2"
  if [ -f "$path" ]; then
    log "SKIP file exists: $path"
    ((skipped++))
  else
    echo "$content" > "$path"
    log "CREATE file: $path"
    ((created++))
  fi
}

# --- Directories ---
ensure_dir "$HARNESS"
ensure_dir "$WIKI"
ensure_dir "$WIKI/decisions"
ensure_dir "$WIKI/concepts"
ensure_dir "$WIKI/agents"

# --- state.json ---
ensure_file "$HARNESS/state.json" '{
  "project": "'"$(basename "$ROOT")"'",
  "version": "0.1.0-dev",
  "sprint": {
    "id": "v0.1",
    "name": "Initial Setup",
    "status": "in_progress",
    "started": "'"$(date +%Y-%m-%d)"'",
    "phases": {}
  },
  "counters": {
    "decisions": 0,
    "concepts": 0,
    "agents": 0
  },
  "pending_tasks": [],
  "notes": {}
}'

# --- plan.md ---
ensure_file "$HARNESS/plan.md" "# $(basename "$ROOT") — Active Plan

> Human-editable task queue. Claude reads this at session start via \`.harness/wiki/INDEX.md\`.
> Dynamic state lives in \`state.json\`; narrative context lives here.

## Current Sprint

_TODO: describe your current sprint goals here._

## Backlog

_TODO: list future work here._

## Decisions Log

See \`.harness/wiki/decisions/\` for ADRs."

# --- INDEX.md ---
ensure_file "$WIKI/INDEX.md" "# Wiki Index

> **Entry point for LLM sessions.** Claude reads this file to navigate the project knowledge base.

## Navigation

| Category | Path | Description |
|----------|------|-------------|
| Decisions | \`decisions/\` | Architecture Decision Records (ADRs) |
| Concepts | \`concepts/\` | Explainer docs for key abstractions |
| Agents | \`agents/\` | LLM agent persona definitions |

## Usage Rules

1. **Always start here** — read INDEX.md before diving into subdirectories
2. **Follow cross-references** — \`→ see: concepts/foo.md\` links to related docs
3. **Check state.json** — for current sprint status and counters
4. **Check plan.md** — for the active task queue
5. **Never modify _TEMPLATE.md** — copy it to create new documents

## Quick Stats

- Decisions: _see \`decisions/\` directory_
- Concepts: _see \`concepts/\` directory_
- Agents: _see \`agents/\` directory_"

# --- Templates ---
ensure_file "$WIKI/decisions/_TEMPLATE.md" '---
id: ADR-NNN
title: "Decision Title"
status: proposed  # proposed | accepted | deprecated | superseded
date: YYYY-MM-DD
author: ""
supersedes: ""
superseded_by: ""
---

# ADR-NNN: Decision Title

## Context

_What is the issue we are deciding on?_

## Decision

_What is the change we are making?_

## Consequences

_What becomes easier or harder because of this decision?_

## Alternatives Considered

_What other options were evaluated?_'

ensure_file "$WIKI/concepts/_TEMPLATE.md" '---
title: "Concept Name"
status: draft  # draft | stable | deprecated
date: YYYY-MM-DD
author: ""
related: []
---

# Concept Name

## What

_One-paragraph explanation._

## Why

_Why does this concept exist? What problem does it solve?_

## How

_How does it work? Key mechanics and invariants._

## Where

_Where in the codebase does this manifest?_

## Cross-References

_→ see: decisions/ADR-NNN.md_
_→ see: concepts/related-concept.md_'

ensure_file "$WIKI/agents/_TEMPLATE.md" '---
name: "Agent Name"
role: ""
status: draft  # draft | active | deprecated
date: YYYY-MM-DD
author: ""
---

# Agent Name

## Role

_What is this agent responsible for?_

## Capabilities

_What tools and skills does this agent have access to?_

## Decision Authority

_What can this agent decide autonomously vs. what requires user approval?_

## Handoff Contract

_What context does this agent need to receive? What does it produce?_'

# --- .gitignore entry ---
GITIGNORE="$ROOT/.gitignore"
if [ -f "$GITIGNORE" ]; then
  if ! grep -qF "$MARKER" "$GITIGNORE" 2>/dev/null; then
    echo "" >> "$GITIGNORE"
    echo "# Harness per-user overrides" >> "$GITIGNORE"
    echo "$MARKER" >> "$GITIGNORE"
    log "APPEND .gitignore: $MARKER"
    ((created++))
  else
    log "SKIP .gitignore already has $MARKER"
    ((skipped++))
  fi
else
  echo "# Harness per-user overrides" > "$GITIGNORE"
  echo "$MARKER" >> "$GITIGNORE"
  log "CREATE .gitignore with $MARKER"
  ((created++))
fi

echo ""
log "Done. created=$created skipped=$skipped"
