import 'package:flutter/material.dart';

/// App color palette based on the design system
/// Contains Primary, Neutral, Error, Warning, and Success color scales
class AppColors {
  // Prevent instantiation
  AppColors._();

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  static const Color primary100 = Color(0xFFE0F2F1);
  static const Color primary200 = Color(0xFFB2DFDB);
  static const Color primary300 = Color(0xFF80CBC4);
  static const Color primary400 = Color(0xFF4DB6AC);
  static const Color primary500 = Color(0xFF26A69A);
  static const Color primary600 = Color(0xFF009688);
  static const Color primary700 = Color(0xFF00897B);
  static const Color primary800 = Color(0xFF00796B);
  static const Color primary900 = Color(0xFF004D40);

  /// Default primary color
  static const Color primary = primary600;
  static const Color secondary = Color(0xFF555ECC);

  // ============================================================================
  // NEUTRAL COLORS (Grays)
  // ============================================================================

  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  /// Common neutral aliases
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray = neutral500;
  static const Color darkGray = neutral700;
  static const Color lightGray = neutral300;

  // ============================================================================
  // ERROR COLORS (Reds)
  // ============================================================================

  static const Color error100 = Color(0xFFFFCDD2);
  static const Color error200 = Color(0xFFEF9A9A);
  static const Color error300 = Color(0xFFE57373);
  static const Color error400 = Color(0xFFEF5350);
  static const Color error500 = Color(0xFFF44336);
  static const Color error600 = Color(0xFFE53935);
  static const Color error700 = Color(0xFFD32F2F);
  static const Color error800 = Color(0xFFC62828);
  static const Color error900 = Color(0xFFB71C1C);

  /// Default error color
  static const Color error = error600;

  // ============================================================================
  // WARNING COLORS (Yellows/Ambers)
  // ============================================================================

  static const Color warning100 = Color(0xFFFFF9C4);
  static const Color warning200 = Color(0xFFFFF59D);
  static const Color warning300 = Color(0xFFFFF176);
  static const Color warning400 = Color(0xFFFFEE58);
  static const Color warning500 = Color(0xFFFFEB3B);
  static const Color warning600 = Color(0xFFFDD835);
  static const Color warning700 = Color(0xFFFBC02D);
  static const Color warning800 = Color(0xFFF9A825);
  static const Color warning900 = Color(0xFFF57F17);

  /// Default warning color
  static const Color warning = warning600;

  // ============================================================================
  // SUCCESS COLORS (Greens)
  // ============================================================================

  static const Color success100 = Color(0xFFC8E6C9);
  static const Color success200 = Color(0xFFA5D6A7);
  static const Color success300 = Color(0xFF81C784);
  static const Color success400 = Color(0xFF66BB6A);
  static const Color success500 = Color(0xFF4CAF50);
  static const Color success600 = Color(0xFF43A047);
  static const Color success700 = Color(0xFF388E3C);
  static const Color success800 = Color(0xFF2E7D32);
  static const Color success900 = Color(0xFF1B5E20);

  /// Default success color
  static const Color success = success600;

  // ============================================================================
  // SEMANTIC COLORS (Based on context)
  // ============================================================================

  /// Background colors
  static const Color background = white;
  static const Color backgroundDark = neutral900;
  static const Color surface = white;
  static const Color surfaceDark = neutral800;

  /// Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textDisabled = neutral400;
  static const Color textOnPrimary = white;
  static const Color textOnDark = white;

  /// Border colors
  static const Color border = neutral300;
  static const Color borderDark = neutral600;
  static const Color divider = neutral200;

  /// Interactive states
  static const Color hover = neutral100;
  static const Color pressed = neutral200;
  static const Color focus = primary200;
  static const Color disabled = neutral300;

  // ============================================================================
  // BRAND COLORS (Glow App Specific)
  // ============================================================================

  /// Main brand color (green from design)
  static const Color brandPrimary = Color(0xFF2D6A4F);
  static const Color brandSecondary = Color(0xFF52B788);
  static const Color brandLight = Color(0xFFD8F3DC);
  static const Color brandDark = Color(0xFF1B4332);

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get primary color shade
  static Color getPrimaryShade(int shade) {
    switch (shade) {
      case 100:
        return primary100;
      case 200:
        return primary200;
      case 300:
        return primary300;
      case 400:
        return primary400;
      case 500:
        return primary500;
      case 600:
        return primary600;
      case 700:
        return primary700;
      case 800:
        return primary800;
      case 900:
        return primary900;
      default:
        return primary;
    }
  }

  /// Get neutral color shade
  static Color getNeutralShade(int shade) {
    switch (shade) {
      case 100:
        return neutral100;
      case 200:
        return neutral200;
      case 300:
        return neutral300;
      case 400:
        return neutral400;
      case 500:
        return neutral500;
      case 600:
        return neutral600;
      case 700:
        return neutral700;
      case 800:
        return neutral800;
      case 900:
        return neutral900;
      default:
        return gray;
    }
  }
}
