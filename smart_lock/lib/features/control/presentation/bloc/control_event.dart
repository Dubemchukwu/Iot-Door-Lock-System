part of 'control_bloc.dart';

sealed class ControlEvent {
  const ControlEvent();
}

final class ManualControlToggled extends ControlEvent {
  const ManualControlToggled();
}

final class ManualControlStatusFetched extends ControlEvent {
  const ManualControlStatusFetched();
}
