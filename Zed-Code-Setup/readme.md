# Zed-Code-Setup

> Replace your JetBrains IDE with a free, native editor that opens in seconds — tuned for **Go**, **Rust**, and **TypeScript**, with deep LSP configs and Cursor's AI agent wired straight in.

This is a drop-in configuration for [Zed](https://zed.dev) that replaces the factory defaults with a setup that is quieter on the CPU, sharper on autocomplete, and ready to drive Cursor's AI agent directly from inside the editor.

---

## Switching from a JetBrains IDE?

If you're paying for IntelliJ / GoLand / RustRover / WebStorm and want something **free, fast, and native**, this setup is built for you. Zed is a GPU-accelerated, Rust-based editor that opens in under a second, idles at a fraction of JetBrains' RAM footprint, and speaks your existing JetBrains keymap out of the box.

| What you give up in JetBrains | What you get with this setup |
| --- | --- |
| Paid subscription (Ultimate / All Products Pack) | Free and open-source — no license, no account |
| 1–4 GB RAM per project, slow cold start (~10–30 s) | Native binary, ~1–2 s cold start, typically 150–400 MB idle |
| Electron or JVM UI jank under load | GPU-rendered, stays smooth on large files |
| Re-learning keybindings on a new editor | `base_keymap: "JetBrains"` — your muscle memory carries over (`cmd-shift-r`, `cmd-shift-t`, etc.) |
| Running Cursor as a separate IDE to use its agent | Drive Cursor's agent **from inside Zed** via the bundled `cursor-agent` ACP server |
| Per-language formatter/linter setup per project | Pre-wired `gopls`, `rust-analyzer`, `vtsls` + ESLint with format-on-save |

> **Note — Cursor integration:** This config registers a Cursor ACP agent server in `settings.json`. Once you point it at your real `cursor-agent` binary, Cursor's AI agent runs inside Zed's Assistant panel — same prompts, same model, no second IDE to keep open.

---

## 5-Minute Quick Start

**Goal:** from clone to running TypeScript inside a tuned Zed in under five minutes. For the full multi-language tour (Go, Rust, ESLint, AI agents), skip to [Prerequisites](#prerequisites).

**You need already installed:** [Zed](https://zed.dev) and Node.js 18+ (`node --version`).

```bash
# 1. Install tsx — used by the Run-TypeScript extension
npm install -g tsx
# Expected: added 1 package in ...

# 2. Clone this repo
git clone https://github.com/titikterang/alat-tempur.git ~/src/alat-tempur
# Expected: Cloning into '~/src/alat-tempur'...

# 3. Symlink the config files and the custom extension into Zed
mkdir -p ~/.config/zed/extensions
ln -s ~/src/alat-tempur/Zed-Code-Setup/settings.json ~/.config/zed/settings.json
ln -s ~/src/alat-tempur/Zed-Code-Setup/keymap.json   ~/.config/zed/keymap.json
ln -s ~/src/alat-tempur/Zed-Code-Setup/extension     ~/.config/zed/extensions/run-ts

# 4. Make the runner executable
chmod +x ~/src/alat-tempur/Zed-Code-Setup/extension/run-ts.sh

# 5. Create a scratch TypeScript file and open it in Zed
mkdir -p ~/src/zed-demo && cd ~/src/zed-demo
cat > hello.ts <<'EOF'
const greet = (name: string): string => `Hello, ${name}!`
console.log(greet("Zed"))
EOF
zed hello.ts
```

**See the win:**

1. Zed opens with the **Ayu Dark** theme and JetBrains-style keybindings — the config loaded.
2. Inside `hello.ts`, press **`cmd-shift-t`**. The terminal panel opens and prints:
   ```
   Hello, Zed!
   ```
3. Press **`cmd-shift-i`** to toggle inlay hints — parameter and return-type hints appear next to `greet`. Press again to hide.
4. Add trailing whitespace to a line, save with **`cmd-s`** — the whitespace disappears on save. Format-on-save works.

You're running the tuned setup. To add Go, Rust, ESLint, and Cursor/GLM agents, continue to [Prerequisites](#prerequisites).

> **Note:** If any step fails, jump to [Troubleshooting](#troubleshooting). The usual culprits are a missing toolchain, `tsx` not on Zed's inherited `PATH`, or `run-ts.sh` not being executable.

---

## Overview

- **Audience:** developers working in Go, Rust, and TypeScript — especially JetBrains IDE users looking for a free, lightweight, but powerful alternative.
- **Document type:** how-to guide (installation) + reference (config keys, keybindings, placeholders).
- **What you do after reading:** skim the [5-Minute Quick Start](#5-minute-quick-start) for a fast win, then return here for the full multi-language setup.

### Highlights

- **Tri-language focus** — first-class configs for Go (`gopls`), Rust (`rust-analyzer`), and TypeScript/JavaScript (`vtsls` + `eslint`).
- **Deep LSP, on your terms** — exhaustive inlay hints, diagnostics, and analyses configured per language, but globally disabled until you toggle them (`cmd-shift-i`). Keeps Intel CPUs from thermal-throttling during long sessions.
- **Format on save, the right way** — `language_server` formatter with per-language `code_actions_on_format` (organize imports, ESLint autofix, etc.).
- **AI agent servers wired in** — Cursor (`acp`) and GLM (`glm-acp-agent`) pre-configured with redacted placeholders.
- **JetBrains muscle memory** — `base_keymap: "JetBrains"` so your existing reflexes carry over.
- **Custom Run-TypeScript extension** — execute the current `.ts` file straight from Zed via `tsx` / `ts-node`.
- **Clean editor UX** — trailing whitespace stripped, final newline enforced, selective whitespace display, bar cursor with no blink.
- **Sane terminal** — login interactive `zsh`, copy-on-select, monospace at 13pt.

### Why this over the defaults?

| Area | Zed default | This setup |
| --- | --- | --- |
| Inlay hints | Always on | Globally off; deep config available via toggle |
| Formatter | Off / per-language | `language_server` everywhere, format on save |
| Go | `gopls` basics | `staticcheck`, shadow/nilness/unusedwrite analyses, deep hints |
| Rust | `rust-analyzer` defaults | Clippy checks, all cargo features, granular import control |
| TypeScript | `vtsls` defaults | Full inlay hints, type-only auto-imports, non-relative specifiers |
| Keymap | Platform default | JetBrains layout + custom toggles |
| Telemetry | On | Diagnostics + metrics disabled |

---

## Prerequisites

Install these before applying the config. Run each check command — expected output is shown beneath.

### Editor and fonts

| Tool | Check command | Expected | Install |
| --- | --- | --- | --- |
| Zed | `zed --version` | `Zed 0.x.x` | [zed.dev](https://zed.dev) |
| JetBrains Mono NL | `fc-list \| grep -i "JetBrains Mono NL"` (Linux) or check Font Book (macOS) | At least one match | [jetbrains.com/lp/mono](https://www.jetbrains.com/lp/mono/) |

### Language toolchains

| Tool | Check command | Minimum version | Install |
| --- | --- | --- | --- |
| Go | `go version` | 1.21+ | [go.dev/dl](https://go.dev/dl/) |
| Rust (rustup) | `rustup --version` | any recent | [rustup.rs](https://rustup.rs) |
| `rust-analyzer` | `rust-analyzer --version` | ships with rustup | `rustup component add rust-analyzer` |
| `clippy` | `cargo clippy --version` | ships with rustup | `rustup component add clippy` |
| Node.js | `node --version` | 18+ | [nodejs.org](https://nodejs.org) |
| npm | `npm --version` | 8+ | bundled with Node |
| `tsx` | `tsx --version` | any recent | `npm install -g tsx` |

> **Note:** `eslint` and `typescript` live as per-project `devDependencies` — install them inside each project, not globally.

### Optional: AI agent servers

| Tool | Check command | Install |
| --- | --- | --- |
| `cursor-agent` | `command -v cursor-agent` | Your organization's ACP distribution |
| `glm-acp-agent` | `command -v glm-acp-agent` | Your organization's ACP distribution |

Both require a valid API key before use.

---

## Installation

Zed reads user config from `~/.config/zed/` on macOS/Linux and `%APPDATA%\Zed` on Windows.

1. **Back up your existing config.**
   ```bash
   mv ~/.config/zed ~/.config/zed.bak
   ```

2. **Clone the repo** (replace `~/src` with your preferred location).
   ```bash
   mkdir -p ~/src
   git clone https://github.com/titikterang/alat-tempur.git ~/src/alat-tempur
   # Expected output: Cloning into '~/src/alat-tempur'...
   ls ~/src/alat-tempur/Zed-Code-Setup
   # Expected: extension/ keymap.json readme.md settings.json
   ```

3. **Install the config files.** Symlink to stay in sync with the repo, or copy if you want to edit freely.

   ```bash
   mkdir -p ~/.config/zed

   # Symlink (recommended — edits flow back to the repo)
   ln -s ~/src/alat-tempur/Zed-Code-Setup/settings.json ~/.config/zed/settings.json
   ln -s ~/src/alat-tempur/Zed-Code-Setup/keymap.json   ~/.config/zed/keymap.json
   ```

   Or copy:
   ```bash
   cp ~/src/alat-tempur/Zed-Code-Setup/{settings.json,keymap.json} ~/.config/zed/
   ```

4. **Install the custom Run-TypeScript extension.**
   ```bash
   ln -s ~/src/alat-tempur/Zed-Code-Setup/extension ~/.config/zed/extensions/run-ts
   ```

5. **Replace every placeholder** — see the [Placeholders checklist](#placeholders-to-replace).

---

## Verify your setup

After installation, confirm each piece works.

1. **Zed picks up the config.**
   - Open Zed. Check the theme is **Ayu Dark** and the UI font looks like JetBrains Mono.
   - Open the Command Palette (`cmd-shift-p`) → search **Open Settings File**. You should see the contents of this repo's `settings.json`.

2. **LSP servers attach.**
   - Open any `.go`, `.rs`, or `.ts` file.
   - Status bar (bottom) should show `gopls`, `rust-analyzer`, or `vtsls` respectively.
   - Hover a symbol → you should see type/documentation.

3. **Format on save works.**
   - Add trailing whitespace to a buffer, then save (`cmd-s`).
   - Expected: whitespace disappears, file ends with a single newline.

4. **Run-TypeScript extension runs.**
   - Open a `.ts` file with a `console.log("hello")`.
   - Press `cmd-shift-t`.
   - Expected: terminal panel opens, prints `hello`.

5. **Inlay-hint toggle works.**
   - Press `cmd-shift-i` inside a `.ts` file.
   - Expected: parameter names and return types appear next to functions. Press again to hide.

If any step fails, jump to [Troubleshooting](#troubleshooting).

---

## File map

```
Zed-Code-Setup/
├── readme.md          This document
├── settings.json      Editor, languages, LSP, agent servers
├── keymap.json        JetBrains-style keymap with custom bindings
└── extension/
    ├── extension.json Zed extension manifest for "Run TypeScript"
    └── run-ts.sh      Runner: tsx with ts-node fallback
```

---

## Configuration reference

### `settings.json`

Sections, top to bottom:

1. **Editor & UI** — `JetBrains Mono NL`, dark Ayu theme, Material icons, telemetry off.
2. **Agent servers** — Cursor and GLM ACP configs. Credentials redacted.
3. **Editor UX** — bar cursor (no blink), selective whitespace, scroll margins, trailing-whitespace strip, final newline, inline git blame.
4. **Formatting** — `language_server` formatter, `format_on_save: "on"`, inlay hints disabled by default.
5. **Terminal** — `JetBrains Mono NL` 13pt, copy-on-select, login interactive `zsh`.
6. **Languages** — Go, Rust, TypeScript, TSX, JavaScript, JSX — each with explicit `language_servers`, formatter, and `code_actions_on_format`.
7. **LSP** — `rust-analyzer`, `gopls`, `vtsls` initialization options (clippy, staticcheck, shadow analysis, full TS inlay hints).

Inline comments inside the file explain _why_ specific flags are set — read them before tweaking.

### `keymap.json`

| Binding | Action | Context |
| --- | --- | --- |
| `cmd-shift-i` | Toggle inlay hints (your deep LSP config, on demand) | Editor |
| `cmd-alt-l` | Force format the current buffer | Editor |
| `cmd-j` | Toggle bottom dock (terminal panel) | Workspace |
| `cmd-shift-r` | Open the task modal | Workspace |
| `cmd-shift-t` | Run the "Run TypeScript" task | Workspace |
| `cmd-w` | Close active pane (in terminal) | Terminal |
| `cmd-k` | Clear terminal buffer | Terminal |

---

## Custom extension — Run TypeScript

A minimal Zed extension that runs the current TypeScript file via `tsx` (falls back to `ts-node`). `extension/extension.json` registers the `run-ts.execute` command; `extension/run-ts.sh` does the work.

Install options (covered in step 4 of [Installation](#installation)):

```bash
# Symlink (auto-updates with this repo)
ln -s "$(pwd)/extension" ~/.config/zed/extensions/run-ts

# Copy (edit freely without touching the repo)
cp -r extension ~/.config/zed/extensions/run-ts
```

Make the runner executable if it isn't already:

```bash
chmod +x extension/run-ts.sh
# Verify
ls -l extension/run-ts.sh
# Expected: -rwxr-xr-x ... run-ts.sh
```

Trigger it via `cmd-shift-t` (bound in `keymap.json`) or the Command Palette → **Run TypeScript File**.

---

## AI agent servers

Two agent servers are pre-wired in `settings.json`. Both require your own binaries and credentials before they will respond.

| Server | Type | Required setup |
| --- | --- | --- |
| `cursor` | custom ACP | Set `command` to your real `cursor-agent` path (e.g. `~/.local/bin/cursor-agent`) |
| `glm` | custom ACP | Set `command` to your real `glm-acp-agent` path and provide a valid `Z_AI_API_KEY` |

Defaults shipped here are intentionally inert (`"-"` and `your ... path`) so nothing leaks from the repo.

> **Warning:** Do not commit your real API keys back to this repo. Keep a private local override or use environment variables managed outside Zed.

---

## Placeholders to replace

Before this setup is functional, replace every placeholder with your own value.

| Placeholder | Location | Replace with |
| --- | --- | --- |
| `"your cursor-agent path"` | `settings.json` → `agent_servers.cursor.command` | Absolute path to `cursor-agent` |
| `"your glm-acp-agent path"` | `settings.json` → `agent_servers.glm.command` | Absolute path to `glm-acp-agent` |
| `"-"` | `settings.json` → `agent_servers.glm.env.Z_AI_API_KEY` | Your real `Z_AI_API_KEY` |
| `"Your Name"` | `extension/extension.json` → `authors` | Your name or handle |

Find every remaining placeholder in seconds:

```bash
grep -rn 'your .* path\|"-"\|"Your Name"' ~/src/alat-tempur/Zed-Code-Setup/
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Zed ignores `settings.json` after symlink | Zed expects valid JSON; comments are allowed but trailing commas are not | Run `zed --foreground` in a terminal and read the JSON parse error, then fix and reload (`cmd-shift-p` → `Reload`) |
| LSP does not start (`gopls`, `rust-analyzer`, `vtsls` not in status bar) | Toolchain not installed or not on `PATH` | Run the check command from [Prerequisites](#prerequisites); reinstall the missing tool; restart Zed |
| Inlay hints never appear after `cmd-shift-i` | Language-level hints are off, or the project has no type info | For TS/JS run `npm install` in the project so `typescript` and `eslint` resolve; for Rust run `cargo check` once so `rust-analyzer` indexes |
| `cmd-shift-t` prints "Error: Please install tsx or ts-node globally" | `tsx` missing from `PATH` that Zed inherits | Run `npm install -g tsx`; fully quit and reopen Zed (it does not pick up new `PATH` mid-session) |
| Extension does not appear in the Command Palette | `extension/run-ts.sh` is not executable | Run `chmod +x ~/.config/zed/extensions/run-ts/run-ts.sh` |
| Agent server shows "connection refused" or hangs | Placeholder still in place, or binary path wrong | Confirm you replaced `your ... path` and `"-"`; verify with `command -v cursor-agent` |
| High fan/CPU usage on a large Go or TS project | You enabled inlay hints globally and left them on | Press `cmd-shift-i` to toggle them off; keep them off by default (see Notes) |
| Fonts look wrong (fallback to default sans) | `JetBrains Mono NL` not installed | Install from [jetbrains.com/lp/mono](https://www.jetbrains.com/lp/mono/) and restart Zed |

---

## Notes

> **Note — Thermal / CPU:** Inlay hints are globally disabled on purpose. Enabling them with `gopls` deep hints plus `vtsls` full hints on a large codebase can pin a core on Intel Macs. Toggle with `cmd-shift-i` only when you need them.

> **Note — macOS-first:** Paths and shell assume macOS/Linux. On Windows, swap `zsh` for your shell and adjust paths (`%APPDATA%\Zed` instead of `~/.config/zed`).

> **Note — Fonts:** If `JetBrains Mono NL` is not installed, Zed falls back silently. Install it for the intended look.

---

## Related resources

- [Zed editor](https://zed.dev) — official site
- [Zed documentation](https://zed.dev/docs) — settings, keymaps, extensions
- [gopls settings](https://github.com/golang/tools/blob/master/gopls/doc/settings.md) — full reference for the Go LSP
- [rust-analyzer configuration](https://rust-analyzer.github.io/manual.html#configuration) — full reference for the Rust LSP
- [vtsls](https://github.com/yioneko/vtsls) — TypeScript LSP wrapper used here
- Parent repo: [`alat-tempur`](../README.md)
