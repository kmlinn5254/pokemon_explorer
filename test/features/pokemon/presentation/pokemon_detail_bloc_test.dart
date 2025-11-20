import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_explorer/core/error/failures.dart';
import 'package:pokemon_explorer/core/network/network_info.dart';
import 'package:pokemon_explorer/features/pokemon/domain/entities/pokemon_detail.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_detail/pokemon_detail_bloc.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_detail/pokemon_detail_state.dart';

import '../../../mocks/mock_config.mocks.dart';

@GenerateMocks([GetPokemonDetailUseCase, NetworkInfo])
void main() {
  late PokemonDetailBloc bloc;
  late MockGetPokemonDetailUseCase mockGetPokemonDetailUseCase;
  late MockNetworkInfo mockNetworkInfo;
  late StreamController<bool> networkStreamController;

  setUp(() {
    mockGetPokemonDetailUseCase = MockGetPokemonDetailUseCase();
    mockNetworkInfo = MockNetworkInfo();

    networkStreamController = StreamController<bool>.broadcast();

    when(mockNetworkInfo.onConnectivityChanged)
        .thenAnswer((_) => networkStreamController.stream);

    bloc = PokemonDetailBloc(
      getPokemonDetailUseCase: mockGetPokemonDetailUseCase,
      networkInfo: mockNetworkInfo,
    );
  });

  tearDown(() {
    bloc.close();
  });

  Future<List<PokemonDetailState>> collectStates(
    Future<void> Function() action,
  ) async {
    final emittedStates = <PokemonDetailState>[];
    final subscription = bloc.stream.listen(emittedStates.add);

    await action();
    await Future.delayed(Duration.zero); // allow async events to complete
    await subscription.cancel();

    return emittedStates;
  }

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
    abilities: [PokemonAbility(name: 'overgrow', isHidden: false, slot: 1)],
    stats: [
      PokemonStat(name: 'hp', baseStat: 45, effort: 0),
      PokemonStat(name: 'attack', baseStat: 49, effort: 0),
    ],
    sprites: PokemonSprites(
      frontDefault: 'https://example.com/front.png',
      officialArtwork: 'https://example.com/artwork.png',
    ),
  );

  test('initial state should be PokemonDetailInitial', () {
    // assert
    expect(bloc.state, equals(PokemonDetailInitial()));
  });

  group('LoadPokemonDetail', () {
    test('should set isOffline=true when network is disconnected', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockGetPokemonDetailUseCase(any))
          .thenAnswer((_) async => const Right(tPokemonDetail));

      final emitted = await collectStates(() async {
        bloc.add(LoadPokemonDetail(tPokemonId));
      });

      expect(emitted, [
        PokemonDetailLoading(),
        PokemonDetailLoaded(pokemon: tPokemonDetail, isOffline: true),
      ]);
    });

    test(
      'should emit [Loading, Loaded] when data is fetched successfully',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(
          mockGetPokemonDetailUseCase(any),
        ).thenAnswer((_) async => const Right(tPokemonDetail));

        final emitted = await collectStates(() async {
          bloc.add(LoadPokemonDetail(tPokemonId));
        });

        expect(emitted, [
          PokemonDetailLoading(),
          PokemonDetailLoaded(pokemon: tPokemonDetail),
        ]);

        verify(
          mockGetPokemonDetailUseCase(
            const PokemonDetailParams(id: tPokemonId),
          ),
        );
      },
    );

    test('should emit [Loading, Error] when ServerFailure occurs', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      final emitted = await collectStates(() async {
        bloc.add(LoadPokemonDetail(tPokemonId));
      });

      expect(emitted, [
        PokemonDetailLoading(),
        PokemonDetailError('Server error'),
      ]);

      verify(
        mockGetPokemonDetailUseCase(const PokemonDetailParams(id: tPokemonId)),
      );
    });

    test('should emit [Loading, Error] when NetworkFailure occurs', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockGetPokemonDetailUseCase(any)).thenAnswer(
        (_) async => const Left(NetworkFailure('No internet connection')),
      );

      final emitted = await collectStates(() async {
        bloc.add(LoadPokemonDetail(tPokemonId));
      });

      expect(emitted, [
        PokemonDetailLoading(),
        PokemonDetailError('No internet connection'),
      ]);
    });

    test('should emit [Loading, Error] when CacheFailure occurs', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Left(CacheFailure('Cache error')));

      final emitted = await collectStates(() async {
        bloc.add(LoadPokemonDetail(tPokemonId));
      });

      expect(emitted, [
        PokemonDetailLoading(),
        PokemonDetailError('Cache error'),
      ]);
    });

    test('should call getPokemonDetail with correct params', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      await collectStates(() async {
        bloc.add(LoadPokemonDetail(25));
      });

      verify(mockGetPokemonDetailUseCase(const PokemonDetailParams(id: 25)));
    });
  });

  group('RefreshPokemonDetail', () {
    test('should emit [Loaded] when refresh succeeds', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      final emitted = await collectStates(() async {
        bloc.add(RefreshPokemonDetail(tPokemonId));
      });

      expect(emitted, [PokemonDetailLoaded(pokemon: tPokemonDetail)]);

      verify(
        mockGetPokemonDetailUseCase(
          const PokemonDetailParams(id: tPokemonId, forceRefresh: true),
        ),
      );
    });

    test(
      'should maintain current state when refresh fails and state is Loaded',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(
          mockGetPokemonDetailUseCase(any),
        ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

        bloc.emit(PokemonDetailLoaded(pokemon: tPokemonDetail));

        final emitted = await collectStates(() async {
          bloc.add(RefreshPokemonDetail(tPokemonId));
        });

        expect(emitted, []); // no state change

        verify(
          mockGetPokemonDetailUseCase(
            const PokemonDetailParams(id: tPokemonId, forceRefresh: true),
          ),
        );
      },
    );

    test(
      'should emit Error when refresh fails and current state is not Loaded',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(
          mockGetPokemonDetailUseCase(any),
        ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

        final emitted = await collectStates(() async {
          bloc.add(RefreshPokemonDetail(tPokemonId));
        });

        expect(emitted, [PokemonDetailError('Server error')]);
      },
    );

    test('should call getPokemonDetail with forceRefresh=true', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      await collectStates(() async {
        bloc.add(RefreshPokemonDetail(tPokemonId));
      });

      verify(
        mockGetPokemonDetailUseCase(
          const PokemonDetailParams(id: tPokemonId, forceRefresh: true),
        ),
      );
    });

    test('should emit Error when refresh fails with NetworkFailure', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockGetPokemonDetailUseCase(any)).thenAnswer(
        (_) async => const Left(NetworkFailure('No internet connection')),
      );

      final emitted = await collectStates(() async {
        bloc.add(RefreshPokemonDetail(tPokemonId));
      });

      expect(emitted, [PokemonDetailError('No internet connection')]);
    });
  });

  group('State Transitions', () {
    test('should transition from Initial → Loading → Loaded', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      final emitted = await collectStates(() async {
        bloc.add(LoadPokemonDetail(tPokemonId));
      });

      expect(emitted, [
        PokemonDetailLoading(),
        PokemonDetailLoaded(pokemon: tPokemonDetail),
      ]);
    });

    test('should handle multiple consecutive load events', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonDetailUseCase(any),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      final emitted = await collectStates(() async {
        await Future.delayed(Duration.zero);
        bloc.add(LoadPokemonDetail(1));
        await Future.delayed(Duration.zero);
        bloc.add(LoadPokemonDetail(2));
      });

      expect(emitted, [
        PokemonDetailLoading(),
        PokemonDetailLoaded(pokemon: tPokemonDetail),
        PokemonDetailLoading(),
        PokemonDetailLoaded(pokemon: tPokemonDetail),
      ]);
    });
  });
}
