---
name: mario:progress
description: Check project progress and route to next action
allowed-tools:
  - Read
  - Bash
  - Grep
  - Glob
  - SlashCommand
---
<objective>
Check project progress, show plan list with status, and route to the next unexecuted plan.

Provides situational awareness before continuing work.
</objective>

<execution_context>
@~/.claude/mario/workflows/progress.md
</execution_context>

<context>
@.mario_planning/BACKLOG.md
@.mario_planning/STATE.md
</context>

<process>
Execute the progress workflow from @~/.claude/mario/workflows/progress.md end-to-end.
Preserve all routing logic and edge case handling.
</process>
