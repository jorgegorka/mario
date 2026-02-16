# Plan Argument Parsing

Parse and normalize plan arguments for commands that operate on plans.

## Extraction

From `$ARGUMENTS`:
- Extract plan number (first numeric argument)
- Extract flags (prefixed with `--`)
- Remaining text is description (for add commands)

## Using mario-tools

The `find-plan` command handles normalization and validation in one step:

```bash
PLAN_INFO=$(mario-tools find-plan "${PLAN}")
```

Returns JSON with:
- `found`: true/false
- `directory`: Full path to plan directory
- `plan_number`: Normalized number (e.g., "001")
- `plan_name`: Name portion (e.g., "foundation")
- `plans`: Array of PLAN.md files
- `summaries`: Array of SUMMARY.md files

## Manual Normalization (Legacy)

Zero-pad plan numbers to 3 digits.

```bash
# Normalize plan number
if [[ "$PLAN" =~ ^[0-9]+$ ]]; then
  # Integer: 8 → 008
  PLAN=$(printf "%03d" "$PLAN")
fi
```

## Validation

Use `backlog get` to validate plan exists:

```bash
PLAN_CHECK=$(mario-tools backlog get "${PLAN}")
if [ "$(echo "$PLAN_CHECK" | jq -r '.found')" = "false" ]; then
  echo "ERROR: Plan ${PLAN} not found in backlog"
  exit 1
fi
```

## Directory Lookup

Use `find-plan` for directory lookup:

```bash
PLAN_DIR=$(mario-tools find-plan "${PLAN}" --raw)
```
