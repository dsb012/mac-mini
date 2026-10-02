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
- **Anker 7-port powered hub** on a back port of the mini. It hosts: Focusrite Scarlett 8i6
  (3rd Gen), Elgato Stream Deck+, MIDI Captain footswitch and Kemper Profiler (real USB audio +
  MIDI, not just analog through the 8i6).
- **KVM USB uplink → a back port of the mini**, via a **USB-A to USB-A cable + USB-A (female) →
  USB-C (male) adapter**. Behind the KVM, so they follow the selected computer: **Magic Keyboard**,
  **Logitech Unifying receiver**, **Logitech C920 webcam** and **Fifine mic**. The KVM shows up as a
  Genesys `USB2.1 Hub` (0x05e3/0x0610).
  - ⚠️ **Don't replace the cable + adapter with a single USB-A → USB-C cable.** The back ports won't
    detect the KVM. See [Why the KVM needs the adapter](#why-the-kvm-needs-the-adapter-not-a-single-cable).
  - **If the KVM stops appearing on the mini** (camera, mic, keyboard all gone at once): reseat the
    adapter and cable first. On 2026-10-02 it vanished with this same cable + adapter on the back port, and
    after testing other cables and ports, reconnecting the A-to-A + adapter on the back port worked again.
    The likely cause is a loose connection. Quick check: `ioreg -p IOUSB | grep "USB2.1 Hub"`.
- **Apple Magic Keyboard with Touch ID**: **wired only, never Bluetooth** (decided 2026-10-02).
  Bluetooth is off on the mini. Plugging the keyboard into a Mac pairs it with that Mac automatically,
  so through the KVM it can stay connected over Bluetooth to the last Mac it was plugged into. Keep the
  keyboard's own power switch off, which should disable only its Bluetooth (check that it still types
  over the cable), and/or remove it from the MacBook's Bluetooth list. Touch ID doesn't work through the KVM.
- **KVM:** NAWEN KC-KVM202AS-NA (2 computers, 2 heads, HDMI 2.0). It's shared with the work
  M1 MacBook Pro. Only one head is in use.
- **UPS:** CyberPower CP1000AVRLCD. It's monitored by the Synology NAS and Home Assistant,
  so no UPS software is installed on the Mac.

### Why the KVM needs the adapter, not a single cable
Found 2026-10-02. **Working:** KVM → USB-A to USB-A cable → USB-A (female) to USB-C (male) adapter → mini.
**Not working on the back ports:** KVM → one USB-A to USB-C cable → mini.

The KVM's computer-side USB port is a USB-A socket, so the USB-C end must be at the mini. That's fine,
but **which way round the USB-C part is built matters**:

- **USB-C ports decide what's attached using a resistor in the plug** (on the CC pin), before any
  USB data flows. One value means "a device is here, power it and talk to it". Another means "the far
  end is a host/charger supplying power".
- **A USB-A to USB-C cable** is designed for the USB-A end to be in a computer and the USB-C end in a
  device (a phone, say). So its USB-C plug carries the **"far end is a host"** resistor. Plugged into
  the mini, it tells the mini "another computer is here", which is backwards for this setup.
- **A USB-A (female) to USB-C (male) adapter** (the "OTG" type) is designed to sit in a computer's
  USB-C port with a USB device plugged into it. Its USB-C plug carries the **"a device is here"** resistor.
  That's exactly what the mini needs to see, so it powers the KVM and connects.

**Why the port matters:** the mini's back ports are **Thunderbolt**, and they follow the resistor
strictly. They read the single cable as "another host", and the port reports *No device connected*.
Nothing appears at all, not even a failed connection. The **front ports** sit behind the mini's built-in
USB hub chip and connected the single cable anyway. That front/back difference was observed in testing.
The exact reason is a best guess.

**If replacing parts:** keep the A-to-A cable plus OTG-type adapter, or any USB-C (male) to USB-A
(female) adapter that's sold for connecting USB devices to a Mac, iPad or phone. Don't use a cable sold
as "USB-A to USB-C" for charging or connecting phones.

