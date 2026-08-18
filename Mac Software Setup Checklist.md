# Mac Mini — Software Setup Checklist

One-pager for getting the new Mac mini ready to start the migration. Full reasoning/decisions in `Mac Mini Replacement Research.md` — this is just the install list.

**Run `setup-mac.sh` (in this folder) on the mini once it arrives** — installs everything below that's available via Homebrew/Mac App Store automatically, and opens the vendor pages for the rest (Kemper driver, CyberPower, Bome). This list is the manual reference/fallback.

## 1. Foundational (install first)

| Done | Software | Source | Notes |
|---|---|---|---|
| [ ] | Homebrew | curl installer | package manager — everything else CLI-side builds on this |
| [ ] | git | brew formula — `brew install git` | |
| [ ] | uv | brew formula — `brew install uv` | Python version/venv/package manager. Relying on uv alone, no separate `python` formula — uv installs and manages whatever Python versions are actually needed. |
| [ ] | VS Code | brew cask — `brew install --cask visual-studio-code` | |
| [ ] | Google Drive | brew cask — `brew install --cask google-drive` | current backup provider (not IDrive) |
| [ ] | Google Chrome | brew cask — `brew install --cask google-chrome` | |
| [ ] | Anytune | Mac App Store, id 722444976 — `mas install 722444976` | Chronotron replacement, running on the mini itself |
| [ ] | VeraCrypt | brew cask — `brew install --cask veracrypt-fuse-t` | **Use the `veracrypt-fuse-t` cask, not plain `veracrypt`.** Corrected 2026-08-09: plain `veracrypt` depends on macFUSE, which needs a kernel-extension approval dance on Apple Silicon. The fuse-t cask pulls in fuse-t instead and needs no kext approval. |
| [ ] | Cura | brew cask — `brew install --cask ultimaker-cura` | 3D printing slicer, transfers cleanly — **install right away**, not deferred |

## General utilities (added 2026-08-19)

