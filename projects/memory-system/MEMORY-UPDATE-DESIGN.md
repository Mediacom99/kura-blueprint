# Memory Update System — Design Document

_Context: a 3-layer memory system with `kb/` entity files, daily logs, `NOW.md`, and `TODAY.md`._

---

## The problem in one paragraph

The `kb/` files start as a static snapshot. Without a procedure to keep them alive during and between sessions, the knowledge base risks fossilizing the day after it's created. The daily log captures everything in a stream, but per-entity knowledge goes stale. The central tension: **updating too often slows the conversation; updating too rarely loses data.** We need clear rules for *when*, *what*, and *where* to write.

Three approaches were considered.

---

## Proposal A — "Write-Through"

**Philosophy:** every significant fact is written to its permanent home the moment it emerges. The daily log is a chronological backup; `kb/` is always current.

- During the conversation, when Kura recognizes a fact belonging to an entity, it writes the daily log *and* immediately updates the `kb/` file (and `NOW.md`/`TODAY.md` if relevant).
- **Triggers:** new fact about a person, project status change, new logistical info — anything that would change the answer to "what do I know about X?"
- **Does NOT trigger:** casual mentions with no new info, repetitions, transient moods.

| Pros | Cons |
|------|------|
| `kb/` always current, zero drift | Double-write per fact → perceived latency |
| No data-loss risk | Real-time "is this significant?" decisions = cognitive load |
| Simple model: "write where it belongs" | Risk of writing transient noise into `kb/` |

Complexity 2/5 · Long-term quality 4/5.

---

## Proposal B — "Write-Ahead Log + Checkpoint Flush"

**Philosophy:** the daily log is the primary buffer; `kb/` is updated only at defined checkpoints. Inspired by databases: the WAL captures everything; a periodic flush consolidates into the datastore.

- During the conversation, Kura writes **only** to the daily log. Fast, uninterrupted.
- **Checkpoint flush** at: a significant topic change, a >15-minute pause, every 45–60 minutes of continuous conversation, end of session.
- **Flush procedure (~2–4 min):** re-read the log since the last checkpoint, identify per-entity facts, batch-update `kb/` (one edit per file), update `NOW.md`/`TODAY.md`, note `### Checkpoint flush [HH:MM] — updated: ...` in the log.
- **Emergency flush** outside checkpoints for critical facts (payment received, irreversible decision, status change).

| Pros | Cons |
|------|------|
| Fast conversation, zero interruptions | Vulnerability window between checkpoints |
| Batch writes = fewer tool calls | If the session crashes mid-window, `kb/` is stale |
| Promotion decisions made with more context | Kura must remember to flush (procedural overhead) |

Complexity 3/5 · Long-term quality 4/5.

---

## Proposal C — "Dual-Track: Live Tags + Async Curator"

**Philosophy:** separate capture from consolidation. During the conversation Kura doesn't touch `kb/` — it drops **structured tags** in the daily log. A separate process (the Curator) reads the tags and updates `kb/` carefully.

**Track 1 — live tagging** (during the conversation):
```markdown
Sam talked to Jordan — new analytics-consulting lead, ~€4k, likely July.
→ kb:jordan-lee | new lead: analytics consulting, ~€4k, July
→ kb:NOW | pipeline: new lead via Jordan

Decided to pause the landing redesign to focus on Stripe checkout.
→ kb:lumio | priority: Stripe checkout first; landing paused

Mention of "Theo, a builder from the next Driftspace month"
→ kb:NEW? theo | builder, next Driftspace month — await a second mention
```

**Track 2 — async Curator** (a separate sub-agent, nightly cron or end of session):
1. Read today's daily log
2. Extract all `→ kb:*` tags
3. Update each corresponding `kb/` file
4. For `→ kb:NEW?`, create only on 2+ substantive mentions
5. Update `_index.md`, `NOW.md`, `TODAY.md`
6. Write a one-line report in the log

**Track 2b — emergency flush:** for urgent facts, Kura updates `kb/` directly and notes `⚡ direct flush — reason: [X]`.

| Pros | Cons |
|------|------|
| Zero interruptions to the conversation | `kb/` not real-time — stale until the Curator runs |
| Tags = promotion decided at the right moment | Tagging overhead during the session |
| Curator as a quality gate: curated, not reactive | Dependency on an external process |
| Easy to debug: just read the tags + Curator report | A tag format to learn and keep consistent |

Complexity 4/5 · Long-term quality 5/5.

---

## Comparison

| Dimension | A: Write-Through | B: WAL + Checkpoint | C: Dual-Track |
|---|---|---|---|
| `kb/` update latency | Instant | 15–60 min | Hours (until Curator) |
| Conversation impact | Medium | Low | Minimal |
| Data-loss risk | Minimal | Medium | Medium-low |
| Update quality | Variable | Good | High (curated) |
| Complexity | 2/5 | 3/5 | 4/5 |
| External dependencies | None | None | Cron / sub-agent |
| Debuggability | Low | Medium | High |

---

## Recommendation

**Start with B+ (Checkpoint Flush with Structured Tags), evolve into C.**

1. The bottleneck is the conversation — voice notes expect fast replies, so anything that slows responses (A's double-write) hurts UX.
2. Checkpoints are natural points Kura already recognizes (topic changes, pauses, closings).
3. C is the best at maturity but premature on day one — it needs a reliable Curator, a stable tag format, and a configured cron.
4. The hybrid is natural: adopt C's **structured tags** immediately (they help find what to update at each checkpoint and create an audit trail), and once the tag format is proven (~2–4 weeks), turn on the automatic Curator — a seamless transition because Kura is already writing the same tags.

**This blueprint ships the full C (dual-track) system**, since it's the proven endpoint: live tags during the day + a nightly Curator (`curator-prompt.md`).

---

## Reference tag format
```
→ kb:<slug> | <field>: <value>
→ kb:<slug> | <free fact>
→ kb:NOW | <section>: <update>
→ kb:TODAY | done: <task>
→ kb:TODAY | add: <task>
→ kb:NEW? <slug> | <name>, <context>
⚡ kb:<slug> | <critical fact>     # emergency flush (update now)
```
