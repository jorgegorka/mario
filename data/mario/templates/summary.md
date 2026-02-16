# Summary Template

Template for `.planning/plans/NNN-name/NNN-SUMMARY.md` - plan completion documentation.

---

## File Template

```markdown
---
plan: NNN-name
subsystem: [primary category: auth, payments, ui, api, database, infra, testing, etc.]
tags: [searchable tech: email, social, seo, ads, brand, content]

# Dependency graph
requires:
  - plan: [prior plan this depends on]
    provides: [what that plan built that this uses]
provides:
  - [bullet list of what this plan built/delivered]
affects: [list of plan names or keywords that will need this context]

# Tech tracking
tech-stack:
  added: [libraries/tools added in this plan]
  patterns: [architectural/code patterns established]

key-files:
  created: [important files created]
  modified: [important files modified]

key-decisions:
  - "Decision 1"
  - "Decision 2"

patterns-established:
  - "Pattern 1: description"
  - "Pattern 2: description"

# Metrics
duration: Xmin
completed: YYYY-MM-DD
---

# Plan NNN: [Name] Summary

**[Substantive one-liner describing outcome - NOT "plan complete" or "implementation finished"]**

## Performance

- **Duration:** [time] (e.g., 23 min, 1h 15m)
- **Started:** [ISO timestamp]
- **Completed:** [ISO timestamp]
- **Tasks:** [count completed]
- **Files modified:** [count]

## Accomplishments
- [Most important outcome]
- [Second key accomplishment]
- [Third if applicable]

## Task Commits

Each task was committed atomically:

1. **Task 1: [task name]** - `abc123f` (feat/fix/test/refactor)
2. **Task 2: [task name]** - `def456g` (feat/fix/test/refactor)
3. **Task 3: [task name]** - `hij789k` (feat/fix/test/refactor)

**Plan metadata:** `lmn012o` (docs: complete plan)

_Note: TDD tasks may have multiple commits (test → feat → refactor)_

## Files Created/Modified
- `content/path/to/file.md` - What it does
- `content/path/to/another.md` - What it does

## Decisions Made
[Key decisions with brief rationale, or "None - followed plan as specified"]

## Deviations from Plan

[If no deviations: "None - plan executed exactly as written"]

[If deviations occurred:]

### Auto-fixed Issues

**1. [Rule X - Category] Brief description**
- **Found during:** Task [N] ([task name])
- **Issue:** [What was wrong]
- **Fix:** [What was done]
- **Files modified:** [file paths]
- **Verification:** [How it was verified]
- **Committed in:** [hash] (part of task commit)

[... repeat for each auto-fix ...]

---

**Total deviations:** [N] auto-fixed ([breakdown by rule])
**Impact on plan:** [Brief assessment - e.g., "All auto-fixes necessary for correctness/security. No scope creep."]

## Issues Encountered
[Problems and how they were resolved, or "None"]

[Note: "Deviations from Plan" documents unplanned work that was handled automatically via deviation rules. "Issues Encountered" documents problems during planned work that required problem-solving.]

## User Setup Required

[If USER-SETUP.md was generated:]
**External services require manual configuration.** See [NNN-USER-SETUP.md](./NNN-USER-SETUP.md) for:
- Environment variables to add
- Dashboard configuration steps
- Verification commands

[If no USER-SETUP.md:]
None - no external service configuration required.

## Next Steps
[What's ready for the next plan]
[Any blockers or concerns]

---
*Plan: NNN-name*
*Completed: [date]*
```

<frontmatter_guidance>
**Purpose:** Enable automatic context assembly via dependency graph. Frontmatter makes summary metadata machine-readable so planning can scan all summaries quickly and select relevant ones based on dependencies.

**Fast scanning:** Frontmatter is first ~25 lines, cheap to scan across all summaries without reading full content.

**Dependency graph:** `requires`/`provides`/`affects` create explicit links between plans, enabling transitive closure for context selection.

**Subsystem:** Primary categorization (auth, payments, ui, api, database, infra, testing) for detecting related plans.

**Tags:** Searchable technical keywords (libraries, frameworks, tools) for tech stack awareness.

**Key-files:** Important files for @context references in PLAN.md.

**Patterns:** Established conventions future plans should maintain.

**Population:** Frontmatter is populated during summary creation in execute-plan.md. See `<step name="create_summary">` for field-by-field guidance.
</frontmatter_guidance>

<one_liner_rules>
The one-liner MUST be substantive:

**Good:**
- "5-email welcome sequence with progressive CTAs aligned to brand voice"
- "Brand positioning with 3 audience personas and competitive analysis"
- "30-day social media calendar with platform-specific content for 4 channels"

**Bad:**
- "Plan complete"
- "Authentication implemented"
- "Foundation finished"
- "All tasks done"

The one-liner should tell someone what actually shipped.
</one_liner_rules>

<example>
```markdown
# Plan 001: Foundation Summary

**5-email welcome sequence with progressive CTAs, brand-aligned tone, and audience-segmented messaging**

## Performance

- **Duration:** 28 min
- **Started:** 2025-01-15T14:22:10Z
- **Completed:** 2025-01-15T14:50:33Z
- **Tasks:** 5
- **Files modified:** 8

## Accomplishments
- Complete 5-email welcome sequence mapped to customer journey
- Progressive CTA strategy from awareness to conversion
- Brand voice consistency across all emails
- Audience segmentation for 3 persona types

## Files Created/Modified
- `content/email/welcome-sequence.md` - Full 5-email welcome sequence
- `content/strategy/email-strategy-brief.md` - Email channel strategy and journey mapping
- `content/strategy/cta-framework.md` - Progressive CTA guidelines
- `content/email/subject-line-variants.md` - A/B test subject line options

## Decisions Made
- Progressive CTA approach: blog post → free tool → demo → trial → purchase
- Casual-expert tone per brand voice guidelines (friendly but authoritative)
- 3-day spacing between emails with behavior-based triggers

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added compliance elements to all emails**
- **Found during:** Task 2 (Email sequence drafting)
- **Issue:** Plan didn't specify CAN-SPAM compliance elements
- **Fix:** Added unsubscribe link, physical address, and sender identification to each email
- **Files modified:** content/email/welcome-sequence.md
- **Verification:** All 5 emails include required compliance elements
- **Committed in:** abc123f (Task 2 commit)

**2. [Rule 3 - Blocking] Created missing brand voice reference**
- **Found during:** Task 4 (Tone consistency review)
- **Issue:** Brand positioning document referenced but not yet created
- **Fix:** Created brand-positioning.md with tone guidelines from project brief
- **Files modified:** content/strategy/brand-positioning.md
- **Verification:** All emails align with documented brand voice
- **Committed in:** def456g (Task 4 commit)

---

**Total deviations:** 2 auto-fixed (1 missing critical, 1 blocking)
**Impact on plan:** Both auto-fixes essential for compliance and brand consistency. No scope creep.

## Issues Encountered
- Original subject lines were too long for mobile preview — shortened all to under 40 characters

## Next Steps
- Email welcome sequence complete, ready for landing page creation
- Social media calendar needed to align cross-channel messaging

---
*Plan: 001-foundation*
*Completed: 2025-01-15*
```
</example>

<guidelines>
**Frontmatter:** MANDATORY - complete all fields. Enables automatic context assembly for future planning.

**One-liner:** Must be substantive. "JWT auth with refresh rotation using jose library" not "Authentication implemented".

**Decisions section:**
- Key decisions made during execution with rationale
- Extracted to STATE.md accumulated context
- Use "None - followed plan as specified" if no deviations

**After creation:** STATE.md updated with position, decisions, issues.
</guidelines>
