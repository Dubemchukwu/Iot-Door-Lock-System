import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';

class STextFormFieldTheme {
  STextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: SColor.white,
    suffixIconColor: SColor.white,
    // constraints: const BoxConstraints.expand(height: 14, inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      color: SColor.textColor2,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      color: SColor.textColor2,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: SColor.textColor2.withValues(alpha: 0.8),
    ),
    filled: false,
    hoverColor: SColor.white,
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 1, color: SColor.inputBorder),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 1, color: SColor.inputBorder),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 2, color: SColor.primaryButtonColor),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 1, color: SColor.errorColor),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 2, color: SColor.errorColor),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: SColor.white,
    suffixIconColor: SColor.white,
    // constraints: const BoxConstraints.expand(height: 14, inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      color: SColor.textColor2,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: SSizes.fontSizeXs,
      color: SColor.textColor2,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: SColor.textColor2.withValues(alpha: 0.8),
    ),
    fillColor: Colors.transparent,
    filled: false,
    hoverColor: SColor.white,
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 1, color: SColor.inputBorder),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 1, color: SColor.inputBorder),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 2, color: SColor.primaryButtonColor),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 1, color: SColor.errorColor),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(SSizes.borderRadiusSm),
      borderSide: const BorderSide(width: 2, color: SColor.errorColor),
    ),
  );
}
