# Kura blueprint — quality-of-life commands.
.DEFAULT_GOAL := help
.PHONY: help quickstart env hooks scan check

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

quickstart: ## One-shot setup: env file + git hooks (then edit USER.md/TOOLS.md)
	@bash scripts/quickstart.sh

env: ## Create .env from .env.example (won't overwrite an existing .env)
	@if [ -f .env ]; then echo ".env already exists — leaving it untouched."; \
	else cp .env.example .env && echo "Created .env — fill it in (see SECURITY.md)."; fi

hooks: ## Install the gitleaks pre-commit secret guard
	@bash scripts/install-hooks.sh

scan: ## Scan the whole git history for secrets (requires gitleaks)
	@gitleaks detect --no-banner --config .gitleaks.toml || true

check: ## Quick sanity check: no obvious placeholders left unfilled in core files
	@echo "Remaining <PLACEHOLDERS> in core config (expected in a fresh clone):" ; \
	grep -rno '<[A-Z_]\+>' USER.md TOOLS.md README.md 2>/dev/null | head -20 || echo "  none"
