<purpose>
Create a PLAN.md for a given plan number. Optionally researches the domain before planning. Orchestrates mario-plan-researcher (optional) and mario-planner agents.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.

@~/.claude/mario/references/ui-brand.md
</required_reading>

<process>

## 1. Initialize

Load all context in one call (include file contents to avoid redundant reads):

```bash
INIT=$(mario-tools init plan "$PLAN_NUM" --include state,backlog,requirements,context,research)
```

Parse JSON for: `planner_model`, `researcher_model`, `research_enabled`, `commit_docs`, `plan_found`, `plan_dir`, `plan_number`, `plan_name`, `plan_slug`, `padded_plan`, `has_research`, `has_context`, `has_plan`, `planning_exists`, `backlog_exists`.

**File contents (from --include):** `state_content`, `backlog_content`, `requirements_content`, `context_content`, `research_content`. These are null if files don't exist.

**If `planning_exists` is false:** Error — run `/mario:new-project` first.

## 2. Parse and Normalize Arguments

Extract from $ARGUMENTS: plan number (3-digit like `001`), flags (`--research`, `--skip-research`).

**If no plan number:** Detect next unplanned plan from BACKLOG.md.

**If `plan_found` is false:** Create the plan directory:
```bash
mkdir -p ".planning/plans/${padded_plan}-${plan_slug}"
```

## 3. Validate Plan

Check that the plan exists in BACKLOG.md or was provided as a new plan description.

**If plan not in backlog and no description provided:** Error with available plans.

## 4. Handle Research

**Skip if:** `--skip-research` flag, or `research_enabled` is false (from init) without `--research` override.

**If `has_research` is true (from init) AND no `--research` flag:** Use existing, skip to step 5.

**If RESEARCH.md missing OR `--research` flag:**

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► RESEARCHING PLAN {NNN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

◆ Spawning researcher...
```

### Spawn mario-plan-researcher

```bash
REQUIREMENTS=$(echo "$INIT" | jq -r '.requirements_content // empty' | head -50)
```

Research prompt:

```markdown
<objective>
Research how to implement Plan {plan_number}: {plan_name}
Answer: "What do I need to know to PLAN this well?"
</objective>

<additional_context>
**Plan description:** {plan_description}
**Requirements:** {requirements}
</additional_context>

<output>
Write to: {plan_dir}/RESEARCH.md
</output>
```

```
Task(
  prompt="First, read ~/.claude/agents/mario-plan-researcher.md for your role and instructions.\n\n" + research_prompt,
  subagent_type="general-purpose",
  model="{researcher_model}",
  description="Research Plan {plan_number}"
)
```

### Handle Researcher Return

- **`## RESEARCH COMPLETE`:** Display confirmation, continue to step 5
- **`## RESEARCH BLOCKED`:** Display blocker, offer: 1) Provide context, 2) Skip research, 3) Abort

## 5. Check Existing Plan

```bash
ls "${PLAN_DIR}"/PLAN.md 2>/dev/null
```

**If PLAN.md exists:** Offer: 1) Overwrite, 2) View existing, 3) Abort.

## 6. Use Context Files from INIT

All file contents are already loaded via `--include` in step 1:

```bash
STATE_CONTENT=$(echo "$INIT" | jq -r '.state_content // empty')
BACKLOG_CONTENT=$(echo "$INIT" | jq -r '.backlog_content // empty')
REQUIREMENTS_CONTENT=$(echo "$INIT" | jq -r '.requirements_content // empty')
RESEARCH_CONTENT=$(echo "$INIT" | jq -r '.research_content // empty')
CONTEXT_CONTENT=$(echo "$INIT" | jq -r '.context_content // empty')
```

## 7. Spawn mario-planner Agent

Display banner:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► PLANNING {NNN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

◆ Spawning planner...
```

Planner prompt:

```markdown
<planning_context>
**Plan:** {plan_number} — {plan_name}

**Project State:** {state_content}
**Backlog:** {backlog_content}
**Requirements:** {requirements_content}
**Research:** {research_content}
</planning_context>

<downstream_consumer>
Output consumed by /mario:execute. Plan needs:
- Tasks in XML format
- Verification criteria
- Success criteria
</downstream_consumer>

<quality_gate>
- [ ] PLAN.md created in plan directory
- [ ] Tasks are specific and actionable
- [ ] Dependencies correctly identified
</quality_gate>
```

```
Task(
  prompt="First, read ~/.claude/agents/mario-planner.md for your role and instructions.\n\n" + filled_prompt,
  subagent_type="general-purpose",
  model="{planner_model}",
  description="Plan {plan_number}"
)
```

## 8. Handle Planner Return

- **`## PLANNING COMPLETE`:** Display confirmation. Proceed to step 9.
- **`## CHECKPOINT REACHED`:** Present to user, get response, spawn continuation.
- **`## PLANNING INCONCLUSIVE`:** Show attempts, offer: Add context / Retry / Manual.

## 9. Update STATE.md

```bash
mario-tools state update-progress
```

## 10. Commit

**If `commit_docs` is true:**

```bash
mario-tools commit "docs(plan-${PLAN_NUM}): create plan" --files "${PLAN_DIR}/PLAN.md" .planning/STATE.md
```

## 11. Present Final Status

Route to `<offer_next>`.

</process>

<offer_next>
Output this markdown directly (not as a code block):

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► PLAN {NNN} CREATED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**Plan {NNN}: {Name}**

Research: {Completed | Used existing | Skipped}

───────────────────────────────────────────────────────────────

## ▶ Next Up

**Execute Plan {NNN}**

/mario:execute {NNN}

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────

**Also available:**
- cat .planning/plans/{plan-dir}/PLAN.md — review plan
- /mario:plan {NNN} --research — re-research first

───────────────────────────────────────────────────────────────
</offer_next>

<success_criteria>
- [ ] .planning/ directory validated
- [ ] Plan validated against backlog
- [ ] Plan directory created if needed
- [ ] Research completed (unless --skip-research or exists)
- [ ] mario-planner spawned with context
- [ ] PLAN.md created
- [ ] STATE.md updated
- [ ] User sees status between agent spawns
- [ ] User knows next steps
</success_criteria>
</output>
