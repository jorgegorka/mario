---
name: mario:new-from-template
description: Create a new plan from a reusable template
argument-hint: "<template-name> [--var key=value ...]"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Task
  - AskUserQuestion
---

<objective>
Fill a template's variables and create a new plan in `.planning/plans/`, then update BACKLOG.md.

**Flow:** Load template -> prompt for variables -> fill template -> create plan -> update backlog.
</objective>

<execution_context>
@~/.claude/mario/workflows/new-from-template.md
</execution_context>

<context>
Template name and variables: $ARGUMENTS

@.planning/BACKLOG.md
@.planning/STATE.md
</context>

<process>
Execute the new-from-template workflow from @~/.claude/mario/workflows/new-from-template.md end-to-end.
</process>
