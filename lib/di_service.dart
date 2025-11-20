import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_explorer/core/network/interceptors/logging_interceptor.dart';

import 'core/database/app_database.dart';
import 'core/network/interceptors/retry_interceptor.dart';
import 'core/network/network_info.dart';
import 'core/services/image_optimization_service.dart';
import 'features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'features/pokemon/domain/repositories/pokemon_repository.dart';
import 'features/pokemon/domain/usecases/get_pokemon_detail_use_case.dart';
import 'features/pokemon/domain/usecases/get_pokemon_list_use_case.dart';
import 'features/pokemon/domain/usecases/refresh_pokemon_list_use_case.dart';
import 'features/pokemon/presentation/bloc/pokemon_detail/pokemon_detail_bloc.dart';
import 'features/pokemon/presentation/bloc/pokemon_list/pokemon_list_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // BLoCs
  getIt.registerFactory(
    () => PokemonListBloc(
      getPokemonListUseCase: getIt(),
      refreshPokemonListUseCase: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerFactory(
    () => PokemonDetailBloc(
      getPokemonDetailUseCase: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetPokemonListUseCase(getIt()));
  getIt.registerLazySingleton(() => GetPokemonDetailUseCase(getIt()));
  getIt.registerLazySingleton(() => RefreshPokemonListUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
      imageOptimizationService: getIt(),
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(database: getIt()),
  );

  // Core
  getIt.registerLazySingleton(() => AppDatabase());
  getIt.registerLazySingleton(() => ImageOptimizationService());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.addAll([RetryInterceptor(dio: dio), LoggingInterceptor()]);

    return dio;
  });

  getIt.registerLazySingleton(() => Connectivity());
}
