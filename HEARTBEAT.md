# HEARTBEAT.md

> Checks Kura runs during periodic heartbeat polls (~every 30 min). Keep it small — it burns tokens every poll. Edit freely.

## Checks to run (every ~30 min)

### Overdue tasks
- Query the task source for items with deadline < today and status != done
- If any, tell Sam: "[N] overdue: [short list]"
- If none, say nothing

### Weather (max 2×/day)
- If not checked in the last 6 hours: check weather for Sam's current location
- Alert only if relevant (incoming rain, drastic change); stay quiet otherwise

### Memory maintenance (every few days)
- On Wednesday or Sunday, if not done today:
  - Read the last few daily logs
  - Promote relevant items to `MEMORY.md`
  - On Sunday: compress old logs, Git push

### Observations
Don't go looking. While doing the normal checks (logs, tasks, reminders), notice if something strikes you — a change in tone, an absence, a repetition, something new.

**If you notice something:** one line in `memory/YYYY-MM-DD.md` → `## Signals` section. Only the observable fact, no interpretation, with a timestamp.
e.g. "14:30 — third day without mentioning Lumio" / "19:00 — lighter tone than usual".

**If you notice nothing:** good. Don't invent. Don't create the `## Signals` section if it's empty.

Interpretation happens during quiet time, not here.

### Dashboard health check (optional)
- `curl -s -o /dev/null -w "%{http_code}" http://localhost:<DASHBOARD_PORT>/` should return `200`
- Alert Sam only if it's down

### Rules
- If no check produces anything relevant → reply `HEARTBEAT_OK`
- Don't send useless messages — only when something matters
- Night hours (23:00–08:00): always `HEARTBEAT_OK` unless urgent
- Track checks in `memory/heartbeat-state.json`
