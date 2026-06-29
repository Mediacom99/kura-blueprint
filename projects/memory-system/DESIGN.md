# Kura Memory System — Design Specification

> How Kura remembers. A file-based, three-layer memory system designed to survive an LLM's stateless sessions. Examples use the fictional persona **Sam Rivera**.

## Contents
1. Research foundation
2. Architecture overview
3. Directory structure
4. File schemas
5. Boot sequence
6. Read patterns
7. Write patterns
8. Retrieval strategy
9. Freshness & temporal awareness
10. Relationship modeling
11. Contradiction handling
12. Compression & archival
13. Maintenance schedule
14. Design decisions & rationale

---

## 1. Research foundation

This design synthesizes ideas from several memory systems and cognitive architectures:

- **MemGPT/Letta** — an editable, always-loaded "core memory" the agent rewrites each session; agent-directed memory (the agent decides what to keep); separate recall (raw logs) from archival (processed entities).
- **Zep/Graphiti** — bi-temporal awareness (event time vs. ingestion time); entity files as the semantic subgraph; daily logs as the episode subgraph; index files as navigation.
- **Mem0** — extract facts, don't just log; update in place; graph structure helps relational queries.
- **Generative Agents (Park et al. 2023)** — three-factor retrieval (recency × importance × relevance); reflection as consolidation — entity files *are* reflections.
- **A-MEM (Zettelkasten for AI)** — atomic, self-contained notes with rich metadata; bidirectional linking; update related files when creating new ones.
- **Cognitive architectures (ACT-R, SOAR, CoALA)** — working memory = boot sequence; episodic = daily logs; semantic = entity files; procedural = `SOUL.md`/`TOOLS.md`; consolidation (episodic → semantic) is the core maintenance loop.
- **Knowledge management (Obsidian, Roam, Logseq)** — flat directories per entity type; YAML frontmatter as machine-queryable metadata; curated indexes; daily notes as an inbox processed into permanent files.

