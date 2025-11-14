part of 'pin_bloc.dart';

enum PinStatus { initial, loading, success, failure }

class PinState extends Equatable {
  const PinState({
    required this.pin,
    this.status = PinStatus.initial,
    this.errorMessage,
  });

  final String pin;
  final PinStatus? status;
  final String? errorMessage;

  PinState copyWith({String? pin, PinStatus? status, String? errorMessage}) {
    return PinState(
      pin: pin ?? this.pin,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return '''PinState { status: $status, pin: $pin, errorMessage: $errorMessage }''';
  }

  @override
  List<Object?> get props => [pin, status, errorMessage];
}
