---
name: codex-review
description: >-
  Use when the user wants an independent second opinion on code changes via
  OpenAI Codex CLI — triggers include "codex review", "second opinion",
  "codex 리뷰", "코덱스 리뷰", "independent review", "adversarial review",
  "codex challenge", "코덱스 도전", "다른 관점에서 봐줘", "ask codex".
  Thin wrapper around Gstack's `/codex` skill — delegates the actual Codex CLI
  interaction and adds a structured handoff contract (what context to pass,
  what to expect back). Three modes: review (pass/fail gate on diff),
  challenge (adversarial break-my-code), consult (ask anything with follow-ups).
  Produces a structured verdict with severity-tagged findings.
allowed-tools: Read, Bash, Grep, Glob
version: 1.0.0
author: simon
tags: [codex, review, adversarial, second-opinion]
---

# Codex Review

OpenAI Codex CLI 를 통한 독립적 코드 리뷰. Claude 가 직접 작성한 코드에 대해
"다른 관점"의 리뷰를 받을 수 있습니다.

## Why a Second Opinion?

Claude 가 작성한 코드를 Claude 가 리뷰하면 같은 blind spot 을 공유합니다.
Codex CLI 는 다른 모델 기반이므로 다른 관점의 피드백을 제공합니다.

## Prerequisites

이 skill 은 Gstack 의 `/codex` skill 에 위임합니다. Gstack 이 설치되어 있어야 합니다.
Codex CLI 가 없으면 설치를 안내합니다.

## Three Modes

### Mode 1: Review (Pass/Fail Gate)

현재 branch 의 diff 를 Codex 에 넘겨 독립적으로 리뷰합니다.

**Handoff context** (Claude → Codex):
- `git diff main...HEAD` — 전체 변경 diff
- 프로젝트의 주요 기술 스택 (CLAUDE.md 에서 추출)
- 리뷰 포커스 영역 (있으면): security, performance, correctness

**Expected back** (Codex → Claude):
- `PASS` 또는 `FAIL` 판정
- 발견 사항 목록 (severity: blocker / major / minor / nit)
- 각 발견에 대한 근거와 수정 제안

**사용 시점**: PR 생성 전 최종 게이트, `/ship` 전 안전장치

### Mode 2: Challenge (Adversarial)

Codex 에게 "이 코드를 깨뜨려봐"라고 요청합니다.

**Handoff context** (Claude → Codex):
- 변경된 파일의 전체 코드 (diff 가 아닌 전문)
- "Find bugs, edge cases, security issues, and race conditions"

**Expected back** (Codex → Claude):
- 발견된 취약점/버그 목록
- 재현 시나리오 (가능한 경우)
- 심각도 평가

**사용 시점**: security-sensitive 변경, 복잡한 로직, concurrent 코드

### Mode 3: Consult (Ask Anything)

Codex 에 자유 형식 질문을 합니다. 세션 연속성 지원.

**Handoff context** (Claude → Codex):
- 사용자의 질문
- 관련 코드 context (선택)

**Expected back** (Codex → Claude):
- 답변
- 코드 예시 (해당 시)

**사용 시점**: 아키텍처 결정, 대안 탐색, "이거 맞는 방향이야?"

## Handoff Contract

### Context Preparation

Codex 에 넘기기 전에 Claude 가 준비하는 것:

1. **Scope**: 어떤 파일/변경이 리뷰 대상인지 명확히
2. **Stack**: 프로젝트 기술 스택 한 줄 요약
3. **Focus**: 특별히 확인해야 할 영역 (security, perf, correctness)
4. **Constraints**: 프로젝트 특정 규칙 (예: "no direct DB access from handlers")

### Result Interpretation

Codex 결과를 Claude 가 해석할 때:

1. **PASS with nits** → 사용자에게 nit 목록 공유, merge 가능
2. **FAIL with blockers** → blocker 항목을 분석, 실제 문제인지 확인
3. **False positive** → Codex 가 프로젝트 context 를 모르는 경우 발생 가능, 사용자에게 설명
4. **Disagreement** → Claude 와 Codex 의견이 다르면 양쪽 근거를 사용자에게 제시

## Delegation to Gstack

실제 Codex CLI 실행은 Gstack `/codex` skill 이 담당합니다.
이 skill 은 handoff contract 와 context preparation 을 정의하는 wrapper 입니다.

```
User → "codex review 해줘"
  → codex-review (이 skill): context 준비 + handoff contract 적용
    → /codex (Gstack): Codex CLI 실행 + 결과 반환
  → codex-review: 결과 해석 + 사용자에게 보고
```

## Related Skills

- `review` (simon-stack) — Claude 기반 PR 리뷰 (이 skill 과 상호 보완)
- `/codex` (Gstack) — 실제 Codex CLI wrapper (이 skill 이 위임하는 대상)
- `simon-tdd` — GREEN step 에서 codex challenge 참조 가능
- `security-orchestrator` — stage 5 에서 codex challenge 실행
