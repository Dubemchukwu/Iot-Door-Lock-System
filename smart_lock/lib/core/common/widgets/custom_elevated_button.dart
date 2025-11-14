import 'package:flutter/material.dart';
import 'package:smart_lock/core/common/widgets/loader.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';

class SCustomElevatedButton extends StatelessWidget {
  const SCustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.width = double.infinity,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 51,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide.none,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SSizes.fontSizeXs),
          ),
        ),
        child: isLoading
            ? const Center(child: IosLoader())
            : Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
