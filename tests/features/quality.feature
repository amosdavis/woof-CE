Feature: Non-Security Quality Issues
  Puppy Linux must address non-security issues from os_issues.md
  including UX, hardware, stability, performance, and design quality

  Scenario: JWM crash recovery tool exists
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-jwm-recovery" should exist
    And the file "usr/sbin/puppy-jwm-recovery" should be a shell script

  Scenario: Memory watchdog tool exists
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-memory-watchdog" should exist
    And the file "usr/sbin/puppy-memory-watchdog" should be a shell script

  Scenario: Hardware detection tool exists
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-hardware-check" should exist
    And the file "usr/sbin/puppy-hardware-check" should be a shell script

  Scenario: Process killer available in menu
    Given the rootfs skeleton directory
    Then the file "usr/share/applications/puppy-xkill.desktop" should exist
    And the file "usr/share/applications/puppy-xkill.desktop" should contain "xkill"

  Scenario: Desktop restart available without rebooting
    Given the rootfs skeleton directory
    Then the file "usr/share/applications/puppy-restart-desktop.desktop" should exist
    And the file "usr/share/applications/puppy-restart-desktop.desktop" should contain "jwm-recovery restart"

  Scenario: Multi-monitor setup tool exists
    Given the rootfs skeleton directory
    Then the file "usr/sbin/xrandr-gui" should exist
    And the file "usr/sbin/xrandr-gui" should be a shell script
    And the file "usr/share/applications/puppy-monitor-setup.desktop" should exist

  Scenario: Fast file search tool exists
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-search" should exist
    And the file "usr/sbin/puppy-search" should be a shell script

  Scenario: Dark theme consistency tool exists
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-theme-manager" should exist
    And the file "usr/sbin/puppy-theme-manager" should contain "gtk-application-prefer-dark-theme"
    And the file "usr/sbin/puppy-theme-manager" should contain "QT_STYLE_OVERRIDE"

  Scenario: Hardware check runs on first boot
    Given the rootfs skeleton directory
    Then the file "usr/sbin/delayedrun" should contain "puppy-hardware-check"

  Scenario: JWM watchdog starts with X session
    Given the rootfs skeleton directory
    Then the file "root/.xinitrc" should contain "puppy-jwm-recovery watchdog"

  Scenario: Memory watchdog starts with X session
    Given the rootfs skeleton directory
    Then the file "root/.xinitrc" should contain "puppy-memory-watchdog start"

  Scenario: Bluetooth audio codecs configured for PipeWire
    Given the rootfs skeleton directory
    Then the file "etc/pipewire/media-session.d/bluez-monitor.conf" should exist
    And the file "etc/pipewire/media-session.d/bluez-monitor.conf" should contain "sbc_xq"
    And the file "etc/pipewire/media-session.d/bluez-monitor.conf" should contain "ldac"

  Scenario: Build system sets permissions on UX tools
    Given the build support directory
    Then the file "rootfs-hacks.sh" should contain "puppy-hardware-check"
    And the file "rootfs-hacks.sh" should contain "puppy-jwm-recovery"
    And the file "rootfs-hacks.sh" should contain "puppy-memory-watchdog"
    And the file "rootfs-hacks.sh" should contain "xrandr-gui"
    And the file "rootfs-hacks.sh" should contain "puppy-theme-manager"
    And the file "rootfs-hacks.sh" should contain "puppy-search"

  Scenario: Hardware check detects WiFi adapter issues
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-hardware-check" should contain "lspci"
    And the file "usr/sbin/puppy-hardware-check" should contain "wireless"
    And the file "usr/sbin/puppy-hardware-check" should contain "firmware"

  Scenario: Hardware check detects GPU issues
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-hardware-check" should contain "nvidia"
    And the file "usr/sbin/puppy-hardware-check" should contain "nouveau"
    And the file "usr/sbin/puppy-hardware-check" should contain "amdgpu"

  Scenario: Hardware check detects scanner
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-hardware-check" should contain "scanimage"
    And the file "usr/sbin/puppy-hardware-check" should contain "SANE"

  Scenario: Memory watchdog has OOM prevention
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-memory-watchdog" should contain "MemAvailable"
    And the file "usr/sbin/puppy-memory-watchdog" should contain "drop_caches"

  Scenario: JWM recovery has watchdog mode
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-jwm-recovery" should contain "watchdog"
    And the file "usr/sbin/puppy-jwm-recovery" should contain "fixmenus"

  Scenario: Theme manager handles all major toolkits
    Given the rootfs skeleton directory
    Then the file "usr/sbin/puppy-theme-manager" should contain "gtkrc-2.0"
    And the file "usr/sbin/puppy-theme-manager" should contain "gtk-3.0"
    And the file "usr/sbin/puppy-theme-manager" should contain "QT_STYLE_OVERRIDE"

  Scenario: Multi-monitor tool supports common layouts
    Given the rootfs skeleton directory
    Then the file "usr/sbin/xrandr-gui" should contain "right-of"
    And the file "usr/sbin/xrandr-gui" should contain "left-of"
    And the file "usr/sbin/xrandr-gui" should contain "same-as"
