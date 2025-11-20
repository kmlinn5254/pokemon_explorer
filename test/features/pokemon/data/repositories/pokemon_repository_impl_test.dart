import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_explorer/core/error/exceptions.dart';
import 'package:pokemon_explorer/core/error/failures.dart';
import 'package:pokemon_explorer/core/network/network_info.dart';
import 'package:pokemon_explorer/core/services/image_optimization_service.dart';
import 'package:pokemon_explorer/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:pokemon_explorer/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokemon_explorer/features/pokemon/data/repositories/pokemon_repository_impl.dart';

import '../../../../mocks/mock_config.mocks.dart';

@GenerateMocks([
  PokemonRemoteDataSource,
  PokemonLocalDataSource,
  NetworkInfo,
  ImageOptimizationService,
])
void main() {
  late PokemonRepositoryImpl repository;
  late MockPokemonRemoteDataSource mockRemoteDataSource;
  late MockPokemonLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockImageOptimizationService mockImageOptimizationService;

  setUp(() {
    mockRemoteDataSource = MockPokemonRemoteDataSource();
    mockLocalDataSource = MockPokemonLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockImageOptimizationService = MockImageOptimizationService();

    repository = PokemonRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      imageOptimizationService: mockImageOptimizationService,
    );
  });

  group('refreshPokemonList', () {
    test('should clear cache successfully', () async {
      when(
        mockLocalDataSource.clearCache(),
      ).thenAnswer((_) async => Future.value());

      final result = await repository.refreshPokemonList();

      expect(result, const Right(unit));
      verify(mockLocalDataSource.clearCache());
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when clearing cache fails', () async {
      when(
        mockLocalDataSource.clearCache(),
      ).thenThrow(CacheException('Failed to clear cache'));

      final result = await repository.refreshPokemonList();

      expect(result, const Left(CacheFailure('Failed to clear cache')));
      verify(mockLocalDataSource.clearCache());
    });

    test('should handle database errors gracefully', () async {
      when(
        mockLocalDataSource.clearCache(),
      ).thenThrow(CacheException('Database locked'));

      final result = await repository.refreshPokemonList();

      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Database locked');
      }, (_) => fail('Should return failure'));
    });

    test('should not call remote data source or network info', () async {
      when(
        mockLocalDataSource.clearCache(),
      ).thenAnswer((_) async => Future.value());

      await repository.refreshPokemonList();

      verifyNever(mockRemoteDataSource.getPokemonList(any, any));
      verifyNever(mockNetworkInfo.isConnected);
      verifyNever(
        mockImageOptimizationService.optimizeAndCacheImage(
          imageUrl: anyNamed('imageUrl'),
          savePath: anyNamed('savePath'),
          targetWidth: anyNamed('targetWidth'),
          targetHeight: anyNamed('targetHeight'),
          quality: anyNamed('quality'),
        ),
      );
    });
  });
}
