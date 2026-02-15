Feature: Network Security
  As a Puppy Linux user
  I want hardened network configurations
  So that my system is protected from network-based attacks

  Scenario: SSH server is hardened
    Given the rootfs-skeleton directory exists
    Then the file "etc/ssh/sshd_config" should exist
    And it should contain "PermitRootLogin no"
    And it should contain "PasswordAuthentication no"
    And it should contain "MaxAuthTries 3"
    And it should contain "X11Forwarding no"
    And it should contain "AllowAgentForwarding no"
    And it should contain "Protocol 2"

  Scenario: SSH uses strong ciphers only
    Given the SSH config "etc/ssh/sshd_config" exists
    Then it should contain "chacha20-poly1305"
    And it should contain "aes256-gcm"
    And it should not contain "arcfour"
    And it should not contain "3des"

  Scenario: WPA supplicant disables WEP
    Given the WPA config files exist
    Then no WPA config should contain "key_mgmt=NONE"
    And WPA configs should prefer "CCMP" cipher
    And WPA configs should enable PMF

  Scenario: WPA supplicant uses secure protocols
    Given the WPA profile "rootfs-packages/network_wizard/etc/network-wizard/wireless/wpa_profiles/wpa_supplicant.conf" exists
    Then it should contain "proto=RSN"
    And it should contain "pairwise=CCMP"
    And it should contain "pmf=1"

  Scenario: DNS resolver has security limits
    Given the rootfs-skeleton directory exists
    Then the file "etc/resolv-puppy-defaults.conf" should exist
    And it should contain "timeout"
    And it should contain "attempts"

  Scenario: Certificate validation is never disabled
    Given the rootfs-hacks script exists
    Then it should not contain "check_certificate = off"

  Scenario: Bluetooth is not discoverable by default
    Given the rootfs-skeleton directory exists
    Then the file "etc/bluetooth/main.conf.puppy" should exist
    And it should contain "Discoverable = false"

  Scenario: Bluetooth requires authentication
    Given the bluetooth config "etc/bluetooth/main.conf.puppy" exists
    Then it should contain "JustWorksRepairing = confirm"

  Scenario: Kernel module blacklist blocks dangerous protocols
    Given the rootfs-skeleton directory exists
    Then the file "etc/modprobe.d/security-hardening.conf" should exist
    And it should contain "dccp"
    And it should contain "sctp"
    And it should contain "firewire-core"

  Scenario: SSH banner exists
    Given the rootfs-skeleton directory exists
    Then the file "etc/ssh/banner" should exist
    And it should contain "Authorized access only"
