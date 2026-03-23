# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A modular SketchyBar configuration (macOS menu bar replacement). Shell scripts define UI items and event-driven plugins, with a compiled C helper for performance-critical tasks.

## Key Commands

```bash
# Restart sketchybar (applies all config changes)
brew services restart sketchybar

# Or reload manually
sketchybar --reload

# Force all item scripts to re-run
sketchybar --update

# Build the C helper binary
cd ~/.config/sketchybar/helper && make

# Query an item's current properties (useful for debugging)
sketchybar --query <item_name>
sketchybar --query bar

# Make a new plugin executable (required or it won't run)
chmod +x plugins/<name>.sh
```

## Architecture

**Entry point:** `sketchybarrc` — sources `colors.sh` and `icons.sh`, builds the helper, then sources each `items/*.sh` file to register bar elements. Ends with `sketchybar --update` to force initial render.

**Two-file pattern per feature:**
- `items/<name>.sh` — Declares UI properties as bash arrays, calls `sketchybar --add/--set/--subscribe`
- `plugins/<name>.sh` — Event handler script, routes on `$SENDER` via `case` statement

**Event flow:** System/custom events → SketchyBar dispatches to subscribed items → item's `script` (plugin) executes with env vars (`$NAME`, `$SENDER`, `$INFO`, `$BUTTON`, `$PERCENTAGE`)

**Helper (`helper/`):** C binary compiled with `clang -std=c99 -O3`. Registers as Mach IPC server (`git.felix.helper`) for high-perf operations (CPU stats). Built automatically by `sketchybarrc` on every reload.

## Conventions

- **Colors:** `0xAARRGGBB` hex format. All colors defined in `colors.sh` as exported env vars (Catppuccin Macchiato palette).
- **Icons:** SF Symbols defined in `icons.sh`. Require `brew install --cask sf-symbols`.
- **Font:** `SF Pro` with variants (Regular, Bold, Semibold, Heavy, Black).
- **Item naming:** Dot-separated hierarchy: `spotify.anchor`, `spotify.cover`, `spotify.play`.
- **Popup items:** Added to parent via `popup.<parent_name>` position.
- **Batch mode:** Use `sketchybar -m` for multiple `--set` calls in one IPC message.
- **Plugin event routing:** Always use `case "$SENDER" in` pattern with handlers for `mouse.clicked`, `routine`, `forced`, and a default `*) update` fallback.

## Workflow

Before implementing any changes, always read `DOCS.md` for the SketchyBar API reference and current project documentation. After implementing, update `DOCS.md` to reflect changes.

## Design Goals

- **Unified sizing and style:** All bar items should have consistent dimensions and spacing. The default `background.height=26` and `background.corner_radius=9` from `sketchybarrc` are the baseline. Items with custom visuals (e.g. images, icons) should use padding and scaling to match this height. Keep `padding_left`/`padding_right` consistent (default `$PADDINGS=3`). When adding or modifying items, ensure they visually align with existing ones.

## Active vs Disabled Items

Enabled (sourced in `sketchybarrc`): apple, spaces, front_app, spotify (center), battery, layout, calendar, weather.
Commented out: brew, github, volume, cpu, netstat.
