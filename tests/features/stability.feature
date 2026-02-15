Feature: System Stability and Recovery
  As a Puppy Linux user
  I want robust crash recovery and system stability
  So that my system recovers from failures automatically

  Scenario: Kernel panic auto-reboots
    Given the boot init script "etc/rc.d/rc.sysinit" exists
    Then it should configure kernel panic timeout
    And it should contain "kernel/panic"

  Scenario: CPU vulnerability mitigations are verified
    Given the boot init script "etc/rc.d/rc.sysinit" exists
    Then it should check for "mitigations=off"
    And it should warn if mitigations are disabled

  Scenario: Suspend saves ALSA audio state
    Given the suspend script "rootfs-packages/acpid_busybox/etc/acpi/actions/suspend.sh" exists
    Then it should contain "alsactl store"
    And it should contain "alsactl restore"

  Scenario: Suspend handles WiFi reconnection
    Given the suspend script "rootfs-packages/acpid_busybox/etc/acpi/actions/suspend.sh" exists
    Then it should detect WiFi interface
    And it should reconnect WiFi after resume
    And it should support WiFi driver reload

  Scenario: Suspend syncs filesystem before sleeping
    Given the suspend script "rootfs-packages/acpid_busybox/etc/acpi/actions/suspend.sh" exists
    Then it should call "sync" before suspend

  Scenario: Resume re-syncs hardware clock
    Given the suspend script "rootfs-packages/acpid_busybox/etc/acpi/actions/suspend.sh" exists
    Then it should contain "hwclock"

  Scenario: NTP time synchronization service exists
    Given the rootfs-skeleton directory exists
    Then the file "etc/init.d/15ntpd-lite" should exist
    And it should use UTC for hardware clock
    And it should support NTP daemon

  Scenario: Resource limits prevent fork bombs
    Given the rootfs-skeleton directory exists
    Then the file "etc/security/limits.d/99-puppy-hardening.conf" should exist
    And it should limit nproc
    And it should limit nofile
    And it should disable core dumps

  Scenario: Tmp is mounted with security options
    Given the boot init script "etc/rc.d/rc.sysinit" exists
    Then tmpfs mount should include "nosuid"
    And tmpfs mount should include "nodev"
