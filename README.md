# alat-tempur

> Curated, opinionated developer setups — editor configs, boilerplates, and productivity tools. Credentials stripped, ready to fork.

`alat-tempur` (Indonesian for "weapon/toolkit") is a personal arsenal of developer environments. Each top-level folder is a self-contained, drop-in configuration you copy into your own setup, adapt, and ship.

---

## Overview

- **Audience:** developers who already know their stack and want a fast, opinionated baseline.
- **Document type:** reference + index. Each module ships its own how-to guide.
- **What you do after reading:** pick a module, install it, replace the placeholders, start coding.

### What's inside

| Module | Stack | Status | Guide |
| --- | --- | --- | --- |
| [`Zed-Code-Setup`](./Zed-Code-Setup) | Zed editor — **Go**, **Rust**, **TypeScript**. Free, lightweight JetBrains alternative with Cursor agent integration. | Ready | [`Zed-Code-Setup/readme.md`](./Zed-Code-Setup/readme.md) |

_More modules (boilerplates, dotfiles, CLI tools) will land over time._

---

## Design principles

Every module follows the same rules:

- **Redacted by default** — no secrets, tokens, or absolute user paths. Placeholders are clearly marked.
- **Drop-in friendly** — copy the files into place, point them at your environment, done.
- **Opinionated but documented** — every non-obvious choice has a comment explaining _why_.
- **Performance-aware** — defaults favor low CPU/thermal overhead; heavy features are opt-in.

> **Warning:** Every credential, API key, and binary path in this repo is a placeholder. Do not run agent servers or build steps until you replace them with your own values.

---

## Quick start

1. **Clone the repo.**
   ```bash
   git clone https://github.com/titikterang/alat-tempur.git
   cd alat-tempur
   # Expected: top-level folders include Zed-Code-Setup/
   ls
   ```

2. **Pick a module** and open its guide.
   ```bash
   # macOS / Linux
   open Zed-Code-Setup/readme.md
   ```

3. **Follow the module's installation section**, then replace every placeholder (look for `your ... path`, `"-"`, `"Your Name"`).

---

## Repository layout

```
alat-tempur/
└── Zed-Code-Setup/
    ├── readme.md           Full setup guide (start here)
    ├── settings.json       Zed settings — Go / Rust / TS, LSP, agents
    ├── keymap.json         JetBrains-style keymap with custom bindings
    └── extension/
        ├── extension.json  Custom "Run TypeScript" Zed extension
        └── run-ts.sh       Runner script — tsx with ts-node fallback
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| `git clone` fails with permission denied | Repo is private or your SSH key is missing | Use the HTTPS URL above, or add an SSH key to your GitHub account |
| A module's files don't appear after clone | Shallow clone with a different branch | Run `git fetch --unshallow` then `git checkout main` |
| Placeholders like `your ... path` still in files after install | You skipped the replacement step | Re-run `grep -rn "your .* path\|\"-\"\|Your Name" Zed-Code-Setup/` and replace each match |

---

## Related resources

- [Zed editor](https://zed.dev) — official site and docs
- [Zed discussions](https://github.com/zed-industries/zed/discussions) — community Q&A
- Module guides: [`Zed-Code-Setup/readme.md`](./Zed-Code-Setup/readme.md)

---

## License

Shared for educational and personal-use purposes. Adapt freely for your own workflow.
