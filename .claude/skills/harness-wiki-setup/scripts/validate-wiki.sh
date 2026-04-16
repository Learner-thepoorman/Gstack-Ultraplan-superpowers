#!/usr/bin/env bash
# validate-wiki.sh — Validate .harness/wiki/ structure and content
# Usage: bash .claude/skills/harness-wiki-setup/scripts/validate-wiki.sh [project_root]
set -euo pipefail

ROOT="${1:-$(pwd)}"
HARNESS="$ROOT/.harness"
WIKI="$HARNESS/wiki"

pass=0
warn=0
fail=0

check() {
  local level="$1" msg="$2"
  case "$level" in
    PASS) echo "  ✓ $msg"; ((pass++)) ;;
    WARN) echo "  ⚠ $msg"; ((warn++)) ;;
    FAIL) echo "  ✗ $msg"; ((fail++)) ;;
  esac
}

echo "=== Harness Wiki Validation ==="
echo "Root: $ROOT"
echo ""

# --- Structure checks ---
echo "[Structure]"
[ -d "$HARNESS" ] && check PASS ".harness/ exists" || check FAIL ".harness/ missing"
[ -d "$WIKI" ] && check PASS ".harness/wiki/ exists" || check FAIL ".harness/wiki/ missing"
[ -d "$WIKI/decisions" ] && check PASS "wiki/decisions/ exists" || check FAIL "wiki/decisions/ missing"
[ -d "$WIKI/concepts" ] && check PASS "wiki/concepts/ exists" || check FAIL "wiki/concepts/ missing"
[ -d "$WIKI/agents" ] && check PASS "wiki/agents/ exists" || check FAIL "wiki/agents/ missing"

# --- Required files ---
echo ""
echo "[Required Files]"
[ -f "$WIKI/INDEX.md" ] && check PASS "wiki/INDEX.md exists" || check FAIL "wiki/INDEX.md missing"
[ -f "$HARNESS/state.json" ] && check PASS "state.json exists" || check FAIL "state.json missing"
[ -f "$HARNESS/plan.md" ] && check PASS "plan.md exists" || check FAIL "plan.md missing"

# --- state.json parseable ---
if [ -f "$HARNESS/state.json" ]; then
  if python3 -c "import json; json.load(open('$HARNESS/state.json'))" 2>/dev/null; then
    check PASS "state.json is valid JSON"
  else
    check FAIL "state.json is not valid JSON"
  fi
fi

# --- plan.md not empty ---
if [ -f "$HARNESS/plan.md" ]; then
  if [ -s "$HARNESS/plan.md" ]; then
    check PASS "plan.md is not empty"
  else
    check WARN "plan.md is empty"
  fi
fi

# --- Templates ---
echo ""
echo "[Templates]"
[ -f "$WIKI/decisions/_TEMPLATE.md" ] && check PASS "decisions/_TEMPLATE.md exists" || check WARN "decisions/_TEMPLATE.md missing"
[ -f "$WIKI/concepts/_TEMPLATE.md" ] && check PASS "concepts/_TEMPLATE.md exists" || check WARN "concepts/_TEMPLATE.md missing"
[ -f "$WIKI/agents/_TEMPLATE.md" ] && check PASS "agents/_TEMPLATE.md exists" || check WARN "agents/_TEMPLATE.md missing"

# --- YAML frontmatter in wiki docs ---
echo ""
echo "[Frontmatter]"
fm_checked=0
fm_missing=0
for f in "$WIKI"/decisions/*.md "$WIKI"/concepts/*.md "$WIKI"/agents/*.md; do
  [ -f "$f" ] || continue
  basename_f=$(basename "$f")
  [ "$basename_f" = "_TEMPLATE.md" ] && continue
  ((fm_checked++))
  if head -1 "$f" | grep -q '^---$'; then
    check PASS "$(basename "$(dirname "$f")")/$(basename "$f") has frontmatter"
  else
    check WARN "$(basename "$(dirname "$f")")/$(basename "$f") missing frontmatter"
    ((fm_missing++))
  fi
done
if [ "$fm_checked" -eq 0 ]; then
  check WARN "No wiki documents found (only templates)"
fi

# --- INDEX.md link check ---
echo ""
echo "[Link Check]"
if [ -f "$WIKI/INDEX.md" ]; then
  broken=0
  while IFS= read -r link; do
    target="$WIKI/$link"
    if [ ! -e "$target" ]; then
      check WARN "INDEX.md links to missing: $link"
      ((broken++))
    fi
  done < <(grep -oP '`(?:decisions|concepts|agents)/[^`]+`' "$WIKI/INDEX.md" 2>/dev/null | tr -d '`' || true)
  if [ "$broken" -eq 0 ]; then
    check PASS "All INDEX.md links valid (or no specific file links)"
  fi
fi

# --- .gitignore check ---
echo ""
echo "[Gitignore]"
if [ -f "$ROOT/.gitignore" ]; then
  if grep -qF '.harness/*.local.*' "$ROOT/.gitignore" 2>/dev/null; then
    check PASS ".gitignore has .harness/*.local.* pattern"
  else
    check WARN ".gitignore missing .harness/*.local.* pattern"
  fi
else
  check WARN "No .gitignore found"
fi

# --- Summary ---
echo ""
echo "=== Result: $pass PASS / $warn WARN / $fail FAIL ==="
if [ "$fail" -gt 0 ]; then
  echo "Status: FAIL"
  exit 1
elif [ "$warn" -gt 0 ]; then
  echo "Status: WARN"
  exit 0
else
  echo "Status: PASS"
  exit 0
fi
