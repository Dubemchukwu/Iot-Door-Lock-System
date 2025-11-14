import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';

class SElevatedButtonTheme {
  SElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColor.white,
      backgroundColor: SColor.primaryButtonColor,
      disabledForegroundColor: SColor.white,
      disabledBackgroundColor: SColor.disabledButtonColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: SSizes.fontSizeXs,
        color: SColor.white,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: SColor.white,
      backgroundColor: SColor.primaryButtonColor,
      disabledForegroundColor: SColor.disabledButtonColor,
      disabledBackgroundColor: SColor.disabledButtonColor,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: SSizes.fontSizeXs,
        color: SColor.textColor,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      ),
    ),
  );
}
