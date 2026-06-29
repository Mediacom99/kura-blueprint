# assets/

Generated and committed media for the workspace.

```
assets/
├── logo.svg         # Kura compass mark (used in the README header)
├── logo.png         # 512×512 raster of the mark
├── og-image.svg     # 1280×640 social card (source)
├── og-image.png     # 1280×640 social card (raster — for the GitHub social preview)
└── diagrams/        # Architecture diagrams (Mermaid source)
    └── architecture.mmd
```

## Social preview (Open Graph image)
`og-image.png` is the neutral compass social card. GitHub's social preview can only
be set from the web UI, not the API/CLI:
**Repo → Settings → General → Social preview → Edit → upload `assets/og-image.png`.**
The SVG sources regenerate the PNGs with `librsvg`:
```bash
rsvg-convert -w 1280 -h 640 assets/og-image.svg -o assets/og-image.png
rsvg-convert -w 512  -h 512  assets/logo.svg     -o assets/logo.png
```

## Notes
- The reference system also stored DALL·E outputs, avatars, and TTS audio here. Those were personal/owner-specific and are **not** included in this public blueprint.
- For any screenshots or demo media, use **mocked, fictional content only** — never real Telegram/Notion captures. See `docs/walkthrough.md`.
- Keep large binaries out of git where you can; this folder is for small, committable, neutral assets.
