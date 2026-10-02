#!/bin/bash
# Recover the Dell from the black-screen state (see "Display Black Screen Issue.md").
# A real sleep/wake cycle makes macOS drop and re-detect the HDMI monitor, which brings the picture back.
# Wired to a Stream Deck key via ~/Applications/Display Reset.app.
#
# After pressing: wait ~15 s without touching the keyboard or mouse, then press a key to wake.
# (Waking within ~1 s doesn't give the monitor time to disconnect/reconnect.)
# Check it ran: /usr/bin/log show --last 10m --predicate 'eventMessage CONTAINS "display-reset"'

/usr/bin/logger "display-reset: pressed, sleeping in 2 s"
sleep 2   # let go of the Stream Deck key first, so its activity doesn't count as a wake
# Sleep the same way the power button / Apple menu does (via loginwindow). 2026-10-02: `pmset sleepnow` only
# reached DarkWake (HDMI stayed up, no hotplug out → no recovery); the power button's sleep did a full sleep
# with hotplug out → in, which brought the picture back.
/usr/bin/osascript -e 'tell application "System Events" to sleep'
/usr/bin/logger "display-reset: System Events sleep returned $?"
