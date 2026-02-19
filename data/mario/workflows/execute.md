<purpose>
Execute a single plan. Spawns a mario-executor agent, creates SUMMARY.md, marks plan complete in BACKLOG.md, and updates STATE.md.
</purpose>

<required_reading>
Read STATE.md before any operation to load project context.
</required_reading>

<process>

<step name="initialize" priority="first">
Load all context in one call:

```bash
INIT=$(mario-tools init execute "${PLAN_NUM}")
```

Parse JSON for: `executor_model`, `commit_docs`, `plan_found`, `plan_dir`, `plan_number`, `plan_name`, `plan_slug`, `has_plan`, `has_summary`, `state_exists`, `backlog_exists`.

**If `plan_found` is false:** Error — plan directory not found.
**If `has_plan` is false:** Error — no PLAN.md found in plan directory.
**If `has_summary` is true:** Plan already executed. Offer: 1) Re-execute, 2) View summary, 3) Abort.
**If `state_exists` is false but `.mario_planning/` exists:** Offer reconstruct or continue.
</step>

<step name="validate_plan">
From init JSON: `plan_dir`, `plan_number`, `plan_name`.

Report: "Executing plan {plan_number}: {plan_name}"

Read the PLAN.md to extract objective and task count:

```bash
cat "${PLAN_DIR}/PLAN.md"
```
</step>

<step name="describe_plan">
**Describe what's being built (BEFORE spawning):**

Read the plan's `<objective>`. Extract what's being built and why.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► EXECUTING PLAN {NNN}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**{Plan NNN}: {Plan Name}**
{2-3 sentences: what this builds, technical approach, why it matters}

Spawning executor...
```

- Bad: "Executing email marketing plan"
- Good: "Welcome email sequence with 5-touch nurture flow — onboarding drip, value prop reinforcement, and conversion CTA."
</step>

<step name="spawn_executor">
**Domain routing:** Read `domain` from the plan's frontmatter to determine which executor to spawn:

```bash
DOMAIN=$(mario-tools frontmatter get "${PLAN_DIR}/PLAN.md" --field domain)
DOMAIN_GUIDE=$(mario-tools frontmatter get "${PLAN_DIR}/PLAN.md" --field domain_guide)
DESIGN_GUIDE=$(mario-tools frontmatter get "${PLAN_DIR}/PLAN.md" --field design_guide)
```

| Domain | Executor Agent | Guide |
|--------|---------------|-------|
| `strategy` | `mario-strategy-executor` | `@~/.claude/guides/strategy.md` |
| `web` | `mario-web-executor` | `@~/.claude/guides/web-copy.md` |
| `email` | `mario-email-executor` | `@~/.claude/guides/email.md` |
| `social` | `mario-social-executor` | `@~/.claude/guides/social.md` |
| `seo` | `mario-seo-executor` | `@~/.claude/guides/seo-content.md` |
| `ads` | `mario-ads-executor` | `@~/.claude/guides/paid-ads.md` |
| `general` or unset | `mario-executor` | (none) |

```
Task(
  subagent_type="{executor_agent}",
  model="{executor_model}",
  prompt="
    <objective>
    Execute plan {plan_number}: {plan_name}.
    Commit each task atomically. Create SUMMARY.md. Update STATE.md.
    </objective>

    <execution_context>
    @~/.claude/mario/workflows/execute-plan.md
    @~/.claude/mario/templates/summary.md
    @~/.claude/mario/references/checkpoints.md
    @~/.claude/mario/references/tdd.md
    {If domain_guide is set:}
    @~/.claude/guides/{domain_guide}
    {If design_guide is set:}
    @~/.claude/guides/{design_guide}
    </execution_context>

    <files_to_read>
    Read these files at execution start using the Read tool:
    - Plan: {plan_dir}/PLAN.md
    - State: .mario_planning/STATE.md
    - Config: .mario_planning/config.json (if exists)
    </files_to_read>

    <success_criteria>
    - [ ] All tasks executed
    - [ ] Each task committed individually
    - [ ] SUMMARY.md created in plan directory
    - [ ] STATE.md updated with position and decisions
    </success_criteria>
  "
)
```
</step>

<step name="handle_executor_return">
**Spot-check claims first:**

For SUMMARY.md:
- Verify first 2 files from `key-files.created` exist on disk
- Check `git log --oneline --all --grep="plan-${PLAN_NUM}"` returns ≥1 commit
- Check for `## Self-Check: FAILED` marker

If ANY spot-check fails: report which check failed, ask "Retry?" or "Continue?"

**Known Claude Code bug (classifyHandoffIfNeeded):** If agent reports "failed" with error containing `classifyHandoffIfNeeded is not defined`, this is a Claude Code runtime bug — not a Mario or agent issue. Run spot-checks; if they pass, treat as successful.

If pass:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► PLAN {NNN} COMPLETE ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

**{Plan NNN}: {Plan Name}**
{What was built — from SUMMARY.md}
{Notable deviations, if any}
```
</step>

<step name="mark_complete">
Mark plan complete in BACKLOG.md:

```bash
mario-tools backlog complete "${PLAN_NUM}"
```
</step>

<step name="update_state">
Update STATE.md:

```bash
mario-tools state advance-plan
mario-tools state update-progress
```
</step>

<step name="commit_metadata">
Task code already committed per-task. Commit plan metadata:

```bash
mario-tools commit "docs(plan-${PLAN_NUM}): complete plan execution" --files "${PLAN_DIR}/SUMMARY.md" .mario_planning/STATE.md .mario_planning/BACKLOG.md
```
</step>

<step name="offer_next">
```bash
# Check backlog for next incomplete plan
NEXT=$(mario-tools backlog next)
```

**If next plan exists:**
```
───────────────────────────────────────────────────────────────

## ▶ Next Up

**Plan {NEXT_NUM}: {Next Name}** — {description}

/mario:execute {NEXT_NUM}

<sub>/clear first → fresh context window</sub>

───────────────────────────────────────────────────────────────

**Also available:**
- /mario:progress — check overall status
- cat {plan_dir}/SUMMARY.md — review what was built

───────────────────────────────────────────────────────────────
```

**If all plans complete:**
```
───────────────────────────────────────────────────────────────

## ✓ All Plans Complete

All plans in BACKLOG.md have been executed.

/mario:progress — review overall status

───────────────────────────────────────────────────────────────
```
</step>

</process>

<failure_handling>
- **classifyHandoffIfNeeded false failure:** Agent reports "failed" but error is `classifyHandoffIfNeeded is not defined` → Claude Code bug, not Mario. Spot-check (SUMMARY exists, commits present) → if pass, treat as success
- **Agent fails mid-plan:** Missing SUMMARY.md → report, ask user how to proceed
- **Checkpoint unresolvable:** "Skip this plan?" or "Abort execution?" → record partial progress in STATE.md
</failure_handling>

<resumption>
Re-run `/mario:execute {NNN}` → checks for existing SUMMARY.md → offers re-execute or skip.

STATE.md tracks: last completed plan, pending checkpoints.
</resumption>
</output>
