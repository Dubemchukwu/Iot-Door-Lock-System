import 'package:smart_lock/features/control/domain/entities/manual_control.dart';

class ManualControlDto extends ManualControl {
  ManualControlDto({required super.lock});

  factory ManualControlDto.fromJson(Map<String, dynamic> json) {
    return ManualControlDto(lock: json['lock'] as bool);
  }
}
