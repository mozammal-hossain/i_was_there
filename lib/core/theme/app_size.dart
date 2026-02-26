/// Centralized size tokens for spacing, radius, icons, and components.
/// Use instead of hardcoded numbers for consistent layout and easy theming.
abstract class AppSize {
  AppSize._();

  // --- Spacing (padding, margins, gaps) ---
  static const double spacingXs = 2;
  static const double spacingS = 4;
  static const double spacingS2 = 6;
  static const double spacingM = 8;
  static const double spacingM2 = 10;
  static const double spacingM3 = 12;
  static const double spacingInputVertical = 14;
  static const double spacingL = 16;
  static const double spacingL2 = 20;
  static const double spacingXl = 24;
  static const double spacingXl2 = 26;
  static const double spacingXl3 = 32;
  static const double spacingXl4 = 40;
  static const double spacingXl5 = 48;
  static const double spacingXl6 = 56;
  static const double spacingXl7 = 60;
  static const double spacingXl8 = 80;
  static const double spacingXl9 = 100;
  static const double spacingHeroBottom = 120;
  static const double heroMinHeight = 320;

  // --- Border radius ---
  static const double radiusXs = 2;
  static const double radiusS = 3;
  static const double radiusM = 4;
  static const double radiusL = 12;
  static const double radiusXl = 16;
  static const double radiusXl2 = 20;
  static const double radiusXl3 = 22;
  static const double radiusCard = 24;
  static const double radiusSheet = 40;
  static const double radiusPill = 999;

  // --- Icon sizes ---
  static const double iconXs = 14;
  static const double iconS = 16;
  static const double iconS2 = 18;
  static const double iconM = 20;
  static const double iconM2 = 22;
  static const double iconL = 24;
  static const double iconL2 = 26;
  static const double iconL3 = 28;
  static const double iconNav = 32;
  static const double iconXl = 40;
  static const double iconXl2 = 48;
  static const double iconXl3 = 64;
  static const double iconXl4 = 80;

  // --- Component (heights, fixed dimensions) ---
  static const double handleHeight = 4;
  static const double handleWidth = 36;
  static const double progressHeight = 6;
  static const double avatarSm = 40;
  static const double avatarMd = 44;
  static const double avatarLg = 48;
  static const double buttonHeight = 56;
  static const double buttonHeightSm = 48;
  static const double dotSm = 8;
  static const double dotMd = 12;
  static const double stepIconSize = 40;
  static const double onboardingSpacer = 60;
  static const double mapPadding = 80;
  static const double heroIllustrationMaxHeight = 220;

  // --- Font sizes (optional typography scale) ---
  static const double fontCaption = 10;
  static const double fontCaption2 = 11;
  static const double fontSmall = 12;
  static const double fontBody2 = 13;
  static const double fontBodySm = 14;
  static const double fontBody = 15;
  static const double fontBodyLg = 16;
  static const double fontTitle = 17;
  static const double fontHeadlineSm = 18;

  // --- Border / stroke ---
  static const double borderWidth = 1;

  // --- Elevation ---
  static const double elevationNone = 0;
  static const double elevationFab = 8;
  static const double elevationFabExtended = 5;

  // --- Shadow ---
  static const double shadowBlurMd = 15;

  // --- Letter spacing ---
  static const double letterSpacingTight = 0.1;
  static const double letterSpacingSm = 0.15;
  static const double letterSpacingMd = 0.2;
  static const double letterSpacingLg = 0.5;
  static const double letterSpacingXl = 1.2;

  // --- Line height (TextStyle height multiplier) ---
  static const double lineHeightTight = 1.2;
  static const double lineHeightBody = 1.3;
  static const double lineHeightRelaxed = 1.4;
  static const double lineHeightLoose = 1.5;
}
