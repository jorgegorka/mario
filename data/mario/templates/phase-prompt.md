# Phase Prompt Template

> **Note:** Planning methodology is in `agents/mario-planner.md`.
> This template defines the PLAN.md output format that the agent produces.

Template for `.planning/phases/XX-name/{phase}-{plan}-PLAN.md` - executable phase plans optimized for parallel execution.

**Naming:** Use `{phase}-{plan}-PLAN.md` format (e.g., `01-02-PLAN.md` for Phase 1, Plan 2)

---

## File Template

```markdown
---
phase: XX-name
plan: NN
type: execute
wave: N                     # Execution wave (1, 2, 3...). Pre-computed at plan time.
depends_on: []              # Plan IDs this plan requires (e.g., ["01-01"]).
files_modified: []          # Files this plan modifies.
autonomous: true            # false if plan has checkpoints requiring user interaction
user_setup: []              # Human-required setup Claude cannot automate (see below)
domain: general             # optional: backend, frontend, testing, general
domain_guide: ~             # optional: guide filename (e.g., backend.md)

# Goal-backward verification (derived during planning, verified after execution)
must_haves:
  truths: []                # Observable behaviors that must be true for goal achievement
  artifacts: []             # Files that must exist with real implementation
  key_links: []             # Critical connections between artifacts
---

<objective>
[What this plan accomplishes]

Purpose: [Why this matters for the project]
Output: [What artifacts will be created]
</objective>

<execution_context>
@~/.claude/mario/workflows/execute-plan.md
@~/.claude/mario/templates/summary.md
[If plan contains checkpoint tasks (type="checkpoint:*"), add:]
@~/.claude/mario/references/checkpoints.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md

# Only reference prior plan SUMMARYs if genuinely needed:
# - This plan uses types/exports from prior plan
# - Prior plan made decision that affects this plan
# Do NOT reflexively chain: Plan 02 refs 01, Plan 03 refs 02...

[Relevant source files:]
@content/path/to/relevant.md
</context>

<tasks>

<task type="auto">
  <name>Task 1: [Action-oriented name]</name>
  <files>path/to/file.ext, another/file.ext</files>
  <action>[Specific implementation - what to do, how to do it, what to avoid and WHY]</action>
  <verify>[Command or check to prove it worked]</verify>
  <done>[Measurable acceptance criteria]</done>
</task>

<task type="auto">
  <name>Task 2: [Action-oriented name]</name>
  <files>path/to/file.ext</files>
  <action>[Specific implementation]</action>
  <verify>[Command or check]</verify>
  <done>[Acceptance criteria]</done>
</task>

<!-- For checkpoint task examples and patterns, see @~/.claude/mario/references/checkpoints.md -->
<!-- Key rule: Claude starts dev server BEFORE human-verify checkpoints. User only visits URLs. -->

<task type="checkpoint:decision" gate="blocking">
  <decision>[What needs deciding]</decision>
  <context>[Why this decision matters]</context>
  <options>
    <option id="option-a"><name>[Name]</name><pros>[Benefits]</pros><cons>[Tradeoffs]</cons></option>
    <option id="option-b"><name>[Name]</name><pros>[Benefits]</pros><cons>[Tradeoffs]</cons></option>
  </options>
  <resume-signal>Select: option-a or option-b</resume-signal>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <what-built>[What Claude built] - server running at [URL]</what-built>
  <how-to-verify>Visit [URL] and verify: [visual checks only, NO CLI commands]</how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>
</task>

</tasks>

<verification>
Before declaring plan complete:
- [ ] [Specific test command]
- [ ] [Build/type check passes]
- [ ] [Behavior verification]
</verification>

<success_criteria>

- All tasks completed
- All verification checks pass
- No errors or warnings introduced
- [Plan-specific criteria]
  </success_criteria>

<output>
After completion, create `.planning/phases/XX-name/{phase}-{plan}-SUMMARY.md`
</output>
```

---

## Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `phase` | Yes | Phase identifier (e.g., `01-foundation`) |
| `plan` | Yes | Plan number within phase (e.g., `01`, `02`) |
| `type` | Yes | Always `execute` for standard plans, `tdd` for TDD plans |
| `wave` | Yes | Execution wave number (1, 2, 3...). Pre-computed at plan time. |
| `depends_on` | Yes | Array of plan IDs this plan requires. |
| `files_modified` | Yes | Files this plan touches. |
| `autonomous` | Yes | `true` if no checkpoints, `false` if has checkpoints |
| `user_setup` | No | Array of human-required setup items (external services) |
| `domain` | No | Domain assignment: `strategy`, `web`, `email`, `social`, `seo`, `ads`, `general` (for domain-split execution) |
| `domain_guide` | No | Guide filename for domain executor (e.g., `strategy.md`) |
| `must_haves` | Yes | Goal-backward verification criteria (see below) |

