part of 'control_bloc.dart';

enum ControlStatus { initial, loading, success, failure }

class ControlState extends Equatable {
  const ControlState({
    this.isManualControlled = false,
    this.status = ControlStatus.initial,
    this.errorMessage,
  });

  final bool isManualControlled;
  final ControlStatus? status;
  final String? errorMessage;

  ControlState copyWith({
    bool? isManualControlled,
    ControlStatus? status,
    String? errorMessage,
  }) {
    return ControlState(
      isManualControlled: isManualControlled ?? this.isManualControlled,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return '''ControlState { status: $status, isManualControlled: $isManualControlled, errorMessage: $errorMessage }''';
  }

  @override
  List<Object?> get props => [isManualControlled, status, errorMessage];
}
