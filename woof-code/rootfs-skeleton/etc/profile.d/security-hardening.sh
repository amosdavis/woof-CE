#!/bin/sh
# /etc/profile.d/security-hardening.sh
# Security environment settings applied at login
# Addresses: PATH hijacking, core dumps, history security, umask

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
