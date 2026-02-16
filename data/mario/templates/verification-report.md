# Verification Report Template

Template for `.planning/phases/XX-name/{phase}-VERIFICATION.md` — phase goal verification results.

---

## File Template

```markdown
---
phase: XX-name
verified: YYYY-MM-DDTHH:MM:SSZ
status: passed | gaps_found | human_needed
score: N/M must-haves verified | security: N critical, N high | performance: N high
---

# Phase {X}: {Name} Verification Report

**Phase Goal:** {goal from ROADMAP.md}
**Verified:** {timestamp}
**Status:** {passed | gaps_found | human_needed}

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | {truth from must_haves} | ✓ VERIFIED | {what confirmed it} |
| 2 | {truth from must_haves} | ✗ FAILED | {what's wrong} |
| 3 | {truth from must_haves} | ? UNCERTAIN | {why can't verify} |

**Score:** {N}/{M} truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `content/email/welcome-sequence.md` | Welcome email sequence | ✓ EXISTS + SUBSTANTIVE | Contains 5 complete emails with subject lines, CTAs, and body copy |
| `content/strategy/brand-positioning.md` | Brand positioning | ✗ STUB | File exists but only has placeholder sections, no real positioning |
| `content/strategy/audience-personas.md` | Audience personas | ✓ EXISTS + SUBSTANTIVE | Defines 3 personas with demographics, pain points, and goals |

**Artifacts:** {N}/{M} verified

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|----|--------|---------|
| welcome-sequence.md | brand-positioning.md | Tone alignment | ✓ CONNECTED | Emails reference brand voice guidelines consistently |
| welcome-sequence.md | landing-page.md | CTA destinations | ✗ NOT CONNECTED | Email CTAs mention landing page but no landing page content exists |
| campaign-brief.md | social-calendar.md | Channel coordination | ✗ NOT CONNECTED | Brief references social channel but no social content created |

**Wiring:** {N}/{M} connections verified

## Requirements Coverage

| Requirement | Status | Blocking Issue |
|-------------|--------|----------------|
| {REQ-01}: {description} | ✓ SATISFIED | - |
| {REQ-02}: {description} | ✗ BLOCKED | Landing page content is placeholder |
| {REQ-03}: {description} | ? NEEDS HUMAN | Can't verify visual brand alignment programmatically |

**Coverage:** {N}/{M} requirements satisfied

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| content/strategy/brand-positioning.md | 12 | `[To be determined]` | ⚠️ Warning | Indicates incomplete |
| content/email/welcome-sequence.md | 8 | `[Insert CTA here]` | 🛑 Blocker | Placeholder CTA |
| content/web/landing-page.md | - | File missing | 🛑 Blocker | Expected landing page doesn't exist |

**Anti-patterns:** {N} found ({blockers} blockers, {warnings} warnings)

## Security Findings

| Check | Name | Severity | File | Line | Detail |
|-------|------|----------|------|------|--------|
| 1.2a | Missing compliance | Critical | content/email/welcome-sequence.md | 15 | No unsubscribe link or physical address |
| 2.5a | Unsubstantiated claims | High | content/ads/google-ads-copy.md | 28 | Claims "#1 rated" without source citation |

**Security:** {N} findings ({critical} critical, {high} high, {medium} medium)

## Performance Findings

| Check | Name | Severity | File | Line | Detail |
|-------|------|----------|------|------|--------|
| 2.2a | Missing CTA | High | content/email/welcome-sequence.md | 10 | Email 3 has no call-to-action |
| 3.1a | Poor scanability | High | content/web/landing-page.md | 10 | Long paragraphs without headers or bullet points |

**Performance:** {N} findings ({high} high, {medium} medium, {low} low)

## Human Verification Required

{If no human verification needed:}
None — all verifiable items checked programmatically.

{If human verification needed:}

### 1. {Test Name}
**Test:** {What to do}
**Expected:** {What should happen}
**Why human:** {Why can't verify programmatically}

### 2. {Test Name}
**Test:** {What to do}
**Expected:** {What should happen}
**Why human:** {Why can't verify programmatically}

## Gaps Summary

{If no gaps:}
**No gaps found.** Phase goal achieved. Ready to proceed.

{If gaps found:}

### Critical Gaps (Block Progress)

1. **{Gap name}**
   - Missing: {what's missing}
   - Impact: {why this blocks the goal}
   - Fix: {what needs to happen}

2. **{Gap name}**
   - Missing: {what's missing}
   - Impact: {why this blocks the goal}
   - Fix: {what needs to happen}

### Non-Critical Gaps (Can Defer)

1. **{Gap name}**
   - Issue: {what's wrong}
   - Impact: {limited impact because...}
   - Recommendation: {fix now or defer}

## Recommended Fix Plans

{If gaps found, generate fix plan recommendations:}

### {phase}-{next}-PLAN.md: {Fix Name}

**Objective:** {What this fixes}

**Tasks:**
1. {Task to fix gap 1}
2. {Task to fix gap 2}
3. {Verification task}

**Estimated scope:** {Small / Medium}

---

### {phase}-{next+1}-PLAN.md: {Fix Name}

**Objective:** {What this fixes}

**Tasks:**
1. {Task}
2. {Task}

**Estimated scope:** {Small / Medium}

---

## Verification Metadata

**Verification approach:** Goal-backward (derived from phase goal)
**Must-haves source:** {PLAN.md frontmatter | derived from ROADMAP.md goal}
**Automated checks:** {N} passed, {M} failed
**Human checks required:** {N}
**Total verification time:** {duration}

---
*Verified: {timestamp}*
*Verifier: Claude (subagent)*
```

