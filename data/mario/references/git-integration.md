<overview>
Git integration for Mario framework.
</overview>

<core_principle>

**Commit outcomes, not process.**

The git log should read like a changelog of what shipped, not a diary of planning activity.
</core_principle>

<commit_points>

| Event                   | Commit? | Why                                              |
| ----------------------- | ------- | ------------------------------------------------ |
| BRIEF + BACKLOG created | YES     | Project initialization                           |
| PLAN.md created         | NO      | Intermediate - commit with plan completion       |
| RESEARCH.md created     | NO      | Intermediate                                     |
| DISCOVERY.md created    | NO      | Intermediate                                     |
| **Task completed**      | YES     | Atomic unit of work (1 commit per task)         |
| **Plan completed**      | YES     | Metadata commit (SUMMARY + STATE + BACKLOG)     |
| Handoff created         | YES     | WIP state preserved                              |

</commit_points>

<git_check>

```bash
[ -d .git ] && echo "GIT_EXISTS" || echo "NO_GIT"
```

If NO_GIT: Run `git init` silently. Mario projects always get their own repo.
</git_check>

<commit_formats>

<format name="initialization">
## Project Initialization (brief + backlog together)

```
docs: initialize [project-name] ([N] plans)

[One-liner from PROJECT.md]

Plans:
1. [plan-name]: [goal]
2. [plan-name]: [goal]
3. [plan-name]: [goal]
```

What to commit:

```bash
mario-tools commit "docs: initialize [project-name] ([N] plans)" --files .planning/
```

</format>

<format name="task-completion">
## Task Completion (During Plan Execution)

Each task gets its own commit immediately after completion.

```
{type}(plan-{NNN}): {task-name}

- [Key change 1]
- [Key change 2]
- [Key change 3]
```

**Commit types:**
- `feat` - New feature/functionality
- `fix` - Bug fix
- `test` - Test-only (TDD RED phase)
- `refactor` - Code cleanup (TDD REFACTOR phase)
- `perf` - Performance improvement
- `chore` - Dependencies, config, tooling

**Examples:**

```bash
# Standard task
git add content/strategy/positioning.md content/strategy/messaging-hierarchy.md
git commit -m "feat(plan-008): create brand positioning document

- Defines primary ICP and buyer personas
- Establishes 3-tier messaging hierarchy
- Includes competitive differentiation framework
"

# Content review task
git add content/web/homepage.md
git commit -m "fix(plan-007): align homepage copy with brand voice

- Updates headline to reflect positioning statement
- Replaces generic CTAs with benefit-driven copy
- Adds social proof section with customer quotes
"

# Strategy task
git add content/strategy/audience-research.md
git commit -m "feat(plan-007): complete audience research

- Documents 3 buyer personas with JTBD statements
- Maps objections to response strategies
- Includes language extraction from customer interviews
"
```

</format>

<format name="plan-completion">
## Plan Completion (After All Tasks Done)

After all tasks committed, one final metadata commit captures plan completion.

```
docs(plan-{NNN}): complete [plan-name] plan

Tasks completed: [N]/[N]
- [Task 1 name]
- [Task 2 name]
- [Task 3 name]

SUMMARY: .planning/plans/NNN-name/SUMMARY.md
```

What to commit:

```bash
mario-tools commit "docs(plan-{NNN}): complete [plan-name] plan" --files .planning/plans/NNN-name/PLAN.md .planning/plans/NNN-name/SUMMARY.md .planning/STATE.md .planning/BACKLOG.md
```

**Note:** Code files NOT included - already committed per-task.

</format>

<format name="handoff">
## Handoff (WIP)

```
wip: [plan-name] paused at task [X]/[Y]

Current: [task name]
[If blocked:] Blocked: [reason]
```

What to commit:

```bash
mario-tools commit "wip: [plan-name] paused at task [X]/[Y]" --files .planning/
```

</format>
</commit_formats>

<example_log>

**Old approach (per-plan commits):**
```
a7f2d1 feat(email): welcome sequence with 5-email nurture flow
3e9c4b feat(web): homepage and landing pages with conversion copy
8a1b2c feat(positioning): brand voice and messaging hierarchy
5c3d7e feat(foundation): audience research and competitive analysis
2f4a8d docs: initialize saas-marketing (5 plans)
```

**New approach (per-task commits):**
```
# Plan 004 - Email Campaigns
1a2b3c docs(plan-004): complete email sequence plan
4d5e6f feat(plan-004): add re-engagement email series
7g8h9i feat(plan-004): create trial onboarding sequence
0j1k2l feat(plan-004): write welcome email series

# Plan 003 - Web Copy
3m4n5o docs(plan-003): complete landing page plan
6p7q8r feat(plan-003): add comparison landing pages
9s0t1u feat(plan-003): write feature page copy
2v3w4x feat(plan-003): create homepage messaging

# Plan 002 - Brand Positioning
5y6z7a docs(plan-002): complete messaging hierarchy plan
8b9c0d feat(plan-002): create proof points inventory
1e2f3g feat(plan-002): define messaging hierarchy tiers
4h5i6j docs(plan-002): complete brand voice plan
7k8l9m feat(plan-002): establish brand voice attributes
0n1o2p feat(plan-002): write positioning statement

# Plan 001 - Foundation
3q4r5s docs(plan-001): complete research plan
6t7u8v feat(plan-001): complete competitive analysis
9w0x1y feat(plan-001): document buyer personas
2z3a4b feat(plan-001): conduct audience research

# Initialization
5c6d7e docs: initialize saas-marketing (5 plans)
```

Each plan produces 2-4 commits (tasks + metadata). Clear, granular, bisectable.

</example_log>

<anti_patterns>

**Still don't commit (intermediate artifacts):**
- PLAN.md creation (commit with plan completion)
- RESEARCH.md (intermediate)
- DISCOVERY.md (intermediate)
- Minor planning tweaks
- "Fixed typo in backlog"

**Do commit (outcomes):**
- Each task completion (feat/fix/test/refactor)
- Plan completion metadata (docs)
- Project initialization (docs)

**Key principle:** Commit finished content and shipped outcomes, not planning process.

</anti_patterns>

<commit_strategy_rationale>

## Why Per-Task Commits?

**Context engineering for AI:**
- Git history becomes primary context source for future Claude sessions
- `git log --grep="plan-{NNN}"` shows all work for a plan
- `git diff <hash>^..<hash>` shows exact changes per task
- Less reliance on parsing SUMMARY.md = more context for actual work

**Failure recovery:**
- Task 1 committed, Task 2 failed
- Claude in next session: sees task 1 complete, can retry task 2
- Can `git reset --hard` to last successful task

**Debugging:**
- `git bisect` finds exact failing task, not just failing plan
- `git blame` traces line to specific task context
- Each commit is independently revertable

**Observability:**
- Solo developer + Claude workflow benefits from granular attribution
- Atomic commits are git best practice
- "Commit noise" irrelevant when consumer is Claude, not humans

</commit_strategy_rationale>
