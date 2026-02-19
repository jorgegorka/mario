# PROJECT.md Template

Template for `.mario_planning/PROJECT.md` — the living project context document.

<template>

```markdown
# [Project Name]

## What This Is

[Current accurate description — 2-3 sentences. What does this product do and who is it for?
Use the user's language and framing. Update whenever reality drifts from this description.]

**Website:** [company/product URL if provided]

## Core Message / Value Proposition

[The ONE thing that matters most. If everything else fails, this must resonate.
One sentence that drives prioritization when tradeoffs arise.]

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] [Requirement 1]
- [ ] [Requirement 2]
- [ ] [Requirement 3]

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- [Exclusion 1] — [why]
- [Exclusion 2] — [why]

## Voice & Tone (Initial Notes)

[Captured during questioning — gives foundation researchers richer context.
- Brand personality traits (e.g., authoritative, friendly, playful, technical)
- Existing brand guidelines or style references
- Preferred tone (formal/casual, serious/lighthearted)
- Examples of content they admire or want to emulate
- Words/phrases they love or hate]

## Target Audience (Initial Notes)

[Captured during questioning — gives foundation researchers richer context.
- Customer descriptions in their own words
- Key segments or personas they recognize
- Language their customers use
- Where their customers spend time online
- What their customers care about most]

## Competitive Context (Initial Notes)

[Captured during questioning — gives foundation researchers richer context.
- Competitors mentioned and how they're positioned
- What differentiates this brand from competitors
- Competitor content or messaging they admire or dislike
- Market gaps they see]

## Context

[Background information that informs marketing decisions:
- Business environment, market context, competitive landscape
- Existing marketing efforts and their performance
- Customer research or feedback themes
- Known gaps or issues to address]

## Constraints

- **[Type]**: [What] — [Why]
- **[Type]**: [What] — [Why]

Common types: Budget, Timeline, Brand guidelines, Regulatory constraints, Channel restrictions, Dependencies

## Key Decisions

<!-- Decisions that constrain future work. Add throughout project lifecycle. -->

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| [Choice] | [Why] | [✓ Good / ⚠️ Revisit / — Pending] |

---
*Last updated: [date] after [trigger]*
```

</template>

<guidelines>

**What This Is:**
- Current accurate description of the product
- 2-3 sentences capturing what it does and who it's for
- Use the user's words and framing
- Update when the product evolves beyond this description

**Core Message / Value Proposition:**
- The single most important message to communicate
- Everything else can fail; this must resonate with the target audience
- Drives prioritization when tradeoffs arise
- Rarely changes; if it does, it's a significant pivot

**Requirements — Validated:**
- Requirements that shipped and proved valuable
- Format: `- ✓ [Requirement] — [plan]`
- These are locked — changing them requires explicit discussion

**Requirements — Active:**
- Current scope being built toward
- These are hypotheses until shipped and validated
- Move to Validated when shipped, Out of Scope if invalidated

**Requirements — Out of Scope:**
- Explicit boundaries on what we're not building
- Always include reasoning (prevents re-adding later)
- Includes: considered and rejected, deferred to future, explicitly excluded

**Website:**
- The company or product website URL
- Used by the feature researcher to crawl and extract product features
- Optional — research can also use WebSearch or customer-provided documents

**Voice & Tone (Initial Notes):**
- Captured during questioning to give foundation researchers richer context
- Brand personality, existing guidelines, preferred tone
- Examples they admire, words they love/hate
- Feeds into VOICE-TONE.md foundation research

**Target Audience (Initial Notes):**
- Captured during questioning to give foundation researchers richer context
- Customer descriptions, segments, language
- Where customers spend time, what they care about
- Feeds into AUDIENCE-PERSONAS.md foundation research

**Competitive Context (Initial Notes):**
- Captured during questioning to give foundation researchers richer context
- Competitors mentioned, positioning, differentiation
- Content they admire or dislike from competitors
- Feeds into COMPETITIVE-LANDSCAPE.md foundation research

**Context:**
- Background that informs marketing decisions
- Business environment, competitive landscape, existing marketing efforts
- Customer research, market trends, known gaps
- Update as new context emerges

**Constraints:**
- Hard limits on marketing choices
- Budget, timeline, brand guidelines, regulatory constraints, channel restrictions
- Include the "why" — constraints without rationale get questioned

**Key Decisions:**
- Significant choices that affect future work
- Add decisions as they're made throughout the project
- Track outcome when known:
  - ✓ Good — decision proved correct
  - ⚠️ Revisit — decision may need reconsideration
  - — Pending — too early to evaluate

**Last Updated:**
- Always note when and why the document was updated
- Format: `after Plan 002`
- Triggers review of whether content is still accurate

</guidelines>

<evolution>

PROJECT.md evolves throughout the project lifecycle.

**After completing each plan:**
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with plan reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

</evolution>

<brownfield>

For existing codebases:

1. **Map codebase first** via `/mario:map-codebase`

2. **Infer Validated requirements** from existing code:
   - What does the codebase actually do?
   - What patterns are established?
   - What's clearly working and relied upon?

3. **Gather Active requirements** from user:
   - Present inferred current state
   - Ask what they want to build next

4. **Initialize:**
   - Validated = inferred from existing code
   - Active = user's goals for this work
   - Out of Scope = boundaries user specifies
   - Context = includes current codebase state

</brownfield>

<state_reference>

STATE.md references PROJECT.md:

```markdown
## Project Reference

See: .mario_planning/PROJECT.md (updated [date])

**Core message:** [One-liner from Core Message section]
**Current focus:** [Current plan name]
```

This ensures Claude reads current PROJECT.md context.

</state_reference>
