# Mac Mini Setup

Current state of the Mac mini that replaced the Windows desktop (ASUS PRIME H310M-A).
The migration is done and verified. This file records how the machine is set up and what's
still open. Superseded planning docs are in git history.

Rebuild from scratch: run [`setup-mac.sh`](setup-mac.sh), then work through
[Configuration](#configuration).

## Machine
- Mac mini **Apple M6** (Mac18,5): 12-core CPU (2 Super, 4 Performance, 6 Efficiency), 12-core
  GPU, 24GB RAM, 512GB SSD, macOS 27.
- The original base M4 order (#W1640840367, placed 2026-07-29) arrived the day the M6 was
  announced. It went back unopened and was replaced with this M6.
- AppleCare: not purchased (see [Open items](#open-items)).

## Desk hardware
- **Anker 7-port powered hub** on one Mac mini port. It hosts: Focusrite Scarlett 8i6
  (3rd Gen), Elgato Stream Deck+, Logitech HD Pro Webcam C920, Fifine USB mic, MIDI
  Captain footswitch, Kemper Profiler (real USB audio + MIDI, not just analog through the
  8i6), Logitech Unifying receiver, and the KVM's keyboard/mouse uplink.
- **Apple Magic Keyboard with Touch ID** plugs directly into the mini.
- **KVM:** NAWEN KC-KVM202AS-NA (2 computers, 2 heads, HDMI 2.0). It's shared with the work
  M1 MacBook Pro. Only one head is in use.
- **UPS:** CyberPower CP1000AVRLCD. It's monitored by the Synology NAS and Home Assistant,
  so no UPS software is installed on the Mac.

## Display
- **Dell S3425DW** only (34", 3440×1440, VA, 1800R curve, 120Hz panel). The two LG monitors
  are out of the daily setup.
- **Mac mini → HDMI through the KVM at 100Hz max.** 3440×1440@120 needs ~19 Gbps, which is
  more than the KVM's HDMI 2.0 ceiling (~18 Gbps). To get 120Hz, plug straight into one of
  the Dell's HDMI 2.1 inputs.
- **MacBook Pro → the Dell's USB-C input.** One cable carries video, audio (the Dell's
  speakers, used for calls) and 65W charging.

## Audio
- Mac audio goes out through the **Scarlett 8i6**. The Mackie Big Knob is retired.
- **Focusrite Control (the original app, not Focusrite Control 2).** The custom Stream Deck
  dial plugin connects to this app's FC1 socket.
- Custom mix and routing: [`focusrite-custom-mix.ff`](focusrite-custom-mix.ff) (exported
  2026-08-14). Import it in Focusrite Control.

## Storage & NAS
- **Synology DS124** (`HomeNAS.local`, 1TB WD Red) holds the canonical Pictures, Videos,
  Music and Taxes. The Mac uses the NAS paths and doesn't keep local copies.
- **SMB share `smb://HomeNAS.local/Share`** mounts at `/Volumes/Share`.
- **System sleep is disabled** (`sudo pmset -a sleep 0`, set 2026-09-26). Idle sleep was
  dropping the SMB mount overnight. The display still sleeps after 10 minutes.
- Backup: Google Drive.
- The `Mac Migration` folder on the NAS was only used to stage the move (Rig Manager
  backup, Stream Deck icons, Cura config).

## Software
Everything installable by script is in [`setup-mac.sh`](setup-mac.sh).

| Source | Installed |
|---|---|
| Homebrew formulae | git, gh, uv (manages Python; no separate `python`), node, mas, bash |
| Homebrew casks | VS Code, Google Drive, VeraCrypt (`veracrypt-fuse-t`), Focusrite Control, Elgato Stream Deck, UltiMaker Cura, Rectangle, AltTab, iTerm2, Ghostty, Proton VPN, Spotify, Signal, Zoom, OBS, RustDesk, Logi Options+ |
| Mac App Store | Anytune (722444976), Home Assistant (1099568401), Folders (1593644229), plus Apple's GarageBand, iMovie, Keynote, Numbers and Pages |
| Manual | Bome MIDI Translator Pro (licensed), Kemper driver + Rig Manager, Reolink Client, Rectangle Pro, Claude, Google Chrome |

Install notes:
- **VeraCrypt:** use the `veracrypt-fuse-t` cask, not `veracrypt`. Plain VeraCrypt needs
  macFUSE, which requires approving a kernel extension on Apple Silicon.
- **Chrome - Personal / Chrome - Work** in Applications are Chrome profile shortcuts, not
  separate installs.
- **Login items:** Claude, Bome MIDI Translator Pro, Rectangle Pro.
- Not needed on the Mac: WSL/Hyper-V, Visual Studio, VirtualBox, Steam, CyberPower
  PowerPanel, X-Touch config, Focusrite Midi Control, Power Mixer.

## Configuration

### Stream Deck+
- **Focusrite dial plugin**: [dsb012/streamdeck-focusrite](https://github.com/dsb012/streamdeck-focusrite)
  (private). Package it by following the repo's `ARCHITECTURE.md`.
- **"Midi" plugin** (`se.trevligaspel.midi.sdPlugin`, Trevliga Spel, from the Elgato
  Marketplace; already owned). It needs **IAC Driver** ports. In Audio MIDI Setup → MIDI
  Studio → IAC Driver, create these 6 ports and leave the Device Name blank:
  `StreamDeck2Daw` / `Daw2StreamDeck`, `StreamDeck2DawTrack` / `DawTrack2StreamDeck`,
  `Mackie2Daw` / `Daw2Mackie`.
  [Setup docs](https://trevligaspel.se/streamdeck/midi/index.php/miscellaneous/virtual-midi-ports-mac).
- Button icons (album art, guitar icons) come from `Mac Migration/Stream Deck/` on the NAS.

### MIDI routing — Bome MIDI Translator Pro
- Routes were rebuilt by hand on the Mac. The Windows config didn't map to macOS port
  names.
- Bome handles general routing, and the Stream Deck Midi plugin uses the IAC ports above.
  Both run side by side.

### Kemper
- Rig Manager library restored with **Tools → Restore Rig Manager Content** from
  `Mac Migration/2026-08-18 16-09-47 - David.rmbackup`. That's Kemper's supported
  cross-platform method; don't copy the library folder instead.

### Cura 5.13
- Windows settings were copied into `~/Library/Application Support/cura/5.13` on
  2026-09-23: the Neptune 3 Pro printer, 8 custom profiles, 6 custom materials and
  `cura.cfg`.
- Don't copy `cache/`, logs, `cura.lock`, `plugins/`, `packages.json` or
  `plugins.json` from Windows. Reinstall plugins from the Marketplace instead.
- If copying the folder fails, the fallback is Preferences → Profiles → Export/Import.
  That only moves quality profiles.

### Anytune
- Per-song pitch offsets from Chronotron are in
  [`chronotron-pitch-extraction/`](chronotron-pitch-extraction/Chronotron%20Pitch%20Offsets.md).

## Open items
- [ ] **Windows PC fallback** stays powered until **~2026-10-24** (60 days after cutover).
      After that, decommission it:
  - [ ] Move the Samsung 970 EVO Plus (old C:) as-is into the UGREEN 40Gbps TB4/USB4
        enclosure, which is already bought. It needs a full TB4 port on the mini.
  - [ ] Decide where the 4TB WD40EFAX (old N:, the on-site NAS backup copy) goes.
  - [ ] Clean up the NAS `Mac Migration` staging folder.
- [ ] **AppleCare:** decide yes/no. The purchase window is limited, typically 60 days from
      the M6's purchase date.
- [ ] **Cura:** reinstall the Mesh Tools, Settings Guide and Start Optimiser plugins. After a
      few good prints, delete `~/Library/Application Support/cura/5.13.bak-2026-09-23`.
- [ ] **Video switching:** decide whether to keep it on the KVM (100Hz, one button) or use
      the Dell's own 3 inputs (120Hz, switch with the monitor's input button).
- [ ] **LG 29WN600-W and 24ML600M-B:** keep as spares, retire or relocate. The USB-C→HDMI
      cable that fed the 24" is spare too.
- [ ] **Rectangle and Rectangle Pro are both installed.** Only Pro launches at login, so
      remove the free one if Pro is the keeper.
