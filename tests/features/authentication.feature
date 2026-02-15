Feature: Authentication and Access Control
  As a Puppy Linux user
  I want proper authentication and access controls
  So that unauthorized access is prevented

  Scenario: No static password hashes in shadow
    Given the rootfs-skeleton directory exists
    Then the file "etc/shadow" should not contain "$1$"
    And the file "etc/shadow" should not contain "$5$"
    And the file "etc/shadow" should not contain "$6$"

  Scenario: All system accounts are locked
    Given the shadow file "etc/shadow" exists
    Then the account "haldaemon" should be locked
    And the account "uucp" should be locked
    And the account "sshd" should be locked
    And the account "daemon" should be locked
    And the account "nobody" should be locked
    And the account "ftp" should be locked
    And the account "webuser" should be locked
    And the account "bin" should be locked

  Scenario: Shadow file has correct permissions
    Given the rootfs-hacks script exists
    Then it should set permissions "600" on "etc/shadow"
    And it should set permissions "600" on "etc/gshadow"
    And it should set permissions "640" on "etc/sudoers"

  Scenario: Home directories are protected
    Given the rootfs-hacks script exists
    Then it should set permissions "700" on "root"
    And it should set permissions "700" on "home/spot"

  Scenario: Var directory is not world-writable
    Given the rootfs-hacks script exists
    Then it should set permissions "755" on "var"

  Scenario: SUID binaries are minimized
    Given the rootfs-hacks script exists
    Then it should audit SUID binaries
    And it should remove SUID from "chage"
    And it should remove SUID from "chfn"
    And it should remove SUID from "chsh"

  Scenario: First boot password setup exists
    Given the rootfs-skeleton directory exists
    Then the file "usr/sbin/puppy-firstboot-security" should exist
    And the file "usr/sbin/puppy-firstboot-security" should contain "passwd"

  Scenario: First boot security is triggered at startup
    Given the delayedrun script exists
    Then it should contain "puppy-firstboot-security"

  Scenario: Internet apps run as non-root user
    Given the rootfs-skeleton directory exists
    Then the desktop file "usr/share/applications/defaultbrowser.desktop" should contain "run-as-spot"
    And the desktop file "usr/share/applications/defaultemail.desktop" should contain "run-as-spot"
    And the desktop file "usr/share/applications/defaultchat.desktop" should contain "run-as-spot"
    And the desktop file "usr/share/applications/defaulttorrent.desktop" should contain "run-as-spot"
