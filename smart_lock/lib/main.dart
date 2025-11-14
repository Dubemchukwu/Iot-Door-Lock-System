import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lock/app.dart';
import 'package:smart_lock/features/control/presentation/bloc/control_bloc.dart';
import 'package:smart_lock/features/door/presentation/bloc/door_bloc.dart';
import 'package:smart_lock/features/pin/presentation/bloc/pin_bloc.dart';
import 'package:smart_lock/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              serviceLocator<DoorBloc>()..add(DoorLockedStatusFetched()),
        ),
        BlocProvider(
          create: (_) => serviceLocator<PinBloc>()..add(PinFetched()),
        ),
        BlocProvider(
          create: (_) =>
              serviceLocator<ControlBloc>()..add(ManualControlStatusFetched()),
        ),
      ],
      child: const App(),
    ),
  );
}
