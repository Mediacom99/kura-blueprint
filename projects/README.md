# projects/

Active work lives here — **one folder per client or project**, `kebab-case`, English names.

```
projects/
├── memory-system/      # The design + templates for Kura's 3-layer memory (showcase)
└── <client-name>/      # e.g. northwind/ — one folder per engagement
```

## Conventions
- **One folder per client/project.** Keep quotes, specs, code, and notes for that engagement together.
- **NDA-safe by default.** Real client work is private; this public blueprint ships only the generic `memory-system/` so you can see the architecture. The entity for a sample engagement lives in `kb/projects/atlas-crm.md`.
- **English, `kebab-case`** filenames — even for non-English clients.
- Anything that isn't a real deliverable (scratch, downloads) goes in `tmp/`, not here.

## What's included here
- **`memory-system/`** — the spec (`DESIGN.md`), the memory-update design (`MEMORY-UPDATE-DESIGN.md`), the Curator prompt (`curator-prompt.md`), and the entity `TEMPLATES/`. This is the reusable scaffolding behind `kb/`.
