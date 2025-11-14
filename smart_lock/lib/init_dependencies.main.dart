part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  _initDoor();
  _initControl();
  _initPin();

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(DioInterceptor(dioClient: dio));

  serviceLocator.registerLazySingleton(() => InternetConnection());
  serviceLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(internetConnection: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => dio);
}

void _initDoor() {
  serviceLocator
    ..registerFactory<DoorRemoteDataSource>(
      () => DoorRemoteDataSourceImpl(dioClient: serviceLocator()),
    )
    ..registerFactory<DoorRepository>(
      () => DoorRepositoryImpl(
        doorRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(() => GetDoorState(doorRepository: serviceLocator()))
    ..registerFactory(() => UpdateDoorState(doorRepository: serviceLocator()))
    ..registerLazySingleton(
      () => DoorBloc(
        getDoorState: serviceLocator(),
        updateDoorState: serviceLocator(),
      ),
    );
}

void _initControl() {
  serviceLocator
    ..registerFactory<ControlRemoteDataSource>(
      () => ControlRemoteDataSourceImpl(dioClient: serviceLocator()),
    )
    ..registerFactory<ControlRepository>(
      () => ControlRepositoryImpl(
        controlRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetManualControlState(controlRepository: serviceLocator()),
    )
    ..registerFactory(
      () => ToggleManualControl(controlRepository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => ControlBloc(
        getManualControlState: serviceLocator(),
        toggleManualControl: serviceLocator(),
      ),
    );
}

void _initPin() {
  serviceLocator
    ..registerFactory<PinRemoteDataSource>(
      () => PinRemoteDataSourceImpl(dioClient: serviceLocator()),
    )
    ..registerFactory<PinRepository>(
      () => PinRepositoryImpl(
        pinRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(() => GetLockPin(pinRepository: serviceLocator()))
    ..registerFactory(() => UpdateLockPin(pinRepository: serviceLocator()))
    ..registerLazySingleton(
      () => PinBloc(
        getLockPin: serviceLocator(),
        updateLockPin: serviceLocator(),
      ),
    );
}
