# Claude Code Skill Set — General Development

A collection of reusable skills for Claude Code focused on everyday software development tasks.

## Skills

| Skill | Purpose |
|-------|---------|
| [`commit`](./commit/SKILL.md) | Create well-structured Conventional Commits |
| [`review`](./review/SKILL.md) | Perform thorough, prioritized code reviews |
| [`debug`](./debug/SKILL.md) | Systematically find root causes of bugs |
| [`refactor`](./refactor/SKILL.md) | Improve code structure without changing behavior |
| [`test-gen`](./test-gen/SKILL.md) | Generate meaningful, deterministic tests |
| [`explain`](./explain/SKILL.md) | Walk through unfamiliar code clearly |

## How it works

Each skill is a directory containing a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: skill-name
description: When to invoke this skill
---
```

Claude Code reads the `description` to decide when to load and apply the skill. The body of the file gives Claude the workflow, principles, and anti-patterns to follow.

## Adding a new skill

1. Create a new directory under `.claude/skills/<your-skill>/`
2. Add a `SKILL.md` file with frontmatter and content
3. Keep the description specific — it's what triggers the skill
4. Focus the body on **workflow** and **principles**, not exhaustive examples
