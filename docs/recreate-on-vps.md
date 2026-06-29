# Recreate this on a VPS with OpenClaw

A from-scratch recipe to stand up your own Kura. Where a step depends on the exact OpenClaw version or command, it's marked **▸ verify against the OpenClaw docs** — don't take version-specific commands here as gospel; this blueprint deliberately avoids inventing runtime specifics.

## Prerequisites

- A small VPS (e.g. Hetzner CX22, Ubuntu 24.04). Bare-metal or a container both work.
- A non-root service user (e.g. `assistant`).
- API keys ready: **Anthropic**, **Telegram bot**, **Notion**, **OpenAI** (see `.env.example`).
- A GitHub account + repo for hourly workspace backups.
- (Optional) A private network like Tailscale if you want a dashboard reachable only by you.

## 1. Base box

```bash
# as root, then switch to the service user
adduser assistant && usermod -aG sudo assistant
# basics
apt update && apt install -y git curl jq ffmpeg
```

Install per-user CLI tools the assistant uses (into `~/.local/bin`): `gh` (GitHub CLI), and a headless browser for JS-heavy pages (Playwright/Chromium). Add `export PATH=$HOME/.local/bin:$PATH` to the shell profile.

## 2. Install OpenClaw  ▸ verify against the OpenClaw docs

```bash
# Follow the official OpenClaw install for your platform, then:
openclaw agent create
```
This creates the agent and its workspace directory (typically `~/.openclaw/workspace/`).

## 3. Drop in this workspace

```bash
cd ~/.openclaw/workspace
git clone <your-fork-url> .
make quickstart          # .env + secret-leak hook
$EDITOR .env             # fill in your keys
```
Then personalize the files per **[make-it-yours.md](make-it-yours.md)**.

## 4. Connect Telegram

- Create a bot with **@BotFather**, copy the token into `.env` (`TELEGRAM_BOT_TOKEN`).
- Get your numeric user id (e.g. via **@userinfobot**) → `TELEGRAM_USER_ID`.
- (Optional) Create a "Kura HQ" group with topics for automated reports → `TELEGRAM_GROUP_ID` + topic IDs in `TOOLS.md`.
- Configure Telegram as the agent's channel.  ▸ verify against the OpenClaw docs

## 5. Connect Notion

- Create a Notion integration, copy the key into `.env` (`NOTION_API_KEY`).
- Share your databases (Tasks, Habits, Clients, …) with the integration.
- Put each database's `data_source_id` / `database_id` into `TOOLS.md`.

## 6. Set the cron jobs

Recreate the schedule from the README (adjust the timezone). Conceptually:

| Job | When | Does |
|-----|------|------|
| Morning briefing | daily 09:30 | tasks, deadlines, weather → Telegram |
| Evening review | daily 21:00 | reconcile the day, move undone items |
| Weekly review | Mon 09:00 | retrospective + priorities |
| Self-maintenance | Sun 23:00 | memory cleanup, distillation, Git push |
| Hourly Git push | hourly | commit + push the workspace |
| Quiet time | 22:00 / 22:20 / 22:40 | reflect → explore one whitelisted source → report |
| Memory Curator | nightly | apply `→ kb:*` tags to `kb/` |

Use OpenClaw's cron tool to create these.  ▸ verify the exact cron syntax against the OpenClaw docs

## 7. First boot

- Send the bot a message. It should read `SOUL.md` + `USER.md`, bootstrap from `NOW.md`/`TODAY.md`, and reply in your style.
- Say "enable debug" to see context stats while you're tuning.
- Confirm the hourly Git push lands commits in your backup repo.

## 8. Hardening (recommended)

- SSH keys only, no password login; a firewall (ufw) allowing only what you need.
- Keep secrets in the environment; confirm `gitleaks` runs on commit (`make hooks`).
- If you expose a dashboard, bind it to your private network (Tailscale), not the public internet.

---

That's the whole loop: a box, OpenClaw, this workspace, a channel, a store, and a handful of cron jobs. Everything else — the personality, the memory, the knowledge base — is just the files in this repo.
