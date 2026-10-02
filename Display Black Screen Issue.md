# Display Black Screen Issue (Mac mini → KVM → Dell)

**Status (2026-09-27): open. Reproducible on demand. Next step: the KVM-bypass test (see *Next test*).**

## Symptom
After the Mac mini's display has been asleep, or after switching the KVM back to the mini, the Dell stays **black**
even though the mini is awake and thinks the screen is on. Moving the mouse or typing doesn't bring it
back.

| Date | What happened | How it was recovered |
|---|---|---|
| 2026-09-24 ~08:10–08:20 | Black after a KVM switch back to the mini | Pressed the mini's **power button** once (sleep/wake cycle) |
| 2026-09-26 16:21 | The mini restarted. **Cause not recorded**; may or may not be this issue | — |
| 2026-09-26 → 27 | Dell **powered off at night** by hand. Black the next morning | **Rebooted** the mini (12:05) |
| 2026-09-27 ~15:41–15:58 | **Reproducible:** KVM to the other port **with no other computer connected**, then back to the mini → black | — (repeated tests) |
| 2026-09-27 ~16:01 | **Dell locked to HDMI 1, just powered off and on → black.** No KVM switch needed | — |
| 2026-10-02 09:31–10:58 | Mini **rebooted 3×** (09:33, 09:40, 10:58), with a power-button sleep attempt at 10:57:25. Same log pattern: hotplug "in" → `Deferred hotplugs cannot be processed` → `Waking TV`. Running macOS **27.0.1** (installed 2026-09-30), so the point update didn't fix it | Reboots |
| 2026-10-02 ~12:05–12:20 | **60Hz test:** mini set to 3440×1440 @ **60Hz** (half the bandwidth), Dell power-cycled → **still black**. Rules out the KVM's 18 Gbps bandwidth margin. CEC (`Waking TV` still sent at 12:20:06) remains the lead suspect; next test is a CEC-less adapter on the KVM's mini input | — |
| 2026-10-02 11:36 | Black during a KVM switch back to the mini. Mini logged hotplug "in" → display on → `Waking TV` → `ActiveSource → YES` (it thinks everything is fine) | — |