**Anti-patterns to avoid:** a single monolithic memory file; implicit-only relationships (grepping names doesn't scale); no consolidation pipeline; loading everything at boot; deep folder hierarchies.

---

## 2. Architecture overview

```
LAYER 0 — IDENTITY (read-only)        SOUL · IDENTITY · USER · TOOLS · AGENTS
   ↑ read at boot, never modified by this system

LAYER 1 — WORKING MEMORY (boot)       NOW.md · TODAY.md
   ↑↓ always loaded; ~2-3KB; high-signal orientation

LAYER 2 — SEMANTIC MEMORY (entities)  kb/people · kb/projects · kb/orgs · kb/topics
   ↑↓ one atomic file per entity; YAML frontmatter + body; loaded on demand

LAYER 3 — EPISODIC MEMORY (logs)      memory/YYYY-MM-DD.md
   ↑ raw, timestamped, append-only; the source of truth; searched on deep questions
```

Key choices: a small `NOW.md` "core memory" gives instant orientation; `TODAY.md` is the ephemeral daily file; **entity files** are the core abstraction; daily logs stay raw and unchanged (they work).

---

## 3. Directory structure

```
workspace/
├── NOW.md  TODAY.md                # Layer 1 — working memory
├── SOUL.md IDENTITY.md USER.md TOOLS.md AGENTS.md   # Layer 0
├── kb/                             # Layer 2 — knowledge base
│   ├── _index.md  _rules.md
│   ├── people/   *.md (one per person)
│   ├── projects/ *.md (one per project)
│   ├── orgs/     *.md (one per org)
│   └── topics/   *.md (cross-cutting topics)
├── memory/                         # Layer 3 — episodic logs
│   ├── YYYY-MM-DD.md
│   ├── heartbeat-state.json  settings.json
└── MEMORY.md                       # long-term distillation (loaded only in main sessions)
```

Flat directories per entity type; slug-based filenames (`kb/people/jordan-lee.md`) so paths are predictable.

---

## 4. File schemas

See `TEMPLATES/` for the canonical skeletons. In short:

**Person** — frontmatter: `type, name, aliases, tags, status, related_*, created, updated, last_interaction, contact`. Body: *Who they are · Current status · Interaction history (append-only) · Notes*.

**Project** — frontmatter adds `priority, repo, stack, started, deadline`. Body: *What it is · Current status · Architecture · History · Notes*.

**Org / Topic** — lighter; see templates.

Example (abbreviated) — `kb/people/jordan-lee.md`:
```yaml
---
type: person
name: "Jordan Lee"
tags: [work, priority-high]
status: active
related_projects: [atlas-crm]
updated: 2026-06-26
last_interaction: 2026-06-26
---
# Jordan Lee
## Who they are
Sam's main referral channel — connects freelancers with clients.
## Current status
Confirmed the Northwind/Atlas CRM engagement; second lead likely in July.
```

**Why YAML frontmatter:** it's machine-queryable. `grep "tags:.*client" kb/people/` finds all clients instantly; the body carries the narrative.

---

## 5. Boot sequence

On every new session Kura reads, in order:
1. `SOUL.md` — identity, rules, tone
2. `USER.md` — the user's profile
3. `kb/_rules.md` — absolute rules
4. `NOW.md` — current-state briefing
5. `TODAY.md` — today's schedule and tasks

A few hundred lines total — minimal but sufficient. **Not read at boot:** entity files, daily logs, `_index.md`, `MEMORY.md`, `IDENTITY.md` (all on demand). First action after boot: if `TODAY.md` is missing or from yesterday, create it from `NOW.md` + calendar + tasks.

---

## 6. Read patterns

| Question | Files | Notes |
|----------|-------|-------|
| "Who is Jordan?" | `kb/people/jordan-lee.md` | direct lookup by slug |
| "What happened with the Northwind client?" | `kb/projects/atlas-crm.md` | entity file has history |
| "...last week specifically?" | entity file → relevant `memory/2026-06-*.md` | entity for context, logs for detail |
| "What should I do today?" | `TODAY.md` (already loaded) | in context |
| "Who do I know that works with Go?" | `kb/_index.md` → grep frontmatter | index for discovery |
| "Can't find X" | `memory_search` | semantic fallback |

---

## 7. Write patterns

**During conversation** (via the dual-track tags — see `MEMORY-UPDATE-DESIGN.md`):
- New person → tag `→ kb:NEW? <slug>`; the Curator creates it on a second substantive mention.
- New info about a known entity → tag `→ kb:<slug> | <fact>`.
- Decision/task → `→ kb:TODAY | ...` and update the project on the next Curator run.
- Critical fact (money, irreversible decision) → `⚡` emergency flush, update now.

**Key principle:** write *during* the conversation, not just at the end. Entity edits are small and targeted, so it's cheap.

---

## 8. Retrieval strategy (layered)

```
1. Direct lookup    → read entity file by slug          (fastest)
2. Index scan       → read kb/_index.md, find the slug
3. Frontmatter grep → grep YAML across kb/ (e.g. all "client")
4. Semantic search  → memory_search across all .md
5. Log search       → grep memory/YYYY-MM-DD.md by date
```
Most queries resolve at layers 1–2. Frontmatter greps are fast O(n) scans — milliseconds at hundreds of entities.

---

## 9. Freshness & temporal awareness

Every entity tracks three dates: `created`, `updated`, `last_interaction`. Weekly staleness scan flags `status: active` entities not touched in 30+ days (people) or 14+ days (projects) for review → update or set `inactive`/`archived`.

**Entity file = current truth; daily log = historical record.** When a fact changes, edit the entity file and log the change. No versioning in entity files — that's what git + daily logs are for.

---

## 10. Relationship modeling

Explicit links in frontmatter: `related_projects`, `related_people`, `related_orgs`. **Bidirectional:** when you add A → B, add B → A (something humans forget and an AI can do reliably). Traversal is graph-walking via sequential file reads (Zep's approach on a filesystem). Qualified relationships ("client via Jordan") go in the body, not frontmatter.

---

## 11. Contradiction handling

Entity file is the single source of current truth. On contradiction: (1) update the entity file, (2) log the change with a timestamp, (3) don't keep old versions in the file. Conflicting sources: **the user always wins** over Notion/email; if two systems disagree, flag it.

---

## 12. Compression & archival

- **Daily logs:** after 30+ days, compress into `memory/YYYY-MM/summary.md` (key events, people, projects, decisions). Raw files move into the month directory but are **not deleted**.
- **Entities:** `status: archived` → `kb/_archive/`, excluded from normal queries, still searchable.
- **Size targets:** `NOW.md` 40–60 lines · `TODAY.md` 20–40 · person file 30–80 · project file 50–150 · `_index.md` one line/entity.

---

## 13. Maintenance schedule

- **Daily (evening review):** ensure today's conversations are reflected in entity files; update `NOW.md`; check for orphan mentions.
- **Weekly (Sunday):** verify `_index.md`; check bidirectional links; flag stale entities; comprehensive `NOW.md` refresh; Git push.
- **Monthly:** compress the previous month's logs; archive dead entities.

---

## 14. Design decisions & rationale

- **`kb/` separate from `memory/`** — semantic vs. episodic; different access patterns.
- **Flat, not nested** — a person can be both a collaborator *and* a friend; tags handle multi-classification; flat scans faster; slugs are predictable.
- **Frontmatter** — structure for queries, narrative in the body.
- **`NOW.md` separate from `SOUL.md`/`USER.md`** — different update frequencies; volatile state shouldn't live in the system prompt.
- **Keep daily logs as-is** — the problem was never the logs, it was the lack of consolidation; entity files fix that without changing the log format.
- **`NOW.md` + `TODAY.md`, not one file** — one is persistent across days, one is ephemeral per day.
- **Topics** — some knowledge is cross-cutting (e.g. "stack decisions" spans many projects); topic files capture it naturally.
