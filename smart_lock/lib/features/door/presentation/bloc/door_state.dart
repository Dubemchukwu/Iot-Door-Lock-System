part of 'door_bloc.dart';

enum DoorStatus { initial, success, failure }

class DoorState extends Equatable {
  const DoorState({
    this.isDoorLocked = false,
    this.status = DoorStatus.initial,
    this.errorMessage,
  });

  final bool isDoorLocked;
  final DoorStatus? status;
  final String? errorMessage;

  DoorState copyWith({
    bool? isDoorLocked,
    DoorStatus? status,
    String? errorMessage,
  }) {
    return DoorState(
      isDoorLocked: isDoorLocked ?? this.isDoorLocked,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return '''DoorState { status: $status, isDoorLocked: $isDoorLocked }''';
  }

  @override
  List<Object?> get props => [isDoorLocked, status, errorMessage];
}
