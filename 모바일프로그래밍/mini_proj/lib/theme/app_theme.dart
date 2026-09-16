import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Outfeed 디자인 시스템 — 글래스모피즘 라이트 테마
class AppColors {
  AppColors._();

  // Core
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF1A1A2E);

  // Background — 연한 라벤더-화이트
  static const background = Color(0xFFF6F5FB);
  static const backgroundPure = Color(0xFFFFFFFF);

  // Surfaces (Glassmorphism)
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSecondary = Color(0xFFF0EFF5);
  static const surfaceTertiary = Color(0xFFE8E7EF);

  // Glass surface colors (반투명)
  static Color glassWhite = Colors.white.withValues(alpha: 0.55);
  static Color glassBorder = Colors.white.withValues(alpha: 0.6);

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B6B80);
  static const textTertiary = Color(0xFF9E9EB0);

  // Brand Accent — 기존 시그니처 컬러 유지 (teal → green)
  static const accentTeal = Color(0xFF2EC4B6);
  static const accentGreen = Color(0xFF7FD48A);
  static const accentMint = Color(0xFF6FEDD6);

  // Semantic
  static const separator = Color(0xFFE8E8EE);

  // Brand Gradient — teal-cyan → soft-green
  static const brandGradient = LinearGradient(
    colors: [accentTeal, accentGreen],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Premium Gradient — mint → teal
  static const mintGradient = LinearGradient(
    colors: [Color(0xFF00E5BF), accentMint],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// 글래스모피즘 BoxDecoration — BackdropFilter와 함께 사용
  static BoxDecoration glassDecoration({
    double radius = 20,
    Color? color,
    double opacity = 0.55,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.6),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// 카드 기본 BoxDecoration (글래스모피즘 스타일)
  static BoxDecoration cardDecoration({
    double radius = 20,
    Color? color,
  }) {
    return glassDecoration(radius: radius, color: color);
  }
}

/// 글래스모피즘 컨테이너 위젯 — BackdropFilter 포함
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;

  const GlassContainer({
    super.key,
    required this.child,
    this.radius = 20,
    this.padding,
    this.margin,
    this.blur = 20,
    this.opacity = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: AppColors.glassDecoration(
              radius: radius,
              opacity: opacity,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    );

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.accentTeal,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentTeal,
        secondary: AppColors.accentGreen,
        surface: AppColors.surface,
        onPrimary: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 34, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary, letterSpacing: -0.5,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          fontSize: 28, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary, letterSpacing: -0.3,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 22, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 15, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 17, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary, height: 1.5,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 15, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary, height: 1.4,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          fontSize: 13, fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 15, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          fontSize: 11, fontWeight: FontWeight.w500,
          color: AppColors.textTertiary, letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.accentTeal,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400),
      ),
    );
  }

  /// Legacy alias
  static ThemeData get dark => light;
}
