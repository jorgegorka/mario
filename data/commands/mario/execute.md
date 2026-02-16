---
name: mario:execute
description: Execute a plan
argument-hint: "<plan-number>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
  - TodoWrite
  - AskUserQuestion
---
<objective>
Execute a single plan. The orchestrator loads the plan, spawns executor subagents, and collects results.

Context budget: ~15% orchestrator, 100% fresh per subagent.
</objective>

<execution_context>
@~/.claude/mario/workflows/execute.md
@~/.claude/mario/references/ui-brand.md
</execution_context>

<context>
Plan number: $ARGUMENTS

@.planning/BACKLOG.md
@.planning/STATE.md
</context>

<process>
Execute the execute workflow from @~/.claude/mario/workflows/execute.md end-to-end.
Preserve all workflow gates (execution, checkpoint handling, verification, state updates, routing).
</process>
