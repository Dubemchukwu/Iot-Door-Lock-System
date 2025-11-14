import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/core/common/params/no_params.dart';
import 'package:smart_lock/features/control/domain/useCases/get_manual_control_state.dart';
import 'package:smart_lock/features/control/domain/useCases/toggle_manual_control.dart';

part 'control_state.dart';
part 'control_event.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final GetManualControlState _getManualControlState;
  final ToggleManualControl _toggleManualControl;

  ControlBloc({
    required GetManualControlState getManualControlState,
    required ToggleManualControl toggleManualControl,
  }) : _getManualControlState = getManualControlState,
       _toggleManualControl = toggleManualControl,
       super(ControlState()) {
    on<ManualControlStatusFetched>(_onGetManualControlState);
    on<ManualControlToggled>(_onToggleManualControl);
  }

  Future<void> _onGetManualControlState(
    ManualControlStatusFetched event,
    Emitter<ControlState> emit,
  ) async {
    emit(state.copyWith(status: ControlStatus.loading));
    final response = await _getManualControlState(NoParams());
    response.fold(
      (failure) => emit(
        ControlState(
          status: ControlStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (pin) => emit(
        state.copyWith(
          isManualControlled: pin.state,
          status: ControlStatus.success,
        ),
      ),
    );
  }

  Future<void> _onToggleManualControl(
    ManualControlToggled event,
    Emitter<ControlState> emit,
  ) async {
    emit(state.copyWith(status: ControlStatus.loading));
    final response = await _toggleManualControl(
      ToggleManualControlParams(state: !state.isManualControlled),
    );

    response.fold(
      (failure) => emit(
        state.copyWith(
          status: ControlStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          isManualControlled: !state.isManualControlled,
          status: ControlStatus.success,
        ),
      ),
    );
  }
}
