<purpose>
Run a comprehensive website marketing audit with 5 parallel dimension agents and a synthesizer. Produces a scored audit report in `.mario_planning/audits/{slug}/`.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Initialize

**MANDATORY FIRST STEP — Execute before any user interaction:**

```bash
INIT=$(mario-tools init audit "${ARGUMENTS}")
```

Parse JSON for: `auditor_model`, `synthesizer_model`, `commit_docs`, `url`, `domain`, `slug`, `audit_dir`, `has_brand_context`, `has_previous_audit`.

**If URL is empty or invalid:** Error — URL required.

```
╔══════════════════════════════════════════════════════════════╗
║  ERROR                                                       ║
╚══════════════════════════════════════════════════════════════╝

URL required. Usage: /mario:audit https://example.com
```

**If `has_previous_audit`:** Warn that previous audit exists and will be overwritten.

## 2. Pre-fetch Website Content

**Display stage banner:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario > AUDITING WEBSITE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Fetching: {url}
```

Use WebFetch to retrieve the homepage and key subpages:

1. Homepage (`{url}`)
2. About page (`{url}/about` or linked about page)
3. Pricing page (`{url}/pricing` or linked pricing page)
4. Features/product page (`{url}/features` or linked features page)
5. Contact page (`{url}/contact` or linked contact page)

For each page: Store the fetched content. If a subpage returns 404, skip it — not all sites have all pages.

Create the audit directory:
```bash
mkdir -p {audit_dir}
```

## 3. Load Context

**Brand context (optional):** If `has_brand_context` is true, read `.mario_planning/foundations/BRAND-BIBLE.md` for brand context to pass to auditors.

**Scoring rubric:** Read `~/.claude/mario/references/audit-scoring.md` — this was loaded via execution_context.

## 4. Spawn 5 Auditors

Display spawning indicator:
```
◆ Spawning 5 website auditors in parallel...
  → Content & Messaging analysis
  → Conversion Optimization analysis
  → SEO & Discoverability analysis
  → Competitive Positioning analysis
  → Brand & Trust analysis
