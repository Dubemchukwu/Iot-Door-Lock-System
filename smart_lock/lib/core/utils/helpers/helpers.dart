import 'package:flutter/material.dart';

class SHelpers {
  const SHelpers._();

  static String getNameCredentials(String name) {
    final initials = name.substring(1, 3).toUpperCase();
    return initials;
  }

  static void showSnackBar(
    BuildContext context,
    String content,
    Color? color,
    Color? textColor,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
          backgroundColor: color,
          content: Center(
            child: Text(
              content,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: textColor),
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
