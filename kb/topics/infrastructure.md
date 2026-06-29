---
type: topic
name: "Kura Infrastructure"
tags: [infra, vps, tools]
updated: 2026-06-28
---

# Kura Infrastructure

> The assistant keeps a live map of where everything runs. Fill in your own values — **never put secrets or tokens here**; those live in the environment (see `.env.example`).

## VPS + system
- **VPS:** `your-vps` — `assistant@your-vps`, Ubuntu 24.04 LTS
- **Private network:** `<TAILSCALE_HOSTNAME>` (e.g. Tailscale)
- **Runtime:** OpenClaw
- **Default model:** `anthropic/claude-sonnet-4-6`
- **Database:** `localhost:5432`, db `<YOUR_DB_NAME>`

## GitHub
- **Account:** `<YOUR_GITHUB_USERNAME>`
- **gh CLI:** `~/.local/bin/gh` · `export GH_CONFIG_DIR=$HOME/.config/gh`
- **Active repos:** `<your-workspace-repo>`, plus project repos

## Dev server / dashboard (optional)
- **Port:** `<DASHBOARD_PORT>`, served behind a reverse proxy
- **URL:** `http://<DASHBOARD_HOST>:<DASHBOARD_PORT>/`

## Cron jobs
| Job | Schedule | Destination |
|-----|----------|-------------|
| Morning Briefing | 09:30 | topic `<TOPIC_BRIEFING>` |
| Evening Review | 21:00 | topic `<TOPIC_REVIEW>` |
| Weekly Review | Mon 09:00 | topic `<TOPIC_WEEKLY>` |
| Self-Maintenance | Sun 23:00 | — |
| Git Push workspace | hourly | — |
| Quiet Time | 22:00 / 22:20 / 22:40 | — |
| Memory Curator | 23:00 | — |

## Telegram
- **Direct chat:** `<YOUR_TELEGRAM_USER_ID>`
- **Group (Kura HQ):** `<YOUR_TELEGRAM_GROUP_ID>`
- **Topics:** briefing/review/health/weekly → `<TOPIC_*>`

## Owner contacts
- Fill in your own (kept out of the public blueprint on purpose).

## Memory search
- BM25 + vector + reranking over `kb/`, daily logs, and `MEMORY.md`
- Embeddings fallback: OpenAI `text-embedding-3-small`

## Curator (memory maintenance)
- **Cron:** nightly
- **Prompt:** `projects/memory-system/curator-prompt.md`
- **Function:** reads `→ kb:*` tags from the daily log and updates `kb/` files
- **System:** dual-track — live tags during the day + async Curator at night
