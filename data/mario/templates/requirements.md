# Requirements Template

Template for `.planning/REQUIREMENTS.md` — checkable requirements that define "done."

<template>

```markdown
# Requirements: [Project Name]

**Defined:** [date]
**Core Message:** [from PROJECT.md]

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Brand Foundation

- [ ] **BRAND-01**: Brand voice guide documented
- [ ] **BRAND-02**: 3 detailed buyer personas created
- [ ] **BRAND-03**: Core messaging framework defined
- [ ] **BRAND-04**: Competitive positioning matrix completed

### Website Copy

- [ ] **WEB-01**: Homepage copy written
- [ ] **WEB-02**: Landing page for primary offering
- [ ] **WEB-03**: About page copy written

### Email Marketing

- [ ] **EMAIL-01**: Welcome sequence created
- [ ] **EMAIL-02**: Nurture sequence for leads

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### [Category]

- **[CAT]-01**: [Requirement description]
- **[CAT]-02**: [Requirement description]

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| [Feature] | [Why excluded] |
| [Feature] | [Why excluded] |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| BRAND-01 | Phase 1 | Pending |
| BRAND-02 | Phase 1 | Pending |
| BRAND-03 | Phase 1 | Pending |
| BRAND-04 | Phase 1 | Pending |
| WEB-01 | Phase 2 | Pending |
| WEB-02 | Phase 2 | Pending |
| WEB-03 | Phase 2 | Pending |
| EMAIL-01 | Phase 3 | Pending |
| EMAIL-02 | Phase 3 | Pending |

**Coverage:**
- v1 requirements: [X] total
- Mapped to phases: [Y]
- Unmapped: [Z] ⚠️

---
*Requirements defined: [date]*
*Last updated: [date] after [trigger]*
```

</template>

<guidelines>

**Requirement Format:**
- ID: `[CATEGORY]-[NUMBER]` (BRAND-01, WEB-02, EMAIL-01, SOCIAL-03)
- Description: Outcome-oriented, testable, atomic
- Checkbox: Only for v1 requirements (v2 are not yet actionable)

**Categories:**
- Derive from research FEATURES.md categories
- Keep consistent with marketing domain conventions
- Typical: Brand Foundation, Website Copy, Email Marketing, Social Media, SEO Content, Paid Advertising

**v1 vs v2:**
- v1: Committed scope, will be in roadmap phases
- v2: Acknowledged but deferred, not in current roadmap
- Moving v2 → v1 requires roadmap update

**Out of Scope:**
- Explicit exclusions with reasoning
- Prevents "why didn't you include X?" later
- Anti-features from research belong here with warnings

**Traceability:**
- Empty initially, populated during roadmap creation
- Each requirement maps to exactly one phase
- Unmapped requirements = roadmap gap

**Status Values:**
- Pending: Not started
- In Progress: Phase is active
- Complete: Requirement verified
- Blocked: Waiting on external factor

</guidelines>

<evolution>

**After each phase completes:**
1. Mark covered requirements as Complete
2. Update traceability status
3. Note any requirements that changed scope

**After roadmap updates:**
1. Verify all v1 requirements still mapped
2. Add new requirements if scope expanded
3. Move requirements to v2/out of scope if descoped

**Requirement completion criteria:**
- Requirement is "Complete" when:
  - Content is created
  - Content is reviewed (quality check, brand alignment verified)
  - Content is committed

</evolution>

<example>

```markdown
# Requirements: GreenLeaf Supplements

**Defined:** 2025-01-14
**Core Message:** Premium plant-based supplements backed by science, for health-conscious professionals

## v1 Requirements

### Brand Foundation

- [ ] **BRAND-01**: Brand voice guide documented
- [ ] **BRAND-02**: 3 detailed buyer personas created
- [ ] **BRAND-03**: Core messaging framework defined
- [ ] **BRAND-04**: Competitive positioning matrix completed

### Website Copy

- [ ] **WEB-01**: Homepage copy written with hero, benefits, and CTA
- [ ] **WEB-02**: Landing page for flagship product
- [ ] **WEB-03**: About page with brand story

### Email Marketing

- [ ] **EMAIL-01**: Welcome sequence (5 emails over 14 days)
- [ ] **EMAIL-02**: Lead nurture sequence for non-purchasers
- [ ] **EMAIL-03**: Post-purchase follow-up sequence

### Social Media

- [ ] **SOCIAL-01**: Content pillar framework defined
- [ ] **SOCIAL-02**: 30-day content calendar created
- [ ] **SOCIAL-03**: Bio and profile copy for all platforms

### SEO Content

- [ ] **SEO-01**: Keyword research completed
- [ ] **SEO-02**: 5 pillar articles written

### Paid Advertising

- [ ] **ADS-01**: Campaign structure defined
- [ ] **ADS-02**: Ad copy variations written (3 per campaign)

## v2 Requirements

### Advanced Email

- **EMAIL-04**: Abandoned cart recovery sequence
- **EMAIL-05**: Win-back campaign for churned customers
- **EMAIL-06**: Referral program email flow

### Content Expansion

- **SEO-03**: 10 supporting cluster articles
- **SEO-04**: Monthly content refresh cadence
- **SOCIAL-04**: Video content strategy

## Out of Scope

| Feature | Reason |
|---------|--------|
| Influencer partnerships | Requires dedicated budget and relationship management |
| Podcast production | High effort, low ROI at current stage |
| Print advertising | Digital-first strategy for v1 |
| International markets | Focus on domestic audience first |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| BRAND-01 | Phase 1 | Pending |
| BRAND-02 | Phase 1 | Pending |
| BRAND-03 | Phase 1 | Pending |
| BRAND-04 | Phase 1 | Pending |
| WEB-01 | Phase 2 | Pending |
| WEB-02 | Phase 2 | Pending |
| WEB-03 | Phase 2 | Pending |
| EMAIL-01 | Phase 3 | Pending |
| EMAIL-02 | Phase 3 | Pending |
| EMAIL-03 | Phase 3 | Pending |
| SOCIAL-01 | Phase 4 | Pending |
| SOCIAL-02 | Phase 4 | Pending |
| SOCIAL-03 | Phase 4 | Pending |
| SEO-01 | Phase 5 | Pending |
| SEO-02 | Phase 5 | Pending |
| ADS-01 | Phase 6 | Pending |
| ADS-02 | Phase 6 | Pending |

**Coverage:**
- v1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0 ✓

---
*Requirements defined: 2025-01-14*
*Last updated: 2025-01-14 after initial definition*
```

</example>
