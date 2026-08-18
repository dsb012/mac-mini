#!/usr/bin/env bash
#
# Mac mini setup — installs everything from Mac Software Setup Checklist.md.
# Run this ON the Mac mini itself (macOS Terminal), not on the Windows PC.
#
#   chmod +x setup-mac.sh
#   ./setup-mac.sh
#
# Safe to re-run: `brew install --cask` skips anything already installed.
# Nothing here needs sudo except Homebrew's own installer (which prompts you).

set -uo pipefail

# ---- toggles -----------------------------------------------------------
# Flip to false if you end up not keeping the Logitech Unifying mouse.
INSTALL_LOGI_OPTIONS=true

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

# ---- 1. brew casks --------------------------------------------------------
# name -> homebrew cask token
declare -A CASKS=(
  ["Visual Studio Code"]="visual-studio-code"
  ["Google Drive"]="google-drive"
  ["Google Chrome"]="google-chrome"
  ["VeraCrypt (fuse-t backend)"]="veracrypt-fuse-t"   # pulls in fuse-t automatically — no kernel-extension approval dance like plain macFUSE
  ["Focusrite Control"]="focusrite-control"            # NOT focusrite-control-2 — confirmed 2026-08-14 this (not Control 2) is what the custom Stream Deck dial plugin's FC1 socket actually needs
  ["Elgato Stream Deck"]="elgato-stream-deck"
  ["Ultimaker Cura"]="ultimaker-cura"
  ["Rectangle"]="rectangle"
  ["AltTab"]="alt-tab"
  ["iTerm2"]="iterm2"
  ["Ghostty"]="ghostty"
  ["Proton VPN"]="protonvpn"
  ["Spotify"]="spotify"
  ["Claude"]="claude"
  ["Signal"]="signal"
)
if [ "$INSTALL_LOGI_OPTIONS" = true ]; then
  CASKS["Logi Options+"]="logi-options+"
fi

log "Homebrew casks"
for name in "${!CASKS[@]}"; do
  token="${CASKS[$name]}"
  if brew list --cask "$token" >/dev/null 2>&1; then
    ok "$name (already installed)"
    continue
  fi
  if brew install --cask "$token"; then
    ok "$name"
  else
    fail "$name (brew install --cask $token)"
  fi
done

# ---- 2. Mac App Store apps -------------------------------------------------
log "Mac App Store apps (via mas)"
if ! command -v mas >/dev/null 2>&1; then
  brew install mas || fail "mas (App Store CLI)"
fi

if command -v mas >/dev/null 2>&1; then
  if ! mas account >/dev/null 2>&1; then
    echo "  Not signed into the App Store. Open the App Store app, sign in, then re-run this script"
    echo "  (or just install these two manually once signed in):"
    skip "Home Assistant Companion (id 1099568401) — needs App Store sign-in"
    skip "Anytune (id 722444976) — needs App Store sign-in"
  else
    declare -A MAS_APPS=(
      ["Home Assistant Companion"]="1099568401"
      ["Anytune"]="722444976"   # this is the Mac product, distinct from the iOS "Anytune Pro" id
    )
    for name in "${!MAS_APPS[@]}"; do
      id="${MAS_APPS[$name]}"
      if mas list 2>/dev/null | grep -q "^$id "; then
        ok "$name (already installed)"
      elif mas install "$id"; then
        ok "$name"
      else
        fail "$name (mas install $id)"
      fi
    done
  fi
else
  skip "Home Assistant Companion — mas unavailable"
  skip "Anytune — mas unavailable"
fi

# ---- 3. Manual downloads ---------------------------------------------------
# These aren't packaged for brew/mas — proprietary installers and/or license
# keys involved. Script just opens each vendor page so you can download,
# log in, and enter your license where needed.
log "Manual downloads (opening pages in your browser)"

declare -A MANUAL=(
  ["Kemper macOS driver"]="https://www.kemper-amps.com/downloads"
  ["Kemper Rig Manager"]="https://www.kemper-amps.com/downloads"
  ["Bome MIDI Translator Pro (log in for your licensed download)"]="https://www.bome.com/downloads"
  ["Reolink Client (not on Homebrew)"]="https://reolink.com/us/software-and-manual/"
)
for name in "${!MANUAL[@]}"; do
  url="${MANUAL[$name]}"
  open "$url" 2>/dev/null && ok "$name (opened $url)" || fail "$name (couldn't open $url)"
done

# ---- summary ----------------------------------------------------------
log "Summary"
echo "Installed OK: ${#OK[@]}"
echo "Failed:       ${#FAILED[@]}"
echo "Skipped:      ${#SKIPPED[@]}"
if [ ${#FAILED[@]} -gt 0 ]; then
  printf '\nFailed items:\n'
  printf '  - %s\n' "${FAILED[@]}"
fi

cat <<'EOF'

Still needs you, by hand:
  - Kemper: install the macOS driver, then Rig Manager — restore the library from
    Z:\Mac Migration\2026-08-18 16-09-47 - David.rmbackup via Tools > Restore Rig Manager Content
  - Bome MIDI Translator Pro: log into your Bome account for the licensed download + key
  - Reolink Client: download from reolink.com (not packaged for Homebrew)
  - VeraCrypt (fuse-t): no kernel-extension approval needed (that's the point of the
    fuse-t backend) — should just work after install
  - Sign into Google Drive, Google Chrome, Proton VPN, Spotify, and any App Store apps
    that were skipped
EOF