```

Spawn 5 parallel `mario-website-auditor` agents. Each gets:
- The pre-fetched page content
- Their assigned dimension and the scoring rubric for that dimension
- The audit output directory
- Brand context (if available)

```
Task(prompt="First, read ~/.claude/agents/mario-website-auditor.md for your role and instructions.

<assignment>
Dimension: Content & Messaging
Domain: {domain}
URL: {url}
Audit Directory: {audit_dir}
Output File: {audit_dir}/dimension-content.md
</assignment>

<scoring_rubric>
[Paste the Content & Messaging section from audit-scoring.md]
</scoring_rubric>

<page_content>
[Paste all pre-fetched page content here]
</page_content>

<brand_context>
[If available: key excerpts from BRAND-BIBLE.md relevant to content/messaging evaluation]
[If not available: No brand context available. Evaluate based on what the website presents.]
</brand_context>
", subagent_type="general-purpose", model="{auditor_model}", description="Audit: Content & Messaging")

Task(prompt="First, read ~/.claude/agents/mario-website-auditor.md for your role and instructions.

<assignment>
Dimension: Conversion Optimization
Domain: {domain}
URL: {url}
Audit Directory: {audit_dir}
Output File: {audit_dir}/dimension-conversion.md
</assignment>

<scoring_rubric>
[Paste the Conversion Optimization section from audit-scoring.md]
</scoring_rubric>

<page_content>
[Paste all pre-fetched page content here]
</page_content>

<brand_context>
[If available: key excerpts from BRAND-BIBLE.md relevant to conversion evaluation]
[If not available: No brand context available. Evaluate based on what the website presents.]
</brand_context>
", subagent_type="general-purpose", model="{auditor_model}", description="Audit: Conversion Optimization")

Task(prompt="First, read ~/.claude/agents/mario-website-auditor.md for your role and instructions.

<assignment>
Dimension: SEO & Discoverability
Domain: {domain}
URL: {url}
Audit Directory: {audit_dir}
Output File: {audit_dir}/dimension-seo.md
</assignment>

<scoring_rubric>
[Paste the SEO & Discoverability section from audit-scoring.md]
</scoring_rubric>

<page_content>
[Paste all pre-fetched page content here]
</page_content>

<brand_context>
[If not available: No brand context available. Evaluate based on what the website presents.]
</brand_context>
", subagent_type="general-purpose", model="{auditor_model}", description="Audit: SEO & Discoverability")

Task(prompt="First, read ~/.claude/agents/mario-website-auditor.md for your role and instructions.

<assignment>
Dimension: Competitive Positioning
Domain: {domain}
URL: {url}
Audit Directory: {audit_dir}
Output File: {audit_dir}/dimension-competitive.md
</assignment>

<scoring_rubric>
[Paste the Competitive Positioning section from audit-scoring.md]
</scoring_rubric>

<page_content>
[Paste all pre-fetched page content here]
</page_content>

<brand_context>
[If available: key excerpts from BRAND-BIBLE.md relevant to competitive positioning]
[If not available: No brand context available. Evaluate based on what the website presents.]
</brand_context>
", subagent_type="general-purpose", model="{auditor_model}", description="Audit: Competitive Positioning")

Task(prompt="First, read ~/.claude/agents/mario-website-auditor.md for your role and instructions.

<assignment>
Dimension: Brand & Trust
Domain: {domain}
URL: {url}
Audit Directory: {audit_dir}
Output File: {audit_dir}/dimension-trust.md
</assignment>

<scoring_rubric>
[Paste the Brand & Trust section from audit-scoring.md]
</scoring_rubric>

<page_content>
[Paste all pre-fetched page content here]
</page_content>

<brand_context>
[If available: key excerpts from BRAND-BIBLE.md relevant to brand/trust evaluation]
[If not available: No brand context available. Evaluate based on what the website presents.]
</brand_context>
", subagent_type="general-purpose", model="{auditor_model}", description="Audit: Brand & Trust")
```

## 5. Synthesize

After all 5 agents complete, spawn the synthesizer:

```
Task(prompt="First, read ~/.claude/agents/mario-audit-synthesizer.md for your role and instructions.

<task>
Synthesize 5 dimension analyses into AUDIT-REPORT.md for {domain}.
</task>

<audit_files>
Read these files:
- {audit_dir}/dimension-content.md
- {audit_dir}/dimension-conversion.md
- {audit_dir}/dimension-seo.md
- {audit_dir}/dimension-competitive.md
- {audit_dir}/dimension-trust.md
</audit_files>

<scoring_reference>
Read: ~/.claude/mario/references/audit-scoring.md
</scoring_reference>

<brand_context>
[If has_brand_context: Also read .mario_planning/foundations/BRAND-BIBLE.md]
</brand_context>

<output>
Write to: {audit_dir}/AUDIT-REPORT.md
Use template: ~/.claude/mario/templates/audit-report.md
Commit all audit files after writing report.
</output>
", subagent_type="general-purpose", model="{synthesizer_model}", description="Synthesize audit report")
```

## 6. Present Results

Display the composite score and dimension table from the synthesizer's return:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario > AUDIT COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## {domain} — {composite_score}/100 ({rating})

[Dimension score table from synthesizer]

### Top 3 Recommendations

[Top 3 from synthesizer]

Report: {audit_dir}/AUDIT-REPORT.md
```

## 7. Next Steps

```
───────────────────────────────────────────────────────────────

## ▶ What's Next?

- `/mario:competitors {url} [competitor-urls...]` — Compare against competitors
- `/mario:create "Improve our homepage based on audit findings"` — Act on recommendations

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────
```

</process>

<success_criteria>

- [ ] URL validated and slug generated
- [ ] Homepage + subpages pre-fetched
- [ ] 5 auditor agents spawned in parallel
- [ ] All 5 dimension files written
- [ ] Synthesizer produced AUDIT-REPORT.md with composite score
- [ ] All files committed to git (if commit_docs)
- [ ] Results presented to user
- [ ] Next steps suggested

</success_criteria>
