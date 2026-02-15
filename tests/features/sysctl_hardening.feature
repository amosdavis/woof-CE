Feature: Kernel Sysctl Hardening
  As a Puppy Linux user
  I want kernel security parameters hardened by default
  So that my system is protected from memory, network, and information disclosure attacks

  Scenario: Sysctl hardening configuration exists
    Given the rootfs-skeleton directory exists
    Then the file "etc/sysctl.d/99-puppy-hardening.conf" should exist

  Scenario: ASLR is fully enabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "kernel.randomize_va_space = 2"

  Scenario: Ptrace is restricted
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "kernel.yama.ptrace_scope = 1"

  Scenario: Kernel pointers are hidden
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "kernel.kptr_restrict = 2"

  Scenario: Dmesg is restricted to root
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "kernel.dmesg_restrict = 1"

  Scenario: SUID core dumps are prevented
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "fs.suid_dumpable = 0"

  Scenario: Hardlinks and symlinks are protected
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "fs.protected_hardlinks = 1"
    And it should contain "fs.protected_symlinks = 1"

  Scenario: IP forwarding is disabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.ip_forward = 0"

  Scenario: SYN cookies are enabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.tcp_syncookies = 1"

  Scenario: Source routing is disabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.conf.all.accept_source_route = 0"

  Scenario: ICMP redirects are disabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.conf.all.accept_redirects = 0"
    And it should contain "net.ipv4.conf.all.send_redirects = 0"

  Scenario: Reverse path filtering is enabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.conf.all.rp_filter = 1"

  Scenario: Martian packets are logged
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.conf.all.log_martians = 1"

  Scenario: ICMP broadcast is ignored
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv4.icmp_echo_ignore_broadcasts = 1"

  Scenario: BPF JIT hardening is enabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.core.bpf_jit_harden = 2"

  Scenario: Kexec is disabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "kernel.kexec_load_disabled = 1"

  Scenario: IPv6 source routing is disabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv6.conf.all.accept_source_route = 0"

  Scenario: IPv6 redirects are disabled
    Given the sysctl config "etc/sysctl.d/99-puppy-hardening.conf" exists
    Then it should contain "net.ipv6.conf.all.accept_redirects = 0"