| Done | Software | Source | Notes |
|---|---|---|---|
| [ ] | Rectangle | brew cask — `brew install --cask rectangle` | window management/snapping |
| [ ] | AltTab | brew cask — `brew install --cask alt-tab` | Windows-style app switcher |
| [ ] | iTerm2 | brew cask — `brew install --cask iterm2` | terminal |
| [ ] | Ghostty | brew cask — `brew install --cask ghostty` | terminal |
| [ ] | Proton VPN | brew cask — `brew install --cask protonvpn` | sign in with existing account |
| [ ] | Spotify | brew cask — `brew install --cask spotify` | |
| [ ] | Reolink Client | manual — [reolink.com/us/software-and-manual](https://reolink.com/us/software-and-manual/) | not on Homebrew (official recommended method). May also be on the Mac App Store (id 1086871235) — unconfirmed for the US storefront, worth checking `mas search reolink` first. |
| [ ] | Claude | brew cask — `brew install --cask claude` | native desktop app |
| [ ] | Signal | brew cask — `brew install --cask signal` | |
| [ ] | Zoom | brew cask — `brew install --cask zoom` | |

## 2. Peripheral drivers / control apps

| Done | Software | Source | Notes |
|---|---|---|---|
| [ ] | Focusrite Control | brew cask — `brew install --cask focusrite-control` | For the Scarlett 8i6. **Not `focusrite-control-2`** — confirmed 2026-08-14 via the Windows registry that this original app is what's actually installed and what the custom Stream Deck dial plugin's FC1 socket connects to (see `Home Projects\focusrite-streamdeck-dial\`). |
| [ ] | Elgato Stream Deck | brew cask — `brew install --cask elgato-stream-deck` | native macOS build |
| [ ] | Kemper macOS driver | manual — [kemper-amps.com/downloads](https://www.kemper-amps.com/downloads) | Confirm the official Core Audio driver exists/works *before* relying on it; connects via USB (audio+MIDI), not just analog through the 8i6. Not on Homebrew. |
| [ ] | Kemper Rig Manager | manual — [kemper-amps.com/downloads](https://www.kemper-amps.com/downloads) | Desktop app, separate from the driver — install, then restore the rig library (see "Kemper Rig Manager backup/restore" below) |
| [ ] | Logi Options+ | brew cask — `brew install --cask logi-options+` | only if keeping the Logitech Unifying mouse; optional otherwise (Apple Magic Keyboard needs no software) |
| [ ] | Stream Deck "Midi" plugin | manual — Elgato Marketplace, search "Midi" | `se.trevligaspel.midi.sdPlugin`, maker Trevliga Spel. Went from free to paid 2026-03-03 — already owned, confirm it activates under David's account without a repurchase prompt. Full setup detail below. |

**Stream Deck "Midi" plugin setup:** sends CC/NRPN/Program Change/Note/SysEx/Mackie Control from Stream Deck buttons/dials. macOS setup differs from Windows (Windows uses loopMIDI; Mac doesn't need third-party software): open **Audio MIDI Setup → MIDI Studio**, ports must be created under the **IAC Driver** device (a new/external virtual device won't be seen by the plugin). Recommended 6 ports: `StreamDeck2Daw`/`Daw2StreamDeck` (remote control), `StreamDeck2DawTrack`/`DawTrack2StreamDeck` (note/program change), `Mackie2Daw`/`Daw2Mackie` (Mackie Control). Leave MIDI Studio's Device Name field blank for default port naming. David already did this setup once on the MacBook Pro during testing — replicate the same port names there. Docs: [Installation/Logging](https://trevligaspel.se/streamdeck/midi/index.php/miscellaneous/installation-logging), [Virtual MIDI ports, Mac](https://trevligaspel.se/streamdeck/midi/index.php/miscellaneous/virtual-midi-ports-mac).

## 3. Verify before trusting with real use

| Done | Software | Source | Notes |
|---|---|---|---|
| [x] | Home Assistant Companion app | Mac App Store, id 1099568401 — `mas install 1099568401` | **Verified 2026-08-09** via official Home Assistant docs/blog: confirms Shortcuts integration, Mac sensors (active/idle, mic/camera in use, battery level+state), and actionable notifications with HA-side automation triggers. No install-time surprises expected. |

~~**CyberPower PowerPanel Personal**~~ — **dropped 2026-08-19**: UPS (CP1000AVRLCD) is monitored via the Synology DS124 NAS + Home Assistant instead. No Mac-side app, no Apple Silicon question, no support call needed.

## 4. MIDI routing

| Done | Software | Source | Notes |
|---|---|---|---|
| [ ] | Bome MIDI Translator Pro | manual — [bome.com/downloads](https://www.bome.com/downloads) | Native Mac build. **Decided 2026-08-09: staying with Bome Pro**, not switching to macOS's built-in Audio MIDI Setup + IAC Driver — David's used to it, already licensed, works well. Licensed software, not on Homebrew. |

- **Routing config: rebuild manually, don't export/import** (decided 2026-08-18) — the existing Windows routing config won't map cleanly to macOS (different device/port naming), so re-create the routes by hand on the Mac rather than trying to migrate the config file. Budget actual time for this in the migration runbook, not just an install-and-go step.
- **Note:** even though Bome (not IAC Driver) is the general MIDI routing choice, the Stream Deck "Midi" plugin above still specifically requires **IAC Driver** ports — that's a plugin-level requirement, not a routing-philosophy conflict. Both coexist fine.

## Kemper Rig Manager backup/restore
Confirmed via [Kemper forum](https://forum.kemper-amps.com/forum/thread/40662-how-to-transfer-rm-library-to-new-computer/) — this is the supported, cross-platform-safe method (don't just copy the library folder):
- [x] **On this PC:** Rig Manager → **Tools → Backup Rig Manager Content** — **done 2026-08-19**, fresh backup at `Z:\Mac Migration\2026-08-18 16-09-47 - David.rmbackup` (5.08MB). Supersedes the stale 2025-12-14 one still sitting in `Guitar\Current Guitar\` (that older one can be ignored/cleaned up later).
- [x] **Move that backup file to the Mac** — already staged on `Z:\Mac Migration`, just needs pulling down once Rig Manager is installed on the mini
- [ ] **On the Mac mini:** install Rig Manager, then **Tools → Restore Rig Manager Content**, point it at the backup file
- Cross-platform compatible (Mac↔PC) per Kemper's own docs — this is the intended migration path, not a workaround

## Explicitly skip
- **WSL/Hyper-V, Visual Studio, VirtualBox, Steam** — all confirmed not needed for this workflow

## Hardware note
Anker 7-port hub covers all standard-USB peripherals (webcam, mic, footswitch, Stream Deck, UPS) off one port — no dock-specific drivers needed. External storage (970 EVO Plus in the 40Gbps enclosure) is plug-and-play, no software required.
