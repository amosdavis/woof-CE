Feature: User Interface Quality
  As a Puppy Linux user
  I want good font rendering and display quality
  So that text is clear and readable on all displays

  Scenario: Font rendering config exists
    Given the rootfs-skeleton directory exists
    Then the file "etc/fonts/local.conf" should exist

  Scenario: Antialiasing is enabled
    Given the font config "etc/fonts/local.conf" exists
    Then it should enable antialiasing
    And it should set rgba subpixel rendering
    And it should set slight hinting
    And it should enable LCD filter

  Scenario: Bitmap fonts are disabled
    Given the font config "etc/fonts/local.conf" exists
    Then it should reject bitmap fonts

  Scenario: Font fallbacks are configured
    Given the font config "etc/fonts/local.conf" exists
    Then it should define serif fallback fonts
    And it should define sans-serif fallback fonts
    And it should define monospace fallback fonts

  Scenario: HiDPI auto-detection exists
    Given the rootfs-skeleton directory exists
    Then the file "etc/profile.d/hidpi-detect.sh" should exist
    And it should detect display DPI
    And it should set GDK_SCALE
    And it should set QT_AUTO_SCREEN_SCALE_FACTOR

  Scenario: No telemetry or phone-home exists
    Given the rootfs-skeleton directory exists
    Then no file should contain telemetry endpoints
    And no file should contain analytics tracking
    And no file should contain advertising URLs

  Scenario: No bloatware or ads
    Given the rootfs-skeleton directory exists
    Then no desktop file should contain ad-related categories
    And no startup script should download advertising content

  Scenario: Security profile is applied at login
    Given the rootfs-skeleton directory exists
    Then the file "etc/profile.d/security-hardening.sh" should exist
    And it should set secure umask
    And it should remove current directory from PATH
    And it should set idle timeout
