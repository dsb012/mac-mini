# Mac Mini Migration Runbook

Sequenced, day-by-day version of everything in `Mac Mini Replacement Research.md`
and `Mac Software Setup Checklist.md` — this is the doc to actually follow on the
day. Those two remain the reference/reasoning; this is the checklist you work
through in order.

**Arrival: Tuesday, Aug 25, 2026.**

## This week (now → Mon Aug 24)

- [ ] **AppleCare** — decide yes/no (only real open decision left)
- [ ] Finish copying anything still pending into `Z:\Mac Migration` (staging folder on the NAS)
- [ ] If anything about the rig/mixes changes before Tuesday, redo the Rig Manager
      backup and/or re-export `focusrite-custom-mix.ff` — the ones currently staged
      are dated 2026-08-18 and 2026-08-14 respectively; don't let them go stale
- [ ] Old PC decommission timing — decide how long to keep the Windows PC powered
      as a fallback after cutover (suggest: don't decommission until everything in
      the "Verification" section below passes)

## Day of arrival — Tue Aug 25

1. **Unbox.** Don't touch the Windows PC yet — keep it live as fallback until
   migration is verified end-to-end.
2. **Physical display hookup:**
   - LG 29WN600-W (ultrawide) → mini's native HDMI port, straight cable
   - LG 24ML600M-B → active-chip USB-C-to-HDMI cable, from a rear Thunderbolt port
   - Both into the KVM's existing 2 HDMI inputs
3. **macOS initial setup** — Apple ID, Wi-Fi/Ethernet, Touch ID enrollment for the
   Magic Keyboard.
4. **KVM/display check** — confirm both legs hold native 2560×1080, no fuzzy
   text or refresh-rate cap. If a 50Hz-style cap shows up, swap in a Pluggable
   active-chipset adapter (same fix that worked on the MacBook Pro leg of this
   same KVM).
5. **Connect the Anker 7-port hub** to a mini USB port. Verify each peripheral
   enumerates: Focusrite Scarlett 8i6, Elgato Stream Deck+, Logitech HD Pro
   Webcam C920, MIDI Captain footswitch, CyberPower UPS, Kemper Profiler.
6. **Run `setup-mac.sh`** (this folder) — installs Homebrew + all casks/MAS apps,
   opens vendor pages for the manual downloads (Kemper driver/Rig Manager, Bome).
7. **Manual installs** (see `Mac Software Setup Checklist.md` for full detail on each):
   - Kemper macOS driver — confirm official Core Audio driver actually works
   - Kemper Rig Manager — install, then restore from
     `Z:\Mac Migration\2026-08-18 16-09-47 - David.rmbackup` via
     **Tools → Restore Rig Manager Content**
   - Bome MIDI Translator Pro — log in, licensed download
   - Stream Deck **"Midi"** plugin (`se.trevligaspel.midi.sdPlugin`) — install from
     Elgato Marketplace, then set up **IAC Driver** ports in Audio MIDI Setup →
     MIDI Studio (6 ports: `StreamDeck2Daw`/`Daw2StreamDeck`,
     `StreamDeck2DawTrack`/`DawTrack2StreamDeck`, `Mackie2Daw`/`Daw2Mackie`) —
     same port names David already used when testing this on the MacBook Pro
8. **Sign into** Google Drive, Google Chrome, and any App Store apps that were
   skipped during the script run.

## Data & config migration

- [ ] Mount `Z:\Mac Migration` (Synology DS124) from the Mac — pull down everything
      staged there (Guitar/, Stream Deck/, the fresh `.rmbackup`, `.ff` files, etc.)
- [ ] Mount the canonical NAS shares (Pictures/Videos/Music/Taxes) — point any
      apps that need them (e.g. a photo viewer) at the NAS paths, not local storage
- [ ] Import **`focusrite-custom-mix.ff`** into Focusrite Control (the current one,
      dated 2026-08-14 — ignore the two older `.ff` files that were sitting on the NAS)
- [ ] Clone the Stream Deck dial plugin repo — `https://github.com/dsb012/streamdeck-focusrite`
      (private) — onto the Mac and follow its own `ARCHITECTURE.md` for packaging
      (`.streamDeckPlugin`) and the `node_modules` gap it documents
- [ ] Rebuild Stream Deck button profiles using the icon images from
      `Z:\Mac Migration\Stream Deck\` (album art, guitar icons)
- [ ] Rebuild Bome MIDI routing **manually** — the existing Windows config won't
      map cleanly to macOS device/port naming, so this is a from-scratch rebuild,
      not an import. Budget real time for this, not a quick step.

## Verification — confirm before trusting the setup for real use

- [ ] Custom Stream Deck+ dial plugin talks to Focusrite Control's FC1 socket
      (gain/mute control working)
- [ ] Kemper connects via real USB audio+MIDI, not falling back to analog
      through the 8i6
- [ ] Stream Deck "Midi" plugin actually sends MIDI through the new IAC Driver
      ports to Bome/DAW as expected
- [ ] Rig Manager library fully restored — rig count/library matches what was
      on the Windows PC, rigs load onto the Kemper correctly
- [ ] HD Pro Webcam C920 works in a real video call
- [ ] Home Assistant still shows correct UPS status (should be unaffected by
      the Mac migration since it goes through the NAS, not the Mac — just confirm)

## Decommission old Windows PC (only after everything above passes)

- [ ] Keep the Windows PC powered and available as fallback until verification
      is fully done — no fixed timeline yet, decide once migration is underway
- [ ] Old C: SSD (Samsung 970 EVO Plus) → UGREEN 40Gbps TB4/USB4 enclosure —
      not time-pressured, do whenever after the PC is retired
- [ ] Confirm final resting place for the N: 4TB HDD (WD40EFAX) — currently
      planned to stay in this machine as the on-site backup copy of the NAS

## Open items not resolved by this runbook

- AppleCare yes/no
- Exact decommission timeline for the old PC (buffer period undecided)
