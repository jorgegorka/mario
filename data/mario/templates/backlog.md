# Backlog Template

Template for `.mario_planning/BACKLOG.md`.

```markdown
# Backlog: {{project_name}}

## Plans

- [ ] **001: [Plan Name]** — [Brief description]

## Upcoming

Ideas not yet scoped into plans:
- [idea]

## Completed

| # | Plan | Completed | Commit |
|---|------|-----------|--------|
```

<guidelines>

**Plan format:**
- Plans are numbered sequentially: 001, 002, 003...
- Each plan has a name and brief description
- Plans are checked off when completed and moved to the Completed table
- New plans are added to the end of the Plans list

**Upcoming:**
- Ideas captured but not yet scoped into concrete plans
- Moved to Plans section when ready to scope
- No commitment implied

**Completed:**
- Tracks completion date and commit hash
- Provides audit trail of delivered work

**Status values for plans:**
- Unchecked `- [ ]`: Not started or in progress
- Checked `- [x]`: Complete

</guidelines>

<status_values>
- `Not started` - Haven't begun
- `In progress` - Currently working
- `Complete` - Done (add completion date)
- `Deferred` - Pushed to later (with reason)
</status_values>
