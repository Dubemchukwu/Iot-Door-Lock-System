import 'package:smart_lock/features/control/domain/entities/manual_control.dart';

class ManualControlDto extends ManualControl {
  ManualControlDto({required super.state});

  factory ManualControlDto.fromJson(Map<String, dynamic> json) {
    return ManualControlDto(state: json['state'] as bool);
  }
}
