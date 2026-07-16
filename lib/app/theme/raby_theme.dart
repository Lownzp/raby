import 'package:flutter/material.dart';

import 'raby_colors.dart';
import 'raby_tokens.dart';

const rabyTextFontFamily = 'RabyChillRoundF';

abstract final class RabyTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: RabyColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: RabyColors.primary,
          onPrimary: RabyColors.onPrimary,
          secondary: RabyColors.secondary,
          surface: RabyColors.surface,
          error: RabyColors.danger,
          onSurface: RabyColors.textPrimary,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: RabyColors.background,
      fontFamily: rabyTextFontFamily,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: RabyColors.background,
        foregroundColor: RabyColors.textPrimary,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: RabyColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          fontFamily: rabyTextFontFamily,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          color: RabyColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          height: 1.18,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          color: RabyColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          height: 1.25,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          color: RabyColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          height: 1.3,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          color: RabyColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
          height: 1.35,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(
          color: RabyColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.5,
        ),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(
          color: RabyColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.5,
        ),
        labelLarge: base.textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        labelMedium: base.textTheme.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: RabyColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RabyRadius.lg),
          side: const BorderSide(color: RabyColors.stickerBorder, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: RabyColors.primary,
          foregroundColor: RabyColors.onPrimary,
          disabledBackgroundColor: RabyColors.surfaceWarm,
          disabledForegroundColor: RabyColors.textTertiary,
          minimumSize: const Size(48, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RabyRadius.pill),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: RabyColors.surface,
          minimumSize: const Size.square(52),
          foregroundColor: RabyColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RabyRadius.xl),
            side: const BorderSide(color: RabyColors.border),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RabyColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: RabySpacing.md,
          vertical: RabySpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RabyRadius.md),
          borderSide: const BorderSide(color: RabyColors.borderWarm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RabyRadius.md),
          borderSide: const BorderSide(color: RabyColors.borderWarm),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RabyRadius.md),
          borderSide: const BorderSide(color: RabyColors.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: Colors.transparent,
        indicatorColor: RabyColors.surfaceWarm,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RabyRadius.pill),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? RabyColors.primary : RabyColors.textSecondary,
            size: 24,
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: RabyColors.primary,
        foregroundColor: RabyColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(RabyRadius.xl)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: RabyColors.surfaceWarm,
        selectedColor: RabyColors.surfaceWarm,
        side: const BorderSide(color: RabyColors.borderWarm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RabyRadius.pill),
        ),
        labelStyle: const TextStyle(
          color: RabyColors.secondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(44, 38)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: RabySpacing.md),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? RabyColors.surfaceWarm
                : RabyColors.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? RabyColors.primaryDeep
                : RabyColors.textSecondary;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: RabyColors.borderWarm),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(RabyRadius.pill),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: RabyColors.secondary,
          minimumSize: const Size(48, 52),
          side: const BorderSide(color: RabyColors.borderWarm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RabyRadius.pill),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: RabyColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
