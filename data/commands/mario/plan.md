---
name: mario:plan
description: Create an execution plan for a specific plan number
argument-hint: "<plan-number>"
agent: mario-planner
allowed-tools:
  - Read
  - Write
  - Bash
  - Glob
  - Grep
  - Task
  - WebFetch
  - mcp__context7__*
---
<objective>
Create a single PLAN.md for the given plan number with integrated research (toggled by config).

**Default flow:** Research (inline, if enabled) -> Plan -> Verify -> Done

**Orchestrator role:** Parse plan number, validate it exists in backlog, spawn mario-planner to create the plan, verify with mario-plan-checker, iterate until pass or max iterations, present results.
</objective>

<execution_context>
@~/.claude/mario/workflows/plan.md
@~/.claude/mario/references/ui-brand.md
</execution_context>

<context>
Plan number: $ARGUMENTS

@.planning/BACKLOG.md
@.planning/STATE.md
</context>

<process>
Execute the plan workflow from @~/.claude/mario/workflows/plan.md end-to-end.
Preserve all workflow gates (validation, planning, verification loop, routing).
</process>
