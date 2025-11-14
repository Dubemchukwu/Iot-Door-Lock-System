import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/core/common/widgets/custom_elevated_button.dart';
import 'package:smart_lock/core/common/widgets/custom_pin_form_field.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';
import 'package:smart_lock/core/utils/helpers/helpers.dart';
import 'package:smart_lock/core/utils/validators/validator.dart';
import 'package:smart_lock/features/pin/presentation/bloc/pin_bloc.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final oldPin = TextEditingController();
  final newPin = TextEditingController();
  final confirmPin = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    oldPin.dispose();
    newPin.dispose();
    confirmPin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.fromLTRB(
            SSizes.fontSizeXl,
            SSizes.fontSize3Xl,
            SSizes.fontSizeXs,
            SSizes.fontSizeXl,
          ),
          child: BlocListener<PinBloc, PinState>(
            listener: (context, state) {
              if (state.status == PinStatus.success) {
                oldPin.clear();
                newPin.clear();
                confirmPin.clear();

                return SHelpers.showSnackBar(
                  context,
                  "Successfully updated pin",
                  Color(0XFF17301a),
                  SColor.successTextColor,
                );
              } else if (state.status == PinStatus.failure &&
                  state.errorMessage != null) {
                return SHelpers.showSnackBar(
                  context,
                  state.errorMessage ?? '',
                  Color(0Xff301717),
                  SColor.errorColor,
                );
              }
            },
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change Access Pin",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: SColor.white),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Enter your old PIN and set a new one to change access credentials.",
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: SColor.textColor2),
                  ),
                  SizedBox(height: 53.0),
                  SCustomPinFormField(
                    label: 'Old PIN',
                    hint: 'Enter your current PIN',
                    controller: oldPin,
                  ),
                  SizedBox(height: SSizes.fontSizeMd),
                  SCustomPinFormField(
                    label: 'New PIN',
                    hint: 'Enter new 4-digit PIN',
                    controller: newPin,
                  ),
                  SizedBox(height: SSizes.fontSizeMd),
                  SCustomPinFormField(
                    validate: (value) => SValidator.confirmPin(
                      newPin.text.trim(),
                      value?.trim(),
                    ),
                    label: 'Confirm New PIN',
                    hint: 'Re-enter new PIN',
                    controller: confirmPin,
                  ),
                  SizedBox(height: 40.0),
                  BlocBuilder<PinBloc, PinState>(
                    builder: (context, state) {
                      return SCustomElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<PinBloc>().add(
                              PinUpdated(pin: newPin.text.trim()),
                            );
                          }
                        },
                        isLoading: state.status == PinStatus.loading
                            ? true
                            : false,
                        text: "Update PIN",
                        backgroundColor: SColor.primaryButtonColor,
                        textColor: SColor.white,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
