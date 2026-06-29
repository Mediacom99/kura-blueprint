---
type: topic
name: "Stack Decisions"
tags: [tech, decisions]
updated: 2026-06-26
---

# Stack Decisions

> A running log of the user's confirmed technical choices, so the assistant proposes consistent options.

## Confirmed choices

| Area | Choice | Why |
|------|--------|-----|
| SaaS infra (MVP) | **Railway / small VPS + Coolify** | Zero-ops to start; self-host once there's revenue |
| Auth | **Hosted auth provider** (social login) | Zero infra, fast to integrate |
| AI | **Direct API calls** | No heavy framework layers — simpler, debuggable |
| PDF | **Pure-Go library** | No external service dependency |
| Payments | **Stripe** | Standard, well-documented |

## Languages & preferences
- **Backend:** Go (preferred), Python, TypeScript
- **Frontend:** React (when needed)
- **Infra:** Docker, GitHub Actions, Coolify, a small VPS fleet
- **AI:** prefer direct API calls over framework layers

## Proposals / quotes
- Always 3 tiers with optional add-ons
- Keep a reusable quote template per engagement type
