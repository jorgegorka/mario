# Research Template

Template for `.mario_planning/plans/XX-name/{plan}-RESEARCH.md` - comprehensive ecosystem research before planning.

**Purpose:** Document what Claude needs to know to implement a plan well - not just "which library" but "how do experts build this."

---

## File Template

```markdown
# Plan [X]: [Name] - Research

**Researched:** [date]
**Domain:** [primary technology/problem domain]
**Confidence:** [HIGH/MEDIUM/LOW]

<user_constraints>
## User Constraints (from CONTEXT.md)

**CRITICAL:** If CONTEXT.md exists from a discussion, copy locked decisions here verbatim. These MUST be honored by the planner.

### Locked Decisions
[Copy from CONTEXT.md `## Decisions` section - these are NON-NEGOTIABLE]
- [Decision 1]
- [Decision 2]

### Claude's Discretion
[Copy from CONTEXT.md - areas where researcher/planner can choose]
- [Area 1]
- [Area 2]

### Deferred Ideas (OUT OF SCOPE)
[Copy from CONTEXT.md - do NOT research or plan these]
- [Deferred 1]
- [Deferred 2]

**If no CONTEXT.md exists:** Write "No user constraints - all decisions at Claude's discretion"
</user_constraints>

<research_summary>
## Summary

[2-3 paragraph executive summary]
- What was researched
- What the standard approach is
- Key recommendations

**Primary recommendation:** [one-liner actionable guidance]
</research_summary>

<standard_stack>
## Standard Stack

The established libraries/tools for this domain:

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| [name] | [ver] | [what it does] | [why experts use it] |
| [name] | [ver] | [what it does] | [why experts use it] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| [name] | [ver] | [what it does] | [use case] |
| [name] | [ver] | [what it does] | [use case] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| [standard] | [alternative] | [when alternative makes sense] |

**Installation:**
```bash
bundle add [gems]
# or add to Gemfile and run:
bundle install
# For marketing platform integrations, document API setup steps
```
</standard_stack>

<architecture_patterns>
## Architecture Patterns

### Recommended Project Structure
```
content/
├── [folder]/        # [purpose]
├── [folder]/        # [purpose]
└── [folder]/        # [purpose]
```

### Pattern 1: [Pattern Name]
**What:** [description]
**When to use:** [conditions]
**Example:**
```markdown
# [content example or framework from authoritative sources]
```

### Pattern 2: [Pattern Name]
**What:** [description]
**When to use:** [conditions]
**Example:**
```markdown
# [content example]
```

