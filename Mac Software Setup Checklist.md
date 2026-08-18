# Mac Mini — Software Setup Checklist

One-pager for getting the new Mac mini ready to start the migration. Full reasoning/decisions in `Mac Mini Replacement Research.md` — this is just the install list.

**Run `setup-mac.sh` (in this folder) on the mini once it arrives** — installs everything below that's available via Homebrew/Mac App Store automatically, and opens the vendor pages for the rest (Kemper driver, CyberPower, Bome). This list is the manual reference/fallback.

## 1. Foundational (install first)
- [ ] **Homebrew** — package manager, everything else CLI-side builds on this
- [ ] **VS Code** — `brew install --cask visual-studio-code`
- [ ] **Google Drive** desktop app — current backup provider (not IDrive) — `brew install --cask google-drive`
- [ ] **Google Chrome** — `brew install --cask google-chrome`
- [ ] **Anytune** — Chronotron replacement, running on the mini itself — Mac App Store, id 722444976 (`mas install 722444976`)
- [ ] **VeraCrypt** — **use the `veracrypt-fuse-t` cask**, not plain `veracrypt` (`brew install --cask veracrypt-fuse-t`). Corrected 2026-08-09: plain `veracrypt` actually depends on **macFUSE**, which needs a kernel-extension approval dance in System Settings on Apple Silicon. The `veracrypt-fuse-t` cask pulls in **fuse-t** instead and needs no kext approval — this replaces the earlier "install FUSE-T first, then VeraCrypt separately" plan with one command.

## 2. Peripheral drivers / control apps
- [ ] **Focusrite Control** — for the Scarlett 8i6 (confirmed 2026-08-14 via Windows registry that this original app, not "Focusrite Control 2", is what's actually installed and what the custom Stream Deck dial plugin's FC1 socket connects to — see `Home Projects\focusrite-streamdeck-dial\`). On Homebrew: `brew install --cask focusrite-control` (Control 2 is the separate `focusrite-control-2` cask — don't use that one)
- [ ] **Elgato Stream Deck** software — native macOS build, same MIDI plugin as Windows — `brew install --cask elgato-stream-deck`
- [ ] **Kemper macOS driver** — confirm official Core Audio driver exists/works *before* relying on it; it connects via USB (audio+MIDI), not just analog through the 8i6. Not on Homebrew — download page: kemper-amps.com/downloads
- [ ] **Logi Options+** — only if keeping the Logitech Unifying mouse; optional otherwise (Apple Magic Keyboard needs no software) — `brew install --cask logi-options+`

## 3. Verify before trusting with real use
- [ ] **CyberPower PowerPanel Personal** — install and test. UPS is a **CyberPower CP1000AVRLCD** (1000VA/600W, 9 outlets, AVR, mini-tower). Researched 2026-08-09: CyberPower's own product page for this exact model **confirms it's on the supported list for PowerPanel Personal**, and PowerPanel Personal for Mac states "supports macOS 14 and above" — but **CPU architecture (Apple Silicon vs. Intel/Rosetta) still isn't stated anywhere**, and a third-party tracker still lists it as "not yet tested." **Still call CyberPower support (1-877-297-6937, model CP1000AVRLCD) for an explicit yes/no on Apple Silicon** before trusting it for auto-shutdown. Not on Homebrew — download page: cyberpowersystems.com (see research doc for exact URL). **Fallback if it doesn't work well:** this UPS is also natively supported by **NUT (Network UPS Tools)** via the standard `usbhid-ups` driver — NUT has an Apple-Silicon-native Homebrew build (`brew install nut`), open-source, well-established, works on macOS/Linux/BSD.
- [x] **Home Assistant Companion app** — **verified 2026-08-09** via official Home Assistant docs/blog: confirms Shortcuts integration (shortcuts can send data to HA and trigger automations), Mac sensors (active/idle state, mic/camera in use, battery level+state, more), and actionable notifications with HA-side automation triggers. No install-time surprises expected. Mac App Store, id 1099568401 (`mas install 1099568401`).

## 4. MIDI routing
- [ ] **Bome MIDI Translator Pro** (native Mac build) — **decided 2026-08-09: staying with Bome Pro**, not switching to macOS's built-in Audio MIDI Setup + IAC Driver. David's used to it, already has it licensed, and it works well. Not on Homebrew (licensed software) — download/login page: bome.com/downloads

## 5. Install when you get to it
- [ ] **Cura** — 3D printing slicer, transfers cleanly — `brew install --cask ultimaker-cura`

## Explicitly skip
- **WSL/Hyper-V, Visual Studio, VirtualBox, Steam** — all confirmed not needed for this workflow

## Hardware note
Anker 7-port hub covers all standard-USB peripherals (webcam, mic, footswitch, Stream Deck, UPS) off one port — no dock-specific drivers needed. External storage (970 EVO Plus in the 40Gbps enclosure) is plug-and-play, no software required.
