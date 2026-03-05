---
name: mario:audit
description: Run a full website marketing audit with 6-dimension scoring
argument-hint: "<url>"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Task
  - AskUserQuestion
  - WebSearch
  - WebFetch
---
<context>
URL to audit: $ARGUMENTS

Example usage:
- `/mario:audit https://example.com`
- `/mario:audit https://mycompany.io`
</context>

<objective>
Run a comprehensive website marketing audit with 5 parallel dimension agents and a synthesizer. Produces a scored report across 6 dimensions: Content & Messaging, Conversion Optimization, SEO & Discoverability, Competitive Positioning, Brand & Trust, and Growth & Strategy.

**Flow:** Pre-fetch site → Spawn 5 auditors → Synthesize report → Present scores and recommendations

**Optional:** If brand foundations exist (from `/mario:new-project`), audit results are contextualized against your brand positioning.
</objective>

<execution_context>
@~/.claude/mario/workflows/audit.md
@~/.claude/mario/references/audit-scoring.md
@~/.claude/mario/references/ui-brand.md
</execution_context>

<process>
Execute the audit workflow from @~/.claude/mario/workflows/audit.md end-to-end.
Preserve all workflow gates (initialization, pre-fetch, parallel agents, synthesis, presentation).
</process>
