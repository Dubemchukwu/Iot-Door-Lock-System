import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/core/common/widgets/custom_elevated_button.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';
import 'package:smart_lock/core/utils/helpers/helpers.dart';
import 'package:smart_lock/features/control/presentation/bloc/control_bloc.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(
            SSizes.fontSizeXl,
            SSizes.fontSize3Xl,
            SSizes.fontSizeXs,
            SSizes.fontSizeXl,
          ),
          child: BlocListener<ControlBloc, ControlState>(
            listener: (context, state) {
              if (state.status == ControlStatus.failure &&
                  state.errorMessage != null) {
                return SHelpers.showSnackBar(
                  context,
                  state.errorMessage ?? '',
                  Color(0Xff301717),
                  SColor.errorColor,
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "System Control",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: SSizes.spacingSmall),
                Text(
                  "Temporarily enable or disable manual door control.",
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: SColor.textColor2),
                ),
                SizedBox(height: 220.0),
                BlocBuilder<ControlBloc, ControlState>(
                  builder: (context, state) {
                    return Column(
                      spacing: SSizes.fontSizeXs,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.isManualControlled
                              ? "Manual Control Status: Enabled"
                              : "Manual Control Status: Disabled",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        SCustomElevatedButton(
                          onPressed: () {
                            context.read<ControlBloc>().add(
                              ManualControlToggled(),
                            );
                          },
                          text: state.isManualControlled
                              ? "Click to disable manual control"
                              : "Click to enable manual control",
                          isLoading: state.status == ControlStatus.loading
                              ? true
                              : false,
                          backgroundColor: state.isManualControlled
                              ? SColor.navBackgroundColor
                              : SColor.primaryButtonColor,
                          textColor: SColor.white,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
