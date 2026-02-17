<purpose>
Display the complete Mario command reference. Output ONLY the reference content. Do NOT add project-specific analysis, git status, next-step suggestions, or any commentary beyond the reference.
</purpose>

<reference>
# Mario Command Reference

**Mario** creates structured marketing content powered by brand foundations and competitive research.

## Quick Start

1. `/mario:new-project` - Establish brand foundations (includes research across 7 dimensions)
2. `/mario:create "Write a blog post about X"` - Create content using your foundations

## Staying Updated

Mario evolves fast. Update periodically:

```bash
gem update mario && mario install --global
```

## Core Workflow

```
/mario:new-project → /mario:create → repeat
```

### Project Initialization

**`/mario:new-project`**
Establish brand foundations through unified flow.

One command takes you from idea to content-ready:
- Deep questioning to understand your brand and market
- Spawns 7 parallel foundation researcher agents
- Produces comprehensive brand foundation documents
- Synthesizes everything into BRAND-BIBLE.md

Creates all `.planning/` artifacts:
- `PROJECT.md` — project context and initial notes
- `config.json` — workflow preferences
- `foundations/` — 7 foundation documents + BRAND-BIBLE.md

Usage: `/mario:new-project`

### Content Creation

**`/mario:create <content description>`**
Create content using your brand foundations.

- Loads BRAND-BIBLE.md and PROJECT.md as context
- Spawns topic researcher to analyze competing content
- Presents research brief with recommended angle for approval
- Generates content aligned with brand voice and positioning
- Conversational iteration until you're happy

Usage: `/mario:create "Write a blog post about NPS surveys"`
Usage: `/mario:create "Landing page for our new feature"`

### Planning & Execution (Legacy)

These commands remain available for structured plan-based projects:

**`/mario:plan <number>`**
Create detailed execution plan for a specific backlog item.

Usage: `/mario:plan 001`

**`/mario:execute <number>`**
Execute a plan.

Usage: `/mario:execute 001`

### Quick Mode

**`/mario:quick`**
Execute small, ad-hoc tasks with Mario guarantees but skip optional agents.

Usage: `/mario:quick`

### Templates

**`/mario:new-from-template [template-name]`**
Create a new plan from a reusable template.

Usage: `/mario:new-from-template email-sequence`

**`/mario:save-template <plan-number> [template-name]`**
Save a completed plan's structure as a reusable template.

Usage: `/mario:save-template 003 email-sequence`

### Progress Tracking

**`/mario:progress`**
Check project status and intelligently route to next action.

Usage: `/mario:progress`

### Debugging

**`/mario:debug [issue description]`**
Systematic debugging with persistent state across context resets.

Usage: `/mario:debug "login button doesn't work"`
Usage: `/mario:debug` (resume active session)

### Todo Management

**`/mario:add-todo [description]`**
Capture idea or task as todo from current conversation.

Usage: `/mario:add-todo` (infers from conversation)
Usage: `/mario:add-todo Add auth token refresh`

**`/mario:check-todos [area]`**
List pending todos and select one to work on.

Usage: `/mario:check-todos`
Usage: `/mario:check-todos api`

### Configuration

**`/mario:settings [profile]`**
Configure workflow toggles and model profile interactively.

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
├── PROJECT.md            # Project vision & initial notes
├── config.json           # Workflow mode & settings
├── foundations/           # Brand foundation documents
│   ├── BRAND-IDENTITY.md
│   ├── VOICE-TONE.md
│   ├── AUDIENCE-PERSONAS.md
│   ├── COMPETITIVE-LANDSCAPE.md
│   ├── MESSAGING-FRAMEWORK.md
│   ├── PRODUCT-SERVICE.md
│   ├── CHANNELS-DISTRIBUTION.md
│   └── BRAND-BIBLE.md   # Synthesized quick-reference
├── todos/                # Captured ideas and tasks
│   ├── pending/          # Todos waiting to be worked on
│   └── done/             # Completed todos
├── debug/                # Active debug sessions
│   └── resolved/         # Archived resolved issues
└── plans/                # Legacy plan-based execution
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
/mario:new-project        # Establish brand foundations
/clear
/mario:create "Blog post about customer onboarding best practices"
```

**Creating more content:**

```
/mario:create "Email welcome sequence for new signups"
/clear
/mario:create "Landing page for our enterprise plan"
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
- Read `.planning/foundations/BRAND-BIBLE.md` for brand reference
- Run `/mario:progress` to check where you're up to
</reference>