## Setup involved
- **Mac mini (M6), macOS 27.0** → HDMI → **NAWEN KC-KVM202AS-NA** KVM (HDMI 2.0) → **Dell S3425DW** HDMI input.
- MacBook Pro → USB-C → **Dell dock** → HDMI → **the same KVM** → Dell. (Corrected 2026-10-02; earlier notes said
  the Dell's USB-C input.) **The MacBook never gets the black screen**, through the same KVM and monitor.
- The mini never sleeps as a system, only its display. Kemper Rig Manager holds a sleep-prevention assertion,
  and system sleep is disabled for the NAS mount. Display sleep: **10 min**.

## What the logs show
From `pmset -g log` and the unified log (`/usr/bin/log show`, WindowServer). Note that in zsh, `log` is a
built-in, so use `/usr/bin/log`.

**2026-09-24:** WindowServer logged `Deferred hotplugs cannot be processed in a non-wake state` when the
monitor came back. Pressing the power button ran sleep → wake (08:19:52 → 08:19:58, wake reason `pwrbtn`),
during which the monitor was seen **disconnected (08:19:57) → reconnected (08:20:04)**, and the picture
returned. So re-detecting the monitor is what fixes it.

**2026-09-26 → 27:**
```
21:48:58  Display is turned off
21:48:58  WindowServer CoreRCPlugin: "Putting TV to standby"            ← HDMI-CEC standby sent
          (nothing until the next morning)
12:03:33  Display is turned on
12:03:33  Hotplug "in" — "Deferred hotplugs cannot be processed in a non-wake state"
12:03:33  CoreRCPlugin: "Waking TV" — CECDeviceActiveSourceStatus → YES  ← CEC wake sent; mini thinks all is well
12:05:15  reboot (powerd started)
```

## Reproducing it (2026-09-27)
**KVM away from the mini while nothing else is feeding the Dell, then back → black.** The log for each switch
back (15:41, 15:43, 15:45/46, 15:47, 15:57) shows the **mini doing everything right**: monitor reconnected,
display turned on, a fresh CEC device added, `Waking TV`, `ActiveSource → YES`. So in this case the mini is sending
a picture and **the Dell isn't showing it.** One switch-back registered the monitor as a different display
(`display_id=3`), so the mini re-enumerates it as a new screen at times.

**Ruled out: the Dell's Auto Select / input selection.** With the Dell **locked to HDMI 1**, simply **powering
the Dell off and back on** reproduces it (16:01:48: reconnect event → display on → CEC `Waking TV` →
still black). So the monitor's input scanning isn't involved. The failure is in re-establishing the HDMI
connection after the far end goes away: either **the KVM** or **the mini/macOS 27** itself.

**Only once (15:44:55) did the mini log the monitor going away** (hotplug "out"). Every other time it only
sees it coming back. The KVM usually hides the disconnect.

## Next test: take the KVM out of the video path
1. Move the mini's HDMI cable from the KVM to the Dell's **HDMI 2** input, and select HDMI 2.
2. Power the Dell off, wait 10 s, power it on.

| Result | Means | Fix |
|---|---|---|
| **Picture returns** | **The KVM** breaks the reconnection (likely passing a monitor description or signal mode it can't carry) | Direct video (also 120 Hz), or an HDMI **EDID-emulator** dongle at the mini, or replace the KVM |
| **Still black** | **The mini / macOS 27** doesn't reconnect properly on its own | Sleep/wake to recover; try another HDMI cable; report to Apple (Feedback Assistant); or run the mini through the Dell's USB-C input |

**2026-10-02:** the Dell shows **plain black, no "No HDMI signal" message**. **The MacBook, through the dock and
the same KVM, never has the problem.** So the KVM on its own isn't the cause. The fault is on the mini's side:
its built-in HDMI port (CEC commands, hotplug handling in macOS 27), or how that port interacts with the KVM.
The dock is a different kind of HDMI source (its own converter chip, almost certainly no CEC).

**Cheaper, sharper test than the bypass:** feed the KVM from the mini through the **spare USB-C → HDMI cable**
(from a free Thunderbolt port on the back) instead of the mini's HDMI port. That copies the MacBook's path (USB-C →
converter → HDMI). USB-C-to-HDMI converters generally don't carry CEC. If the black screens stop, the mini's
HDMI port is the trigger, and the cable is the fix.

**Also note what the Dell shows when black:** a **"No HDMI signal" box** (the mini isn't driving a usable
signal) vs **lit but black** (signal arrives, but no image, which points at the signal mode or HDCP).

## Earlier theory: HDMI-CEC (overnight case)
Still possible as a contributor, but **the power-cycle repro shows the reconnection itself is the failure**. Two things combine:

1. **HDMI-CEC.** On this macOS version the mini sends CEC commands over HDMI: "standby" when its display
   sleeps and "wake" when it wakes, treating the monitor like a TV. **Apple provides no setting to turn this
   off.** Apple's own advice for screens that turn on or off unexpectedly is to change CEC on the display.
2. **The KVM in the video path.** The KVM keeps telling the mini the monitor is still connected even when
   the Dell is powered off. So the mini never sees the monitor leave, keeps talking CEC to a monitor that's off,
   and when the Dell comes back on the wake-up handshake doesn't complete.

**Powering the Dell off by hand** is a confirmed trigger (reproduced 2026-09-27), as is switching the KVM away
with nothing else connected.

## What's been checked
- **The mini's power settings:** display sleep 10 min, system sleep blocked (Rig Manager, audio). The mini
  isn't sleeping. Only the display link is lost.
- **macOS CEC setting:** none exists. No System Settings option and no preference file (`defaults domains`
  shows no CoreRC/CEC domain). Re-checked 2026-10-02 by inspecting the CEC component itself
  (`/System/Library/HIDPlugins/SessionFilters/CoreRCPlugin.plugin`). macOS does turn CEC off for specific
  monitors (it logs `CEC Disabled! EDID matched against …`), but the list is **compiled in**: Samsung Odyssey
  Ark/G7/G70B/LS28AG700N, HP OMEN 32c, MSI MAG274QRF-QD. The Dell isn't on it. The plugin has
  `DisabledEDIDs`/`cecUserDefaults` names, but no usable defaults key could be found, and guessing the format
  risks crashing WindowServer. In practice, software can't turn CEC off on the mini.
- **Dell S3425DW manual (67 pages):** **no HDMI-CEC option.** "CEC" only appears in the HDMI pin table (pin 13).
  The Others menu has only DDC/CI, LCD Conditioning, Self-Diagnostic, Reset Others and Factory Reset. There is
  no sleep or wake setting either (only the power LED and USB charging options).
- **The recording didn't cause it:** OBS / Rig Manager keep the system awake, not the display, so the display
  sleep → CEC standby path still runs.

## Fixes, in order
0. ~~Dell Auto Select / Options for HDMI~~ — **ruled out** (locked to HDMI 1, still reproduces).
1. **⬅ Now, until fixed: don't power the Dell off, and don't switch the KVM away unless the MacBook is feeding the Dell.** Let the mini sleep it** (10 min), and the Dell drops to standby on its
   own (well under 1 W). Run this for 1–2 weeks and log any recurrence in the table above.
2. **HDMI CEC-blocking adapter** between the mini and the KVM. It disconnects the CEC wire (pin 13) so
   standby/wake commands never reach the monitor. Cheap, and doesn't affect video.
3. **Bypass the KVM for video:** mini HDMI straight into the Dell's **HDMI 2** input, with the KVM kept for
   keyboard, mouse and USB. It also allows 120 Hz. **Run it first as the diagnostic test** (see *Next test*):
   if it fixes the repro, it becomes the real fix, despite the 2026-09-26 "video stays on the KVM" decision.

## If it happens again: recover without rebooting
1. **Stream Deck "Display Reset" key** (or the **mini's power button**: press for **about half a second**. Under 0.35 s is ignored as a bump; over 1.5 s opens the shutdown dialog, which is invisible on a black screen. Both happened 2026-10-02 12:36). Either one sleeps the mini.
   Then **don't touch the keyboard or mouse for 10–15 s**, then press a key to wake.
   **Verified** in the 2026-09-24 log: `Software Sleep` → wake reason `pwrbtn` (asleep ~6 s) → monitor
   disconnected and reconnected → picture back. **2026-10-02 10:57 it failed** because the mini woke after ~1 s
   (`DarkWake … due to HID Activity`), too soon for the monitor to reconnect, and a reboot followed.
   The key runs [`scripts/display-reset.sh`](scripts/display-reset.sh) (2 s delay, then sleep via System Events, the same
   path as the power button; `pmset sleepnow` only reached DarkWake and didn't reset the link). **Verified 2026-10-02
   12:46:** full sleep 6 s → monitor out (12:47:05) → in (12:47:13) → picture back.
2. Reboot, only if that doesn't work.

⚠️ **Not the Touch ID key.** Apple documents the power-key shortcuts (Option–Command–Power to sleep,
Control–Shift–Power for display sleep) only for keyboards **without** Touch ID. On a Touch ID keyboard a press
**locks the screen**, and **pressing and holding forces a shutdown**. (An earlier version of this doc wrongly
listed Option + Command + Touch ID.)

**Don't power-cycle the Dell to recover:** that's now a confirmed *trigger*.

**Then note the time** and check the logs:
```
pmset -g log | grep -E "Display is turned|Sleep  |Wake  " | tail -20
/usr/bin/log show --start "YYYY-MM-DD HH:MM:00" --end "YYYY-MM-DD HH:MM:00" --style compact \
  --predicate 'process == "WindowServer" AND (eventMessage CONTAINS "Hotplug" OR eventMessage CONTAINS "TV")'
```
Look for "Putting TV to standby" / "Waking TV" (CEC) and "Deferred hotplugs cannot be processed".

## Sources
- [Connect to HDMI from your Mac — Apple Support](https://support.apple.com/en-us/108928): Apple's
  guidance to change HDMI-CEC on the display when it turns on or off unexpectedly.
- [The Two-Mac HDMI CEC Problem — scottstuff.net (2026-02-10)](https://scottstuff.net/posts/2026/02/10/the-two-mac-hdmi-cec-problem/):
  Macs sending conflicting CEC messages that turn a display on and off. "Apple … provides *no settings
  whatsoever* for controlling how HDMI CEC works with Macs." Workaround was power-cycling the display.
- [Mac mini M4 Pro — HDMI CEC (MacRumors Forums)](https://forums.macrumors.com/threads/mac-mini-m4-pro-hdmi-cec.2442641/):
  CEC behavior on recent Mac minis.
- [Dell 34 Plus USB-C Monitor S3425DW User's Guide (PDF)](https://gzhls.at/blob/ldb/c/1/2/9/4cc594acecd609bcfe039f9f91b2c872d3f7.pdf):
  searched in full. No CEC setting, Others menu contents as listed above.
- [Mac keyboard shortcuts — Apple Support](https://support.apple.com/en-us/102650): power-button
  shortcuts are listed for keyboards without Touch ID only. With Touch ID, a press locks the screen.
- [Dell S3425DW support page](https://www.dell.com/support/product-details/en-us/product/s3425dw-monitor/overview)