## Display
- **Dell S3425DW** only (34", 3440×1440, VA, 1800R curve, 120Hz panel). The 24" LG moved to
  the office; the 29" LG is out of the daily setup.
- **Video switching stays on the KVM** (decided 2026-09-26, working well).
- ⚠️ **Known issue — black screen after display sleep / KVM switch** (HDMI-CEC through the KVM). **Don't
  power the Dell off at night**; let the mini sleep it. Details, log evidence and next fixes:
  [Display Black Screen Issue.md](Display%20Black%20Screen%20Issue.md).
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
- ⚠️ **Known issue: "No hardware" after the 8i6 is power-cycled or unplugged.** Sound keeps working, since Core Audio
  reconnects, but Focusrite Control's helper (`FocusriteControlServer`, a **root** system service) doesn't
  re-attach. Fix: run `sudo launchctl kickstart -k system/com.focusrite.ControlServer`, then reopen Focusrite
  Control. The Stream Deck dial plugin reconnects on its own. (Seen 2026-10-01, and at least once before.)

## Storage & NAS
- **Synology DS124** (`HomeNAS.local`, 1TB WD Red) holds the canonical Pictures, Videos,
  Music and Taxes. The Mac uses the NAS paths and doesn't keep local copies.
- **SMB share `smb://HomeNAS.local/Share`** mounts at `/Volumes/Share`.
- **System sleep is disabled** (`sudo pmset -a sleep 0`, set 2026-09-26). Idle sleep was
  dropping the SMB mount overnight. The display still sleeps after 10 minutes.
- The `Mac Migration` folder on the NAS was only used to stage the move (Rig Manager
  backup, Stream Deck icons, Cura config).

## Software
Everything installable by script is in [`setup-mac.sh`](setup-mac.sh).

| Source | Installed |
|---|---|
| Homebrew formulae | git, gh, uv (manages Python; no separate `python`), node, mas, bash |
| Homebrew casks | VS Code, VeraCrypt (`veracrypt-fuse-t`), Focusrite Control, Elgato Stream Deck, UltiMaker Cura, AltTab, iTerm2, Ghostty, Proton VPN, Spotify, noTunes, Signal, Zoom, OBS, IINA, Stats, RustDesk, Logi Options+ |
| Mac App Store | Anytune (722444976), Home Assistant (1099568401), Folders (1593644229), plus Apple's GarageBand, iMovie, Keynote, Numbers and Pages |
| Manual | Bome MIDI Translator Pro (licensed), Kemper driver + Rig Manager, Reolink Client, Rectangle Pro (purchased license), Claude, Google Chrome |

Install notes:
- **VeraCrypt:** use the `veracrypt-fuse-t` cask, not `veracrypt`. Plain VeraCrypt needs
  macFUSE, which requires approving a kernel extension on Apple Silicon.
- **Chrome - Personal / Chrome - Work** in Applications are Chrome profile shortcuts, not
  separate installs.
- **Login items:** Claude, Bome MIDI Translator Pro, Rectangle Pro, noTunes.
- **IINA:** video player for the OBS guitar recordings — can switch between the Kemper and Anytune
  audio tracks (**Audio → Audio Track** menu), which QuickTime can't.
- **noTunes:** stops Apple Music launching on the play key or when headphones/Bluetooth connect,
  and opens **Spotify** instead: `defaults write digital.twisted.noTunes replacement /Applications/Spotify.app`.
  Runs as a login item (hidden). `setup-mac.sh` sets both up.
- Not needed on the Mac: WSL/Hyper-V, Visual Studio, VirtualBox, Steam, CyberPower
  PowerPanel, X-Touch config, Focusrite Midi Control, Power Mixer.

## Configuration

### Desktops (Spaces)
- **Two desktops.** Desktop 1 is everyday work. **Desktop 2 is guitar**: **Anytune** and **Kemper Rig Manager**
  are assigned to it (Dock → Options → Assign To → This Desktop). Each desktop has its own wallpaper.
- **"Automatically rearrange Spaces based on most recent use": off** (Desktop & Dock → Mission Control), so the
  desktop numbers stay fixed.
- **Control + 1 / Control + 2** jump to a desktop. macOS only offers these once the desktops exist; they were
  turned on with `defaults write com.apple.symbolichotkeys` (keys 118/119) and can be checked under Keyboard →
  Keyboard Shortcuts → Mission Control. Control + Left/Right also works.
- **Rectangle Pro "Guitar" layout:** Anytune on top (1659×524) and Rig Manager below it (1658×814), in the left
  half of the ultrawide; the right half is free. It launches the apps if they aren't running. Shortcut
  **Command + Shift + G** — ⚠️ that clashes with "Go to Folder" (Finder, Open/Save dialogs) and "Find Previous"
  (browsers, VS Code). Consider Control + Option + Command + G. A leftover "Layout 1" also exists. Stored in
  `defaults read com.knollsoft.Hookshot appSpecs`.
- **Rectangle Pro can only arrange the desktop you're on** (no public macOS API for other Spaces). To combine,
  jump to the desktop first, then apply the layout. A Stream Deck Multi Action can do both in one press.

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
- [ ] **Backups: the Mac currently has none** (Google Drive removed 2026-09-26). Set up Time
      Machine. Recommended target: the 970 EVO in the UGREEN enclosure, attached directly,
      once it's out of the Windows PC. The NAS isn't a good target: 122GB free vs ~150–200GB
      needed for the Mac's 97GB of data.
- [ ] **AppleCare:** decide yes/no. The purchase window is limited, typically 60 days from
      the M6's purchase date.
- [ ] **Cura:** reinstall the Mesh Tools, Settings Guide and Start Optimiser plugins. After a
      few good prints, delete `~/Library/Application Support/cura/5.13.bak-2026-09-23`.
- [ ] **LG 29WN600-W:** keep as a spare, retire or relocate. (The 24" LG 24ML600M-B went
      to the office. The USB-C→HDMI cable that fed it is spare.)
