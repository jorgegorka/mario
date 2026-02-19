<purpose>
Interactive configuration of Mario workflow settings and model profile selection via multi-question prompt. Updates .mario_planning/config.json with user preferences. Also handles direct profile switching (e.g., `/mario:settings quality`).
</purpose>

<required_reading>
Read all files referenced by the invoking prompt's execution_context before starting.
</required_reading>

<process>

<step name="check_direct_profile">
**If $ARGUMENTS matches a profile name** (`quality`, `balanced`, `budget`):

Quick-switch model profile without interactive menu:

```bash
mario-tools config-ensure-section
```

Update `model_profile` field in `.mario_planning/config.json` to the provided value.

Display confirmation with model table:
```
Model profile set to: $ARGUMENTS

Agents will now use:

| Agent | Model |
|-------|-------|
| mario-planner | [model] |
| mario-executor | [model] |
| ... | ... |

Next spawned agents will use the new profile.
```

Exit — skip interactive settings below.
</step>

<step name="ensure_and_load_config">
Ensure config exists and load current state:

```bash
mario-tools config-ensure-section
INIT=$(mario-tools state load)
```

Creates `.mario_planning/config.json` with defaults if missing and loads current config values.
</step>

<step name="read_current">
```bash
cat .mario_planning/config.json
```

Parse current values (default to `true` if not present):
- `workflow.research` — spawn researcher before planning
- `model_profile` — which model each agent uses (default: `balanced`)
</step>

<step name="present_settings">
Use AskUserQuestion with current values pre-selected:

```
AskUserQuestion([
  {
    question: "Which model profile for agents?",
    header: "Model",
    multiSelect: false,
    options: [
      { label: "Quality", description: "Opus everywhere (highest cost)" },
      { label: "Balanced (Recommended)", description: "Opus for planning, Sonnet for execution" },
      { label: "Budget", description: "Sonnet for writing, Haiku for research (lowest cost)" }
    ]
  },
  {
    question: "Spawn Plan Researcher? (researches domain before planning)",
    header: "Research",
    multiSelect: false,
    options: [
      { label: "Yes", description: "Research plan goals before planning" },
      { label: "No", description: "Skip research, plan directly" }
    ]
  }
])
```
</step>

<step name="update_config">
Merge new settings into existing config.json:

```json
{
  ...existing_config,
  "model_profile": "quality" | "balanced" | "budget",
  "workflow": {
    "research": true/false
  }
}
```

Write updated config to `.mario_planning/config.json`.
</step>

<step name="confirm">
Display:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Mario ► SETTINGS UPDATED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Setting              | Value |
|----------------------|-------|
| Model Profile        | {quality/balanced/budget} |
| Plan Researcher      | {On/Off} |

These settings apply to future /mario:plan and /mario:execute runs.

Quick commands:
- /mario:settings <profile> — switch model profile directly
- /mario:plan --research — force research
- /mario:plan --skip-research — skip research
```
</step>

</process>

<success_criteria>
- [ ] Current config read
- [ ] User presented with settings (profile + research toggle)
- [ ] Config updated with model_profile and workflow sections
- [ ] Changes confirmed to user
- [ ] Direct profile switching supported via argument
</success_criteria>
</output>
