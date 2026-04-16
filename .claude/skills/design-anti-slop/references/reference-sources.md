# Reference Sources

## Contents

- [Curated Sources](#curated-sources)
- [How to Extract Patterns](#how-to-extract-patterns)
- [Anti-Patterns to Avoid](#anti-patterns-to-avoid)

## Curated Sources

### Component Galleries

| Source | Best For | Notes |
|--------|----------|-------|
| 21st.dev | UI components, micro-interactions | Community-curated, high quality |
| Shadcn/ui | Accessible component patterns | Not for visual design, for structure |
| Radix | Headless component behavior | Accessibility patterns |

### Full-Site Inspiration

| Source | Best For | Notes |
|--------|----------|-------|
| Awwwards | Cutting-edge visual design | Filter by "Site of the Day" |
| Dribbble | UI concepts, exploration | Avoid "popular" — curate by hand |
| Mobbin | Mobile UI patterns | Searchable by flow type |
| Lapa.ninja | Landing page collection | Categorized by industry |
| SaaS Landing Page | SaaS-specific patterns | Focused on conversion |

### Typography

| Source | Best For | Notes |
|--------|----------|-------|
| Google Fonts | Free web fonts | Stick to popular, well-hinted fonts |
| Fontshare | Free quality fonts | Higher curation than Google Fonts |
| Typewolf | Font pairing inspiration | Shows fonts in real-world use |

### Color

| Source | Best For | Notes |
|--------|----------|-------|
| Realtime Colors | Live palette preview | See colors on a real layout |
| Coolors | Quick palette generation | Good for starting points |
| Happy Hues | Curated palettes with context | Shows palettes applied to designs |

## How to Extract Patterns

When reviewing a reference site, capture these specifics:

### Typography Extraction
```
Font family: Inter
Heading sizes: 48 / 32 / 24 / 20
Body size: 16px, line-height: 1.6
Font weights used: 400 (body), 600 (heading), 700 (hero)
Letter-spacing: -0.02em (headings), normal (body)
```

### Color Extraction
```
Primary: #2563EB (blue, CTAs and links)
Secondary: #F59E0B (amber, highlights and badges)
Accent: none (they only use 2 colors)
Neutral-dark: #111827 (text)
Neutral-mid: #6B7280 (secondary text)
Neutral-light: #F9FAFB (backgrounds)
```

### Spacing Extraction
```
Base unit: 8px
Section padding: 96px (top/bottom)
Card gap: 24px
Feature grid: 3-col, 32px gap
Hero top-padding: 128px
```

### Layout Extraction
```
Max-width: 1200px
Columns: 12-col grid
Hero: centered, single column
Features: 3-col grid
Testimonials: 2-col offset
```

## Anti-Patterns to Avoid

When selecting references, skip sites that exhibit:

1. **Template lineage** — if you can tell which template/builder was used
2. **Stock photo overload** — generic "diverse team in office" imagery
3. **Feature dumping** — everything the product does on one page
4. **Animation carnival** — parallax + floating + pulsing + sliding
5. **Color explosion** — different accent color per section
6. **Font buffet** — 3+ different typefaces on one page
