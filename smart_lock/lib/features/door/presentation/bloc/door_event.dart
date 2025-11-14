part of 'door_bloc.dart';

sealed class DoorEvent {
  const DoorEvent();
}

final class DoorStateToggled extends DoorEvent {
  const DoorStateToggled();
}

final class DoorLockedStatusFetched extends DoorEvent {
  const DoorLockedStatusFetched();
}
