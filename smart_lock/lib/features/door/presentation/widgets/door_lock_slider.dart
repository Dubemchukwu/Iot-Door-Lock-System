import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/features/door/presentation/bloc/door_bloc.dart';
import 'package:smart_lock/features/door/presentation/widgets/door_slider_button.dart';

class SDoorLockSlider extends StatelessWidget {
  const SDoorLockSlider({
    super.key,
    required this.containerHeight,
    required this.buttonSize,
    required this.isDoorLocked,
  });

  final double containerHeight;
  final double buttonSize;
  final bool isDoorLocked;

  @override
  Widget build(BuildContext context) {
    double dragDistance = 0.0;
    final double threshold = 60.0;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          top: isDoorLocked ? (containerHeight - buttonSize - 28) : 0,
          left: 0,
          right: 0,
          child: SDoorSliderButton(
            icon: isDoorLocked ? Icons.lock_open : Icons.lock,
            buttonSize: buttonSize,
          ),
        ),
        Positioned.fill(
          child: Center(
            child: AnimatedRotation(
              turns: isDoorLocked ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 28.0,
                    color: Color(0xFF818181),
                  ),
                  Icon(
                    Icons.keyboard_arrow_up,
                    size: 28.0,
                    color: Color(0xFF818181),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          top: isDoorLocked ? 0 : (containerHeight - buttonSize - 28),
          left: 0,
          right: 0,
          child: GestureDetector(
            onPanUpdate: (details) {
              dragDistance += details.delta.dy;

              if (dragDistance.abs() > threshold) {
                context.read<DoorBloc>().add(DoorStateToggled());
                dragDistance = 0;
              }
            },
            child: SDoorSliderButton(
              icon: isDoorLocked ? Icons.lock : Icons.lock_open,
              isPrimary: true,
              buttonSize: buttonSize,
            ),
          ),
        ),
      ],
    );
  }
}
