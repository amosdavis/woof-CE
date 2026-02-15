#!/bin/sh
# /etc/profile.d/security-hardening.sh
# Security environment settings applied at login
# Addresses: PATH hijacking, core dumps, history security, umask,
# Unicode/locale safety, environment sanitization

# Secure umask: files created are not world-readable by default
umask 027

# Ensure PATH does not contain current directory (prevents PATH hijacking)
PATH=$(echo "$PATH" | sed -e 's/:\.:/:/g' -e 's/^\.://' -e 's/:\.$//')
export PATH

# Prevent core dumps in user sessions (data leak prevention)
ulimit -c 0

# Secure history settings (prevent history injection/leakage)
export HISTCONTROL=ignoreboth
export HISTIGNORE='*password*:*secret*:*token*:*key*'
export HISTSIZE=1000
export HISTFILESIZE=2000

# Auto-timeout idle shells (15 minutes)
TMOUT=900
export TMOUT
readonly TMOUT

# Unicode/locale safety: ensure valid locale to prevent encoding exploits
# (homoglyph attacks, buffer overflows from malformed UTF-8, bidi attacks)
if [ -z "$LANG" ] || ! locale -a 2>/dev/null | grep -q "^${LANG}$"; then
  if locale -a 2>/dev/null | grep -q 'en_US.utf8'; then
    export LANG=en_US.UTF-8
  elif locale -a 2>/dev/null | grep -q 'C.utf8'; then
    export LANG=C.UTF-8
  else
    export LANG=C
  fi
fi
export LC_ALL="${LC_ALL:-$LANG}"

# Sanitize terminal: reset escape sequences that could be abused
# Prevents terminal escape injection attacks
if [ -t 1 ]; then
  printf '\033[0m' 2>/dev/null
fi
