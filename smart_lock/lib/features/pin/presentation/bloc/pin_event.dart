part of 'pin_bloc.dart';

sealed class PinEvent {
  const PinEvent();
}

final class PinFetched extends PinEvent {
  const PinFetched();
}

final class PinUpdated extends PinEvent {
  final String pin;
  const PinUpdated({required this.pin});
}
