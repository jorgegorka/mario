---
name: mario:save-template
description: Save a completed plan as a reusable template
argument-hint: "<plan-number> <template-name>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
---

<objective>
Extract a plan's structure and create a reusable template in `.planning/templates/`.

**Flow:** Load plan -> extract structure -> parameterize -> save template.
</objective>

<execution_context>
@~/.claude/mario/workflows/save-template.md
</execution_context>

<context>
Plan number and template name: $ARGUMENTS
</context>

<process>
Execute the save-template workflow from @~/.claude/mario/workflows/save-template.md end-to-end.
</process>
