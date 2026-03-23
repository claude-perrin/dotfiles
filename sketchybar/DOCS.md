# SketchyBar Configuration Documentation

This document covers the SketchyBar configuration for this setup, based on the [official SketchyBar documentation](https://felixkratz.github.io/SketchyBar/config/bar).

---

## Table of Contents

- [Overview](#overview)
- [File Structure](#file-structure)
- [Bar Configuration](#bar-configuration)
- [Default Item Properties](#default-item-properties)
- [Items](#items)
- [Plugins](#plugins)
- [Color Palette](#color-palette)
- [Icons](#icons)
- [SketchyBar Reference](#sketchybar-reference)

---

## Overview

The configuration lives at `~/.config/sketchybar/` and is loaded via `sketchybarrc` when SketchyBar starts. It uses a modular structure with separate files for items (bar elements), plugins (scripts), colors, and icons.

The bar is positioned at the **top** of the screen with a transparent background and a colored border, using the **SF Pro** font family throughout.

---

## File Structure

```
~/.config/sketchybar/
├── sketchybarrc          # Main config entry point
├── colors.sh             # Color palette (Catppuccin-based)
├── icons.sh              # SF Symbol icon definitions
├── items/                # Item definitions (bar elements)
│   ├── apple.sh          # Apple logo menu (left)
│   ├── spaces.sh         # Mission Control spaces (left)
│   ├── front_app.sh      # Active application name (left)
│   ├── spotify.sh        # Spotify now-playing widget (center)
│   ├── battery.sh        # Battery indicator (right)
│   ├── layout.sh         # Layout indicator (right)
│   ├── calendar.sh       # Date/time display (right)
│   ├── weather.sh        # Weather widget (right)
│   ├── brew.sh           # Homebrew updates (disabled)
│   ├── github.sh         # GitHub notifications (disabled)
│   ├── volume.sh         # Volume control (disabled)
│   ├── cpu.sh            # CPU usage (disabled)
│   └── netstat.sh        # Network stats (disabled)
├── plugins/              # Scripts executed by items
│   ├── spotify.sh        # Spotify playback state & controls
│   ├── battery.sh        # Battery level & charging state
│   ├── calendar.sh       # Date/time formatting
│   ├── weather.sh        # Weather data fetching
│   ├── space.sh          # Space change handling
│   ├── yabai.sh          # Yabai WM integration
│   ├── volume.sh         # Volume level handling
│   ├── icon_map.sh       # App-to-icon mapping
│   ├── brew.sh           # Homebrew update check
│   ├── github.sh         # GitHub API polling
│   ├── keyboard.sh       # Keyboard layout
│   ├── zen.sh            # Zen mode toggle
│   └── volume_click.sh   # Volume click handler
└── helper/               # Compiled helper binary (C/Lua)
```

---

## Bar Configuration

Defined in `sketchybarrc`. The bar uses a transparent background with a visible border.

| Property | Value | Description |
|----------|-------|-------------|
| `height` | `45` | Bar height in pixels |
| `color` | `0x00000000` | Fully transparent background |
| `border_width` | `2` | Border thickness |
| `border_color` | `$BAR_COLOUR` | Border color from palette |
| `shadow` | `off` | No drop shadow |
| `position` | `top` | Anchored to top of screen |
| `sticky` | `on` | Persists across space changes |
| `padding_right` | `10` | Right padding |
| `padding_left` | `10` | Left padding |
| `y_offset` | `-5` | Slightly above default position |
| `margin` | `-2` | Slight negative margin |

**Reference:** All available bar properties can be found at [Bar Config](https://felixkratz.github.io/SketchyBar/config/bar).

---

## Default Item Properties

Applied to all items unless overridden. Defined in `sketchybarrc`.

| Property | Value | Description |
|----------|-------|-------------|
| `updates` | `when_shown` | Scripts run only when item is visible |
| `icon.font` | `SF Pro:Bold:14.0` | Icon font |
| `icon.color` | `$ICON_COLOR` (white) | Icon color |
| `icon.padding_left/right` | `3` | Icon padding |
| `label.font` | `SF Pro:Semibold:13.0` | Label font |
| `label.color` | `$LABEL_COLOR` (white) | Label color |
| `label.padding_left/right` | `3` | Label padding |
| `background.height` | `26` | Background pill height |
| `background.corner_radius` | `9` | Rounded corners |
| `background.border_width` | `2` | Background border |
| `popup.background.border_width` | `2` | Popup border |
| `popup.background.corner_radius` | `9` | Popup rounded corners |
| `popup.blur_radius` | `20` | Popup background blur |

---

## Items

### Left Side

#### Apple Menu (`items/apple.sh`)
Apple logo button, typically with a click action for system menu.

#### Spaces (`items/spaces.sh`)
Mission Control space indicators. Uses the `space` component type which provides `$SELECTED`, `$SID`, and `$DID` environment variables.

#### Front App (`items/front_app.sh`)
Displays the currently focused application name. Subscribes to `front_app_switched`.

### Center

#### Spotify (`items/spotify.sh`)
A comprehensive Spotify now-playing widget with popup controls.

**Architecture:**
- `spotify.anchor` — Main bar item (center), displays the album cover art. Starts hidden (`drawing=off`), shown when Spotify is playing.
- `spotify.cover` — Album art in the popup (downloaded to `/tmp/cover.jpg`)
- `spotify.title` — Track name
- `spotify.artist` — Artist name
- `spotify.album` — Album name
- `spotify.state` — Slider component showing playback progress with timestamps

**Optional Controls** (enabled via `SPOTIFY_DISPLAY_CONTROLS=true`):
- `spotify.shuffle` — Toggle shuffle
- `spotify.back` — Previous track
- `spotify.play` — Play/pause
- `spotify.next` — Next track
- `spotify.repeat` — Toggle repeat
- `spotify.controls` — Bracket grouping the controls with a background

**Events:**
- `spotify_change` — Custom event mapped to `com.spotify.client.PlaybackStateChanged`
- `spotify_init` — Triggered at startup to initialize state
- `mouse.entered/exited` — Show/hide popup on hover

### Right Side

#### Battery (`items/battery.sh`)
Battery level indicator with charging state.

#### Layout (`items/layout.sh`)
Window manager layout indicator.

#### Calendar (`items/calendar.sh`)
Date and time display.

#### Weather (`items/weather.sh`)
Weather information widget. Location is auto-detected via IP geolocation. Displays only the weather condition icon and temperature (no city name). Aligned vertically with `y_offset=2` to match adjacent items.

---

## Plugins

Plugins are shell scripts executed in response to events. They receive environment variables:

| Variable | Description |
|----------|-------------|
| `$NAME` | The item that triggered the script |
| `$SENDER` | The event name (e.g., `mouse.clicked`, `routine`, `forced`) |
| `$INFO` | Event-specific data |
| `$BUTTON` | Mouse button for click events |
| `$MODIFIER` | Modifier keys for click events |
| `$SCROLL_DELTA` | Scroll amount for scroll events |
| `$PERCENTAGE` | Click position for slider components |

### Spotify Plugin (`plugins/spotify.sh`)

Handles all Spotify interactions via AppleScript (`osascript`).

**Functions:**
- `update()` — Fetches current track info from Spotify, downloads cover art, updates all labels
- `scroll()` — Updates the progress slider and timestamps (runs every 1 second via `update_freq`)
- `scrubbing()` — Seeks to position when slider is clicked
- `play/next/back()` — Playback controls
- `shuffle_toggle/repeat_toggle()` — Toggle shuffle/repeat states
- `truncate_text()` — Truncates long text with ellipsis

**Event Routing:**
```
SENDER=mouse.clicked  → routes by $NAME to control functions
SENDER=mouse.entered  → shows popup + updates track info
SENDER=mouse.exited   → hides popup
SENDER=routine        → scroll() for state slider, update() for others
SENDER=forced         → runs update
SENDER=*              → update (catches spotify_change, spotify_init, etc.)
```

---

## Color Palette

Catppuccin Macchiato-inspired theme defined in `colors.sh`. Format: `0xAARRGGBB` (alpha, red, green, blue).

| Name | Hex | Usage |
|------|-----|-------|
| `BLACK` | `0xff181926` | Shadow color |
| `WHITE` | `0xffcad3f5` | Icons, labels, popup borders |
| `RED` | `0xffed8796` | — |
| `GREEN` | `0xffa6da95` | — |
| `BLUE` | `0xff8aadf4` | — |
| `YELLOW` | `0xffeed49f` | — |
| `ORANGE` | `0xfff5a97f` | — |
| `MAGENTA` | `0xffc6a0f6` | — |
| `GREY` | `0xff939ab7` | — |
| `TRANSPARENT` | `0x00000000` | — |
| `BAR_COLOR` | `0xff1e1e2e` | Bar background |
| `BAR_BORDER_COLOR` | `0xff494d64` | Bar border |
| `BACKGROUND_1` | `0x603c3e4f` | Semi-transparent bg |
| `BACKGROUND_2` | `0x60494d64` | Semi-transparent bg |
| `POPUP_BACKGROUND_COLOR` | `0xff1e1e2e` | Popup fill |
| `POPUP_BORDER_COLOR` | `$WHITE` | Popup border |

---

## Icons

Defined in `icons.sh` using **SF Symbols**. Install with: `brew install --cask sf-symbols`.

**Categories:**
- **General:** Loading, Apple, Preferences, Activity, Lock, Bell
- **Git:** Issue, Discussion, Pull Request, Commit, Indicator
- **Spotify:** Back, Play/Pause, Next, Shuffle, Repeat
- **Yabai:** Stack, Fullscreen Zoom, Parent Zoom, Float, Grid
- **Battery:** 100%, 75%, 50%, 25%, 0%, Charging
- **Volume:** 100%, 66%, 33%, 10%, Mute

---

## SketchyBar Reference

### Adding Items
```bash
sketchybar --add item <name> <position>    # position: left, right, center, q, e
sketchybar --add space <name> <position>    # Mission Control space component
sketchybar --add graph <name> <position> <width>  # Line graph component
sketchybar --add slider <name> <position> <width> # Draggable slider
sketchybar --add bracket <name> <member> ... <member>  # Group background
sketchybar --add alias <app_name> <position>  # Mirror macOS menu bar item
```

### Setting Properties
```bash
sketchybar --set <name> <property>=<value> ...
sketchybar --default <property>=<value> ...    # Set defaults for new items
```

### Events
```bash
sketchybar --add event <name> [NSDistributedNotificationName]  # Custom event
sketchybar --subscribe <name> <event> ...                       # Subscribe
sketchybar --trigger <event> [envvar=value ...]                 # Trigger
sketchybar --update                                             # Force all scripts
```

### Built-in Events
`front_app_switched`, `space_change`, `space_windows_change`, `display_change`, `volume_change`, `brightness_change`, `power_source_change`, `wifi_change`, `media_change`, `system_will_sleep`, `system_woke`, `mouse.entered`, `mouse.exited`, `mouse.clicked`, `mouse.scrolled`, `mouse.entered.global`, `mouse.exited.global`

### Item Management
```bash
sketchybar --reorder <name> ... <name>
sketchybar --move <name> before|after <reference>
sketchybar --clone <parent> <name> [before|after]
sketchybar --rename <old> <new>
sketchybar --remove <name>
```

### Querying
```bash
sketchybar --query <name>                  # Query item properties
sketchybar --query bar                     # Query bar properties
sketchybar --query default_menu_items      # List available aliases
```

### Tips
- **Batch commands** with `\` continuations to reduce IPC overhead
- **Use bash arrays** for cleaner property definitions
- Set `updates=when_shown` for items that don't need constant updates
- Use `mach_helper` for performance-critical items
- Color format is always `0xAARRGGBB`
- Debug by running `sketchybar` from terminal for verbose output

For full documentation, visit: https://felixkratz.github.io/SketchyBar/
