<purpose>
Run a quick 60-second website marketing snapshot. Single-pass analysis without parallel subagents. Produces a condensed audit in `.mario_planning/audits/{slug}/QUICK-AUDIT.md`.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Initialize

**MANDATORY FIRST STEP:**

```bash
INIT=$(mario-tools init audit "${ARGUMENTS}")
```

Parse JSON for: `url`, `domain`, `slug`, `audit_dir`, `has_brand_context`.

**If URL is empty:** Error — URL required.

## 2. Pre-fetch

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario > QUICK AUDIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Fetching: {url}
```

Use WebFetch to retrieve the homepage only. Optionally fetch 1-2 key subpages if links are obvious.

## 3. Analyze (Single Pass)

As the orchestrator, apply the condensed scoring rubric directly. For each of the 6 dimensions:

1. Score 0-100 based on observable evidence
2. Note 1-2 key observations
3. Identify the single biggest recommendation

Keep it fast — this is a snapshot, not a deep analysis.

## 4. Write Quick Audit

Create the audit directory and write the report:

```bash
mkdir -p {audit_dir}
```

Write `.mario_planning/audits/{slug}/QUICK-AUDIT.md`:

```markdown
# Quick Audit: {domain}

**URL:** {url}
**Audited:** {date}
**Type:** Quick snapshot (single-pass)

## Score: {composite_score}/100 — {rating}

| Dimension | Score | Key Observation |
|-----------|-------|----------------|
| Content & Messaging | {score}/100 | {observation} |
| Conversion Optimization | {score}/100 | {observation} |
| SEO & Discoverability | {score}/100 | {observation} |
| Competitive Positioning | {score}/100 | {observation} |
| Brand & Trust | {score}/100 | {observation} |
| Growth & Strategy | {score}/100 | {observation} |

## Top 3 Recommendations

1. **{recommendation}** — {why and expected impact}
2. **{recommendation}** — {why and expected impact}
3. **{recommendation}** — {why and expected impact}

## Strengths

{top 2-3 strengths observed}

## Gaps

{top 2-3 gaps observed}

---
*Quick audit — for deeper analysis run `/mario:audit {url}`*
```

## 5. Present

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario > QUICK AUDIT COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## {domain} — {composite_score}/100 ({rating})

[Score table]

### Top 3 Recommendations
[Recommendations]

Report: {audit_dir}/QUICK-AUDIT.md
```

## 6. Save Decision

Use AskUserQuestion:
- header: "Save Audit?"
- question: "Save this quick audit to your project?"
- options:
  - "Save" — Commit to git
  - "Discard" — Delete the audit file

If "Save":
```bash
mario-tools commit "audit: quick audit for {domain}" --files {audit_dir}/
```

If "Discard":
```bash
rm -rf {audit_dir}
```

## 7. Next Steps

```
───────────────────────────────────────────────────────────────

## ▶ What's Next?

- `/mario:audit {url}` — Full 6-dimension deep audit
- `/mario:competitors {url} [urls...]` — Compare against competitors

───────────────────────────────────────────────────────────────
```

</process>

<success_criteria>

- [ ] URL fetched and analyzed
- [ ] All 6 dimensions scored with evidence
- [ ] Quick audit report written
- [ ] User offered save/discard choice
- [ ] Next steps suggested

</success_criteria>
