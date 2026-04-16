# state.json Schema Reference

## Purpose

`state.json` is the machine-readable state file for the `.harness/` system.
LLM sessions read this to understand the current sprint, phase, and task status
without parsing human-written prose.

## Schema

```json
{
  "project": "string — project name (typically basename of repo)",
  "version": "string — semver with optional -dev suffix",
  "sprint": {
    "id": "string — sprint identifier (e.g., 'v1.3')",
    "name": "string — human-readable sprint name",
    "status": "string — in_progress | completed | blocked",
    "started": "string — ISO date YYYY-MM-DD",
    "phases": {
      "<phase_key>": "string — pending | in_progress | completed | blocked"
    }
  },
  "counters": {
    "decisions": "number — count of ADR files in wiki/decisions/",
    "concepts": "number — count of concept files in wiki/concepts/",
    "agents": "number — count of agent files in wiki/agents/"
  },
  "pending_tasks": [
    "string — task description with optional ID prefix (e.g., 'B-1: create skill')"
  ],
  "notes": {
    "<key>": "string — freeform notes for LLM context"
  }
}
```

## Required Fields

- `project` — always present
- `version` — always present
- `sprint.id` — always present
- `sprint.status` — always present

## Optional Fields

- `sprint.phases` — only if the sprint has distinct phases
- `counters` — updated by validate-wiki.sh
- `pending_tasks` — task queue (complement to plan.md)
- `notes` — freeform key-value pairs for LLM context

## Example

```json
{
  "project": "my-app",
  "version": "1.0.0-dev",
  "sprint": {
    "id": "v1.0",
    "name": "MVP Launch",
    "status": "in_progress",
    "started": "2026-04-15",
    "phases": {
      "A_design": "completed",
      "B_implementation": "in_progress",
      "C_testing": "pending"
    }
  },
  "counters": {
    "decisions": 3,
    "concepts": 5,
    "agents": 2
  },
  "pending_tasks": [
    "B-3: implement auth flow",
    "B-4: add API rate limiting",
    "C-1: write integration tests"
  ],
  "notes": {
    "deploy_target": "Vercel",
    "blocked_by": "waiting for Stripe API key"
  }
}
```

## Update Protocol

1. **Phase transitions**: when a phase completes, update its status and start the next
2. **Task completion**: remove from `pending_tasks` (or move to a `completed_tasks` array if auditing)
3. **Counter sync**: run `validate-wiki.sh` to auto-update counters
4. **Version bump**: update on each release (plan.md Phase D typically handles this)
