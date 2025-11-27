import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/features/door/presentation/bloc/door_bloc.dart';
import 'package:smart_lock/features/door/presentation/widgets/door_slider_button.dart';

class SDoorLockSlider extends StatefulWidget {
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
  State<SDoorLockSlider> createState() => _SDoorLockSliderState();
}

class _SDoorLockSliderState extends State<SDoorLockSlider> {
  double dragOffset = 0;
  final double threshold = 150;

  @override
  Widget build(BuildContext context) {
    final startPos = widget.isDoorLocked
        ? 0
        : (widget.containerHeight - widget.buttonSize - 28);
    final endPos = widget.isDoorLocked
        ? (widget.containerHeight - widget.buttonSize - 28)
        : 0.0;

    return Stack(
      children: [
        // The background button
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          top: endPos,
          left: 0,
          right: 0,
          child: SDoorSliderButton(
            icon: widget.isDoorLocked ? Icons.lock_open : Icons.lock,
            buttonSize: widget.buttonSize,
          ),
        ),

        Positioned(
          top: startPos + dragOffset,
          left: 0,
          right: 0,
          child: GestureDetector(
            onPanUpdate: (d) {
              setState(() {
                dragOffset += d.delta.dy;
                dragOffset = dragOffset.clamp(-threshold, threshold);
              });
            },

            onPanEnd: (_) {
              if (dragOffset.abs() >= threshold) {
                HapticFeedback.vibrate();
                context.read<DoorBloc>().add(DoorStateToggled());
              }

              setState(() => dragOffset = 0);
            },

            child: SDoorSliderButton(
              icon: widget.isDoorLocked ? Icons.lock : Icons.lock_open,
              isPrimary: true,
              buttonSize: widget.buttonSize,
            ),
          ),
        ),
      ],
    );
  }
}