### Anti-Patterns to Avoid
- **[Anti-pattern]:** [why it's bad, what to do instead]
- **[Anti-pattern]:** [why it's bad, what to do instead]
</architecture_patterns>

<dont_hand_roll>
## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| [problem] | [what you'd build] | [library] | [edge cases, complexity] |
| [problem] | [what you'd build] | [library] | [edge cases, complexity] |
| [problem] | [what you'd build] | [library] | [edge cases, complexity] |

**Key insight:** [why custom solutions are worse in this domain]
</dont_hand_roll>

<common_pitfalls>
## Common Pitfalls

### Pitfall 1: [Name]
**What goes wrong:** [description]
**Why it happens:** [root cause]
**How to avoid:** [prevention strategy]
**Warning signs:** [how to detect early]

### Pitfall 2: [Name]
**What goes wrong:** [description]
**Why it happens:** [root cause]
**How to avoid:** [prevention strategy]
**Warning signs:** [how to detect early]

### Pitfall 3: [Name]
**What goes wrong:** [description]
**Why it happens:** [root cause]
**How to avoid:** [prevention strategy]
**Warning signs:** [how to detect early]
</common_pitfalls>

<code_examples>
## Code Examples

Verified patterns from official sources:

### [Common Operation 1]
```markdown
# Source: [official docs/best practices URL]
[content example]
```

### [Common Operation 2]
```markdown
# Source: [official docs/best practices URL]
[content example]
```

### [Common Operation 3]
```markdown
# Source: [official docs/best practices URL]
[content example]
```
</code_examples>

<sota_updates>
## State of the Art (2024-2025)

What's changed recently:

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| [old] | [new] | [date/version] | [what it means for implementation] |

**New tools/patterns to consider:**
- [Tool/Pattern]: [what it enables, when to use]
- [Tool/Pattern]: [what it enables, when to use]

**Deprecated/outdated:**
- [Thing]: [why it's outdated, what replaced it]
</sota_updates>

<open_questions>
## Open Questions

Things that couldn't be fully resolved:

1. **[Question]**
   - What we know: [partial info]
   - What's unclear: [the gap]
   - Recommendation: [how to handle during planning/execution]

2. **[Question]**
   - What we know: [partial info]
   - What's unclear: [the gap]
   - Recommendation: [how to handle]
</open_questions>

<sources>
## Sources

### Primary (HIGH confidence)
- [Context7 library ID] - [topics fetched]
- [Official docs URL] - [what was checked]

### Secondary (MEDIUM confidence)
- [WebSearch verified with official source] - [finding + verification]

### Tertiary (LOW confidence - needs validation)
- [WebSearch only] - [finding, marked for validation during implementation]
</sources>

<metadata>
## Metadata

**Research scope:**
- Core technology: [what]
- Ecosystem: [libraries explored]
- Patterns: [patterns researched]
- Pitfalls: [areas checked]

**Confidence breakdown:**
- Standard stack: [HIGH/MEDIUM/LOW] - [reason]
- Architecture: [HIGH/MEDIUM/LOW] - [reason]
- Pitfalls: [HIGH/MEDIUM/LOW] - [reason]
- Code examples: [HIGH/MEDIUM/LOW] - [reason]

**Research date:** [date]
**Valid until:** [estimate - 30 days for stable tech, 7 days for fast-moving]
</metadata>

---

*Plan: XX-name*
*Research completed: [date]*
*Ready for planning: [yes/no]*
```

---

## Good Example

```markdown
# Plan 3: Email Marketing Automation - Research

**Researched:** 2025-01-20
**Domain:** Email marketing automation with Mailchimp and ConvertKit
**Confidence:** HIGH

<research_summary>
## Summary

Researched the email marketing ecosystem for building an effective automated welcome sequence. The standard approach uses a dedicated ESP (Email Service Provider) with built-in automation, segmentation, and analytics — either Mailchimp for broader marketing needs or ConvertKit for creator-focused workflows.

Key finding: Don't hand-roll email scheduling logic, deliverability optimization, or audience segmentation. ESPs handle all of this with battle-tested infrastructure. Custom email sending leads to deliverability issues, spam classification, and lost subscribers.

**Primary recommendation:** Use Mailchimp or ConvertKit for automation. Structure sequences around customer journey stages with progressive CTAs, maintain brand voice consistency across all touchpoints, and include compliance elements (CAN-SPAM, GDPR) from day one.
</research_summary>

<standard_stack>
## Standard Stack

### Core
| Tool | Version/Tier | Purpose | Why Standard |
|------|-------------|---------|--------------|
| Mailchimp | Standard plan | Email automation + audience management | Most widely adopted ESP with robust automation |
| ConvertKit | Creator plan | Creator-focused email sequences | Superior tagging and visual automation builder |
| Google Analytics 4 | Free | Email campaign tracking | Industry standard for conversion attribution |
| Litmus | Basic plan | Email rendering testing | Cross-client preview and accessibility checks |

### Supporting
| Tool | Version/Tier | Purpose | When to Use |
|------|-------------|---------|-------------|
| Canva | Pro | Email header graphics | Visual content for email templates |
| SpamAssassin | - | Deliverability testing | Pre-send spam score checking |
| MailTester | Free | Deliverability scoring | Quick spam score before launch |
| Zapier | Starter | Platform integration | Connecting ESP to CRM or other tools |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Mailchimp | ConvertKit | ConvertKit better for creators, Mailchimp better for e-commerce |
| Mailchimp | ActiveCampaign | More powerful automation but steeper learning curve |
| Litmus | Email on Acid | Similar features, Litmus has broader client coverage |

**Setup:**
```bash
# Mailchimp API integration
# 1. Create Mailchimp account and generate API key
# 2. Configure audience lists and tags
# 3. Set up automation workflows in dashboard
```
</standard_stack>

<architecture_patterns>
## Architecture Patterns

### Recommended Content Structure
```
content/
├── email/
│   ├── welcome-sequence.md        # Full automated welcome series
│   ├── subject-line-variants.md   # A/B test options per email
│   └── segmentation-rules.md      # Audience segment definitions
├── strategy/
│   ├── email-strategy-brief.md    # Channel strategy and goals
│   ├── cta-framework.md           # Progressive CTA guidelines
│   └── brand-positioning.md       # Voice and tone reference
└── analytics/
    └── email-kpi-targets.md       # Open rate, CTR, conversion goals
```

### Pattern 1: Journey-Mapped Sequences
**What:** Map each email to a specific customer journey stage with escalating engagement
**When to use:** Always for automated sequences — ensures intentional progression
**Example:**
```markdown
# Source: Mailchimp email marketing best practices
## Email Sequence Journey Map

| Email | Day | Journey Stage | CTA Level | Goal |
|-------|-----|---------------|-----------|------|
| 1 | 0 | Awareness | Low (read blog) | Establish value |
| 2 | 3 | Interest | Medium (free tool) | Build trust |
| 3 | 7 | Consideration | Medium (case study) | Show proof |
| 4 | 14 | Intent | High (free trial) | Lower barrier |
| 5 | 21 | Decision | High (purchase) | Convert |
```

### Pattern 2: Brand Voice Consistency Framework
**What:** Define voice attributes with do/don't examples that apply across all emails
**When to use:** Every sequence — prevents tone drift between emails
**Example:**
```markdown
# Source: Content Marketing Institute voice guidelines
## Voice Attributes

| Attribute | Do | Don't |
|-----------|-----|-------|
| Casual-expert | "Here's what we've found works best" | "Our proprietary methodology leverages..." |
| Helpful | "Try this 3-step approach" | "You should already know this" |
| Confident | "This approach delivers results" | "We think this might possibly help" |
```

### Anti-Patterns to Avoid
- **Generic messaging to all segments:** Personalize based on signup source, behavior, or stated interests
- **Inconsistent send cadence:** Establish and maintain predictable timing
- **Missing compliance elements:** Always include unsubscribe, physical address, and sender ID from email 1
</architecture_patterns>

<dont_hand_roll>
## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Email scheduling | Manual send timing | ESP automation workflows | Handles timezone, optimal send time, throttling |
| Audience segmentation | Spreadsheet-based lists | ESP tagging and segments | Dynamic, behavior-based, auto-updating |
| Deliverability | Self-hosted email sending | ESP infrastructure | IP reputation, authentication (SPF/DKIM), bounce handling |
| A/B testing | Manual variant tracking | ESP built-in A/B testing | Statistical significance, automatic winner selection |
| Analytics | Custom tracking spreadsheets | ESP analytics + GA4 | Real-time, automated, integrated with campaigns |

**Key insight:** Email deliverability alone has decades of solved problems. ESPs maintain IP reputation, handle bounce management, and implement authentication protocols. Self-managed email sending leads to spam classification and lost subscribers.
</dont_hand_roll>

<common_pitfalls>
## Common Pitfalls

### Pitfall 1: Aggressive Early CTAs
**What goes wrong:** High unsubscribe rates, low engagement, spam complaints
**Why it happens:** Pushing purchase CTAs before establishing value and trust
**How to avoid:** Progressive CTA escalation — start with low-commitment asks (read, watch, download)
**Warning signs:** Unsubscribe rate above 1% on early emails, declining open rates

### Pitfall 2: Tone Drift Across Sequence
**What goes wrong:** Brand feels inconsistent, readers lose trust
**Why it happens:** Writing emails at different times without referencing brand voice guidelines
**How to avoid:** Define voice attributes with examples, review full sequence for consistency before launch
**Warning signs:** Feedback about "different feel" between emails, varying engagement patterns

### Pitfall 3: Missing Compliance Elements
**What goes wrong:** Legal liability, ESP account suspension, deliverability damage
**Why it happens:** Treating compliance as an afterthought, adding "later"
**How to avoid:** Include CAN-SPAM/GDPR elements (unsubscribe, address, sender ID) in every email from draft 1
**Warning signs:** ESP warnings, complaint rates above 0.1%, missing footer elements
</common_pitfalls>

<code_examples>
## Code Examples

### Welcome Email Structure
```markdown
# Source: Mailchimp email marketing best practices
## Email 1: Welcome + Value Proposition

**Subject:** Welcome to [Brand] — here's what to expect
**Preview text:** Plus a quick win to get you started

### Body Structure
1. Personal greeting (use first name merge tag)
2. What they signed up for (set expectations)
3. One quick-win tip (immediate value)
4. What's coming next (build anticipation)
5. Low-commitment CTA (read our most popular guide)

### Footer
- Unsubscribe link
- Physical address
- Why they're receiving this email
```

### Subject Line A/B Testing Framework
```markdown
# Source: Campaign Monitor subject line research
## A/B Test Variants

| Variant | Type | Example |
|---------|------|---------|
| A | Curiosity | "The one thing most [audience] get wrong about [topic]" |
| B | Benefit-led | "Get [specific result] in [timeframe]" |
| C | Social proof | "[Number] [audience members] already use this approach" |

**Test rules:**
- Test one variable at a time (length, emoji, personalization)
- Minimum 1,000 recipients per variant for significance
- Let test run 4+ hours before declaring winner
```
</code_examples>

<sota_updates>
## State of the Art (2024-2025)

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Batch-and-blast | Behavior-triggered sequences | 2020+ | Higher engagement, lower unsubscribe rates |
| Open rate as primary KPI | Click-through + conversion tracking | 2021+ | Apple MPP made open rates unreliable |
| Generic subject lines | AI-assisted personalization | 2023+ | Dynamic subject lines improve open rates 10-20% |

**New tools/patterns to consider:**
- **AI-powered send time optimization:** Mailchimp and ConvertKit now optimize per-subscriber send times
- **Interactive email (AMP):** Enables in-email forms and dynamic content, growing adoption

**Deprecated/outdated:**
- **Open rate as primary metric:** Apple Mail Privacy Protection inflates open rates since 2021
- **Single-send campaigns only:** Automation sequences outperform one-off sends consistently
</sota_updates>

<sources>
## Sources

### Primary (HIGH confidence)
- Mailchimp email marketing best practices - sequence structure, compliance, deliverability
- Campaign Monitor research - subject line optimization, A/B testing methodology
- CAN-SPAM Act requirements - compliance elements checklist

### Secondary (MEDIUM confidence)
- Content Marketing Institute - brand voice frameworks, verified against multiple sources
- HubSpot email benchmarks 2024 - industry averages for open/click rates

### Tertiary (LOW confidence - needs validation)
- None - all findings verified
</sources>

<metadata>
## Metadata

**Research scope:**
- Core technology: Mailchimp + ConvertKit
- Ecosystem: Litmus, GA4, Zapier
- Patterns: Journey-mapped sequences, brand voice consistency, progressive CTAs
- Pitfalls: Aggressive CTAs, tone drift, missing compliance

**Confidence breakdown:**
- Standard stack: HIGH - verified with ESP documentation, widely adopted
- Architecture: HIGH - from official best practices and industry standards
- Pitfalls: HIGH - documented in ESP guidelines, validated by industry benchmarks
- Content examples: HIGH - from official sources and verified frameworks

**Research date:** 2025-01-20
**Valid until:** 2025-02-20 (30 days - email marketing ecosystem stable)
</metadata>

---

*Plan: 03-email-campaign*
*Research completed: 2025-01-20*
*Ready for planning: yes*
```

---

## Guidelines

**When to create:**
- Before planning plans in niche/complex domains
- When Claude's training data is likely stale or sparse
- When "how do experts do this" matters more than "which library"

**Structure:**
- Use XML tags for section markers (matches Mario templates)
- Seven core sections: summary, standard_stack, architecture_patterns, dont_hand_roll, common_pitfalls, code_examples, sources
- All sections required (drives comprehensive research)

**Content quality:**
- Standard stack: Specific versions, not just names
- Architecture: Include actual content examples from authoritative sources
- Don't hand-roll: Be explicit about what problems to NOT solve yourself
- Pitfalls: Include warning signs, not just "don't do this"
- Sources: Mark confidence levels honestly

**Integration with planning:**
- RESEARCH.md loaded as context reference in PLAN.md
- Standard stack informs library choices
- Don't hand-roll prevents custom solutions
- Pitfalls inform verification criteria
- Code examples can be referenced in task actions

**After creation:**
- File lives in plan directory: `.mario_planning/plans/XX-name/{plan}-RESEARCH.md`
- Referenced during planning workflow
- plan loads it automatically when present
