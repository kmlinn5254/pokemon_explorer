import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_explorer/core/error/failures.dart';
import 'package:pokemon_explorer/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:pokemon_explorer/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/get_pokemon_detail_use_case.dart';

import '../../../../mocks/mock_config.mocks.dart';

@GenerateMocks([PokemonRepository])
void main() {
  late GetPokemonDetailUseCase usecase;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    usecase = GetPokemonDetailUseCase(mockRepository);
  });

  const tPokemonId = 1;
  const tPokemonDetail = PokemonDetail(
    id: 1,
    name: 'bulbasaur',
    height: 7,
    weight: 69,
    types: [
      PokemonType(slot: 1, name: 'grass'),
      PokemonType(slot: 2, name: 'poison'),
    ],
    abilities: [
      PokemonAbility(name: 'overgrow', isHidden: false, slot: 1),
      PokemonAbility(name: 'chlorophyll', isHidden: true, slot: 3),
    ],
    stats: [
      PokemonStat(name: 'hp', baseStat: 45, effort: 0),
      PokemonStat(name: 'attack', baseStat: 49, effort: 0),
      PokemonStat(name: 'defense', baseStat: 49, effort: 0),
      PokemonStat(name: 'special-attack', baseStat: 65, effort: 1),
      PokemonStat(name: 'special-defense', baseStat: 65, effort: 0),
      PokemonStat(name: 'speed', baseStat: 45, effort: 0),
    ],
    sprites: PokemonSprites(
      frontDefault: 'https://example.com/front.png',
      officialArtwork: 'https://example.com/artwork.png',
    ),
  );

  group('GetPokemonDetail', () {
    test('should get pokemon detail from repository', () async {
      when(
        mockRepository.getPokemonDetail(
          id: anyNamed('id'),
          forceRefresh: anyNamed('forceRefresh'),
        ),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      final result = await usecase(const PokemonDetailParams(id: tPokemonId));

      expect(result, const Right(tPokemonDetail));
      verify(
        mockRepository.getPokemonDetail(id: tPokemonId, forceRefresh: false),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get pokemon detail with force refresh', () async {
      when(
        mockRepository.getPokemonDetail(
          id: anyNamed('id'),
          forceRefresh: anyNamed('forceRefresh'),
        ),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      final result = await usecase(
        const PokemonDetailParams(id: tPokemonId, forceRefresh: true),
      );

      expect(result, const Right(tPokemonDetail));
      verify(
        mockRepository.getPokemonDetail(id: tPokemonId, forceRefresh: true),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      const failure = ServerFailure('Server error');
      when(
        mockRepository.getPokemonDetail(
          id: anyNamed('id'),
          forceRefresh: anyNamed('forceRefresh'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(const PokemonDetailParams(id: tPokemonId));

      expect(result, const Left(failure));
      verify(
        mockRepository.getPokemonDetail(id: tPokemonId, forceRefresh: false),
      );
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when no internet connection', () async {
      const failure = NetworkFailure('No internet connection');
      when(
        mockRepository.getPokemonDetail(
          id: anyNamed('id'),
          forceRefresh: anyNamed('forceRefresh'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(const PokemonDetailParams(id: tPokemonId));

      expect(result, const Left(failure));
      verify(
        mockRepository.getPokemonDetail(id: tPokemonId, forceRefresh: false),
      );
    });

    test('should return CacheFailure when cache fails', () async {
      const failure = CacheFailure('Cache error');
      when(
        mockRepository.getPokemonDetail(
          id: anyNamed('id'),
          forceRefresh: anyNamed('forceRefresh'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(const PokemonDetailParams(id: tPokemonId));

      expect(result, const Left(failure));
    });
  });

  group('PokemonDetailParams', () {
    test('should have correct default values', () {
      const params = PokemonDetailParams(id: tPokemonId);

      expect(params.id, tPokemonId);
      expect(params.forceRefresh, false);
    });

    test('should support custom forceRefresh value', () {
      const params = PokemonDetailParams(id: tPokemonId, forceRefresh: true);

      expect(params.id, tPokemonId);
      expect(params.forceRefresh, true);
    });

    test('should be equal when properties are equal', () {
      const params1 = PokemonDetailParams(id: tPokemonId);
      const params2 = PokemonDetailParams(id: tPokemonId);

      expect(params1, params2);
    });

    test('should not be equal when properties differ', () {
      const params1 = PokemonDetailParams(id: 1);
      const params2 = PokemonDetailParams(id: 2);

      expect(params1, isNot(params2));
    });
  });
}
