<purpose>
Check project progress, summarize recent work and what's ahead, then intelligently route to the next action — either executing an existing plan or creating the next one. Provides situational awareness before continuing work.
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

<step name="init_context">
**Load progress context (with file contents to avoid redundant reads):**

```bash
INIT=$(mario-tools init progress --include state,backlog,project,config)
```

Extract from init JSON: `project_exists`, `backlog_exists`, `state_exists`.

**File contents (from --include):** `state_content`, `backlog_content`, `project_content`, `config_content`. These are null if files don't exist.

If `project_exists` is false (no `.planning/` directory):

```
No planning structure found.

Run /mario:new-project to start a new project.
```

Exit.

If missing STATE.md: suggest `/mario:new-project`.
If missing BACKLOG.md: suggest `/mario:new-project`.
</step>

<step name="load">
**Use project context from INIT:**

All file contents are already loaded via `--include` in init_context step:
- `state_content` — living memory (position, decisions, issues)
- `backlog_content` — plan list and status
- `project_content` — current state (What This Is, Core Value, Requirements)
- `config_content` — settings (model_profile, workflow toggles)

No additional file reads needed.
</step>

<step name="analyze_backlog">
**Get plan status from backlog:**

```bash
BACKLOG=$(mario-tools backlog list)
```

This returns structured JSON with:
- All plans with status (pending/planned/in_progress/complete)
- Plan descriptions and numbers
- Aggregated stats: total plans, completed, progress percent
- Next plan identification
</step>

<step name="recent">
**Gather recent work context:**

- Find the 2-3 most recent SUMMARY.md files in `.planning/plans/`
- Use `summary-extract` for efficient parsing:
  ```bash
  mario-tools summary-extract <path> --fields one_liner
  ```
- This shows "what we've been working on"
</step>

<step name="position">
**Parse current position from init context and backlog:**

- Use backlog for next incomplete plan
- Count pending todos: use `init todos` or `list-todos`
- Check for active debug sessions: `ls .planning/debug/*.md 2>/dev/null | grep -v resolved | wc -l`
</step>

<step name="report">
**Generate progress bar from mario-tools, then present rich status report:**

```bash
PROGRESS_BAR=$(mario-tools progress bar --raw)
```

Present:

```
# [Project Name]

**Progress:** {PROGRESS_BAR}
**Profile:** [quality/balanced/budget]

## Recent Work
- [Plan NNN]: [what was accomplished - 1 line from summary-extract]
- [Plan NNN]: [what was accomplished - 1 line from summary-extract]

## Current Position
Plan [NNN] of [total]: [plan-name] — [status]

## Key Decisions Made
- [decision 1 from STATE.md]
- [decision 2]

## Blockers/Concerns
- [any blockers or concerns from STATE.md]

## Pending Todos
- [count] pending — /mario:check-todos to review

## Active Debug Sessions
- [count] active — /mario:debug to continue
(Only show this section if count > 0)

## What's Next
[Next plan objective from backlog]
```

</step>

<step name="route">
**Determine next action based on backlog status.**

**Step 1: Check backlog for next action**

```bash
NEXT=$(mario-tools backlog next)
```

Parse result for: `plan_number`, `plan_name`, `status` (pending/planned).

---

**Route A: Plan needs execution (status = planned, PLAN.md exists)**

```
---

## ▶ Next Up

**Plan {NNN}: {Name}** — {description}

/mario:execute {NNN}

<sub>/clear first → fresh context window</sub>

---
```

---

**Route B: Plan needs planning (status = pending, no PLAN.md)**

```
---

## ▶ Next Up

**Plan {NNN}: {Name}** — {description}

/mario:plan {NNN}

<sub>/clear first → fresh context window</sub>

---

**Also available:**
- /mario:plan {NNN} --research — research first

---
```

---

**Route C: All plans complete**

```
---

## ✓ All Plans Complete

All plans in BACKLOG.md have been executed.

/mario:progress — review overall status

---
```

</step>

<step name="edge_cases">
**Handle edge cases:**

- Blockers present → highlight before offering to continue
- Active debug sessions → mention them
</step>

</process>

<success_criteria>

- [ ] Rich context provided (recent work, decisions, issues)
- [ ] Current position clear with visual progress
- [ ] What's next clearly explained
- [ ] Smart routing: /mario:execute if plan exists, /mario:plan if not
- [ ] User confirms before any action
</success_criteria>
</output>
