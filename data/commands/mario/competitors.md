---
name: mario:competitors
description: Analyze competitors against your brand positioning
argument-hint: "<url> [url2] [url3...]"
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
Competitor URLs: $ARGUMENTS

Example usage:
- `/mario:competitors https://competitor1.com https://competitor2.com`
- `/mario:competitors https://rival.io`
</context>

<objective>
Analyze competitor websites against your brand positioning. Spawns parallel profiler agents for each competitor, then synthesizes a comparison report with strategic opportunities.

**Requires:** Run `/mario:new-project` first — competitors are analyzed relative to your brand foundations.

**Flow:** Verify foundations → Fetch competitor sites → Profile each → Synthesize comparison → Present opportunities
</objective>

<execution_context>
@~/.claude/mario/workflows/competitors.md
@~/.claude/mario/references/audit-scoring.md
@~/.claude/mario/references/ui-brand.md
@.mario_planning/foundations/BRAND-BIBLE.md
@.mario_planning/PROJECT.md
</execution_context>

<process>
Execute the competitors workflow from @~/.claude/mario/workflows/competitors.md end-to-end.
Preserve all workflow gates (foundation verification, parallel profiling, synthesis, presentation).
</process>
