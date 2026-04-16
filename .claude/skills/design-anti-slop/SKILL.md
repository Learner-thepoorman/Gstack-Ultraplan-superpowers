---
name: design-anti-slop
description: >-
  Use when the user wants to ensure AI-generated designs avoid generic "AI slop"
  patterns — triggers include "AI 느낌 없애줘", "디자인 슬롭", "generic AI look",
  "make it look real", "not like AI made it", "디자인 퀄리티", "anti-slop",
  "design quality check", "looks too templated", "슬롭 제거", "design polish".
  Enforces a reference-first workflow: real screenshots before any generation,
  3-color constraint, 5-step landing structure, and human-touch details
  (asymmetric spacing, real photography, specific typography). Produces a design
  checklist and inline critique. Pairs with /design-html for production output
  and /design-review for live site auditing.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
version: 1.0.0
author: simon
tags: [design, anti-slop, quality, landing-page, ui]
---

# Design Anti-Slop

AI 로 생성한 디자인이 "AI 가 만든 티"가 나는 흔한 함정을 체계적으로 방지합니다.

## The Problem

AI-generated designs share telltale patterns ("slop"):
- Gradient blobs everywhere
- Perfect symmetry with no visual tension
- Generic stock-photo-style hero images
- "SaaS template" color palettes (blue-purple gradient)
- Placeholder-feeling copy ("Transform your workflow")
- Equal spacing everywhere (no rhythm)
- Too many font weights and sizes

## Core Principles

### 1. Reference-First

**Never generate before referencing.** Before any design work:

1. Collect 3-5 real screenshots from best-in-class sites
2. Identify what makes each one feel "real" and "human"
3. Extract specific patterns: typography scale, spacing rhythm, color usage
4. Use these as constraints, not as templates to copy

Sources for references:
- Dribbble (curated collections, not popular/trending)
- Awwwards (site of the day archives)
- 21st.dev (component gallery)
- Mobbin (mobile patterns)
- Direct competitors' live sites

### 2. Three-Color Constraint

Maximum 3 colors + neutrals:

```
Primary:   1 bold color (CTA, key accents)
Secondary: 1 supporting color (subtle highlights, secondary actions)
Accent:    1 contrast color (sparingly — alerts, badges, special states)
Neutrals:  Gray scale only (text, borders, backgrounds)
```

**Red flags**: gradient backgrounds, rainbow sections, color for every feature.

### 3. Typography Discipline

- **2 fonts maximum** (1 heading + 1 body, or 1 font family with weight contrast)
- **3-4 size stops** (don't use more than 4 distinct font sizes)
- **Heading scale**: pick one ratio and stick to it (1.25, 1.333, or 1.5)
- **Body**: 16-18px minimum, 1.5-1.7 line height
- **Letter-spacing**: tighten headings (-0.02em), loosen small caps (+0.05em)

### 4. Spacing Rhythm

Use a base unit (8px) and vary it intentionally:

```
Tight:    8px  (related items)
Default: 16px  (standard gaps)
Loose:   32px  (section breathing room)
Generous: 64px (section separators)
Hero:   128px+ (above-the-fold vertical space)
```

**Anti-pattern**: everything at 24px. Rhythm = variety with system.

### 5. Human Touch Details

What separates "designed" from "generated":

- **Asymmetric layouts** — not everything centered
- **Real photography** over illustrations (or specific illustration style, not generic)
- **Micro-interactions** — subtle hover states, not dramatic animations
- **Imperfect alignment** — intentional off-grid elements create visual interest
- **Content-specific imagery** — screenshots of actual product, not abstract shapes
- **Whitespace as a feature** — empty space is not wasted space

## 5-Step Landing Page Structure

When building landing pages, follow this anatomy:

### Step 1: Hero (above the fold)
- **One** clear value proposition (not a paragraph)
- **One** CTA button (not three)
- Product screenshot or demo, not abstract illustration
- Social proof number if available ("10,000+ teams")

### Step 2: Feature Showcase
- 3 features maximum in the first pass
- Each with a real screenshot or specific icon
- Benefits, not features ("Save 4 hours/week" not "Automated workflows")

### Step 3: Use Case / Social Proof
- Real customer quotes with names and photos
- Or: "Before/After" comparison
- Or: Logo wall of recognizable companies

### Step 4: How It Works
- 3-step visual flow
- Numbered, not bulleted
- Each step has a clear action verb

### Step 5: CTA + Footer
- Repeat the primary CTA
- Minimal footer (links, legal, social)
- No "newsletter signup" unless it's the primary conversion

## Slop Detection Checklist

Run this checklist against any AI-generated design:

| # | Check | Slop Signal | Fix |
|---|-------|-------------|-----|
| 1 | Color count | > 3 non-neutral colors | Reduce to 3-color palette |
| 2 | Gradient usage | Decorative gradient backgrounds | Solid colors or subtle single-axis |
| 3 | Typography | > 4 font sizes on one page | Establish type scale, reduce stops |
| 4 | Symmetry | Everything perfectly centered | Add asymmetric sections |
| 5 | Imagery | Abstract blobs / generic illustrations | Real product screenshots |
| 6 | Copy | "Transform/Revolutionize/Empower" | Specific outcome language |
| 7 | Spacing | Uniform gaps everywhere | Intentional rhythm (8/16/32/64) |
| 8 | CTAs | Multiple competing CTAs | One primary, one secondary max |
| 9 | Animation | Parallax + floating + pulsing | Subtle hover/scroll only |
| 10 | Hero | Tagline + paragraph + 3 buttons | One sentence + one CTA |

Score: count the number of PASS items.
- 9-10: Ship it
- 7-8: Polish pass needed
- 5-6: Significant rework
- < 5: Start over with references

## Workflow

1. **Collect references** — gather 3-5 screenshots from reference sources
2. **Extract patterns** — note specific typography, color, spacing choices
3. **Apply constraints** — enforce 3-color, 2-font, spacing rhythm
4. **Generate/design** — with constraints loaded
5. **Run checklist** — score the result against the 10-point slop check
6. **Iterate** — fix any slop signals found

## Related Skills

- `design-html` — production HTML/CSS generation (use AFTER anti-slop review)
- `design-review` — live site visual QA (finds slop in deployed sites)
- `design-shotgun` — generates multiple variants (run anti-slop on each)
- `design-consultation` — full design system creation (anti-slop principles embedded)
- `stitch-design-flow` — Stitch prompt generation (reference anti-slop in prompt)
