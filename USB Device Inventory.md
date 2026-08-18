# USB Device Inventory (current Windows PC)

Captured 2026-07-19 via `Get-PnpDevice`/`Get-CimInstance Win32_PnPEntity` on the
current Windows desktop, with everything actually powered on (Kemper + MIDI
Captain included). Purpose: input for figuring out a Mac mini dock/hub layout —
see "Port count / hub question" and "Enclosure/dock specifics" in
`Mac Mini Replacement Research.md` for the plan this feeds into.

## Confirmed peripherals

| Device | USB ID (VID:PID) | Interfaces | Notes |
|---|---|---|---|
| Logitech Unifying Receiver (mouse + keyboard dongle) | 046D:C52B | 3x HID | Wireless — single dongle covers both mouse and keyboard |
| Apple Magic Keyboard w/ Touch ID + Numeric Keypad (2024) | 05AC:0322 | USB-C + 2x HID aux | |
| Logitech HD Pro Webcam C920 | 046D:08E5 | Camera + Media (audio) | |
| Focusrite Scarlett 8i6 (3rd Gen) | 1235:8213 | Focusrite Audio | |
| CyberPower UPS | 0764:0501 | HID | Used by PowerPanel Personal for monitoring |
| Elgato Stream Deck+ | 0FD9:0084 | HID | PID confirms Stream Deck+ specifically (not base/XL/MK.2) |
| Fifine microphone | 0C76:161E | Audio + HID | HID interface is likely a mute button/gain knob. (JMTek is a generic audio-chip vendor — initially misidentified as the Spark amp before confirming) |
| MIDI Captain footswitch | 239A:80F4 | Serial (COM3) + HID + MIDI | Composite device, 3 interfaces at once |
| Kemper Profiler | 133E:0003 | 2x USBDevice + Media | Connects to the PC via USB (audio/MIDI), not just analog through the Scarlett as earlier notes assumed — **correction to the existing research doc's assumption** |
| Unlabeled USB hub | 05E3:0610 | Hub | Likely the existing powered Anker 7-port hub |

**Not currently connected / not in regular use:** Positive Grid Spark amp
(David confirmed 2026-07-19 he barely uses it — absence from the live scan
isn't a problem to chase down).

## Historical devices (Windows device history, not currently attached)

Found as "phantom" (`CM_PROB_PHANTOM`) entries — previously plugged into this
PC at some point, not present now. Listed in case any are still relevant to
the move:
- SABRENT USB drive (external SSD/enclosure)
- Raspberry Pi Pico
- A UAS (USB Attached SCSI) mass-storage bridge — likely a drive enclosure chipset
- Logitech G27 Racing Wheel + Driving Force wheel (old sim-racing peripherals)
- A second Logitech Unifying Receiver (different serial) and a second JMTek audio device — likely earlier units swapped out

## Dock-planning implications

- 9 real peripherals plus the Anker hub. Per the existing plan, all of these
  are standard USB (not Thunderbolt-bandwidth-dependent), so they can all sit
  behind the Anker hub on a single Mac mini USB-C/USB4 port — nothing here
  changes that conclusion.
- **Kemper correction matters for bandwidth/driver planning**: it's a real USB
  audio/MIDI device from the Mac's perspective, not just an analog signal
  arriving via the Scarlett's line-in. Worth confirming Kemper's official
  macOS driver/Core Audio support before finalizing the move (same kind of
  check already flagged for CyberPower's PowerPanel Personal on Mac).
- Two multi-interface audio devices (Scarlett 8i6, Kemper) plus a mic (Fifine)
  and a webcam mic — worth checking how many simultaneous Core Audio input
  devices macOS/your DAW-adjacent software expects to see, in case an
  aggregate device needs to be set up on the Mac side (not a Windows concept,
  new consideration for the move).
