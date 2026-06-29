#!/usr/bin/env bash
# Point git at the versioned hooks in .githooks/ so the secret guard runs on every commit.
set -euo pipefail
cd "$(dirname "$0")/.."

git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true

echo "✅ Hooks installed (core.hooksPath = .githooks)."
if command -v gitleaks >/dev/null 2>&1; then
  echo "✅ gitleaks found: $(gitleaks version 2>/dev/null || echo present)"
else
  echo "⚠️  gitleaks not installed — the pre-commit hook will warn but not block."
  echo "    Install: https://github.com/gitleaks/gitleaks#installing"
fi
