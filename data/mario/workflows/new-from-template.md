<purpose>
Create a new plan from a reusable template, filling variables and updating BACKLOG.md.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Initialize

```bash
INIT=$(mario-tools init new-from-template --include state,backlog)
```

Parse JSON for: `planning_exists`, `backlog_exists`, `next_num`.

**If `planning_exists` is false:** Error — run `/mario:new-project` first.

## 2. List Available Templates

```bash
TEMPLATES=$(mario-tools template-manager list)
```

Parse JSON for available templates with their names and descriptions.

**If no templates available:**
```
No templates found. Create one with /mario:save-template.
```
Exit.

**If template name given in $ARGUMENTS:** Use it directly. Skip to step 3.

**If no template name given:** Present templates and ask user to pick:

```
AskUserQuestion(
  header: "Template",
  question: "Which template do you want to use?",
  options: [
    { label: "[template-1]", description: "[template description]" },
    { label: "[template-2]", description: "[template description]" },
    ...
  ]
)
```

## 3. Get Template Details

```bash
TEMPLATE=$(mario-tools template-manager get "${TEMPLATE_NAME}")
```

Parse JSON for: `name`, `description`, `variables` (list of variable names with descriptions and required flag), `content`.

## 4. Collect Variable Values

For each required variable, use AskUserQuestion:

```
AskUserQuestion(
  header: "[variable_name]",
  question: "[variable description]?",
  options: [
    { label: "Enter value", description: "Provide a value for this variable" }
  ]
)
```

For optional variables with defaults, show the default and ask if they want to change it.

Collect all variable values into a JSON object.

## 5. Fill Template

```bash
FILLED=$(mario-tools template-manager fill "${TEMPLATE_NAME}" '${VARIABLES_JSON}')
```

Parse result for: `content` (the filled template content), `plan_name`.

## 6. Create Plan Directory

```bash
PLAN_DIR=".mario_planning/plans/${next_num}-${slug}"
mkdir -p "${PLAN_DIR}"
```

Write filled template as PLAN.md:

```bash
# Write the filled content to PLAN.md
```

Use the Write tool to create `${PLAN_DIR}/PLAN.md` with the filled template content.

## 7. Add to Backlog

```bash
mario-tools backlog add "${plan_name}"
```

## 8. Update STATE.md

```bash
mario-tools state update-progress
```

## 9. Commit

```bash
mario-tools commit "docs(plan-${next_num}): create plan from template ${TEMPLATE_NAME}" --files "${PLAN_DIR}/PLAN.md" .mario_planning/BACKLOG.md .mario_planning/STATE.md
```

## 10. Present Result

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► PLAN CREATED FROM TEMPLATE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Plan {NNN}: {plan_name}**
Template: {TEMPLATE_NAME}

───────────────────────────────────────────────────────────────

## ▶ Next Up

**Execute Plan {NNN}**

/mario:execute {NNN}

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────

**Also available:**
- cat {PLAN_DIR}/PLAN.md — review plan
- /mario:plan {NNN} — regenerate plan with planner agent

───────────────────────────────────────────────────────────────
```

</process>

<success_criteria>
- [ ] Template listed and selected
- [ ] Variables collected from user
- [ ] Template filled with variable values
- [ ] Plan directory created in `.mario_planning/plans/`
- [ ] PLAN.md written with filled template
- [ ] BACKLOG.md updated with new plan
- [ ] STATE.md updated
- [ ] Artifacts committed
- [ ] User knows next step
</success_criteria>
</output>
