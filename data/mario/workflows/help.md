<purpose>
Display the complete Mario command reference. Output ONLY the reference content. Do NOT add project-specific analysis, git status, next-step suggestions, or any commentary beyond the reference.
</purpose>

<reference>
# Mario Command Reference

**Mario** creates structured project plans optimized for solo agentic development with Claude Code.

## Quick Start

1. `/mario:new-project` - Initialize project (includes research, requirements, backlog)
2. `/mario:plan 001` - Create detailed plan for first item
3. `/mario:execute 001` - Execute the plan

## Staying Updated

Mario evolves fast. Update periodically:

```bash
gem update mario && mario install --global
```

## Core Workflow

```
/mario:new-project → /mario:plan → /mario:execute → repeat
```

### Project Initialization

**`/mario:new-project`**
Initialize new project through unified flow.

One command takes you from idea to ready-for-planning:
- Deep questioning to understand what you're building
- Optional domain research (spawns 4 parallel researcher agents)
- Requirements definition with v1/v2/out-of-scope scoping
- Backlog creation with plan breakdown

Creates all `.planning/` artifacts:
- `PROJECT.md` — vision and requirements
- `config.json` — workflow mode (interactive/yolo)
- `research/` — domain research (if selected)
- `REQUIREMENTS.md` — scoped requirements with REQ-IDs
- `BACKLOG.md` — plans mapped to requirements
- `STATE.md` — project memory

Usage: `/mario:new-project`

### Planning

**`/mario:plan <number>`**
Create detailed execution plan for a specific backlog item.

- Generates `.planning/plans/NNN-plan-name/PLAN.md`
- Breaks plan into concrete, actionable tasks
- Includes verification criteria and success measures
- Optional research before planning (if configured)

Usage: `/mario:plan 001`
Result: Creates `.planning/plans/001-foundation/PLAN.md`

### Execution

**`/mario:execute <number>`**
Execute a plan.

- Spawns executor agent with full 200k context
- Verifies plan completion after execution
- Updates BACKLOG.md and STATE.md

Usage: `/mario:execute 001`

### Quick Mode

**`/mario:quick`**
Execute small, ad-hoc tasks with Mario guarantees but skip optional agents.

Quick mode uses the same system with a shorter path:
- Spawns planner + executor (skips researcher)
- Creates plan in `.planning/plans/` and updates BACKLOG.md
- Updates STATE.md tracking

Use when you know exactly what to do and the task is small enough to not need research.

Usage: `/mario:quick`

### Templates

**`/mario:new-from-template [template-name]`**
Create a new plan from a reusable template.

- Lists available templates if no name given
- Collects variable values from user
- Creates plan directory with filled template
- Updates BACKLOG.md

Usage: `/mario:new-from-template email-sequence`

**`/mario:save-template <plan-number> [template-name]`**
Save a completed plan's structure as a reusable template.

- Extracts plan structure with variable placeholders
- Saves for future reuse with `/mario:new-from-template`

Usage: `/mario:save-template 003 email-sequence`

### Progress Tracking

**`/mario:progress`**
Check project status and intelligently route to next action.

- Shows visual progress bar and completion percentage
- Summarizes recent work from SUMMARY files
- Displays current position and what's next
- Lists key decisions and open issues
- Offers to execute next plan or create it if missing

Usage: `/mario:progress`

### Debugging

**`/mario:debug [issue description]`**
Systematic debugging with persistent state across context resets.

- Gathers symptoms through adaptive questioning
- Creates `.planning/debug/[slug].md` to track investigation
- Investigates using scientific method (evidence → hypothesis → test)
- Survives `/clear` — run `/mario:debug` with no args to resume
- Archives resolved issues to `.planning/debug/resolved/`

Usage: `/mario:debug "login button doesn't work"`
Usage: `/mario:debug` (resume active session)

### Todo Management

**`/mario:add-todo [description]`**
Capture idea or task as todo from current conversation.

- Extracts context from conversation (or uses provided description)
- Creates structured todo file in `.planning/todos/pending/`
- Updates STATE.md todo count

Usage: `/mario:add-todo` (infers from conversation)
Usage: `/mario:add-todo Add auth token refresh`

**`/mario:check-todos [area]`**
List pending todos and select one to work on.

- Lists all pending todos with title, area, age
- Optional area filter
- Routes to appropriate action (work now, add to backlog, brainstorm)

Usage: `/mario:check-todos`
Usage: `/mario:check-todos api`

### Configuration

**`/mario:settings [profile]`**
Configure workflow toggles and model profile interactively.

- Toggle researcher agent
- Select model profile (quality/balanced/budget)
- Updates `.planning/config.json`
- Pass a profile name directly to quick-switch: `/mario:settings budget`

Usage: `/mario:settings`
Usage: `/mario:settings quality`

### Utility Commands

**`/mario:help`**
Show this command reference.

**`/mario:update`**
Update Mario to latest version with changelog preview.

Usage: `/mario:update`

## Files & Structure

```
.planning/
├── PROJECT.md            # Project vision
├── BACKLOG.md            # Plan list and status
├── REQUIREMENTS.md       # Scoped requirements with REQ-IDs
├── STATE.md              # Project memory & context
├── config.json           # Workflow mode & settings
├── todos/                # Captured ideas and tasks
│   ├── pending/          # Todos waiting to be worked on
│   └── done/             # Completed todos
├── debug/                # Active debug sessions
│   └── resolved/         # Archived resolved issues
└── plans/
    ├── 001-foundation/
    │   ├── PLAN.md
    │   └── SUMMARY.md
    └── 002-core-features/
        ├── PLAN.md
        └── SUMMARY.md
```

## Workflow Modes

Set during `/mario:new-project`:

**Interactive Mode**

- Confirms each major decision
- Pauses at checkpoints for approval
- More guidance throughout

**YOLO Mode**

- Auto-approves most decisions
- Executes plans without confirmation
- Only stops for critical checkpoints

Change anytime by editing `.planning/config.json`

## Common Workflows

**Starting a new project:**

```
/mario:new-project        # Unified flow: questioning → research → requirements → backlog
/clear
/mario:plan 001           # Create plan for first item
/clear
/mario:execute 001        # Execute the plan
```

**Resuming work after a break:**

```
/mario:progress  # See where you left off and continue
```

**Capturing ideas during work:**

```
/mario:add-todo                    # Capture from conversation context
/mario:add-todo Fix modal z-index  # Capture with explicit description
/mario:check-todos                 # Review and work on todos
```

**Debugging an issue:**

```
/mario:debug "form submission fails silently"  # Start debug session
# ... investigation happens, context fills up ...
/clear
/mario:debug                                    # Resume from where you left off
```

## Getting Help

- Read `.planning/PROJECT.md` for project vision
- Read `.planning/STATE.md` for current context
- Check `.planning/BACKLOG.md` for plan status
- Run `/mario:progress` to check where you're up to
</reference>
</output>
