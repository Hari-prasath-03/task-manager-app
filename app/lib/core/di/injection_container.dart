import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager/core/network/dio_client.dart';
import 'package:task_manager/core/services/sp_service.dart';
import 'package:task_manager/features/auth/data/repository/auth_local_repository.dart';
import 'package:task_manager/features/auth/data/repository/auth_remote_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  sl.registerLazySingleton<SPService>(() => SPService());
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Repositories
  sl.registerLazySingleton<AuthLocalRepository>(() => AuthLocalRepository());
  sl.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(
      spService: sl(),
      authLocalRepository: sl(),
      dio: sl(),
    ),
  );
}
