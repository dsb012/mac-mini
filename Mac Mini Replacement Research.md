# Mac Mini Replacement — Plan

Replaces the ~8-9 year old Windows desktop (ASUS PRIME H310M-A). Full deliberation history has been trimmed — this is current state + plan only. Related docs in this folder: `Mac Software Setup Checklist.md` (install list), `USB Device Inventory.md` (raw peripheral scan).

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
  (ASM2464PD chipset, ASIN B0F62NG7K3) in a rear Thunderbolt port — preserves near-native ~3600MB/s.
  Only becomes available once this Windows machine is fully decommissioned, which naturally means
  there's no timeline pressure on it — it was never going to be usable before then anyway. Possible
  future use if the Mac mini's base 512GB feels tight later; not urgent, no action needed now.

## Displays
- **Primary — LG 29WN600-W** (29" 21:9 UltraWide, 2560×1080 IPS, HDR10, FreeSync) → mini's **native HDMI port**, straight cable, no adapter (the USB-C→HDMI cable's adapter chip doesn't offer this native resolution, confirmed by testing)
- **Secondary — LG 24ML600M-B** (24" FHD 1920×1080 IPS) → **uni USB-C-to-HDMI cable** (ASIN B075V5JK36, active chip, 4K@60Hz) from a rear Thunderbolt port
- Both feed the KVM's two HDMI inputs, same as the other two machines already on it
- KVM confirmed capable of native 2560×1080 today via both the Windows PC and the MacBook Pro — not expected to be a bottleneck for the mini
- If a refresh-rate/fuzzy-text problem shows up on any leg: swap to an **active-chipset adapter** (Pluggable brand confirmed fixed a 50Hz cap → steady 75Hz on the MacBook Pro's DP-to-HDMI leg on this same KVM)

## Audio
- **Retiring the passive Mackie Big Knob** monitor controller from the chain — no longer part of the setup.
- **Mac mini's audio → Focusrite Scarlett 8i6** (already on the Anker hub, see Hardware section above).
- **MacBook Pro's audio → LG 29WN600-W built-in speakers**, used for conference calls.

## Software
- All originally-flagged blockers resolved — **no WSL/Hyper-V, Visual Studio, VirtualBox, or Steam needed**
- Focusrite (staying on **Focusrite Control**, i.e. the original/"V1" app — confirmed 2026-08-14 via the Windows registry that this, not "Focusrite Control 2", is what's actually installed and what the custom Stream Deck+ dial plugin's FC1 socket connects to; `Home Projects\focusrite-streamdeck-dial\`), Elgato Stream Deck (incl. MIDI plugin), Cura, HD Pro Webcam — all native macOS, transfer cleanly
- **Anytune** (Chronotron replacement) — runs directly on the mini
- MIDI routing — **staying with Bome MIDI Translator Pro** (native Mac build, already licensed, familiar, works well) rather than switching to macOS's built-in Audio MIDI Setup + IAC Driver
- Backup provider is **Google Drive** (switched from IDrive)
- **Home Assistant Companion app** — verified (Shortcuts, sensors, actionable notifications all confirmed via official HA docs)
- Full install checklist: `Mac Software Setup Checklist.md`

## Open / to verify
- **CyberPower PowerPanel Personal** — UPS model confirmed: **CyberPower CP1000AVRLCD** (1000VA/600W, 9 outlets, AVR, mini-tower). Web research (2026-08-09): this model is officially on CyberPower's PowerPanel-Personal-compatible list, and the Mac client supports macOS 14+ — but **CPU architecture (Apple Silicon vs. Intel/Rosetta) is still never stated**, and a third-party tracker still shows it as untested. **Call CyberPower support (1-877-297-6937, model CP1000AVRLCD)** for a real answer before trusting it for auto-shutdown. **Fallback:** this UPS is natively supported by open-source **NUT (Network UPS Tools)** via `usbhid-ups`, which has an Apple-Silicon-native Homebrew build (`brew install nut`) if CyberPower's own app doesn't pan out.
- **AppleCare** — decide yes/no
- `storage-cleanup` project's dedup needs to finish (canonical Pictures/Videos/Music/Taxes) before the 1TB external SSD purchase is finalized
- Real-world KVM/display check once the mini is physically plugged in — proven on the other 2 machines, not yet the mini itself
