import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/core/utils/constants/sizes.dart';
import 'package:smart_lock/core/utils/helpers/helpers.dart';
import 'package:smart_lock/features/door/presentation/bloc/door_bloc.dart';
import 'package:smart_lock/features/door/presentation/widgets/door_lock_slider.dart';

class DoorScreen extends StatefulWidget {
  const DoorScreen({super.key});

  @override
  State<DoorScreen> createState() => _DoorScreenState();
}

class _DoorScreenState extends State<DoorScreen> {
  final double buttonSize = 70.0;
  final double containerHeight = 314.0;

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
          child: BlocBuilder<DoorBloc, DoorState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Door Control",
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: SColor.white),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        state.isDoorLocked
                            ? "Slide to unlock"
                            : "Slide to lock",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: SColor.textColor2),
                      ),
                    ],
                  ),
                  SizedBox(height: 69),
                  Center(
                    child: Container(
                      width: 98.0,
                      height: containerHeight,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(98.0),
                          bottom: Radius.circular(98.0),
                        ),
                        color: SColor.navBackgroundColor,
                      ),
                      child: BlocListener<DoorBloc, DoorState>(
                        listener: (context, state) {
                          if (state.status == DoorStatus.failure &&
                              state.errorMessage != null) {
                            return SHelpers.showSnackBar(
                              context,
                              state.errorMessage ?? '',
                              Color(0Xff301717),
                              SColor.errorColor,
                            );
                          }
                        },
                        child: SDoorLockSlider(
                          containerHeight: containerHeight,
                          buttonSize: buttonSize,
                          isDoorLocked: state.isDoorLocked,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 13.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0XFF17301a),
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20.0),
                          right: Radius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        state.isDoorLocked
                            ? "Your door is locked"
                            : "Your Door is open",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: SColor.successTextColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