**Wave is pre-computed:** Wave numbers are assigned during `/mario:plan-phase`. Execute-phase reads `wave` directly from frontmatter and groups plans by wave number. No runtime dependency analysis needed.

**Must-haves enable verification:** The `must_haves` field carries goal-backward requirements from planning to execution. After all plans complete, execute-phase spawns a verification subagent that checks these criteria against the actual codebase.

---

## Parallel vs Sequential

<parallel_examples>

**Wave 1 candidates (parallel):**

```yaml
# Plan 01 - Email channel content
wave: 1
depends_on: []
files_modified: [content/email/welcome-sequence.md, content/email/nurture-sequence.md]
autonomous: true

# Plan 02 - Social channel content (no overlap with Plan 01)
wave: 1
depends_on: []
files_modified: [content/social/content-calendar.md, content/social/platform-guidelines.md]
autonomous: true

# Plan 03 - Web channel content (no overlap)
wave: 1
depends_on: []
files_modified: [content/web/landing-page.md, content/web/homepage-copy.md]
autonomous: true
```

All three run in parallel (Wave 1) - no dependencies, no file conflicts.

**Sequential (genuine dependency):**

```yaml
# Plan 01 - Brand strategy foundation
wave: 1
depends_on: []
files_modified: [content/strategy/brand-positioning.md, content/strategy/audience-personas.md]
autonomous: true

# Plan 02 - Channel content (needs brand strategy)
wave: 2
depends_on: ["01"]
files_modified: [content/email/welcome-sequence.md]
autonomous: true
```

Plan 02 in Wave 2 waits for Plan 01 in Wave 1 - genuine dependency on auth types/middleware.

**Checkpoint plan:**

```yaml
# Plan 03 - Campaign launch with verification
wave: 3
depends_on: ["01", "02"]
files_modified: [content/strategy/campaign-launch-brief.md]
autonomous: false  # Has checkpoint:human-verify
```

Wave 3 runs after Waves 1 and 2. Pauses at checkpoint, orchestrator presents to user, resumes on approval.

**Domain-split (horizontal by expertise):**

```yaml
# Plan 01 - Strategy: Brand positioning + personas
wave: 1
depends_on: []
files_modified: [content/strategy/brand-positioning.md, content/strategy/audience-personas.md]
autonomous: true
domain: strategy
domain_guide: strategy.md

# Plan 02 - Strategy: Competitive analysis + tone
wave: 1
depends_on: []
files_modified: [content/strategy/competitive-analysis.md, content/strategy/tone-of-voice.md]
autonomous: true
domain: strategy
domain_guide: strategy.md

# Plan 03 - Email: Welcome + nurture sequences
wave: 2
depends_on: ["01", "02"]
files_modified: [content/email/welcome-sequence.md, content/email/nurture-sequence.md]
autonomous: true
domain: email
domain_guide: email.md

# Plan 04 - Web: Landing pages + homepage copy
wave: 2
depends_on: ["01", "02"]
files_modified: [content/web/landing-page.md, content/web/homepage-copy.md]
autonomous: true
domain: web
domain_guide: web-copy.md
```

Strategy plans run in Wave 1. Email and web plans run in Wave 2 (parallel, both depend on strategy). Domain executors load their respective guides for domain-specific expertise.

</parallel_examples>

---

## Context Section

**Parallel-aware context:**

```markdown
<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md

# Only include SUMMARY refs if genuinely needed:
# - This plan imports types from prior plan
# - Prior plan made decision affecting this plan
# - Prior plan's output is input to this plan
#
# Independent plans need NO prior SUMMARY references.
# Do NOT reflexively chain: 02 refs 01, 03 refs 02...

@content/path/to/relevant.md
</context>
```

**Bad pattern (creates false dependencies):**
```markdown
<context>
@.planning/phases/03-features/03-01-SUMMARY.md  # Just because it's earlier
@.planning/phases/03-features/03-02-SUMMARY.md  # Reflexive chaining
</context>
```

---

## Scope Guidance

**Plan sizing:**

- 2-3 tasks per plan
- ~50% context usage maximum
- Complex phases: Multiple focused plans, not one large plan

**When to split:**

- Different channels (email vs social vs web)
- >3 tasks
- Risk of context overflow
- TDD candidates - separate plans

**Vertical slices preferred:**

```
PREFER: Plan 01 = Email (strategy + content + sequences)
        Plan 02 = Social (strategy + content + calendar)

AVOID:  Plan 01 = All strategies
        Plan 02 = All content drafts
        Plan 03 = All campaign assets
```

---

## TDD Plans

TDD features get dedicated plans with `type: tdd`.

**Heuristic:** Can you define clear acceptance criteria before creating the content?
→ Yes: Create a TDD plan
→ No: Standard task in standard plan

