# Wiki Structure Reference

## Contents

- [Directory Layout](#directory-layout)
- [File Naming Conventions](#file-naming-conventions)
- [YAML Frontmatter](#yaml-frontmatter)
- [Cross-Reference Pattern](#cross-reference-pattern)
- [INDEX.md Structure](#indexmd-structure)
- [CLAUDE.md Integration](#claudemd-integration)

## Directory Layout

```
.harness/
├── state.json              ← Machine-readable sprint state
├── plan.md                 ← Human-editable task queue
└── wiki/
    ├── INDEX.md            ← Entry point for LLM sessions
    ├── decisions/          ← Architecture Decision Records
    │   ├── _TEMPLATE.md
    │   ├── ADR-001-*.md
    │   └── ADR-002-*.md
    ├── concepts/           ← Concept/explainer docs
    │   ├── _TEMPLATE.md
    │   ├── skill-anatomy.md
    │   └── orchestrator-pattern.md
    └── agents/             ← LLM agent personas
        ├── _TEMPLATE.md
        ├── orchestrator.md
        └── skill-author.md
```

## File Naming Conventions

| Category | Pattern | Example |
|----------|---------|---------|
| Decisions | `ADR-NNN-kebab-title.md` | `ADR-001-use-yaml-frontmatter.md` |
| Concepts | `kebab-title.md` | `skill-anatomy.md` |
| Agents | `kebab-role-name.md` | `orchestrator.md` |
| Templates | `_TEMPLATE.md` | `_TEMPLATE.md` |

## YAML Frontmatter

Every wiki document (except INDEX.md) must have YAML frontmatter:

```yaml
---
key: value
status: draft | stable | accepted | deprecated
date: YYYY-MM-DD
author: ""
---
```

### Decision-specific fields

```yaml
---
id: ADR-NNN
title: "Decision Title"
status: proposed | accepted | deprecated | superseded
date: YYYY-MM-DD
author: ""
supersedes: ""
superseded_by: ""
---
```

### Concept-specific fields

```yaml
---
title: "Concept Name"
status: draft | stable | deprecated
date: YYYY-MM-DD
author: ""
related: []           # list of related concept/decision paths
---
```

### Agent-specific fields

```yaml
---
name: "Agent Name"
role: ""
status: draft | active | deprecated
date: YYYY-MM-DD
author: ""
---
```

## Cross-Reference Pattern

Use the `→ see:` pattern for cross-references within wiki docs:

```markdown
→ see: concepts/skill-anatomy.md
→ see: decisions/ADR-001-use-yaml-frontmatter.md
```

## INDEX.md Structure

INDEX.md serves as the routing table for LLM sessions:

1. **Navigation table** — category / path / description
2. **Usage rules** — how to navigate the wiki
3. **Quick stats** — document counts per category

## state.json Schema

See `state-json-schema.md` for the full schema.

## CLAUDE.md Integration

The wiki index section is injected into CLAUDE.md using markers:

```
<!-- harness-wiki:v1 -->
...content...
<!-- /harness-wiki:v1 -->
```

This ensures idempotent updates and coexistence with other markers
(e.g., `<!-- context-guardian-rules:v1 -->`).
