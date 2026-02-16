# Planner Subagent Prompt Template

Template for spawning mario-planner agent. The agent contains all planning expertise - this template provides planning context only.

---

## Template

```markdown
<planning_context>

**Plan:** {plan_number}

**Project State:**
@.planning/STATE.md

**Backlog:**
@.planning/BACKLOG.md

**Requirements (if exists):**
@.planning/REQUIREMENTS.md

**Research (if exists):**
@.planning/plans/{plan_dir}/{plan}-RESEARCH.md

</planning_context>

<downstream_consumer>
Output consumed by /mario:execute
Plans must be executable prompts with:
- Frontmatter (depends_on, files_modified, autonomous)
- Tasks in XML format
- Verification criteria
- must_haves for goal-backward verification
</downstream_consumer>

<quality_gate>
Before returning PLANNING COMPLETE:
- [ ] PLAN.md files created in plan directory
- [ ] Each plan has valid frontmatter
- [ ] Tasks are specific and actionable
- [ ] Dependencies correctly identified
- [ ] must_haves derived from plan goal
</quality_gate>
```

---

## Placeholders

| Placeholder | Source | Example |
|-------------|--------|---------|
| `{plan_number}` | From backlog/arguments | `001` |
| `{plan_dir}` | Plan directory name | `001-brand-foundation` |
| `{plan}` | Plan prefix | `001` |

---

## Usage

**From /mario:plan:**
```python
Task(
  prompt=filled_template,
  subagent_type="mario-planner",
  description="Plan {plan_number}"
)
```

---

## Continuation

For checkpoints, spawn fresh agent with:

```markdown
<objective>
Continue planning for Plan {plan_number}: {plan_name}
</objective>

<prior_state>
Plan directory: @.planning/plans/{plan_dir}/
Existing plans: @.planning/plans/{plan_dir}/*-PLAN.md
</prior_state>

<checkpoint_response>
**Type:** {checkpoint_type}
**Response:** {user_response}
</checkpoint_response>
```

---

**Note:** Planning methodology, task breakdown, dependency analysis, TDD detection, and goal-backward derivation are baked into the mario-planner agent. This template only passes context.