---

## Guidelines

**Status values:**
- `passed` — All must-haves verified, no blockers, no Critical/High security findings, no excessive performance findings
- `gaps_found` — One or more critical gaps found, or any Critical/High security findings, or 3+ High performance findings
- `human_needed` — Automated checks pass but human verification required

**Security/Performance impact on status:**
- Any Critical or High security finding forces `gaps_found` regardless of other checks
- 3+ High performance findings forces `gaps_found`; individual High findings are warnings
- Medium and Low findings are informational and do not affect status

**Evidence types:**
- For EXISTS: "File at path, contains X"
- For SUBSTANTIVE: "N sections, has patterns X, Y, Z"
- For CONNECTED: "Section N: content that links A to B"
- For FAILED: "Missing because X" or "Stub because Y"

**Severity levels:**
- 🛑 Blocker: Prevents goal achievement, must fix
- ⚠️ Warning: Indicates incomplete but doesn't block
- ℹ️ Info: Notable but not problematic

**Fix plan generation:**
- Only generate if gaps_found
- Group related fixes into single plans
- Keep to 2-3 tasks per plan
- Include verification task in each plan

---

## Example

```markdown
---
phase: 03-email-campaign
verified: 2025-01-15T14:30:00Z
status: gaps_found
score: 2/5 must-haves verified | security: 1 critical, 1 high | performance: 2 high
---

# Phase 3: Email Campaign Verification Report

**Phase Goal:** Complete email welcome sequence with progressive CTAs and brand-aligned messaging
**Verified:** 2025-01-15T14:30:00Z
**Status:** gaps_found

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Welcome sequence has 5 complete emails | ✗ FAILED | Only 3 emails have full body copy, emails 4-5 are placeholder outlines |
| 2 | Each email has a clear CTA | ✓ VERIFIED | Emails 1-3 each contain specific, action-oriented CTAs |
| 3 | Tone matches brand positioning | ✗ FAILED | Email 3 shifts from casual to formal, breaks brand consistency |
| 4 | CTAs progressively escalate toward conversion | ✗ FAILED | Emails 2 and 3 both push for demo signup, no progression |
| 5 | Sequence references landing page destinations | ? UNCERTAIN | CTAs mention landing pages but no landing page content exists to verify alignment |

**Score:** 1/5 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `content/email/welcome-sequence.md` | 5-email welcome sequence | ✗ STUB | Only 3 emails have substantive copy, emails 4-5 are outlines with `[TBD]` placeholders |
| `content/strategy/email-strategy-brief.md` | Email channel strategy | ✓ EXISTS + SUBSTANTIVE | Defines journey stages, send cadence, and audience segments |
| `content/strategy/cta-framework.md` | Progressive CTA guidelines | ✗ STUB | File exists but only lists CTA types, no progression mapping |
| `content/email/subject-line-variants.md` | A/B test subject lines | ✓ EXISTS + SUBSTANTIVE | 3 variants per email with character counts and personalization tags |

**Artifacts:** 2/4 verified

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|----|--------|---------|
| welcome-sequence.md | brand-positioning.md | Tone alignment | ✗ NOT CONNECTED | Email 3 tone doesn't match casual-expert voice in brand guidelines |
| welcome-sequence.md | landing-page.md | CTA destinations | ✗ NOT CONNECTED | Email CTAs reference landing pages but no landing page content exists |
| email-strategy-brief.md | audience-personas.md | Persona targeting | ✗ PARTIAL | Strategy references personas but emails use generic messaging |
| cta-framework.md | welcome-sequence.md | CTA progression | ✗ NOT CONNECTED | Framework defines progression but emails don't follow it |

**Connections:** 0/4 connections verified

## Requirements Coverage

| Requirement | Status | Blocking Issue |
|-------------|--------|----------------|
| EMAIL-01: Complete 5-email welcome sequence | ✗ BLOCKED | Emails 4-5 are placeholder outlines |
| EMAIL-02: Brand-consistent messaging | ✗ BLOCKED | Email 3 tone breaks brand voice |
| EMAIL-03: Progressive CTA engagement | ✗ BLOCKED | No CTA escalation across sequence |

**Coverage:** 0/3 requirements satisfied

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| content/email/welcome-sequence.md | 45 | `[TBD - complete email body]` | 🛑 Blocker | Placeholder content in emails 4-5 |
| content/strategy/cta-framework.md | 8 | `[Map CTAs to journey stages]` | 🛑 Blocker | No actual CTA progression defined |
| content/email/welcome-sequence.md | 22 | `[Insert landing page URL]` | ⚠️ Warning | Placeholder destination |

**Anti-patterns:** 3 found (2 blockers, 1 warning)

## Security Findings

| Check | Name | Severity | File | Line | Detail |
|-------|------|----------|------|------|--------|
| 1.2a | Missing compliance | Critical | content/email/welcome-sequence.md | 15 | No unsubscribe link or physical address in any email |
| 2.1a | Missing sender ID | High | content/email/welcome-sequence.md | 1 | No From name/address or reply-to specified |

**Security:** 2 findings (1 critical, 1 high, 0 medium)

## Performance Findings

| Check | Name | Severity | File | Line | Detail |
|-------|------|----------|------|------|--------|
| 2.2a | Missing CTA | High | content/email/welcome-sequence.md | 45 | Emails 4-5 have no call-to-action |
| 3.1a | Poor scanability | High | content/email/welcome-sequence.md | 30 | Email 3 has long paragraphs without headers or bullet points |

**Performance:** 2 findings (2 high, 0 medium, 0 low)

## Human Verification Required

None needed until automated gaps are fixed.

## Gaps Summary

### Critical Gaps (Block Progress)

1. **Emails 4-5 are placeholder outlines**
   - Missing: Full body copy, subject lines, and CTAs for emails 4-5
   - Impact: Sequence is incomplete, can't launch campaign
   - Fix: Write complete email copy following brand voice and CTA framework

2. **CTA progression not implemented**
   - Missing: Escalating engagement from awareness to conversion across 5 emails
   - Impact: Emails 2-3 both push demos, no journey progression
   - Fix: Map CTAs to journey stages and rewrite to follow progression

3. **Brand voice inconsistency in email 3**
   - Missing: Casual-expert tone alignment per brand-positioning.md
   - Impact: Tone shift breaks trust and brand consistency
   - Fix: Rewrite email 3 to match casual-expert tone from brand guidelines

### Non-Critical Gaps (Can Defer)

1. **Missing landing page destinations**
   - Issue: Email CTAs reference landing pages that don't exist yet
   - Impact: Limited — landing pages are Phase 4 deliverable
   - Recommendation: Defer to Phase 4, use placeholder URLs for now

## Recommended Fix Plans

### 03-04-PLAN.md: Complete Email Sequence

**Objective:** Finish emails 4-5 with substantive copy aligned to brand and CTA framework

**Tasks:**
1. Write email 4 body copy with journey-appropriate CTA (trial signup)
2. Write email 5 body copy with conversion CTA (purchase/upgrade)
3. Verify: All 5 emails have complete body copy, subject lines, and CTAs

**Estimated scope:** Small

---

### 03-05-PLAN.md: Fix Brand Voice and CTA Progression

**Objective:** Align all emails to brand voice and implement CTA escalation

**Tasks:**
1. Rewrite email 3 to match casual-expert tone from brand-positioning.md
2. Map and implement CTA progression: blog post → free tool → demo → trial → purchase
3. Add CAN-SPAM compliance elements (unsubscribe, physical address, sender ID) to all emails
4. Verify: Consistent tone across sequence, CTAs escalate progressively

**Estimated scope:** Small

---

## Verification Metadata

**Verification approach:** Goal-backward (derived from phase goal)
**Must-haves source:** 03-01-PLAN.md frontmatter
**Automated checks:** 2 passed, 8 failed
**Security checks:** 2 findings (1 critical, 1 high)
**Performance checks:** 2 findings (2 high)
**Human checks required:** 0 (blocked by automated failures)
**Total verification time:** 2 min

---
*Verified: 2025-01-15T14:30:00Z*
*Verifier: Claude (subagent)*
```
