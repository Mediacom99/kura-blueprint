---
type: project
name: "Atlas CRM"
aliases: [northwind-crm]
tags: [client, freelance]
status: active
priority: medium
related_people: [jordan-lee]
related_orgs: []
repo: "<your-username>/atlas-crm"
stack: [typescript, react, node, postgres]
created: 2026-06-12
updated: 2026-06-26
started: 2026-06-16
deadline: 2026-07-14
---

# Atlas CRM

## What it is

A freelance engagement (referred by Jordan Lee → `jordan-lee`) for a fictional client, **Northwind**: a lightweight internal CRM dashboard to replace their spreadsheet. Scope: contacts, deals pipeline, and a weekly summary view. Fixed price ~€3k, ~4 weeks.

## Current status

Week 2 of 4. Auth + contacts done; building the pipeline board. On track for the 2026-07-14 deadline.

## Architecture
- **Frontend:** React + TypeScript
- **Backend:** Node + Postgres
- **Auth:** hosted auth provider (social login)
- **Deploy:** client's existing cloud account

## History
- 2026-06-16 — Kickoff, repo set up
- 2026-06-26 — Contacts module shipped; pipeline board in progress

## Notes
- Fixed-price; scope is locked. New requests → change order, not scope creep.
- This is the template for the `projects/<client>/` convention — real client work lives in a dedicated folder, NDA-safe.
