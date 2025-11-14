import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/core/common/params/no_params.dart';
import 'package:smart_lock/features/pin/domain/useCases/get_lock_pin.dart';
import 'package:smart_lock/features/pin/domain/useCases/update_lock_pin.dart';

part 'pin_event.dart';
part 'pin_state.dart';

class PinBloc extends Bloc<PinEvent, PinState> {
  final GetLockPin _getLockPin;
  final UpdateLockPin _updateLockPin;

  PinBloc({
    required GetLockPin getLockPin,
    required UpdateLockPin updateLockPin,
  }) : _getLockPin = getLockPin,
       _updateLockPin = updateLockPin,
       super(PinState(pin: '')) {
    on<PinFetched>(_onGetLockPin);
    on<PinUpdated>(_onUpdateLockPin);
  }

  Future<void> _onGetLockPin(PinFetched event, Emitter<PinState> emit) async {
    final response = await _getLockPin(NoParams());
    response.fold(
      (failure) => emit(
        state.copyWith(
          status: PinStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (pin) => emit(state.copyWith(pin: pin.pin, status: PinStatus.initial)),
    );
  }

  Future<void> _onUpdateLockPin(
    PinUpdated event,
    Emitter<PinState> emit,
  ) async {
    emit(state.copyWith(status: PinStatus.loading));
    final response = await _updateLockPin(UpdateLockPinParams(pin: event.pin));

    response.fold(
      (failure) => emit(
        state.copyWith(
          status: PinStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: PinStatus.success, pin: event.pin)),
    );
  }
}
