import 'package:smart_lock/features/door/domain/entities/door_state.dart';

class DoorStateDto extends DoorState {
  DoorStateDto({required super.state});

  factory DoorStateDto.fromJson(Map<String, dynamic> json) {
    return DoorStateDto(state: json['state'] as bool);
  }
}
