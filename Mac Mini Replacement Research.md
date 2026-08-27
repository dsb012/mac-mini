# Mac Mini Replacement — Plan

Replaces the ~8-9 year old Windows desktop (ASUS PRIME H310M-A). Full deliberation history has been trimmed — this is current state + plan only. Related docs: `Mac Software Setup Checklist.md` (install list, this folder), `docs/USB Device Inventory.md` (raw peripheral scan).

**Folder layout:** this file + `Mac Software Setup Checklist.md` + `setup-mac.sh` + `focusrite-custom-mix.ff` (Focusrite mix config to import) are the active migration set, kept at top level. `docs/` holds supporting research (monitor comparison, USB inventory, the Elgato refund process). `reference/` holds source material (order confirmation, a setup photo, a keyboard shortcuts PDF). `chronotron-pitch-extraction/` is a self-contained sub-task (pulling pitch offset data out of Chronotron for the Anytune migration).

## Order
- **Base M4 Mac mini** — 10-core CPU/GPU, 24GB RAM, 512GB SSD, Accessory Kit
- Order #W1640840367, placed 2026-07-29, $1,270.94 total
- Delivery: Sep 18–Oct 2 (Express), David's working estimate "mid-September"
- AppleCare — not purchased, still an open decision if wanted

## Hardware & peripherals
- Replaces the Windows PC on the existing KVM (which also carries David's work M1 MacBook Pro)
- Existing powered **Anker 7-port USB hub** hosts all standard-USB peripherals off a single mini port: Focusrite Scarlett 8i6, Elgato Stream Deck+, Logitech HD Pro Webcam C920, MIDI Captain footswitch, CyberPower UPS, Kemper Profiler (connects via real USB audio/MIDI, not just analog through the 8i6)
- Apple Magic Keyboard (Touch ID + numeric keypad) — direct USB-C, no hub needed
- KVM's keyboard/mouse uplink plugs into the Anker hub
- No M4 Pro needed — base M4's port count and performance both cover this workload (MIDI routing, audio passthrough, light dev, Cura slicing, browsing, short single-stream video edits)

## Storage
- **Canonical media (Pictures/Videos/Music/Taxes — 790.16GB confirmed 2026-08-15, targeted ≤1TB) now
  goes on a Synology DS124 NAS, not a Mac mini-attached SSD** (decided 2026-08-13, sizing/scope
  finalized 2026-08-15 — see `storage-cleanup`'s "Storage decision" section for the full plan).
  Multi-computer access was the driver — a local SSD only serves the Mac mini. **Revised plan
  (2026-08-15): the spare 1TB WD Red goes into the DS124's single bay as its drive** (formatted by
  DSM itself during NAS setup, not pre-loaded — Synology doesn't accept a drive with an existing
  filesystem for its internal bay), then the canonical set is copied to it over the network from this
  PC. **The old N: 4TB HDD (WD40EFAX) no longer needs to move at all** — it stays in this machine as
  the on-site backup copy of the NAS's contents, with far more headroom than the originally-planned
  1TB-matched backup. Music (~15GB) is now included in the NAS migration too (reversed from an earlier
  "stays local" call) since the Red drive has room, and the household isn't actively shooting new
  photos/video anymore, so the ~1TB target isn't expected to grow. **No new SSD purchase needed for
  this** — there never was a separate "1TB SSD" to buy; that was this same machine's C: drive (below),
  not a distinct item.
- **Old C: SSD (Samsung 970 EVO Plus, 1TB NVMe)** → standalone **UGREEN 40Gbps TB4/USB4 enclosure**
  (ASM2464PD chipset, ASIN B0F62NG7K3) — preserves near-native ~3600MB/s. **Decided 2026-08-19:
  the Windows PC stays powered for a 60-day fallback buffer after cutover (Aug 25 → ~Oct 24,
  2026), then the drive moves as-is into the enclosure** (already ordered) once actually
  decommissioned. Possible future use if the Mac mini's base 512GB feels tight later.

## Displays

**Changed 2026-08-26: single-monitor setup.** The Dell S3425DW was purchased and is set up
(confirmed running on the work MacBook Pro at native 3440x1440). Going forward the desk runs
**one display for the near future** — the two LGs come out of the daily setup. Supersedes the
dual-LG plan below, which is kept for reference in case a second head comes back.

- **Only display — Dell S3425DW** (34" 21:9, 3440×1440 VA, 1800R, 120Hz panel, USB-C 65W PD, 2× HDMI 2.1 + 1× USB-C upstream). ~110 PPI, vs ~96 on the 29" LG and ~93 on the 24" — text renders ~13–16% smaller than the old setup at the same viewing distance.
- **Runs at 100Hz, not 120Hz, and that is now confirmed as the KVM's ceiling** (2026-08-26, tested on the MacBook Pro — macOS offers no 120Hz mode through the KVM). HDMI 2.0 bandwidth limit, exactly as the analysis in `docs/Monitor Comparison.md` predicted. Not a defect and not worth chasing: 100Hz matches the work monitor. Any machine that genuinely needs 120Hz can take a Dell HDMI 2.1 input directly instead.
- **The KVM's second head is now surplus.** The NAWEN KC-KVM202AS-NA is a 2-computer/2-monitor unit; only one head is in use. If it ever gets replaced for HDMI 2.1, a single-head unit is cheaper and more available.
- **Mini connects by HDMI, not USB-C (decided 2026-08-26).** The mini is mains-powered so it gains nothing from the Dell's 65W USB-C PD, and the Dell's HDMI 2.1 inputs carry 3440×1440@120 on their own. **This frees a rear Thunderbolt 4 port** — relevant to the UGREEN 40Gbps enclosure in the Storage section, which needs a full TB4/USB4 port for its ~3600MB/s. Planned rear TB4 use is then: Anker hub (1), UGREEN enclosure (1), one spare; Magic Keyboard can live on a front USB-C port.
- **MacBook Pro stays on the Dell's USB-C input** — single cable for video, audio, and 65W charging.
- **Open decision — video through the KVM, or straight into the monitor's own inputs?** With one display, the Dell's 3 inputs (2× HDMI 2.1 + USB-C) can host all three machines directly and switch via the monitor's input button, which recovers full 120Hz and removes the EDID/bandwidth question entirely. Cost: the KVM's one-button switching for video. Hybrid option — KVM keeps keyboard/mouse/USB duty, monitor handles video switching.
- **Open decision — what happens to the two LGs** (keep the 29" as a spare, retire both, or relocate). The uni USB-C-to-HDMI cable (ASIN B075V5JK36) that fed the 24" becomes spare either way.

_Superseded dual-display plan (pre-2026-08-26), retained for reference:_
- ~~**Primary — LG 29WN600-W** (29" 21:9 UltraWide, 2560×1080 IPS, HDR10, FreeSync) → mini's **native HDMI port**, straight cable, no adapter (the USB-C→HDMI cable's adapter chip doesn't offer this native resolution, confirmed by testing)~~
- ~~**Secondary — LG 24ML600M-B** (24" FHD 1920×1080 IPS) → **uni USB-C-to-HDMI cable** (ASIN B075V5JK36, active chip, 4K@60Hz) from a rear Thunderbolt port~~
- ~~Both feed the KVM's two HDMI inputs, same as the other two machines already on it~~
- KVM confirmed capable of native 2560×1080 today via both the Windows PC and the MacBook Pro — still true, and now also confirmed to pass native 3440×1440
- If a refresh-rate/fuzzy-text problem shows up on any leg: swap to an **active-chipset adapter** (Pluggable brand confirmed fixed a 50Hz cap → steady 75Hz on the MacBook Pro's DP-to-HDMI leg on this same KVM)

## Audio
- **Retiring the passive Mackie Big Knob** monitor controller from the chain — no longer part of the setup.
- **Mac mini's audio → Focusrite Scarlett 8i6** (already on the Anker hub, see Hardware section above).
- **MacBook Pro's audio → Dell S3425DW built-in speakers** over the USB-C leg, used for conference calls. **Confirmed working 2026-08-26** — replaces the LG 29WN600-W's speakers, and David rates them noticeably better. The single-monitor switch did not cost an audio output; it upgraded one.
- **`focusrite-custom-mix.ff`** (this folder, renamed 2026-08-19 from `kemper.ff` for clarity) — Focusrite Control custom mix config (David's custom routing/mixes, originally named for the mix that routes the Kemper's send/return — not a Kemper amp/rig backup, despite the old name). Needs to be imported into Focusrite Control once installed on the Mac mini — confirm the import mechanism works with the macOS build of the app.

## Migration staging (NAS)
**`Z:\Mac Migration`** (on the Synology DS124) is the live payload staging folder — David is actively copying files there now. This is separate from this project folder (which is planning/docs only) and from the canonical Pictures/Videos/Music/Taxes shares alongside it on the same NAS. Contents as of 2026-08-19 survey:
- **`Guitar\Current Guitar\*.rmbackup`** — a Kemper Rig Manager backup, but dated 2025-12-14 (~8 months stale). **Redo this with Tools → Backup Rig Manager Content right before the actual move** (see checklist's Rig Manager section) rather than relying on this one. `MyProfiler.csv` alongside it is just a rig-library catalog/export, not the audio data itself.
- **`Guitar\Device Configs\`** — held **two old/stale Focusrite `.ff` files** (`FocusRite.ff` 2022, `scarlett.ff` 2023), both confirmed byte-different from the current one (`focusrite-custom-mix.ff` in this project folder, dated 2026-08-14) — the project-folder copy is the one to actually use; the NAS ones are historical. Also had `x-touch.bin` (X-Touch controller config) — **X-Touch confirmed retired/not in use (2026-08-19), skip it.**
- **`Guitar\Guitar Programs\`** — shortcuts included "Focusrite Midi Control" and "Power Mixer" — **both confirmed unused leftovers (2026-08-19), not needed on the Mac.**
- **`Stream Deck\`** — full set of Stream Deck button icon images (album art, guitar icons) — needed to rebuild Stream Deck profiles on the Mac; not otherwise tracked anywhere.

## Software
- All originally-flagged blockers resolved — **no WSL/Hyper-V, Visual Studio, VirtualBox, or Steam needed**
- Focusrite (staying on **Focusrite Control**, i.e. the original/"V1" app — confirmed 2026-08-14 via the Windows registry that this, not "Focusrite Control 2", is what's actually installed and what the custom Stream Deck+ dial plugin's FC1 socket connects to; `Home Projects\focusrite-streamdeck-dial\`), Elgato Stream Deck (incl. MIDI plugin), Cura, HD Pro Webcam — all native macOS, transfer cleanly
- **Anytune** (Chronotron replacement) — runs directly on the mini
- MIDI routing — **staying with Bome MIDI Translator Pro** (native Mac build, already licensed, familiar, works well) rather than switching to macOS's built-in Audio MIDI Setup + IAC Driver
- Backup provider is **Google Drive** (switched from IDrive)
- **Home Assistant Companion app** — verified (Shortcuts, sensors, actionable notifications all confirmed via official HA docs)
- **Dev tooling: git + uv** — relying on uv alone for Python (version/venv/package management), no separate `python` formula
- **Zoom** — added to the cask list for video calls
- Full install checklist: `Mac Software Setup Checklist.md`

## UPS monitoring
- **CyberPower CP1000AVRLCD is monitored via the Synology DS124 NAS + Home Assistant (decided 2026-08-19)** — no PowerPanel Personal app needed on the Mac mini at all. Drops the whole "does PowerPanel Personal support Apple Silicon" question and the planned CyberPower support call — moot now, not just deferred. Removed from the setup checklist and `setup-mac.sh`.

## Open / to verify
- **AppleCare** — decide yes/no
- `storage-cleanup` project's dedup — **done as of 2026-08-19** (canonical Pictures/Videos/Music/Taxes on the NAS)
- Real-world KVM/display check once the mini is physically plugged in — proven on the other 2 machines, not yet the mini itself
- ~~Dell S3425DW refresh rate~~ — **resolved 2026-08-26**: 100Hz is the KVM's HDMI 2.0 ceiling, confirmed. Accepted, not a problem
- **Video switching topology** — KVM vs the monitor's own 3 inputs, now that it's a single display (2026-08-26)
- **Disposition of the LG 29WN600-W and LG 24ML600M-B** — keep as spares, retire, or relocate (2026-08-26)
- ~~Conference-call audio output for the MacBook Pro~~ — **resolved 2026-08-26**: running through the Dell's speakers, confirmed better than the LG's
