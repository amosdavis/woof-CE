Feature: Build System Security
  As a Puppy Linux developer
  I want the build system to produce hardened binaries
  So that the resulting OS is resistant to memory corruption attacks

  Scenario: Compiler uses stack protector
    Given the petbuilds script "support/petbuilds.sh" exists
    Then it should contain "-fstack-protector-strong"

  Scenario: Compiler uses FORTIFY_SOURCE
    Given the petbuilds script "support/petbuilds.sh" exists
    Then it should contain "-D_FORTIFY_SOURCE=2"

  Scenario: Compiler produces PIE binaries
    Given the petbuilds script "support/petbuilds.sh" exists
    Then it should contain "-fPIE"
    And it should contain "-pie"

  Scenario: Linker uses full RELRO
    Given the petbuilds script "support/petbuilds.sh" exists
    Then it should contain "-Wl,-z,relro"
    And it should contain "-Wl,-z,now"

  Scenario: Compiler enforces format string safety
    Given the petbuilds script "support/petbuilds.sh" exists
    Then it should contain "-Wformat"
    And it should contain "-Wformat-security"

  Scenario: Downloads are checksum verified
    Given the petbuilds script "support/petbuilds.sh" exists
    Then it should verify SHA256 checksums
    And it should warn when checksums are missing

  Scenario: Wget certificate validation is not disabled
    Given the rootfs-hacks script "support/rootfs-hacks.sh" exists
    Then it should not contain "check_certificate = off"
    And it should warn about missing ca-certificates
