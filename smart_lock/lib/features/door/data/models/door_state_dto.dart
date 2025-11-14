import 'package:smart_lock/features/door/domain/entities/door_state.dart';

class DoorStateDto extends DoorState {
  DoorStateDto({required super.lock});

  factory DoorStateDto.fromJson(Map<String, dynamic> json) {
    return DoorStateDto(lock: json['lock'] as bool);
  }
}
