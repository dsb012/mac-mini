# Mac Utilities — candidates

Popular macOS utilities **not yet installed** on the Mac mini (checked 2026-09-26). Already installed and
not listed here: Rectangle Pro, AltTab, iTerm2, Ghostty, Folders, Logi Options+, noTunes, **IINA (installed 2026-09-26)**, **Stats (installed 2026-10-01)**.
All are free or have a free tier. Install any of them with `brew install --cask <cask>`. When one gets installed,
move it into [Mac Mini Setup.md](Mac%20Mini%20Setup.md) → Software and add it to [`setup-mac.sh`](setup-mac.sh).

## Top picks: each fixes something already hit

| App | Cask | Why |
|---|---|---|
| **Raycast** | `raycast` | A far better Spotlight: app launcher, file search, calculator, clipboard history and window snapping. The Mac equivalent of **ueli** from the Windows PC. Free core. |
| **MonitorControl** | `monitorcontrol` | Controls the **Dell S3425DW's brightness and speaker volume** from the keyboard instead of the monitor's buttons. |

## Also relevant to this setup

| App | Cask | Why |
|---|---|---|
| **BetterDisplay** | `betterdisplay` | More scaling options for the ultrawide, including sharper "HiDPI" text at 3440×1440. Text on the Dell is ~13–16% smaller than on the old LGs. Free tier; the advanced features are paid. |
| **Maccy** | `maccy` | Clipboard history, like Win+V on Windows. Lightweight. **Skip if using Raycast**, which includes one. |

## Widely used general utilities

| App | Cask | What it does |
|---|---|---|
| **Ice** | `jordanbaird-ice` | Hides and tidies menu bar icons (Bome, Stream Deck, Focusrite, noTunes, …). Free alternative to Bartender. |
| **Shottr** | `shottr` | Better screenshots: annotate, blur, scrolling capture, pixel measurement. Free, with a paid upgrade. |
| **AppCleaner** | `appcleaner` | Uninstalls an app along with its leftover settings files (dragging to the Trash leaves them). |
| **The Unarchiver** | `the-unarchiver` | Opens RAR, 7z and other archive formats macOS can't. |
| **Keka** | `keka` | Alternative to The Unarchiver that also *creates* 7z/zip archives, including password-protected ones. |
| **Hidden Bar** | `hiddenbar` | Simpler, lighter alternative to Ice for hiding menu bar icons. |
| **LinearMouse** | `linearmouse` | Mouse scroll direction and acceleration set separately from a trackpad. Logi Options+ may already cover this for the Logitech mouse. |
| **Karabiner-Elements** | `karabiner-elements` | Powerful key remapping (e.g. Windows-style shortcuts). Only worth it if a specific shortcut keeps tripping you up. |

## Pick one of each pair
- **Raycast vs Maccy:** Raycast includes clipboard history.
- **Ice vs Hidden Bar:** Ice has more features; Hidden Bar is simpler.
- **The Unarchiver vs Keka:** The Unarchiver only opens archives; Keka opens and creates them.
