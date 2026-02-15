#!/bin/sh
# suspend.sh - Improved suspend/resume handler for Puppy Linux
# Original: 28sep09 by shinobar
# Enhanced: addresses unreliable suspend/resume, WiFi dropout after resume,
# USB device issues, audio state loss, filesystem corruption on suspend

ACPI_CONFIG=/etc/acpi/acpi.conf
[ -s "$ACPI_CONFIG" ] && . "$ACPI_CONFIG"
case "$DISABLE_SUSPEND" in
y*|Y*|true|True|TRUE|1) exit;;
esac

# Avoid multiple simultaneous suspend attempts
LOCKFILE=/tmp/acpi_suspend-flg
if [ -f "$LOCKFILE" ]; then
  PID=$(cat "$LOCKFILE")
  ps | grep "^[ ]*$PID " && exit
fi
echo -n $$ > "$LOCKFILE"
sync
[ "$(cat "$LOCKFILE")" = $$ ] || exit 0

# Do not suspend during shutdown
PS=$(ps)
[ ! -f /tmp/suspend ] && echo "$PS" | grep -qE 'sh[ ].*poweroff' && rm -f "$LOCKFILE" && exit 0
rm -f /tmp/suspend

. /etc/DISTRO_SPECS

# Do not suspend if USB media is mounted (prevents data corruption)
if [ "$DISTRO_TARGETARCH" = "x86" ] || [ "$DISTRO_TARGETARCH" = "x86_64" ]; then
	USBS=$(probedisk2 2>/dev/null | grep '|usb' | cut -d'|' -f1)
	for USB in $USBS; do
		mount | grep -q "^$USB" && rm -f "$LOCKFILE" && exit 0
	done
fi

#--- Pre-suspend hooks ---

# Sync all filesystems (prevent corruption on power loss)
sync; sync

# Save ALSA audio state (prevents audio loss after resume)
if command -v alsactl >/dev/null 2>&1; then
	alsactl store 2>/dev/null
fi

# Record WiFi interface state for post-resume restoration
WIFI_IFACE=""
WIFI_DRIVER=""
for iface in /sys/class/net/wlan* /sys/class/net/wlp*; do
	[ -d "$iface" ] || continue
	WIFI_IFACE=$(basename "$iface")
	WIFI_DRIVER=$(basename $(readlink "$iface/device/driver" 2>/dev/null) 2>/dev/null)
	break
done

# Stop network services cleanly before suspend
if [ -n "$WIFI_IFACE" ]; then
	wpa_cli -i "$WIFI_IFACE" disconnect 2>/dev/null
fi

# Unload problematic USB host controller modules
[ "$DISTRO_TARGETARCH" = "x86" ] && rmmod ehci_hcd 2>/dev/null

#--- Suspend ---
case "$DISABLE_LOCK" in
y*|Y*|true|True|TRUE|1) echo -n mem > /sys/power/state ;;
*)
  if [ -n "$WAYLAND_DISPLAY" ]; then
    puplock
    echo mem > /sys/power/state
  elif [ -n "$DISPLAY" ] && [ -z "$(pidof -s xlock)" ]; then
    xlock -startCmd "echo mem > /sys/power/state"
  else
    echo -n mem > /sys/power/state
  fi
  ;;
esac

#--- Post-resume hooks ---

# Reload USB host controller
[ "$DISTRO_TARGETARCH" = "x86" ] && modprobe ehci_hcd 2>/dev/null

# Restore ALSA audio state
if command -v alsactl >/dev/null 2>&1; then
	alsactl restore 2>/dev/null
fi

# Restore WiFi connection
if [ -n "$WIFI_IFACE" ]; then
	# Attempt to reconnect; if that fails, reload the WiFi driver
	if ! wpa_cli -i "$WIFI_IFACE" reconnect 2>/dev/null; then
		if [ -n "$WIFI_DRIVER" ]; then
			modprobe -r "$WIFI_DRIVER" 2>/dev/null
			sleep 1
			modprobe "$WIFI_DRIVER" 2>/dev/null
			sleep 2
			# Restart network service
			[ -x /etc/rc.d/rc.network ] && /etc/rc.d/rc.network restart 2>/dev/null &
		fi
	fi
fi

# Re-sync hardware clock
hwclock --hctosys 2>/dev/null

# Sync filesystem after resume
sync

rm -f "$LOCKFILE"

