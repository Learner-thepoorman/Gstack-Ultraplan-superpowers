# SimonK-stack — Active Plan

> Human-editable task queue. Claude reads this at session start via `.harness/wiki/INDEX.md` entry point.
> Dynamic state lives in `state.json`; narrative context lives here.

## Current sprint: v1.3 — Harness+Wiki + Anti-Slop + Codex

Goal: adopt the Harness + LLM Wiki pattern (decisions/concepts/agents separation) into SimonK-stack itself, then package it as a reusable skill, alongside anti-AI-slop design principles and Codex-driven adversarial review.

### Phase A — Scaffold (this session) ⭐

- [x] Create `.harness/wiki/{decisions,concepts,agents}/` skeleton
- [x] Seed `state.json` + this `plan.md`
- [x] Write 4 ADRs capturing already-made architectural decisions
- [x] Write 5 concept docs (skill anatomy, orchestrator, instincts, hook, context-guardian)
- [x] Write 3 agent personas (orchestrator, skill-author, design-lead)
- [x] Inject `## 🗂 Wiki Index` section into repo CLAUDE.md (preserving context-guardian marker)
- [x] Commit + push

### Phase B — New skills (next session)

- [ ] `harness-wiki-setup` — 5-phase RECON → SCAFFOLD → POPULATE → VALIDATE → REPORT workflow
  - [ ] `scripts/scaffold.sh` (idempotent, marker-based)
  - [ ] `scripts/validate-wiki.sh`
  - [ ] `references/wiki-structure.md`
  - [ ] `references/state-json-schema.md`
  - [ ] `evals/cases.json` (2+ test cases)
- [ ] `design-anti-slop` — reference-first, 3-color, 5-step landing
  - [ ] Fetch `github.com/pbakaus/impeccable` + `github.com/uxjoseph/supanova-design-skill`
  - [ ] Extract core principles into `references/design-philosophy.md`
  - [ ] `references/landing-page-anatomy.md` (Feature-Showcase-UseCase-CTA-Footer)
  - [ ] `references/reference-sources.md` (dribbble / awwwards / 21st.dev)
  - [ ] `evals/cases.json`
- [ ] `codex-review` wrapper
  - [ ] Delegate to Gstack `/codex` slash command
  - [ ] Define handoff contract (what context to pass, what to expect back)
  - [ ] `evals/cases.json`

### Phase C — Integration (next session)

- [ ] `app-dev-orchestrator`: insert `harness-wiki-setup` at stage 11, `design-anti-slop` before stage 4
- [ ] `stitch-design-flow`: Related skills → `design-anti-slop`
- [ ] `simon-tdd`: GREEN step → `codex-review` reference
- [ ] `review`: Related skills → `codex-review`
- [ ] `.claude/skills/INDEX.md`: add Harness/Wiki + Design System + Code Review categories

### Phase D — Validate / Commit / Ship (next session)

- [ ] `validate_skill.py` 23/23 PASS, 0 errors, 0 warnings
- [ ] `test_skill.py --dry-run` for all 3 new skills
- [ ] `scaffold.sh` dry-run against a throwaway tmp repo
- [ ] `bash -n` syntax check for all new scripts
- [ ] CHANGELOG.md v1.3.0 entry
- [ ] README.md skill count 20 → 23
- [ ] Atomic commits + `git push -u origin main` with 503 backoff

## Backlog (post-v1.3)

- Self-healing hook for `.harness/wiki/INDEX.md` (similar marker pattern to context-guardian)
- `harness-wiki-setup` `--migrate` mode: ingest existing `docs/adr/` directories
- Wiki link-check CI
- `design-anti-slop` pairing with real screenshot eval (MCP Playwright?)

## Decisions Log

See `.harness/wiki/decisions/` for ADRs.
