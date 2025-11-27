import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:smart_lock/core/common/params/no_params.dart';
import 'package:smart_lock/features/door/domain/useCases/get_door_state.dart';
import 'package:smart_lock/features/door/domain/useCases/update_door_state.dart';

part 'door_state.dart';
part 'door_event.dart';

class DoorBloc extends Bloc<DoorEvent, DoorState> {
  final GetDoorState _getDoorState;
  final UpdateDoorState _updateDoorState;

  var logger = Logger();

  DoorBloc({
    required GetDoorState getDoorState,
    required UpdateDoorState updateDoorState,
  }) : _getDoorState = getDoorState,
       _updateDoorState = updateDoorState,
       super(DoorState()) {
    on<DoorLockedStatusFetched>(_onGetDoorState);
    on<DoorStateToggled>(_onToggleDoorState);
  }

  Future<void> _onGetDoorState(
    DoorLockedStatusFetched event,
    Emitter<DoorState> emit,
  ) async {
    final response = await _getDoorState(NoParams());
    response.fold(
      (failure) => emit(
        state.copyWith(
          status: DoorStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (door) => emit(
        state.copyWith(
          isDoorLocked: door.state,
          status: DoorStatus.success,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onToggleDoorState(
    DoorStateToggled event,
    Emitter<DoorState> emit,
  ) async {
    emit(state.copyWith(isDoorLocked: !state.isDoorLocked));

    final response = await _updateDoorState(
      UpdateDoorStateParams(state: state.isDoorLocked),
    );

    response.fold(
      (failure) => emit(
        state.copyWith(
          status: DoorStatus.failure,
          isDoorLocked: !state.isDoorLocked,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(errorMessage: null)),
    );
  }
}
