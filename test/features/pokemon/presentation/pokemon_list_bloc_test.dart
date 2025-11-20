import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_explorer/core/error/failures.dart';
import 'package:pokemon_explorer/core/network/network_info.dart';
import 'package:pokemon_explorer/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/refresh_pokemon_list_use_case.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_list/pokemon_list_bloc.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_list/pokemon_list_state.dart';

import '../../../mocks/mock_config.mocks.dart';

@GenerateMocks([GetPokemonListUseCase, RefreshPokemonListUseCase, NetworkInfo])
void main() {
  late PokemonListBloc bloc;
  late MockGetPokemonListUseCase mockGetPokemonListUseCase;
  late MockRefreshPokemonListUseCase mockRefreshPokemonListUseCase;
  late MockNetworkInfo mockNetworkInfo;
  late StreamController<bool> networkStreamController;

  setUp(() {
    mockGetPokemonListUseCase = MockGetPokemonListUseCase();
    mockRefreshPokemonListUseCase = MockRefreshPokemonListUseCase();
    mockNetworkInfo = MockNetworkInfo();

    networkStreamController = StreamController<bool>.broadcast();

    when(
      mockNetworkInfo.onConnectivityChanged,
    ).thenAnswer((_) => networkStreamController.stream);

    bloc = PokemonListBloc(
      getPokemonListUseCase: mockGetPokemonListUseCase,
      refreshPokemonListUseCase: mockRefreshPokemonListUseCase,
      networkInfo: mockNetworkInfo,
    );
  });

  tearDown(() {
    networkStreamController.close();
    bloc.close();
  });

  Future<List<PokemonListState>> collectStates(
    Future<void> Function() action,
  ) async {
    final emittedStates = <PokemonListState>[];
    final subscription = bloc.stream.listen(emittedStates.add);

    await action();
    await Future.delayed(Duration.zero);
    await subscription.cancel();

    return emittedStates;
  }

  group('LoadPokemonList', () {
    final tPokemonList = [
      Pokemon(
        id: 1,
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      ),
      Pokemon(
        id: 2,
        name: 'ivysaur',
        url: 'https://pokeapi.co/api/v2/pokemon/2/',
      ),
      Pokemon(
        id: 3,
        name: 'venusaur',
        url: 'https://pokeapi.co/api/v2/pokemon/3/',
      ),
      Pokemon(
        id: 4,
        name: 'charmander',
        url: 'https://pokeapi.co/api/v2/pokemon/4/',
      ),
      Pokemon(
        id: 5,
        name: 'charmeleon',
        url: 'https://pokeapi.co/api/v2/pokemon/5/',
      ),
      Pokemon(
        id: 6,
        name: 'charizard',
        url: 'https://pokeapi.co/api/v2/pokemon/6/',
      ),
      Pokemon(
        id: 7,
        name: 'squirtle',
        url: 'https://pokeapi.co/api/v2/pokemon/7/',
      ),
      Pokemon(
        id: 8,
        name: 'wartortle',
        url: 'https://pokeapi.co/api/v2/pokemon/8/',
      ),
      Pokemon(
        id: 9,
        name: 'blastoise',
        url: 'https://pokeapi.co/api/v2/pokemon/9/',
      ),
      Pokemon(
        id: 10,
        name: 'caterpie',
        url: 'https://pokeapi.co/api/v2/pokemon/10/',
      ),
      Pokemon(
        id: 11,
        name: 'metapod',
        url: 'https://pokeapi.co/api/v2/pokemon/11/',
      ),
      Pokemon(
        id: 12,
        name: 'butterfree',
        url: 'https://pokeapi.co/api/v2/pokemon/12/',
      ),
      Pokemon(
        id: 13,
        name: 'weedle',
        url: 'https://pokeapi.co/api/v2/pokemon/13/',
      ),
      Pokemon(
        id: 14,
        name: 'kakuna',
        url: 'https://pokeapi.co/api/v2/pokemon/14/',
      ),
      Pokemon(
        id: 15,
        name: 'beedrill',
        url: 'https://pokeapi.co/api/v2/pokemon/15/',
      ),
      Pokemon(
        id: 16,
        name: 'pidgey',
        url: 'https://pokeapi.co/api/v2/pokemon/16/',
      ),
      Pokemon(
        id: 17,
        name: 'pidgeotto',
        url: 'https://pokeapi.co/api/v2/pokemon/17/',
      ),
      Pokemon(
        id: 18,
        name: 'pidgeot',
        url: 'https://pokeapi.co/api/v2/pokemon/18/',
      ),
      Pokemon(
        id: 19,
        name: 'rattata',
        url: 'https://pokeapi.co/api/v2/pokemon/19/',
      ),
      Pokemon(
        id: 20,
        name: 'raticate',
        url: 'https://pokeapi.co/api/v2/pokemon/20/',
      ),
    ];

    test(
      'should emit [Loading, Loaded] when data is fetched successfully',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        when(
          mockGetPokemonListUseCase(any),
        ).thenAnswer((_) async => Right(tPokemonList));

        final emitted = await collectStates(() async {
          bloc.add(LoadPokemonList());
        });

        expect(emitted, [
          PokemonListLoading(),
          PokemonListLoaded(
            pokemon: tPokemonList,
            hasReachedMax: false,
            isOffline: false,
          ),
        ]);
      },
    );

    test('should emit [Loading, Error] when fetching fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        mockGetPokemonListUseCase(any),
      ).thenAnswer((_) async => Left(ServerFailure('Server error')));

      final emitted = await collectStates(() async {
        bloc.add(LoadPokemonList());
      });

      expect(emitted, [PokemonListLoading(), PokemonListError('Server error')]);
    });
  });
}
