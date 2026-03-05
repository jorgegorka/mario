---
name: mario:quick-audit
description: Run a quick 60-second website marketing snapshot
argument-hint: "<url>"
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - AskUserQuestion
  - WebSearch
  - WebFetch
---
<context>
URL to audit: $ARGUMENTS

Example usage:
- `/mario:quick-audit https://example.com`
- `/mario:quick-audit https://mycompany.io`
</context>

<objective>
Run a quick single-pass website marketing snapshot. No parallel subagents — the orchestrator analyzes directly. Produces a condensed scorecard with top recommendations.

**Flow:** Fetch homepage → Score 6 dimensions → Present snapshot → Offer to save

**Use when:** You want a fast read on a website without the full audit process.
</objective>

<execution_context>
@~/.claude/mario/workflows/quick-audit.md
@~/.claude/mario/references/audit-scoring.md
@~/.claude/mario/references/ui-brand.md
</execution_context>

<process>
Execute the quick-audit workflow from @~/.claude/mario/workflows/quick-audit.md end-to-end.
Preserve all workflow gates (initialization, analysis, save/discard choice).
</process>
