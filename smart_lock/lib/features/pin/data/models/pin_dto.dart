import 'package:smart_lock/features/pin/domain/entities/pin.dart';

class PinDto extends Pin {
  PinDto({required super.pin});

  factory PinDto.fromJson(Map<String, dynamic> json) {
    return PinDto(pin: json['pin'] as String);
  }
}
