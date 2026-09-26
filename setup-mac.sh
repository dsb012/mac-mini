#!/bin/bash
#
# Mac mini setup — installs everything scriptable from "Mac Mini Setup.md".
#
#   chmod +x setup-mac.sh
#   ./setup-mac.sh
#
# Safe to re-run: anything already installed (by brew or by hand) is skipped.
# Written for the stock macOS bash 3.2 — no associative arrays.
# Nothing here needs sudo except Homebrew's own installer (which prompts you).

set -uo pipefail

# ---- bookkeeping (for the summary at the end) ---------------------------
OK=()
FAILED=()
SKIPPED=()

log()  { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }
ok()   { OK+=("$1");     printf '  \033[1;32m✓\033[0m %s\n' "$1"; }
fail() { FAILED+=("$1"); printf '  \033[1;31m✗\033[0m %s\n' "$1"; }
skip() { SKIPPED+=("$1"); printf '  \033[1;33m•\033[0m %s (skipped)\n' "$1"; }

# ---- 0. Homebrew ---------------------------------------------------------
log "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew (will prompt for your password)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon installs to /opt/homebrew, not /usr/local — put it on PATH now.
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  fi
fi
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew"
else
  fail "Homebrew"
  echo "Homebrew install failed — everything below needs it. Fix that first, then re-run." >&2
  exit 1
fi

brew update >/dev/null 2>&1 || true

# ---- 1. brew formulae (CLI tools) -----------------------------------------
FORMULAE=(
  git
  gh
  uv      # manages Python versions/venvs itself — no separate python formula needed
  node
  mas
  bash
)

log "Homebrew formulae"
for token in "${FORMULAE[@]}"; do
  if brew list "$token" >/dev/null 2>&1; then
    ok "$token (already installed)"
  elif brew install "$token"; then
    ok "$token"
  else
    fail "$token (brew install $token)"
  fi
done

# ---- 2. brew casks --------------------------------------------------------
# "cask token|app bundle name" — the app name lets us skip apps installed by hand.
CASKS=(
  "visual-studio-code|Visual Studio Code.app"
  "google-drive|Google Drive.app"
  "google-chrome|Google Chrome.app"
  "veracrypt-fuse-t|VeraCrypt.app"          # NOT plain veracrypt — fuse-t avoids macFUSE's kernel-extension approval
  "focusrite-control|Focusrite Control.app" # NOT focusrite-control-2 — the Stream Deck dial plugin needs this app's FC1 socket
  "elgato-stream-deck|Elgato Stream Deck.app"
  "ultimaker-cura|UltiMaker Cura.app"
  "rectangle|Rectangle.app"
  "alt-tab|AltTab.app"
  "iterm2|iTerm.app"
  "ghostty|Ghostty.app"
  "protonvpn|ProtonVPN.app"
  "spotify|Spotify.app"
  "claude|Claude.app"
  "signal|Signal.app"
  "zoom|zoom.us.app"
  "obs|OBS.app"
  "rustdesk|RustDesk.app"
  "logi-options+|logioptionsplus.app"
)

log "Homebrew casks"
for entry in "${CASKS[@]}"; do
  token="${entry%%|*}"
  app="${entry#*|}"
  if brew list --cask "$token" >/dev/null 2>&1; then
    ok "$token (already installed)"
  elif [ -d "/Applications/$app" ]; then
    ok "$token (already installed outside brew)"
  elif brew install --cask "$token"; then
    ok "$token"
  else
    fail "$token (brew install --cask $token)"
  fi
done

# ---- 3. Mac App Store apps -------------------------------------------------
MAS_APPS=(
  "722444976|Anytune"            # the Mac product, distinct from the iOS "Anytune Pro" id
  "1099568401|Home Assistant"
  "1593644229|Folders"
)

log "Mac App Store apps (via mas)"
if ! command -v mas >/dev/null 2>&1; then
  for entry in "${MAS_APPS[@]}"; do skip "${entry#*|} — mas unavailable"; done
elif ! mas account >/dev/null 2>&1; then
  echo "  Not signed into the App Store. Sign in via the App Store app, then re-run."
  for entry in "${MAS_APPS[@]}"; do skip "${entry#*|} (id ${entry%%|*}) — needs App Store sign-in"; done
else
  for entry in "${MAS_APPS[@]}"; do
    id="${entry%%|*}"
    name="${entry#*|}"
    if mas list 2>/dev/null | grep -q "^ *$id "; then
      ok "$name (already installed)"
    elif mas install "$id"; then
      ok "$name"
    else
      fail "$name (mas install $id)"
    fi
  done
fi

# ---- 4. Manual downloads ---------------------------------------------------
# Not packaged for brew/mas (proprietary installers and/or license keys).
# Opens each vendor page unless the app is already there.
MANUAL=(
  "Rig Manager.app|Kemper driver + Rig Manager|https://www.kemper-amps.com/downloads"
  "Bome MIDI Translator Pro.app|Bome MIDI Translator Pro (log in for the licensed download)|https://www.bome.com/downloads"
  "Reolink.app|Reolink Client|https://reolink.com/us/software-and-manual/"
  "Rectangle Pro.app|Rectangle Pro|https://rectangleapp.com/pro"
)

log "Manual downloads"
for entry in "${MANUAL[@]}"; do
  app="${entry%%|*}"
  rest="${entry#*|}"
  name="${rest%%|*}"
  url="${rest#*|}"
  if [ -d "/Applications/$app" ]; then
    ok "$name (already installed)"
  else
    open "$url" 2>/dev/null && ok "$name (opened $url)" || fail "$name (couldn't open $url)"
  fi
done

# ---- summary ----------------------------------------------------------
log "Summary"
echo "OK:      ${#OK[@]}"
echo "Failed:  ${#FAILED[@]}"
echo "Skipped: ${#SKIPPED[@]}"
if [ ${#FAILED[@]} -gt 0 ]; then
  printf '\nFailed items:\n'
  printf '  - %s\n' "${FAILED[@]}"
fi

cat <<'EOF'

Still needs you, by hand (details in "Mac Mini Setup.md" → Configuration):
  - Disable system sleep so the NAS share stays mounted: sudo pmset -a sleep 0
  - Kemper Rig Manager: Tools > Restore Rig Manager Content from the .rmbackup
  - Focusrite Control: import focusrite-custom-mix.ff
  - Audio MIDI Setup: create the 6 IAC Driver ports for the Stream Deck Midi plugin
  - Bome: rebuild routes; add Bome, Claude and Rectangle Pro as login items
  - Sign into Google Drive, Chrome, Proton VPN, Spotify, Signal, Zoom
EOF