See `~/.claude/mario/references/tdd.md` for TDD plan structure.

---

## Task Types

| Type | Use For | Autonomy |
|------|---------|----------|
| `auto` | Everything Claude can do independently | Fully autonomous |
| `checkpoint:human-verify` | Visual/functional verification | Pauses, returns to orchestrator |
| `checkpoint:decision` | Implementation choices | Pauses, returns to orchestrator |
| `checkpoint:human-action` | Truly unavoidable manual steps (rare) | Pauses, returns to orchestrator |

**Checkpoint behavior in parallel execution:**
- Plan runs until checkpoint
- Agent returns with checkpoint details + agent_id
- Orchestrator presents to user
- User responds
- Orchestrator resumes agent with `resume: agent_id`

---

## Examples

**Autonomous parallel plan:**

```markdown
---
phase: 03-content-creation
plan: 01
type: execute
wave: 1
depends_on: []
files_modified: [content/email/welcome-sequence.md, content/email/nurture-sequence.md, content/email/subject-line-variants.md]
autonomous: true
---

<objective>
Create complete email channel content as vertical slice.

Purpose: Self-contained email content that can run parallel to other channels.
Output: Welcome sequence, nurture sequence, and subject line variants.
</objective>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
</context>

<tasks>
<task type="auto">
  <name>Task 1: Create welcome email sequence</name>
  <files>content/email/welcome-sequence.md</files>
  <action>Write 5-email welcome sequence mapped to customer journey stages. Each email: subject line, preview text, body copy, CTA. Follow brand voice guidelines.</action>
  <verify>All 5 emails have subject, body, and CTA. Tone matches brand guidelines.</verify>
  <done>Complete welcome sequence with progressive CTAs from awareness to conversion</done>
</task>

<task type="auto">
  <name>Task 2: Create nurture sequence and subject variants</name>
  <files>content/email/nurture-sequence.md, content/email/subject-line-variants.md</files>
  <action>Write 3-email nurture sequence for non-converters. Create A/B subject line variants for all emails.</action>
  <verify>Nurture sequence addresses common objections. Each email has 2+ subject line variants.</verify>
  <done>All email content complete with A/B testing variants</done>
</task>
</tasks>

<verification>
- [ ] All emails have required sections (subject, preview, body, CTA)
- [ ] Brand voice consistency across sequences
</verification>

<success_criteria>
- All tasks completed
- Email content aligned with brand positioning
</success_criteria>

<output>
After completion, create `.planning/phases/03-features/03-01-SUMMARY.md`
</output>
```

**Plan with checkpoint (non-autonomous):**

```markdown
---
phase: 03-content-creation
plan: 03
type: execute
wave: 2
depends_on: ["03-01", "03-02"]
files_modified: [content/strategy/campaign-launch-brief.md, content/strategy/cross-channel-plan.md]
autonomous: false
---

<objective>
Create campaign launch brief with stakeholder verification.

Purpose: Integrate email and web content into unified campaign plan.
Output: Campaign brief and cross-channel coordination plan.
</objective>

<execution_context>
@~/.claude/mario/workflows/execute-plan.md
@~/.claude/mario/templates/summary.md
@~/.claude/mario/references/checkpoints.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/phases/03-features/03-01-SUMMARY.md
@.planning/phases/03-features/03-02-SUMMARY.md
</context>

<tasks>
<task type="auto">
  <name>Task 1: Create campaign launch brief</name>
  <files>content/strategy/campaign-launch-brief.md, content/strategy/cross-channel-plan.md</files>
  <action>Create campaign brief integrating email sequence and landing page copy. Define launch timeline, channel responsibilities, and success metrics. Build cross-channel plan with messaging alignment.</action>
  <verify>Brief covers all channels, timeline is realistic, metrics are measurable.</verify>
  <done>Campaign brief with cross-channel coordination plan</done>
</task>

<!-- Checkpoint pattern: Claude prepares review materials, user reviews content. See checkpoints.md for full patterns. -->
<task type="auto">
  <name>Prepare content review package</name>
  <action>Compile all content deliverables into review-ready format with summary of key messaging decisions</action>
  <verify>Review package includes all deliverables with cross-references</verify>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <what-built>Campaign launch brief and cross-channel plan</what-built>
  <how-to-verify>Review campaign brief for: messaging consistency, channel alignment, timeline feasibility, metric clarity.</how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>
</task>
</tasks>

<verification>
- [ ] All content sections complete and cross-referenced
- [ ] Stakeholder verification passed
</verification>

<success_criteria>
- All tasks completed
- User approved campaign brief and messaging
</success_criteria>

<output>
After completion, create `.planning/phases/03-features/03-03-SUMMARY.md`
</output>
```

---

## Anti-Patterns

