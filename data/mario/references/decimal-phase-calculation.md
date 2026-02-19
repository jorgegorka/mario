# Plan Numbering

Plans use 3-digit sequential numbering (001, 002, 003).

## Numbering Scheme

Plans are numbered sequentially starting from 001. The numbering is automatic and handled by `mario-tools plan add`.

| Plan | Directory |
|------|-----------|
| 1st plan | `.mario_planning/plans/001-foundation/` |
| 2nd plan | `.mario_planning/plans/002-authentication/` |
| 3rd plan | `.mario_planning/plans/003-core-features/` |

## Adding Plans

```bash
# Add a new plan (numbering is automatic)
mario-tools plan add "Foundation"
```

Output:
```json
{
  "created": true,
  "plan_number": "001",
  "directory": ".mario_planning/plans/001-foundation/"
}
```

## Looking Up Plans

```bash
# Find a plan by number
PLAN_INFO=$(mario-tools find-plan "1")
```

Returns JSON with:
- `found`: true/false
- `directory`: Full path to plan directory
- `plan_number`: Normalized 3-digit number (e.g., "001")
- `plan_name`: Name portion (e.g., "foundation")
- `plans`: Array of PLAN.md files
- `summaries`: Array of SUMMARY.md files

## Normalization

User input is normalized to 3-digit padding:

| Input | Normalized |
|-------|------------|
| `1` | `001` |
| `12` | `012` |
| `100` | `100` |

## Directory Naming

Plan directories use the 3-digit number and a slug:

```
.mario_planning/plans/{NNN}-{slug}/
```

Examples:
- `.mario_planning/plans/001-foundation/`
- `.mario_planning/plans/002-authentication/`
- `.mario_planning/plans/003-core-features/`
