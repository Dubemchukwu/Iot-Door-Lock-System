import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';
import 'package:smart_lock/core/utils/validators/validator.dart';

class SCustomPinFormField extends StatefulWidget {
  const SCustomPinFormField({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    this.validate,
    this.autoValidate = false,
  });

  final String hint;
  final String label;
  final String? Function(String?)? validate;
  final TextEditingController? controller;
  final bool autoValidate;

  @override
  State<SCustomPinFormField> createState() => _SCustomPinFormFieldState();
}

class _SCustomPinFormFieldState extends State<SCustomPinFormField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: SSizes.spacingSmall,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.labelMedium),
        TextFormField(
          keyboardType: TextInputType.number,
          maxLength: 4,
          onTapUpOutside: (_) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          obscureText: !_isObscure,
          validator: widget.validate ?? SValidator.validatePin,
          autovalidateMode: widget.autoValidate
              ? AutovalidateMode.onUserInteraction
              : null,
          controller: widget.controller,
          decoration: InputDecoration(
            hint: Text(
              widget.hint,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: SColor.textColor2),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _isObscure = !_isObscure);
              },
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility_outlined,
                size: 19.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
