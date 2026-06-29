---
type: project
name: "Lumio"
aliases: []
tags: [saas, revenue]
status: active
priority: high
related_people: [priya-nair]
related_orgs: []
repo: "<your-username>/lumio"
stack: [go, fiber, postgres, supabase, telegram, openai, stripe]
created: 2026-06-08
updated: 2026-06-27
started: 2026-05-20
deadline:
---

# Lumio

## What it is

A micro-SaaS that emails founders a **weekly plain-language digest** of their app analytics — "what changed and why it matters" instead of a dashboard nobody opens. Target: solo founders and small SaaS teams. Connects to a metrics source, summarizes with an LLM, sends a clean weekly email.

## Current status

Beta in progress. Core pipeline (ingest → summarize → email) works end to end. Priya is building onboarding + the digest template. Next: Stripe checkout, then a private beta with 10 founders.

Pricing: Free (1 project, monthly digest) · Pro €12/mo (weekly, multiple projects).

## Architecture

Stack locked 2026-05-28:
- **Backend:** Go + Fiber
- **Database:** Postgres (Supabase)
- **Notifications:** Telegram bot (alerts) + email digest (Resend)
- **AI:** OpenAI with structured outputs (direct API, no framework)
- **Payments:** Stripe
- **Infra:** small VPS + Coolify
- **Landing:** static site on a CDN

## History
- 2026-05-20 — Project start
- 2026-05-28 — Stack locked
- 2026-06-27 — Pipeline working end to end; Stripe next

## Notes
- Co-builder: Priya Nair (revenue share post-launch).
- Keep the digest *short* — the whole value prop is "you don't have to read a dashboard".
