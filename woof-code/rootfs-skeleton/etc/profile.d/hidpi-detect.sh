#!/bin/sh
# /etc/profile.d/hidpi-detect.sh
# Auto-detect HiDPI displays and set appropriate scaling
# Addresses: HiDPI scaling inconsistency across toolkits

detect_dpi() {
    # Try to get DPI from Xorg
    if command -v xdpyinfo >/dev/null 2>&1; then
        DPI=$(xdpyinfo 2>/dev/null | grep 'resolution' | head -1 | awk '{print $2}' | cut -d'x' -f1)
    fi

    # Fallback: try xrandr
    if [ -z "$DPI" ] || [ "$DPI" = "0" ]; then
        if command -v xrandr >/dev/null 2>&1; then
            # Calculate DPI from resolution and physical size
            XRES=$(xrandr 2>/dev/null | grep '\*' | head -1 | awk '{print $1}' | cut -d'x' -f1)
            XMM=$(xrandr 2>/dev/null | grep ' connected' | head -1 | grep -o '[0-9]*mm' | head -1 | tr -d 'mm')
            if [ -n "$XRES" ] && [ -n "$XMM" ] && [ "$XMM" -gt 0 ] 2>/dev/null; then
                DPI=$(( XRES * 254 / XMM / 10 ))
            fi
        fi
    fi

    # Default to 96 DPI
    [ -z "$DPI" ] && DPI=96

    echo "$DPI"
}

setup_scaling() {
    DPI=$(detect_dpi)

    # Only apply scaling if display is present
    [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && return

    if [ "$DPI" -ge 192 ]; then
        SCALE=2
    elif [ "$DPI" -ge 144 ]; then
        SCALE=1.5
    elif [ "$DPI" -ge 120 ]; then
        SCALE=1.25
    else
        SCALE=1
    fi

    # GTK 3/4 scaling
    export GDK_SCALE=$SCALE
    export GDK_DPI_SCALE=$(echo "scale=2; 1/$SCALE" | bc 2>/dev/null || echo "1")

    # Qt scaling
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_SCALE_FACTOR=$SCALE

    # Xft DPI
    if [ "$DPI" -gt 96 ]; then
        echo "Xft.dpi: $DPI" | xrdb -merge 2>/dev/null
    fi
}

# Only run in graphical sessions
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    setup_scaling
fi
