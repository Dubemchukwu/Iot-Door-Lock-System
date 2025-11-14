import 'package:flutter/material.dart';
import 'package:smart_lock/core/utils/validators/validator.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
    required this.formKey,
    required this.dark,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final bool dark;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            onTapUpOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: SValidator.validateRequired,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            onTapUpOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: SValidator.validateRequired,
          ),
        ],
      ),
    );
  }
}
