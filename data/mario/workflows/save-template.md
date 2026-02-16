<purpose>
Save a completed plan's structure as a reusable template.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

## 1. Find Plan

```bash
PLAN_INFO=$(mario-tools find-plan "${PLAN_NUM}")
```

Parse JSON for: `plan_dir`, `plan_number`, `plan_name`, `has_plan`.

**If `has_plan` is false:** Error — no PLAN.md found for plan {PLAN_NUM}.

## 2. Read Plan

Read the PLAN.md from the plan directory:

```bash
cat "${plan_dir}/PLAN.md"
```

Display plan summary to user for confirmation.

## 3. Get Template Name

**If template name given in $ARGUMENTS:** Use it directly.

**If no template name given:** Ask user:

```
AskUserQuestion(
  header: "Template Name",
  question: "What should this template be called?",
  options: [
    { label: "Use plan name", description: "Name template after the plan: ${plan_name}" },
    { label: "Custom name", description: "Enter a custom template name" }
  ]
)
```

## 4. Save as Template

```bash
mario-tools template-manager save "${plan_dir}/PLAN.md" "${TEMPLATE_NAME}"
```

Parse result for confirmation and template path.

## 5. Confirm to User

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► TEMPLATE SAVED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Template:** ${TEMPLATE_NAME}
**Source:** Plan ${PLAN_NUM}: ${plan_name}

Use with: /mario:new-from-template ${TEMPLATE_NAME}

───────────────────────────────────────────────────────────────
```

</process>

<success_criteria>
- [ ] Plan found and read
- [ ] Template name determined
- [ ] Template saved via template-manager
- [ ] User confirmed with template name and usage instructions
</success_criteria>
</output>
