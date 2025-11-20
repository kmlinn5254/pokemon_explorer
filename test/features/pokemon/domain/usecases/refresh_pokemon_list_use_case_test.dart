import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_explorer/core/error/failures.dart';
import 'package:pokemon_explorer/core/usecases/usecase.dart';
import 'package:pokemon_explorer/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/refresh_pokemon_list_use_case.dart';

import '../../../../mocks/mock_config.mocks.dart';

@GenerateMocks([PokemonRepository])
void main() {
  late RefreshPokemonListUseCase usecase;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    usecase = RefreshPokemonListUseCase(mockRepository);
  });

  group('RefreshPokemonListUseCase', () {
    test('should call repository refreshPokemonList method', () async {
      when(
        mockRepository.refreshPokemonList(),
      ).thenAnswer((_) async => const Right(unit));

      final result = await usecase(NoParams());

      expect(result, const Right(unit));
      verify(mockRepository.refreshPokemonList());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      final failure = CacheFailure('Failed to clear cache');
      when(
        mockRepository.refreshPokemonList(),
      ).thenAnswer((_) async => Left(failure));

      final result = await usecase(NoParams());

      expect(result, Left(failure));
      verify(mockRepository.refreshPokemonList());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate CacheFailure from repository', () async {
      const failureMessage = 'Database error';
      when(
        mockRepository.refreshPokemonList(),
      ).thenAnswer((_) async => const Left(CacheFailure(failureMessage)));

      final result = await usecase(NoParams());

      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, failureMessage);
      }, (_) => fail('Should return failure'));
    });
  });
}
