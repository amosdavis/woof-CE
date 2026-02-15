Feature: Supply Chain and Build Integrity
  As a Puppy Linux developer
  I want build downloads to be integrity-verified
  So that supply chain attacks are prevented

  Scenario: Download script prefers certificate validation
    Given the download script "support/download_file.sh" exists
    Then it should attempt download with certificate validation first
    And it should warn when falling back to no-check-certificate

  Scenario: Build system checks for Heartbleed-vulnerable OpenSSL
    Given the build script "3builddistro" exists
    Then it should check OpenSSL version
    And it should warn about CVE-2014-0160

  Scenario: Build system checks for Shellshock-vulnerable bash
    Given the build script "3builddistro" exists
    Then it should check bash version
    And it should warn about CVE-2014-6271

  Scenario: Build system checks for Log4Shell Java
    Given the build script "3builddistro" exists
    Then it should check for Java presence
    And it should warn about CVE-2021-44228

  Scenario: Build system checks for XZ Utils backdoor
    Given the build script "3builddistro" exists
    Then it should check XZ version
    And it should warn about CVE-2024-3094

  Scenario: Filesystem integrity checked on boot
    Given the boot init script "etc/rc.d/rc.sysinit" exists
    Then it should detect filesystem errors via dmesg
    And it should run e2fsck when errors are found

  Scenario: Leap second handling in NTP
    Given the NTP service "etc/init.d/15ntpd-lite" exists
    Then it should handle leap seconds
    And it should use kernel leap smearing

  Scenario: Unicode locale safety
    Given the security profile "etc/profile.d/security-hardening.sh" exists
    Then it should validate locale
    And it should set UTF-8 encoding
    And it should sanitize terminal escape sequences
