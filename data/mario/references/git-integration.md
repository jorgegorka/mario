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
| BRIEF + ROADMAP created | YES     | Project initialization                           |
| PLAN.md created         | NO      | Intermediate - commit with plan completion       |
| RESEARCH.md created     | NO      | Intermediate                                     |
| DISCOVERY.md created    | NO      | Intermediate                                     |
| **Task completed**      | YES     | Atomic unit of work (1 commit per task)         |
| **Plan completed**      | YES     | Metadata commit (SUMMARY + STATE + ROADMAP)     |
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
## Project Initialization (brief + roadmap together)

```
docs: initialize [project-name] ([N] phases)

[One-liner from PROJECT.md]

Phases:
1. [phase-name]: [goal]
2. [phase-name]: [goal]
3. [phase-name]: [goal]
```

What to commit:

```bash
mario-tools commit "docs: initialize [project-name] ([N] phases)" --files .planning/
```

</format>

<format name="task-completion">
## Task Completion (During Plan Execution)

Each task gets its own commit immediately after completion.

```
{type}({phase}-{plan}): {task-name}

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
git commit -m "feat(08-02): create brand positioning document

- Defines primary ICP and buyer personas
- Establishes 3-tier messaging hierarchy
- Includes competitive differentiation framework
"

# Content review task
git add content/web/homepage.md
git commit -m "fix(07-02): align homepage copy with brand voice

- Updates headline to reflect positioning statement
- Replaces generic CTAs with benefit-driven copy
- Adds social proof section with customer quotes
"

# Strategy task
git add content/strategy/audience-research.md
git commit -m "feat(07-02): complete audience research

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
docs({phase}-{plan}): complete [plan-name] plan

Tasks completed: [N]/[N]
- [Task 1 name]
- [Task 2 name]
- [Task 3 name]

SUMMARY: .planning/phases/XX-name/{phase}-{plan}-SUMMARY.md
```

What to commit:

```bash
mario-tools commit "docs({phase}-{plan}): complete [plan-name] plan" --files .planning/phases/XX-name/{phase}-{plan}-PLAN.md .planning/phases/XX-name/{phase}-{plan}-SUMMARY.md .planning/STATE.md .planning/ROADMAP.md
```

**Note:** Code files NOT included - already committed per-task.

</format>

<format name="handoff">
## Handoff (WIP)

```
wip: [phase-name] paused at task [X]/[Y]

Current: [task name]
[If blocked:] Blocked: [reason]
```

What to commit:

```bash
mario-tools commit "wip: [phase-name] paused at task [X]/[Y]" --files .planning/
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
2f4a8d docs: initialize saas-marketing (5 phases)
```

**New approach (per-task commits):**
```
# Phase 04 - Email Campaigns
1a2b3c docs(04-01): complete email sequence plan
4d5e6f feat(04-01): add re-engagement email series
7g8h9i feat(04-01): create trial onboarding sequence
0j1k2l feat(04-01): write welcome email series

# Phase 03 - Web Copy
3m4n5o docs(03-02): complete landing page plan
6p7q8r feat(03-02): add comparison landing pages
9s0t1u feat(03-02): write feature page copy
2v3w4x feat(03-01): create homepage messaging

# Phase 02 - Brand Positioning
5y6z7a docs(02-02): complete messaging hierarchy plan
8b9c0d feat(02-02): create proof points inventory
1e2f3g feat(02-02): define messaging hierarchy tiers
4h5i6j docs(02-01): complete brand voice plan
7k8l9m feat(02-01): establish brand voice attributes
0n1o2p feat(02-01): write positioning statement

# Phase 01 - Foundation
3q4r5s docs(01-01): complete research plan
6t7u8v feat(01-01): complete competitive analysis
9w0x1y feat(01-01): document buyer personas
2z3a4b feat(01-01): conduct audience research

# Initialization
5c6d7e docs: initialize saas-marketing (5 phases)
```

Each plan produces 2-4 commits (tasks + metadata). Clear, granular, bisectable.

</example_log>

<anti_patterns>

**Still don't commit (intermediate artifacts):**
- PLAN.md creation (commit with plan completion)
- RESEARCH.md (intermediate)
- DISCOVERY.md (intermediate)
- Minor planning tweaks
- "Fixed typo in roadmap"

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
- `git log --grep="{phase}-{plan}"` shows all work for a plan
- `git diff <hash>^..<hash>` shows exact changes per task
- Less reliance on parsing SUMMARY.md = more context for actual work

**Failure recovery:**
- Task 1 committed ✅, Task 2 failed ❌
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
