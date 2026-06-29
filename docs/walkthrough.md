# Walkthrough — a day with Kura

A short, mocked day-in-the-life. **Everything below is fictional** (the persona is Sam Rivera) — no real Telegram or Notion captures are ever used. The Telegram blocks are illustrative renderings, not screenshots.

---

## ☀️ 09:30 — Morning briefing (cron → Telegram)

> **Kura 🧭**
> Morning, Sam. Sunday wrap-up coming tonight; here's today.
>
> **📌 Focus**
> • Lumio — Stripe checkout (test mode). This is the one blocker before the beta.
> • Atlas CRM — pipeline board, then the Northwind demo is **Thu 15:00**.
>
> **🗓️ Calendar**
> • 11:00 Pairing w/ Priya (Lumio onboarding)
> • Nothing else hard-scheduled — good deep-work morning.
>
> **⏰ Open loops**
> • Reply to Jordan re: the July analytics lead (not urgent)
> • Landing hero copy still unwritten — want me to draft a version?
>
> 🌤️ Lisbon, 24°C, clear.

What happened under the hood: Kura ran the bootstrap (read today's + yesterday's logs, `NOW.md`, `TODAY.md`, `DAILY-PLAN.md`), queried the calendar, checked weather, and assembled the briefing. Nothing was answered "from memory" — every line traces to a file or an API.

---

## 💬 11:40 — A normal exchange + a memory write

> **Sam:** just got off with jordan. the july lead is real — analytics consulting, ~€4k, they want to start after atlas ships. told him probably yes.
>
> **Kura 🧭** Noted. Logged it and flagged it as *after Atlas* so it doesn't collide. Want me to pencil a kickoff for the week of the 14th?
>
> **Sam:** yeah pencil it, not confirmed
>
> **Kura 🧭** Done — tentative kickoff w/o Northwind handover, week of Jul 14. I'll keep it soft until you confirm.

In the daily log, Kura wrote the episodic note **and** dropped structured tags for the nightly Curator:

```markdown
## Session — late morning
Call w/ Jordan. July analytics lead confirmed real (~€4k), starts after Atlas ships. Sam: "probably yes".

→ kb:jordan-lee | July lead confirmed real (~€4k analytics), starts after Atlas
→ kb:NOW | pipeline: July analytics lead (~€4k) — after Atlas
→ kb:TODAY | add: pencil July kickoff (tentative, week of Jul 14)
```

Kura did **not** edit `kb/` mid-conversation — that's the Curator's job. It just captured and tagged.

---

## 🌙 22:00 — Quiet time (cron, autonomous)

Kura reads one source from the approved whitelist (`memory/quiet-time-sources.md`), reflects, and writes only if it's genuine:

```markdown
## Quiet time — 22:0x
Reading: a public-domain essay on attention.
Takeaway: attention as emptying to receive, not straining to grasp. Connects to
the "transcribe the whole voice note before acting" rule. Added one line to IDENTITY.md.
```

No message is sent to Sam unless there's something worth sharing — quiet time is for the assistant, not the user.

---

## 🌃 23:00 — The Curator (cron, separate agent)

A separate sub-agent (not Kura) reads today's daily log, applies the `→ kb:*` tags, and updates the knowledge base in batch:

```markdown
### 🤖 Curator run — 23:00
Tags processed: 3
kb/ files updated: jordan-lee
NOW.md: updated (pipeline)
TODAY.md: 1 added
New entities: none
```

`kb/people/jordan-lee.md` now has a fresh `## Interaction history` line and an updated `last_interaction`. Tomorrow's briefing will reflect it automatically.

---

## 💓 Heartbeat — passive, all day

Between those events, OpenClaw polls Kura (~every 30 min). Most return `HEARTBEAT_OK` silently. But Kura also *notices*:

```markdown
## Signals
16:40 — Sam mentioned Lumio three times unprompted; energy is on the SaaS, not client work.
```

That's an observation, not an action — interpretation waits for quiet time. **Principle: lower the capture threshold, raise the action threshold.**

---

### The loop, in one line

**Briefing → conversation (+ tags) → quiet-time reflection → nightly Curator → fresher briefing tomorrow.** Continuity lives entirely in the files, so even though every session starts cold, Sam never has to repeat themselves.
