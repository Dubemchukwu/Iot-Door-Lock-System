import 'package:flutter/material.dart';
import 'package:smart_lock/core/common/widgets/loader.dart';

class SButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final WidgetStateColor? buttonColor;

  const SButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? const Loader() : Text(text),
      ),
    );
  }
}
