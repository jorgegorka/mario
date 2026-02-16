# Continuation Format

Standard format for presenting next steps after completing a command or workflow.

## Core Structure

```
---

## ▶ Next Up

**{identifier}: {name}** — {one-line description}

`{command to copy-paste}`

<sub>`/clear` first → fresh context window</sub>

---

**Also available:**
- `{alternative option 1}` — description
- `{alternative option 2}` — description

---
```

## Format Rules

1. **Always show what it is** — name + description, never just a command path
2. **Pull context from source** — BACKLOG.md for plans, PLAN.md `<objective>` for tasks
3. **Command in inline code** — backticks, easy to copy-paste, renders as clickable link
4. **`/clear` explanation** — always include, keeps it concise but explains why
5. **"Also available" not "Other options"** — sounds more app-like
6. **Visual separators** — `---` above and below to make it stand out

## Variants

### Execute Next Plan

```
---

## ▶ Next Up

**002: Refresh Token Rotation** — Add /api/auth/refresh with sliding expiry

`/mario:execute 2`

<sub>`/clear` first → fresh context window</sub>

---

**Also available:**
- Review plan before executing

---
```

### Execute Final Plan

Add note that this is the last plan and what comes after:

```
---

## ▶ Next Up

**003: Refresh Token Rotation** — Add /api/auth/refresh with sliding expiry
<sub>Final plan in project</sub>

`/mario:execute 3`

<sub>`/clear` first → fresh context window</sub>

---

**After this completes:**
- Project complete

---
```

### Plan a Plan

```
---

## ▶ Next Up

**002: Authentication** — JWT login flow with refresh tokens

`/mario:plan 2`

<sub>`/clear` first → fresh context window</sub>

---

**Also available:**
- Review backlog

---
```

### Plan Complete, Ready for Next

Show completion status before next action:

```
---

## ✓ Plan 002 Complete

3/3 tasks executed

## ▶ Next Up

**003: Core Features** — User dashboard, settings, and data export

`/mario:plan 3`

<sub>`/clear` first → fresh context window</sub>

---

**Also available:**
- Review what Plan 002 built

---
```

### Multiple Equal Options

When there's no clear primary action:

```
---

## ▶ Next Up

**003: Core Features** — User dashboard, settings, and data export

**To plan directly:** `/mario:plan 3`

**To execute directly:** `/mario:execute 3`

<sub>`/clear` first → fresh context window</sub>

---
```

## Pulling Context

### For plans (from BACKLOG.md):

```markdown
### 002: Authentication
**Goal**: JWT login flow with refresh tokens
```

Extract: `**002: Authentication** — JWT login flow with refresh tokens`

### For tasks (from PLAN.md):

From PLAN.md `<objective>`:

```xml
<objective>
Add refresh token rotation with sliding expiry window.

Purpose: Extend session lifetime without compromising security.
</objective>
```

Extract: `**002: Refresh Token Rotation** — Add /api/auth/refresh with sliding expiry`

## Anti-Patterns

### Don't: Command-only (no context)

```
## To Continue

Run `/clear`, then paste:
/mario:execute 2
```

User has no idea what plan 002 is about.

### Don't: Missing /clear explanation

```
`/mario:plan 3`

Run /clear first.
```

Doesn't explain why. User might skip it.

### Don't: "Other options" language

```
Other options:
- Review backlog
```

Sounds like an afterthought. Use "Also available:" instead.

### Don't: Fenced code blocks for commands

```
```
/mario:plan 3
```
```

Fenced blocks inside templates create nesting ambiguity. Use inline backticks instead.
