# Memory Folder — Documentation

This folder contains Kura's episodic memory and operational state.

## File Types

### Daily Logs (`YYYY-MM-DD.md`)
Raw episodic memory — what happened each day.

**Structure:**
```markdown
# YYYY-MM-DD

## Session [time or description]

### Key Events
- What happened

### Decisions
- Choices made and why

### People
- Who was discussed, new contacts

### Technical
- What worked, what didn't

### For MEMORY.md
- Items to promote to long-term memory
```

**Lifecycle:**
- Days 1-7: Full detail
- Days 8-30: Compressed to key points
- Day 30+: Archived after monthly summary created

### Monthly Summaries (`YYYY-MM-summary.md`)
Distilled monthly overview created during self-maintenance.

**Contains:**
- Key events and milestones
- People encountered
- Lessons learned
- Projects progressed

### State Files
- `heartbeat-state.json` — tracks last check timestamps

### Archived Documents
- Migration plans, audits, one-time documentation
- Keep for reference but don't load in context

## Maintenance Schedule

### Daily (During Sessions)
- Write to today's log when significant things happen
- Use proactive capture triggers (see AGENTS.md)

### Wednesday Mini-Check
- Review logs since Sunday
- Promote obvious items to MEMORY.md

### Sunday Full Maintenance
1. Review all daily logs from past week
2. Promote worthy items to MEMORY.md
3. Compress logs older than 7 days
4. Create monthly summary if month ended
5. Archive logs older than 30 days
6. Git push

## What to Capture

✅ **Always log:**
- Decisions made with context
- New people with significant details
- Lessons learned (especially from errors)
- Preferences discovered
- Time-sensitive items

❌ **Skip:**
- Routine heartbeat checks
- Simple confirmations
- Transient operational details
- Information already in MEMORY.md

## Compression Guidelines

When compressing old logs, keep:
- Decisions and their rationale
- People and relationship updates
- Lessons and insights
- Project milestones
- Anything marked "For MEMORY.md"

Remove:
- Step-by-step technical operations
- Routine confirmations
- Verbose context that's now obvious
- Duplicated information

## Integration with MEMORY.md

Daily logs are **input**; MEMORY.md is **output**.

- Don't duplicate between them
- Promote patterns, not individual events
- Use confidence tags in MEMORY.md
- Reference daily logs for episodic detail if needed

---

_Last updated: 2026-02-25_
