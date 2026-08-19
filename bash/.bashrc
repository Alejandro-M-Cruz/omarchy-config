# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Omarchy 4 starts hyprsunset lazily (autostart.conf is no longer read), so make
# sure the daemon is up before talking to its socket.
function _hyprsunset_up() {
  pgrep -x hyprsunset >/dev/null && return 0
  setsid uwsm-app -- hyprsunset >/dev/null 2>&1 &
  for _ in {1..20}; do
    hyprctl hyprsunset gamma >/dev/null 2>&1 && return 0
    sleep 0.1
  done
  echo "hyprsunset did not come up" >&2
  return 1
}

# Software dimming, 0-100. Goes below what the monitor buttons allow.
function gamma() {
  _hyprsunset_up || return 1
  [[ -z "$1" ]] && { hyprctl hyprsunset gamma; return; }
  hyprctl hyprsunset gamma "$1"
}

# Colour temperature in K. Lower = warmer (nightlight is 4000, neutral 6500).
function temperature() {
  _hyprsunset_up || return 1
  [[ -z "$1" ]] && { hyprctl hyprsunset temperature; return; }
  hyprctl hyprsunset temperature "$1"
}

. "$HOME/.local/share/../bin/env"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
