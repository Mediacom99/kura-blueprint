#!/usr/bin/env bash
# Kura blueprint — one-shot local setup.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "🧭 Kura blueprint — quickstart"
echo

# 1. Env file
if [ -f .env ]; then
  echo "• .env already exists — leaving it untouched."
else
  cp .env.example .env
  echo "• Created .env from .env.example — open it and fill in your keys (see SECURITY.md)."
fi

# 2. Secret-leak guard
bash scripts/install-hooks.sh

echo
echo "Next steps:"
echo "  1. Edit .env            — API keys (Anthropic, Telegram, Notion, OpenAI)"
echo "  2. Edit USER.md         — who your assistant works for (replace the Sam Rivera sample)"
echo "  3. Edit TOOLS.md        — Notion DB IDs, Telegram IDs, infra placeholders"
echo "  4. Edit SOUL.md         — tune the personality (optional)"
echo "  5. Read docs/make-it-yours.md and docs/recreate-on-vps.md"
echo
echo "Done. Run 'make help' to see available commands."
