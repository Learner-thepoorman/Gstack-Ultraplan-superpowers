---
name: harness-wiki-setup
description: >-
  Use when the user wants to add a structured LLM knowledge base to their project —
  triggers include "wiki 만들어줘", "harness setup", "프로젝트 위키", "ADR 구조",
  "decision log", "concept docs", "agent personas", "set up harness",
  "knowledge base for Claude", "LLM wiki". Produces a `.harness/` directory with
  machine-readable state, a human-editable plan, and a wiki tree
  (decisions/concepts/agents) that Claude Code reads at session start.
  Different from plain docs/ — this is an LLM-optimized knowledge graph
  with INDEX.md routing, YAML frontmatter, and cross-references.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
version: 1.0.0
author: simon
tags: [harness, wiki, knowledge-base, adr, decisions]
---

# Harness Wiki Setup

프로젝트에 `.harness/` + LLM wiki 구조를 설치합니다. Claude Code 가 세션마다 읽는
구조화된 지식 베이스로, 의사결정(ADR), 개념 문서, 에이전트 페르소나를 분리 관리합니다.

## Why a Wiki?

일반 `docs/` 와 다른 점:

| | `docs/` | `.harness/wiki/` |
|---|---|---|
| 대상 독자 | 사람 | LLM + 사람 |
| 진입점 | README 링크 | `INDEX.md` (라우팅 테이블) |
| 메타데이터 | 없거나 자유 | YAML frontmatter (status, date, author) |
| 교차 참조 | 마크다운 링크 | `→ see: concepts/foo.md` 패턴 |
| 상태 추적 | 없음 | `state.json` (machine-readable) |

## 5-Phase Workflow

### Phase 1: RECON

기존 프로젝트 상태를 조사합니다.

1. `.harness/` 존재 여부 확인
2. 기존 `docs/adr/`, `docs/decisions/`, `ARCHITECTURE.md` 탐지
3. `CLAUDE.md` 존재 여부 + context-guardian marker 확인
4. `.gitignore` 에 `.harness/*.local.*` 패턴 존재 확인

결과를 사용자에게 보고하고, 기존 문서 마이그레이션 여부를 확인합니다.

### Phase 2: SCAFFOLD

디렉토리 구조를 생성합니다. **idempotent** — 이미 있으면 skip.

```bash
bash .claude/skills/harness-wiki-setup/scripts/scaffold.sh
```

생성되는 구조:
```
.harness/
├── state.json          ← machine-readable sprint state
├── plan.md             ← human-editable task queue
└── wiki/
    ├── INDEX.md        ← navigation + usage rules
    ├── decisions/      ← ADRs (Architecture Decision Records)
    │   └── _TEMPLATE.md
    ├── concepts/       ← concept/explainer docs
    │   └── _TEMPLATE.md
    └── agents/         ← LLM agent personas
        └── _TEMPLATE.md
```

`.gitignore` 에 `.harness/*.local.*` 추가 (per-user overrides 무시).

### Phase 3: POPULATE

프로젝트 컨텍스트를 바탕으로 초기 문서를 seed 합니다.

1. **state.json** — 현재 sprint 이름, phase, 카운터 초기화
2. **plan.md** — 현재 작업 큐 초기화 (사용자에게 내용 확인)
3. **INDEX.md** — wiki 탐색 규칙 + 카테고리별 링크 자동 생성
4. **decisions/** — 프로젝트에 이미 내린 주요 결정이 있으면 ADR 작성 제안
5. **concepts/** — 프로젝트 핵심 개념 (아키텍처 패턴, 데이터 모델 등) 문서화 제안
6. **agents/** — LLM 이 맡을 역할 (orchestrator, reviewer 등) 페르소나 작성 제안

각 문서는 YAML frontmatter + 본문 구조. 템플릿 참조: `references/wiki-structure.md`

### Phase 4: VALIDATE

구조 검증을 실행합니다.

```bash
bash .claude/skills/harness-wiki-setup/scripts/validate-wiki.sh
```

검증 항목:
- `.harness/wiki/INDEX.md` 존재
- `state.json` JSON 파싱 가능
- `plan.md` 존재 + 비어있지 않음
- 모든 wiki 문서에 YAML frontmatter 존재
- INDEX.md 의 링크가 실제 파일을 가리킴
- `_TEMPLATE.md` 가 각 서브디렉토리에 존재
- `.gitignore` 에 `.harness/*.local.*` 패턴 존재

결과: `PASS` / `WARN` / `FAIL` + 항목별 상세

### Phase 5: REPORT

설치 결과를 요약합니다.

1. 생성된 파일/디렉토리 목록
2. VALIDATE 결과
3. CLAUDE.md 에 wiki index section 추가 제안 (context-guardian marker 보존)
4. 다음 단계 안내:
   - "decisions/ 에 첫 ADR 을 작성하세요"
   - "concepts/ 에 프로젝트 핵심 개념을 문서화하세요"
   - "agents/ 에 Claude 가 맡을 역할을 정의하세요"

## CLAUDE.md Integration

CLAUDE.md 에 아래 섹션을 추가합니다 (마커 기반, idempotent):

```markdown
<!-- harness-wiki:v1 -->
## Wiki Index

LLM sessions start here: `.harness/wiki/INDEX.md`
- **Decisions**: `.harness/wiki/decisions/` — ADRs for architectural choices
- **Concepts**: `.harness/wiki/concepts/` — explainer docs for key abstractions
- **Agents**: `.harness/wiki/agents/` — LLM persona definitions
- **State**: `.harness/state.json` — current sprint state (machine-readable)
- **Plan**: `.harness/plan.md` — task queue (human-editable)
<!-- /harness-wiki:v1 -->
```

**주의**: `<!-- context-guardian-rules:v1 -->` 마커가 있으면 반드시 보존.

## Related Skills

- `context-guardian` — CLAUDE.md 규칙 관리 + 세션 복구
- `project-context-md` — CLAUDE.md 생성/업데이트
- `app-dev-orchestrator` — 새 앱 파이프라인 (stage 11 에서 이 skill 호출)

## Limitations

- `--migrate` 모드 (기존 `docs/adr/` → `.harness/wiki/decisions/` 변환) 는 미구현
- Wiki 간 link-check CI 는 미구현
- `.harness/wiki/INDEX.md` self-healing hook 은 미구현