**Bad: Reflexive dependency chaining**
```yaml
depends_on: ["03-01"]  # Just because 01 comes before 02
```

**Bad: Horizontal layer grouping**
```
Plan 01: All models
Plan 02: All APIs (depends on 01)
Plan 03: All UIs (depends on 02)
```

**Bad: Missing autonomy flag**
```yaml
# Has checkpoint but no autonomous: false
depends_on: []
files_modified: [...]
# autonomous: ???  <- Missing!
```

**Bad: Vague tasks**
```xml
<task type="auto">
  <name>Set up authentication</name>
  <action>Add auth to the app</action>
</task>
```

---

## Guidelines

- Always use XML structure for Claude parsing
- Include `wave`, `depends_on`, `files_modified`, `autonomous` in every plan
- Prefer vertical slices over horizontal layers
- Only reference prior SUMMARYs when genuinely needed
- Group checkpoints with related auto tasks in same plan
- 2-3 tasks per plan, ~50% context max

---

## User Setup (External Services)

When a plan introduces external services requiring human configuration, declare in frontmatter:

```yaml
user_setup:
  - service: stripe
    why: "Payment processing requires API keys"
    env_vars:
      - name: STRIPE_SECRET_KEY
        source: "Stripe Dashboard → Developers → API keys → Secret key"
      - name: STRIPE_WEBHOOK_SECRET
        source: "Stripe Dashboard → Developers → Webhooks → Signing secret"
    dashboard_config:
      - task: "Create webhook endpoint"
        location: "Stripe Dashboard → Developers → Webhooks → Add endpoint"
        details: "URL: https://[your-domain]/api/webhooks/stripe"
    local_dev:
      - "stripe listen --forward-to localhost:3000/api/webhooks/stripe"
```

**The automation-first rule:** `user_setup` contains ONLY what Claude literally cannot do:
- Account creation (requires human signup)
- Secret retrieval (requires dashboard access)
- Dashboard configuration (requires human in browser)

**NOT included:** Package installs, code changes, file creation, CLI commands Claude can run.

**Result:** Execute-plan generates `{phase}-USER-SETUP.md` with checklist for the user.

See `~/.claude/mario/templates/user-setup.md` for full schema and examples

---

## Must-Haves (Goal-Backward Verification)

The `must_haves` field defines what must be TRUE for the phase goal to be achieved. Derived during planning, verified after execution.

**Structure:**

```yaml
must_haves:
  truths:
    - "Each email has a clear purpose aligned to customer journey"
    - "CTAs progressively lead toward conversion"
    - "Brand voice is consistent across all emails"
  artifacts:
    - path: "content/email/welcome-sequence.md"
      provides: "Complete 5-email welcome sequence"
      min_lines: 100
    - path: "content/strategy/email-strategy-brief.md"
      provides: "Email channel strategy and journey mapping"
      exports: ["sequence-map", "timing-triggers"]
    - path: "content/strategy/brand-positioning.md"
      provides: "Brand voice and positioning guidelines"
      contains: "tone of voice"
  key_links:
    - from: "content/email/welcome-sequence.md"
      to: "content/strategy/brand-positioning.md"
      via: "tone and messaging alignment"
      pattern: "brand voice|positioning"
    - from: "content/email/welcome-sequence.md"
      to: "content/web/landing-page.md"
      via: "CTA destinations"
      pattern: "landing page|CTA.*link"
```

**Field descriptions:**

| Field | Purpose |
|-------|---------|
| `truths` | Observable behaviors from user perspective. Each must be testable. |
| `artifacts` | Files that must exist with real implementation. |
| `artifacts[].path` | File path relative to project root. |
| `artifacts[].provides` | What this artifact delivers. |
| `artifacts[].min_lines` | Optional. Minimum lines to be considered substantive. |
| `artifacts[].exports` | Optional. Expected exports to verify. |
| `artifacts[].contains` | Optional. Pattern that must exist in file. |
| `key_links` | Critical connections between artifacts. |
| `key_links[].from` | Source artifact. |
| `key_links[].to` | Target artifact or endpoint. |
| `key_links[].via` | How they connect (description). |
| `key_links[].pattern` | Optional. Regex to verify connection exists. |

**Why this matters:**

Task completion ≠ Goal achievement. A task "create chat component" can complete by creating a placeholder. The `must_haves` field captures what must actually work, enabling verification to catch gaps before they compound.

**Verification flow:**

1. Plan-phase derives must_haves from phase goal (goal-backward)
2. Must_haves written to PLAN.md frontmatter
3. Execute-phase runs all plans
4. Verification subagent checks must_haves against codebase
5. Gaps found → fix plans created → execute → re-verify
6. All must_haves pass → phase complete

See `~/.claude/mario/workflows/verify-phase.md` for verification logic.
