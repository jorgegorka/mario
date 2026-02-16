<purpose>
Execute small, ad-hoc tasks with Mario guarantees (atomic commits, STATE.md tracking) while skipping optional agents (research). Quick mode spawns mario-planner (quick mode) + mario-executor, creates a plan in `.planning/plans/`, and updates BACKLOG.md.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>
**Step 1: Get task description**

Prompt user interactively for the task description:

```
AskUserQuestion(
  header: "Quick Task",
  question: "What do you want to do?",
  followUp: null
)
```

Store response as `$DESCRIPTION`.

If empty, re-prompt: "Please provide a task description."

---

**Step 2: Initialize**

```bash
INIT=$(mario-tools init quick "$DESCRIPTION")
```

Parse JSON for: `planner_model`, `executor_model`, `commit_docs`, `next_num`, `slug`, `date`, `timestamp`, `plan_dir`, `planning_exists`, `backlog_exists`.

**If `backlog_exists` is false:** Error — Quick mode requires an active project with BACKLOG.md. Run `/mario:new-project` first.

---

**Step 3: Create plan directory**

```bash
mkdir -p "${plan_dir}"
```

Report to user:
```
Creating quick plan ${next_num}: ${DESCRIPTION}
Directory: ${plan_dir}
```

---

**Step 4: Add to backlog**

```bash
mario-tools backlog add "${DESCRIPTION}"
```

---

**Step 5: Spawn planner (quick mode)**

Spawn mario-planner with quick mode context:

```
Task(
  prompt="
<planning_context>

**Mode:** quick
**Directory:** ${plan_dir}
**Description:** ${DESCRIPTION}

**Project State:**
@.planning/STATE.md

</planning_context>

<constraints>
- Create a SINGLE PLAN.md with 1-3 focused tasks
- Quick tasks should be atomic and self-contained
- No research, no checker
- Target ~30% context usage (simple, focused)
</constraints>

<output>
Write plan to: ${plan_dir}/PLAN.md
Return: ## PLANNING COMPLETE with plan path
</output>
",
  subagent_type="mario-planner",
  model="{planner_model}",
  description="Quick plan: ${DESCRIPTION}"
)
```

After planner returns:
1. Verify plan exists at `${plan_dir}/PLAN.md`
2. Report: "Plan created: ${plan_dir}/PLAN.md"

If plan not found, error: "Planner failed to create PLAN.md"

---

**Step 6: Spawn executor**

Spawn mario-executor with plan reference:

```
Task(
  prompt="
Execute quick plan ${next_num}.

Plan: @${plan_dir}/PLAN.md
Project state: @.planning/STATE.md

<constraints>
- Execute all tasks in the plan
- Commit each task atomically
- Create summary at: ${plan_dir}/SUMMARY.md
</constraints>
",
  subagent_type="mario-executor",
  model="{executor_model}",
  description="Execute: ${DESCRIPTION}"
)
```

After executor returns:
1. Verify summary exists at `${plan_dir}/SUMMARY.md`
2. Extract commit hash from executor output
3. Report completion status

**Known Claude Code bug (classifyHandoffIfNeeded):** If executor reports "failed" with error `classifyHandoffIfNeeded is not defined`, this is a Claude Code runtime bug — not a real failure. Check if summary file exists and git log shows commits. If so, treat as successful.

If summary not found, error: "Executor failed to create SUMMARY.md"

---

**Step 7: Mark complete and update STATE.md**

```bash
mario-tools backlog complete "${next_num}"
mario-tools state advance-plan
mario-tools state update-progress
```

Update STATE.md with:

**Last activity line:**
```
Last activity: ${date} - Completed quick plan ${next_num}: ${DESCRIPTION}
```

---

**Step 8: Final commit and completion**

Stage and commit plan artifacts:

```bash
mario-tools commit "docs(plan-${next_num}): ${DESCRIPTION}" --files ${plan_dir}/PLAN.md ${plan_dir}/SUMMARY.md .planning/STATE.md .planning/BACKLOG.md
```

Get final commit hash:
```bash
commit_hash=$(git rev-parse --short HEAD)
```

Display completion output:
```
---

Mario > QUICK PLAN COMPLETE

Plan ${next_num}: ${DESCRIPTION}

Summary: ${plan_dir}/SUMMARY.md
Commit: ${commit_hash}

---

Ready for next task: /mario:quick
```

</process>

<success_criteria>
- [ ] BACKLOG.md validation passes
- [ ] User provides task description
- [ ] Slug generated (lowercase, hyphens, max 40 chars)
- [ ] Next number calculated (001, 002, 003...)
- [ ] Directory created at `.planning/plans/NNN-slug/`
- [ ] PLAN.md created by planner
- [ ] SUMMARY.md created by executor
- [ ] BACKLOG.md updated (plan added and marked complete)
- [ ] STATE.md updated
- [ ] Artifacts committed
</success_criteria>
</output>
