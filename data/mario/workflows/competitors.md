<purpose>
Run a competitor analysis comparing multiple competitor websites against your brand foundations. Produces a comparison report in `.mario_planning/audits/competitive-analysis/`.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Initialize

**MANDATORY FIRST STEP:**

```bash
INIT=$(mario-tools init competitors "${ARGUMENTS}")
```

Parse JSON for: `auditor_model`, `synthesizer_model`, `commit_docs`, `urls`, `has_brand_context`.

**If `has_brand_context` is false:** Error — brand foundations required.

```
╔══════════════════════════════════════════════════════════════╗
║  ERROR                                                       ║
╚══════════════════════════════════════════════════════════════╝

Brand foundations required for competitor analysis.
Competitors are analyzed relative to YOUR brand positioning.

**To fix:** Run /mario:new-project first.
```

**If no URLs provided:** Error — at least one competitor URL required.

```
╔══════════════════════════════════════════════════════════════╗
║  ERROR                                                       ║
╚══════════════════════════════════════════════════════════════╝

At least one competitor URL required.

Usage: /mario:competitors https://competitor1.com https://competitor2.com
```

## 2. Setup

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario > ANALYZING COMPETITORS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Analyzing {count} competitors against your brand...
```

Read brand context from `.mario_planning/foundations/BRAND-BIBLE.md`.

Create output directory:
```bash
mkdir -p .mario_planning/audits/competitive-analysis
```

## 3. Pre-fetch Competitor Sites

For each competitor URL, use WebFetch to retrieve the homepage and key subpages.

## 4. Spawn Auditors (Competitive Profile Mode)

For each competitor, spawn a `mario-website-auditor` in `competitive-profile` mode:

```
◆ Spawning competitor profilers in parallel...
  → Analyzing {competitor_1_domain}
  → Analyzing {competitor_2_domain}
  → ...
```

```
Task(prompt="First, read ~/.claude/agents/mario-website-auditor.md for your role and instructions.

<assignment>
Dimension: competitive-profile
Domain: {competitor_domain}
URL: {competitor_url}
Output File: .mario_planning/audits/competitive-analysis/profile-{competitor_slug}.md
</assignment>

<page_content>
[Pre-fetched content for this competitor]
</page_content>

<brand_context>
[Key excerpts from BRAND-BIBLE.md — positioning, personas, messaging, competitors]
</brand_context>

<instructions>
Produce a comprehensive competitor profile covering:
- Company overview and positioning
- Key messaging and value proposition
- Content approach (blog, resources, SEO strategy)
- Conversion strategy (CTAs, pricing, social proof)
- Brand presentation (design, trust signals, personality)
- Strengths to learn from
- Weaknesses to exploit
- How they compare to our brand on key dimensions
</instructions>
", subagent_type="general-purpose", model="{auditor_model}", description="Profile: {competitor_domain}")
```

## 5. Synthesize Comparison

After all competitor profiles complete, spawn synthesizer:

```
Task(prompt="You are synthesizing a competitor comparison analysis.

<task>
Compare {count} competitor profiles against brand foundations and produce COMPETITORS.md.
</task>

<competitor_profiles>
Read these files:
{list of .mario_planning/audits/competitive-analysis/profile-*.md files}
</competitor_profiles>

<brand_context>
Read: .mario_planning/foundations/BRAND-BIBLE.md
</brand_context>

<output>
Write to: .mario_planning/audits/competitive-analysis/COMPETITORS.md
Use template: ~/.claude/mario/templates/competitor-report.md
Commit all competitor analysis files after writing report.
</output>

<instructions>
Produce a comprehensive comparison including:
- Executive summary of competitive landscape
- Per-competitor profiles with strengths/weaknesses
- Positioning map (where each competitor sits)
- Messaging comparison table
- Content gap analysis
- SEO overlap analysis
- Strategic opportunities (differentiation, messaging white space, content opportunities)
- Prioritized recommendations
</instructions>
", subagent_type="general-purpose", model="{synthesizer_model}", description="Synthesize competitor analysis")
```

## 6. Present Results

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario > COMPETITOR ANALYSIS COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Executive summary from synthesizer]

### Top Strategic Opportunities
[From synthesizer]

Report: .mario_planning/audits/competitive-analysis/COMPETITORS.md
```

## 7. Next Steps

```
───────────────────────────────────────────────────────────────

## ▶ What's Next?

- `/mario:create "Differentiation content based on competitor gaps"` — Act on findings
- `/mario:audit {your-url}` — Audit your own website

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────
```

</process>

<success_criteria>

- [ ] Brand foundations verified
- [ ] All competitor URLs fetched
- [ ] Competitor profilers spawned in parallel
- [ ] All profiles written
- [ ] Synthesizer produced COMPETITORS.md
- [ ] All files committed to git (if commit_docs)
- [ ] Results presented to user
- [ ] Next steps suggested

</success_criteria>
