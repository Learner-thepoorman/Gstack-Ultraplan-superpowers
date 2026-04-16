# Design Philosophy Reference

## Contents

- [Anti-Slop Manifesto](#anti-slop-manifesto)
- [What Makes Design Feel Human](#what-makes-design-feel-human)
- [Common AI Design Traps](#common-ai-design-traps)
- [Quality Benchmarks](#quality-benchmarks)

## Anti-Slop Manifesto

"Slop" in AI-generated design is the visual equivalent of filler text — it looks
like design but communicates nothing specific. It exists because AI models have
learned the *average* of millions of designs, producing output that is technically
competent but emotionally flat.

The antidote is **specificity**: specific colors chosen for a reason, specific
typography that matches the brand personality, specific imagery that shows the
actual product, specific copy that names a real outcome.

## What Makes Design Feel Human

1. **Imperfection with intent** — A grid break, an oversized element, a color
   that clashes slightly. These create visual tension that holds attention.

2. **Content density variation** — Some sections are packed, others breathe.
   AI tends to distribute content evenly. Humans cluster and separate.

3. **Personality in details** — A custom cursor, a playful 404 page, a loading
   animation that tells a micro-story. These are decisions, not defaults.

4. **Contextual typography** — Headlines that respond to their content length.
   Short punchy headlines get large type. Longer ones get smaller. AI uses
   one size for all.

5. **Photography > Illustration** — Real photos of real people using real
   products. When illustrations are used, they have a distinctive style
   (Notion's hand-drawn look, Linear's geometric precision).

## Common AI Design Traps

### The Gradient Problem
AI loves gradients because they appeared frequently in training data (2018-2022
design trends). In 2025+, flat or subtle single-axis gradients are more current.

**Instead**: solid background colors, subtle shadows for depth, or photographic
backgrounds with overlays.

### The Symmetry Problem
Perfect center-alignment of everything signals "template." Real design uses
left-aligned text with right-aligned images, offset headings, and deliberately
unbalanced layouts.

**Instead**: mix alignment modes. Hero: centered. Features: left-aligned grid.
Testimonials: offset cards.

### The "SaaS Blue" Problem
A huge percentage of AI-generated SaaS designs use blue-purple palettes because
these dominate the training data. This makes every AI design look the same.

**Instead**: derive colors from the brand, the industry, or a deliberate
contrast strategy. A finance app doesn't have to be blue.

### The Everything-Animated Problem
AI design tools add animations because they seem impressive. But excessive
motion creates cognitive load and screams "I used a builder."

**Instead**: animate only state changes (hover, appear, transition). Every
animation should serve navigation or feedback, never decoration.

## Quality Benchmarks

### Tier 1: Professional (goal)
- Indistinguishable from a human designer's work
- Passes the "would I screenshot this?" test
- Specific to the product and audience

### Tier 2: Competent (acceptable)
- Clean and functional
- Follows basic design principles
- Minor slop signals (1-2 from checklist)

### Tier 3: Generic (needs rework)
- Looks like a template with content swapped in
- Multiple slop signals (3-5 from checklist)
- Could be any product's website

### Tier 4: Slop (start over)
- Immediately recognizable as AI-generated
- Gradient blobs, perfect symmetry, generic copy
- 6+ slop signals
