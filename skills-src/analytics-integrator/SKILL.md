---
name: analytics-integrator
description: "Use when the user asks to set up analytics, tracking, or user behavior analysis—triggers "분석 도구 세팅", "GA4 연동", "이벤트 추적", "PostHog 설치", "퍼널 분석", "setup analytics", "track user behavior", "add Clarity", "event taxonomy". Produces analytics stack setup (GA4/PostHog/Mixpanel + Clarity/Hotjar), event taxonomy document, consent management (GDPR/개인정보보호법), and funnel/retention tracking configuration."
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, WebFetch
version: 1.0.0
author: simon-stack
---

# analytics-integrator

분석 도구 설정 + 이벤트 설계를 수행하는 skill.

## 발동 조건

- "분석 도구 세팅해줘", "GA4 연동", "이벤트 추적 설계"
- "PostHog 설치", "Clarity 추가", "퍼널 분석 만들어줘"
- app-dev-orchestrator / dev-orchestrator 에서 호출

## 도구 선택

| 용도 | 추천 | 대안 |
|---|---|---|
| **제품 분석** (퍼널/리텐션) | PostHog (셀프호스팅 가능) | Mixpanel, Amplitude |
| **웹 트래픽** | GA4 | Plausible, Fathom |
| **세션 리코딩** | Microsoft Clarity (무료) | Hotjar, FullStory |
| **모바일 앱** | Firebase Analytics | Amplitude |
| **에러 추적** | Sentry | Bugsnag |
| **A/B 테스트** | PostHog / GrowthBook | Optimizely |

## Workflow

### 1. 이벤트 택소노미 설계

이벤트 명명 규칙: `object_action` (snake_case)

**필수 이벤트 (모든 서비스)**:
```
# 인증
user_signed_up {method: google|email|kakao}
user_logged_in {method}
user_logged_out

# 핵심 가치
feature_used {feature_name, duration_ms}
content_viewed {content_type, content_id}

# 수익화
subscription_started {plan, price, trial}
subscription_canceled {plan, reason}
payment_completed {amount, currency, method}
payment_failed {reason}

# 성장
invite_sent {channel}
referral_completed
```

### 2. 구현 패턴

```typescript
// 추상화 레이어 (provider 교체 가능)
interface AnalyticsProvider {
  track(event: string, properties?: Record<string, any>): void;
  identify(userId: string, traits?: Record<string, any>): void;
  page(name: string, properties?: Record<string, any>): void;
}
```

### 3. 동의 관리 (Consent)

- 한국: 개인정보보호법 + 정보통신망법 → 수집 동의 배너
- EU: GDPR → opt-in 필수
- 구현: 동의 전 analytics 미로드, 동의 후 활성화

### 4. 대시보드 핵심 지표

| 지표 | 공식 | 목표 |
|---|---|---|
| DAU/MAU | 일간활성/월간활성 | >20% (높을수록 sticky) |
| Retention D1/D7/D30 | N일 후 복귀율 | D1>40%, D7>20% |
| Conversion Rate | 유료전환/가입 | >2% (B2C), >5% (B2B) |
| Churn Rate | 월 이탈/전체구독 | <5% |
| ARPU | 매출/활성유저 | 산업별 상이 |

## 검증 체크리스트

- [ ] 모든 핵심 이벤트 발화 확인 (dev tools network)
- [ ] identify() 호출 시 유저 속성 연결
- [ ] 동의 배너 동작 (미동의 시 추적 안 됨)
- [ ] 퍼널 설정 + 이탈 지점 확인
- [ ] Clarity 세션 리코딩 동작
- [ ] GDPR/개인정보보호법 준수

## Related Skills

- `monetization-planner` — 추적할 전환 지표 정의
- `growth-engine` — 어트리뷰션 + A/B 테스트 연동
- `revenue-scenario-tester` — Analytics Agent 검증

