# Audience & Messaging Research Template

Template for `.planning/research/AUDIENCE.md` — audience landscape and messaging opportunities for the project domain.

<template>

```markdown
# Audience & Messaging Research

**Domain:** [domain type]
**Researched:** [date]
**Confidence:** [HIGH/MEDIUM/LOW]

## Audience Landscape

### Table Stakes (Audience Expects These)

Content and messaging elements the audience assumes exist. Missing these = brand feels incomplete.

| Element | Why Expected | Complexity | Channel | Notes |
|---------|--------------|------------|---------|-------|
| [element] | [audience expectation] | LOW/MEDIUM/HIGH | [e.g., website, email, social, all] | [implementation notes] |
| [element] | [audience expectation] | LOW/MEDIUM/HIGH | [channel] | [implementation notes] |
| [element] | [audience expectation] | LOW/MEDIUM/HIGH | [channel] | [implementation notes] |

### Differentiators (Competitive Advantage)

Messaging angles and content that set the brand apart. Not required, but valuable.

| Element | Value Proposition | Complexity | Channel | Notes |
|---------|-------------------|------------|---------|-------|
| [element] | [why it matters] | LOW/MEDIUM/HIGH | [channel] | [implementation notes] |
| [element] | [why it matters] | LOW/MEDIUM/HIGH | [channel] | [implementation notes] |
| [element] | [why it matters] | LOW/MEDIUM/HIGH | [channel] | [implementation notes] |

### Anti-Patterns (Commonly Requested, Often Problematic)

Content approaches that seem good but create problems.

| Approach | Why Requested | Why Problematic | Alternative |
|----------|---------------|-----------------|-------------|
| [approach] | [surface appeal] | [actual problems] | [better approach] |
| [approach] | [surface appeal] | [actual problems] | [better approach] |

## Content Dependencies

```
[Positioning Document]
    └──requires──> [Audience Research]
                       └──requires──> [Competitive Analysis]

[Email Sequence] ──requires──> [Landing Page Content]

[Social Content] ──adapts──> [Blog Content via repurposing]

[Ad Copy] ──conflicts──> [Organic messaging tone if not aligned]
```

### Dependency Notes

- **[Positioning] requires [Audience Research]:** [why — e.g., positioning must be grounded in real customer language and pain points]
- **[Email] requires [Landing Page]:** [how they work together — e.g., email CTAs drive to landing pages; pages must exist before emails send]
- **[Ad Copy] conflicts with [Organic tone]:** [why they might clash — e.g., ad urgency can feel forced if brand voice is calm and authoritative]

### Channel Infrastructure Needs

For each major content area, note which channels and tools are involved:

| Content Area | Email | Social | Paid Ads | SEO | Website | Design |
|-------------|-------|--------|----------|-----|---------|--------|
| [content area] | YES/NO | YES/NO | YES/NO | YES/NO | YES/NO | YES/NO |
| [content area] | YES/NO | YES/NO | YES/NO | YES/NO | YES/NO | YES/NO |
| [content area] | YES/NO | YES/NO | YES/NO | YES/NO | YES/NO | YES/NO |

## MVP Definition

### Launch With (v1)

Minimum viable marketing presence — what's needed to validate the messaging and start generating leads.

- [ ] [Content/asset] — [why essential]
- [ ] [Content/asset] — [why essential]
- [ ] [Content/asset] — [why essential]

### Add After Validation (v1.x)

Content to add once core messaging is working and converting.

- [ ] [Content/asset] — [trigger for adding]
- [ ] [Content/asset] — [trigger for adding]

### Future Consideration (v2+)

Content to defer until product-market fit and messaging are established.

- [ ] [Content/asset] — [why defer]
- [ ] [Content/asset] — [why defer]

## Content Prioritization Matrix

| Content/Asset | Audience Value | Production Cost | Priority |
|--------------|---------------|-----------------|----------|
| [content] | HIGH/MEDIUM/LOW | HIGH/MEDIUM/LOW | P1/P2/P3 |
| [content] | HIGH/MEDIUM/LOW | HIGH/MEDIUM/LOW | P1/P2/P3 |
| [content] | HIGH/MEDIUM/LOW | HIGH/MEDIUM/LOW | P1/P2/P3 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Messaging Analysis

| Messaging Angle | Competitor A | Competitor B | Our Approach |
|----------------|--------------|--------------|--------------|
| [angle] | [how they position] | [how they position] | [our plan] |
| [angle] | [how they position] | [how they position] | [our plan] |

## Sources

- [Competitor marketing assets analyzed]
- [Customer research or feedback sources]
- [Industry standards and benchmarks referenced]

---
*Audience & messaging research for: [domain]*
*Researched: [date]*
```

</template>

<guidelines>

**Table Stakes:**
- These are non-negotiable for launch
- The audience does not give credit for having them, but penalizes for missing them
- Example: A B2B SaaS without a clear pricing page or product description is broken

**Differentiators:**
- These are where you compete on messaging
- Should align with the Core Value from PROJECT.md
- Don't try to differentiate on everything

**Anti-Patterns:**
- Prevent scope creep by documenting what seems good but isn't
- Include the alternative approach
- Example: "Active on every social platform" when the audience only uses LinkedIn
- Example: "Daily blog posts" when quality and distribution matter more than volume
- Example: "Custom video production" when written content and screenshots suffice for the audience

**Content Dependencies:**
- Critical for backlog plan ordering
- If A requires B, B must be an earlier plan
- Conflicts inform what NOT to combine in same plan
- Note shared strategy documents that multiple content types depend on — build those first
- Channel-specific content depends on strategy layer being complete

**Channel Infrastructure Needs:**
- Identifying channel needs early avoids mid-plan setup delays
- Content needing email delivery requires ESP setup and domain authentication
- Content needing paid distribution requires ad account setup and tracking pixels
- Content needing SEO requires analytics and rank tracking setup
- Content needing social requires profile setup and scheduling tools

**MVP Definition:**
- Be ruthless about what is truly minimum
- "Nice to have" is not MVP
- Launch with less, validate messaging, then expand
- Focus on the minimum content needed to test positioning and start converting

</guidelines>
</output>
