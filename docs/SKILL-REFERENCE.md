# Skill Reference — Simon-stack 상세 문서

> 각 skill 의 **역할 / 구조 / 알고리즘**을 설명합니다.
> README 에서는 카탈로그 테이블만 제공하고, 이 문서에서 상세를 다룹니다.

---

## 목차

1. [Orchestrators (2)](#orchestrators--상위-지휘-2개)
2. [Security (3)](#security--보안-3개)
3. [Method (4)](#method--방법론-4개)
4. [Tools (3)](#tools--특수-목적-3개)
5. [Meta + Session (2)](#meta--session-2개)
6. [General Dev (6)](#general-dev-6개)

---

## Orchestrators — 상위 지휘 (2개)

### 1. `app-dev-orchestrator`

**역할**: 제로베이스 앱 개발 전 과정 자동화. 21단계 파이프라인.

**알고리즘 (21단계)**:
```
 0. 인터뷰 — 플랫폼/타깃/레포/예산/API/마감
 1. /office-hours — YC forcing questions
 2. simon-research — 경쟁 제품 3개 비교
 3. /plan-ceo-review — 10-star 스코프
 4. /design-consultation — DESIGN.md
 5. stitch-design-flow — Safe/Bold/Wild 프롬프트
 6. /design-shotgun — 변형 탐색
 7. UltraPlan — 대형 플래닝
 8. authz-designer — RBAC/ABAC/ReBAC
 9. paid-api-guard — API 설계 리뷰
10. /plan-eng-review → /autoplan — 플랜 잠금
11. 레포·.env·.gitignore·gitleaks hook
12. simon-worktree — 병렬 격리
13. simon-tdd — RED-GREEN-REFACTOR
14. /design-review → /design-html
15. /qa — QA + 버그 수정
16. security-orchestrator — 보안 5단 감사
17. /benchmark — Core Web Vitals
18. /review → /ship — PR
19. /land-and-deploy → /canary
20. /document-release → /retro
21. simon-instincts → /checkpoint
```

핵심: 이 skill 은 스스로 코드를 쓰지 않음. 각 단계는 다른 skill 호출만 함.

---

### 2. `security-orchestrator`

**역할**: 5단계 적대적 보안 감사 → 통합 SUMMARY 리포트.

```
Step 1. security-checklist    → 4대 영역 적대적 테스트
Step 2. authz-designer (감사) → IDOR·권한 상승 스캔
Step 3. paid-api-guard         → 결제 API 6층 방어
Step 4. /cso comprehensive     → 인프라·시크릿·공급망
Step 5. /codex challenge       → 적대적 리뷰

→ docs/security/<date>-SUMMARY.md (심각도 정렬)
→ Critical/High 모두 해결될 때까지 수정 루프
```

---

## Security — 보안 (3개)

### 3. `security-checklist`

**역할**: 웹 앱 4대 보안 구조 적대적 감사. 각 영역 5개 공격 시나리오 + SQL drop-in.

**4대 영역**:
- **A. RLS** — ENABLE+FORCE 확인, pg_policies 스캔, 적대적 SELECT/UPDATE 5종
- **B. 구독 상태** — 민감 필드 9개 보호, 웹훅 HMAC+idempotency, audit_log
- **C. 이중 Rate Limit** — user_id+IP 2중키, Edge+App 2층, 티어 차등
- **D. 예산 한도** — Provider/App/User 3계층, circuit breaker

---

### 4. `authz-designer`

**역할**: 프로젝트에 맞는 권한 모델 선택 + DDL 템플릿 + IDOR 감사.

**모델 선택**:
- 역할 소수+고정 → RBAC (Casbin / Postgres RLS)
- 속성 조건 복잡 → ABAC (Oso / Casbin ABAC)
- 문서·팀 협업 그래프 → ReBAC (OpenFGA / SpiceDB)
- 대부분 SaaS → Hybrid

**DDL 4테이블**: `authz_roles`, `authz_role_assignments`, `authz_policies`, `authz_audit_log`

---

### 5. `paid-api-guard`

**역할**: 유료 API 6층 방어 (결제·SMS·지도·이메일).

| Layer | 내용 |
|---|---|
| 1. 네트워크 경계 | BFF 강제, 브라우저 직접 호출 금지, NEXT_PUBLIC_* 금지 |
| 2. 서명·멱등성 | HMAC+nonce+timestamp, Idempotency-Key, raw body 서명 |
| 3. 남용 탐지 | 사용자별 비용 대시보드, 10배 이상 자동 정지, Turnstile |
| 4. 결제 전용 | 시크릿 매니저, tokenize, 환불 OTP, 금액 서버 재계산 |
| 5. 키 탈취 대응 | Canary 키, INCIDENT-PLAYBOOK, push protection, 90일 로테이션 |
| 6. 관측 | 모든 호출 로깅 (user_id, cost, latency), 주간 /retro |

---

## Method — 방법론 (4개)

### 6. `simon-tdd`

**역할**: RED → GREEN → REFACTOR 사이클 강제 + Boris Cherny 검증 루프.

```
RED:      실패하는 테스트 먼저 → npm test FAIL 확인
GREEN:    최소 코드로 통과 → 전체 스위트 재실행
REFACTOR: 동작 보존 구조 개선 → 매 리팩토링마다 테스트
COMMIT:   git add -p → git commit
```

검증 도구 제공 원칙: CLAUDE.md에 서버/테스트/브라우저/DB 접근 명시 필수.

---

### 7. `simon-worktree`

**역할**: 병렬 Claude 세션을 `git worktree`로 격리.

```
1. git worktree add ../myapp-auth -b feat/auth
2. 각 worktree에 독립 Claude 세션 배정
3. .env 심볼릭 링크 또는 복사
4. 메인 worktree 직접 commit ❌ (PR만)
5. 완료 후 git worktree remove + branch delete
```

---

### 8. `simon-research`

**역할**: 플래닝 전 외부 리서치 의무화. 출처 없는 주장 금지.

```
1. 주제 3줄 요약 (What/Why/Success)
2. 검색 키워드 5-10개 (한/영)
3. 1차 자료 병렬 WebFetch (공식 문서 > GitHub > RFC > 블로그)
4. 경쟁 제품 3개+ 비교표
5. docs/research/<date>-<topic>.md 저장
```

금기: 1년+ 블로그 단일 출처, AI 요약 기사 2차 가공.

---

### 9. `simon-instincts`

**역할**: Claude 실수를 4개 md 파일에 누적. 세션 시작 시 자동 로드.

| 파일 | 내용 | 예시 |
|---|---|---|
| `mistakes-learned.md` | Claude 실수 | grep -c exit 1 함정 |
| `project-patterns.md` | 프로젝트별 관용 | WORDGE는 Drizzle |
| `korean-context.md` | 한국 시장 특이사항 | 토스 웹훅 헤더 |
| `tool-quirks.md` | CLI 함정 | git clone default branch |

각 entry: `### YYYY-MM-DD — <제목>` + 증상/원인/예방책/출처 4필드.

---

## Tools — 특수 목적 (3개)

### 10. `nextjs-optimizer`

**역할**: Next.js 13+ App Router 5대 성능 영역 감사.

| 영역 | 목표 |
|---|---|
| 이미지 | `<img>` → next/image, width/height 필수, CLS 방지 |
| 렌더링 전략 | 페이지별 SSG/ISR/SSR/CSR 라벨링 |
| 코드 분할 | next/dynamic, 초기 번들 < 200KB |
| 서드파티 스크립트 | next/script strategy, FCP < 1.8s |
| 데이터 캐싱 | unstable_cache + revalidateTag |

Core Web Vitals 목표: LCP < 2.5s / CLS < 0.1 / INP < 200ms

---

### 11. `stitch-design-flow`

**역할**: Google Stitch용 디자인 프롬프트 생성기. API 없음, 순수 텍스트.

```
1. DESIGN.md 읽기 (없으면 /design-consultation 먼저)
2. 6가지 브랜드 요소 추출
3. 3변형 생성: Safe (Stripe·Linear) / Bold (Figma·Arc) / Wild (Awwwards)
4. docs/design/stitch-prompts-<date>.md 저장
```

---

### 12. `project-context-md`

**역할**: 프로젝트 CLAUDE.md 생성/갱신. Boris Cherny 검증 루프의 핵심.

9개 필수 섹션: 프로젝트 설명, 스택, **검증 도구** (가장 중요), 주요 경로, 디렉토리 구조, 환경변수, 금기, 관용, 참고 skill.

---

## Meta + Session (2개)

### 13. `skill-gen-agent`

**역할**: Skill 생성·검증·리팩토링·테스트 도구 묶음.

```bash
# 검증
python3 .claude/skills/skill-gen-agent/scripts/validate_skill.py skills-src/<name>

# JSON test case dry-run
python3 .claude/skills/skill-gen-agent/scripts/test_skill.py \
  skills-src/<name> --cases skills-src/<name>/evals/cases.json --dry-run

# 통합 테스트 (24 checks)
python3 .claude/skills/skill-gen-agent/scripts/tests/run_all.py
```

validator 검사: kebab-case, 64자, reserved word, semver, description 점수, 500줄 한도, TODO 마커, 깨진 링크, Windows 경로.

---

### 14. `context-guardian`

**역할**: 컨텍스트 고갈 3단계 대응.

| Mode | 산출물 |
|---|---|
| Prevention | CLAUDE.md 규칙 블록 + .claudeignore |
| Monitoring | context_limit_log.json (80%/90% 경고) |
| Recovery | SESSION_RECOVERY.md (git 상태 + 시크릿 패턴 검사) |

---

## General Dev (6개)

| Skill | 역할 | 산출물 |
|---|---|---|
| `commit` | Conventional Commits | `type(scope): subject` |
| `debug` | 근본 원인 진단 | 수정 + 재현 불가 확인 |
| `explain` | 코드 워크스루 | entry point, 데이터 플로우, 불변식 |
| `refactor` | 동작 보존 구조 개선 | 기존 테스트 통과 |
| `review` | 코드 리뷰 | blocker/major/minor/nit |
| `test-gen` | 테스트 생성 | 골든 패스 + 엣지 + 에러 경로 |
