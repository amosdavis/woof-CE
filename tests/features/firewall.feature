Feature: Firewall Security
  As a Puppy Linux user
  I want a firewall enabled by default
  So that my system is protected from network attacks

  Scenario: Default firewall script exists
    Given the rootfs-skeleton directory exists
    Then the file "etc/rc.d/rc.firewall" should exist
    And the file "etc/rc.d/rc.firewall" should be executable
    And the file "etc/rc.d/firewall.conf" should exist

  Scenario: Firewall denies inbound by default
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "INPUT DROP"
    And it should contain "FORWARD DROP"
    And it should contain "OUTPUT ACCEPT"

  Scenario: Firewall has SYN flood protection
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "syn" 
    And it should contain "limit"

  Scenario: Firewall allows established connections
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "ESTABLISHED,RELATED"

  Scenario: Firewall drops invalid packets
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "INVALID"
    And it should contain "DROP"

  Scenario: Firewall logs dropped packets
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "LOG"
    And it should contain "FW_DROP"

  Scenario: Firewall supports IPv6
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "ip6tables"

  Scenario: Firewall is started on boot
    Given the boot init script "etc/rc.d/rc.sysinit" exists
    Then it should contain "rc.firewall"

  Scenario: Firewall blocks XMAS and NULL packets
    Given the firewall script "etc/rc.d/rc.firewall" exists
    Then it should contain "ALL ALL"
    And it should contain "ALL NONE"
