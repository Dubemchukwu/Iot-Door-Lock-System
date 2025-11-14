import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';

class SDoorSliderButton extends StatelessWidget {
  const SDoorSliderButton({
    super.key,
    required this.buttonSize,
    required this.icon,
    this.isPrimary = false,
  });

  final double buttonSize;
  final bool isPrimary;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(10.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPrimary ? Color(0XFF1e5124) : null,
      ),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary
              ? SColor.primaryButtonColor
              : SColor.inputFieldBorder,
        ),
        child: Center(child: Icon(icon, color: SColor.white)),
      ),
    );
  }
}
