# Make it yours

This blueprint ships with a fictional persona (**Sam Rivera**, an indie founder) so it reads as a living system. To turn it into *your* assistant, edit a handful of files in this order. Budget ~30–60 minutes for a first pass.

## 0. Setup (2 min)
```bash
make quickstart      # creates .env + installs the secret-leak hook
```
Then fill in `.env` with your API keys (see `SECURITY.md`).

## 1. `USER.md` — who the assistant works for (10 min)
The single most important file. Replace every field with your own: name, pronouns, communication style, work, priorities, the people who matter. The richer and more honest it is, the better the assistant performs. Keep the `<!-- comments -->` as guidance or delete them.

## 2. `TOOLS.md` — your integrations (10 min)
Replace the placeholders:
- `<NOTION_*_DB_ID>` → your Notion database IDs (from each DB's "Copy link")
- `<YOUR_TELEGRAM_USER_ID>` / `<YOUR_TELEGRAM_GROUP_ID>` / `<TOPIC_*>` → your chat/topic IDs
- `<YOUR_GITHUB_USERNAME>`, `<YOUR_GOOGLE_ACCOUNT>`, `<YOUR_LAT>/<YOUR_LON>` → your values

Run `make check` to list any placeholders you missed.

## 3. `SOUL.md` + `IDENTITY.md` — personality (5 min, optional)
Tune the tone and boundaries. Replace `{{USER_NAME}}` with your name. `IDENTITY.md` is the assistant's to evolve — you can leave it mostly as-is.

## 4. `kb/` — your knowledge base (10 min)
Delete the sample entities (`jordan-lee`, `priya-nair`, `nora-vance`, `driftspace`, `lumio`, `atlas-crm`) and add your own using the templates in `projects/memory-system/TEMPLATES/`. Update `kb/_index.md`. Keep `_rules.md` (tune the bootstrap if your stack differs). The nightly **Curator** will maintain `kb/` from then on — you mostly let it run.

## 5. `memory/` — start fresh (2 min)
Delete the sample daily logs (`2026-06-*.md`) and the sample continuity files (`last-session.md`, `letter-to-next-me.md`, etc.) — they regenerate themselves once the assistant is running. Keep `README.md`, `settings.json`, and `quiet-time-sources.md` (tune the whitelist to taste).

## 6. `NOW.md` / `TODAY.md` / `DAILY-PLAN.md` — clear the sample (1 min)
Empty them out; the assistant rebuilds them on first boot from your context.

## 7. Deploy
Follow **[recreate-on-vps.md](recreate-on-vps.md)** to stand it up on a VPS, connect Telegram, and set the cron jobs.

---

### Map of the pieces

| File | What it controls | Who edits it after launch |
|------|------------------|---------------------------|
| `SOUL.md` | Personality, tone, trust rules | You + the assistant |
| `IDENTITY.md` | The assistant's self-concept | The assistant |
| `USER.md` | Your profile | You |
| `AGENTS.md` | Operating protocols (boot, memory, safety) | You (rarely) |
| `TOOLS.md` | Integrations, IDs, tool inventory | The assistant |
| `HEARTBEAT.md` | What to check on each poll | Either |
| `kb/` | People, projects, orgs, topics | The Curator |
| `memory/` | Daily logs + continuity state | The assistant |
| `MEMORY.md` | Long-term distilled memory | The assistant |

The rule of thumb: **you own `USER.md` and the integrations; the assistant owns its memory and identity.**
