import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';

class STextTheme {
  STextTheme._();

  static TextTheme lighTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSize3Xl,
      fontWeight: FontWeight.bold,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    headlineMedium: TextStyle().copyWith(
      height: 1.6,
      fontSize: SSizes.fontSize2Xl,
      fontWeight: FontWeight.w600,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXl,
      fontWeight: FontWeight.w600,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXl,
      fontWeight: FontWeight.bold,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: SSizes.fontSizeLg,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeMd,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),

    bodyLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSizeMd,
      fontWeight: FontWeight.normal,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: SSizes.fontSizeSm,
      fontWeight: FontWeight.normal,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    labelLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    labelMedium: TextStyle().copyWith(
      height: 1.6,
      fontSize: SSizes.fontSizeXs,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSize3Xl,
      fontWeight: FontWeight.bold,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: SSizes.fontSize2Xl,
      fontWeight: FontWeight.w600,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXl,
      fontWeight: FontWeight.w600,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXl,
      fontWeight: FontWeight.bold,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: SSizes.fontSizeLg,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeMd,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),

    bodyLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSizeMd,
      fontWeight: FontWeight.normal,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: SSizes.fontSizeSm,
      fontWeight: FontWeight.normal,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: SSizes.fontSizeSm,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      fontWeight: FontWeight.w500,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      fontWeight: FontWeight.w400,
      color: SColor.white,
      fontFamily: 'Plus Jakarta Sans',
    ),
  );
}
