import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_list/pokemon_list_event.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_list/pokemon_list_state.dart';

import '../../../../../core/network/network_info.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_pokemon_list_use_case.dart';
import '../../../domain/usecases/refresh_pokemon_list_use_case.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final GetPokemonListUseCase getPokemonListUseCase;
  final RefreshPokemonListUseCase refreshPokemonListUseCase;
  final NetworkInfo networkInfo;
  StreamSubscription<bool>? _networkSub;

  static const int _pageSize = 20;
  int _currentOffset = 0;

  PokemonListBloc({
    required this.getPokemonListUseCase,
    required this.refreshPokemonListUseCase,
    required this.networkInfo,
  }) : super(PokemonListInitial()) {
    on<LoadPokemonList>(_onLoadPokemonList);
    on<LoadMorePokemon>(_onLoadMorePokemon);
    on<RefreshPokemonList>(_onRefreshPokemonList);
    on<NetworkStatusChanged>(_onNetworkStatusChanged);

    _networkSub = networkInfo.onConnectivityChanged.listen((status) {
      add(NetworkStatusChanged(status));
    });
  }

  @override
  Future<void> close() {
    _networkSub?.cancel();
    return super.close();
  }

  Future<void> _onLoadPokemonList(
    LoadPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(PokemonListLoading());
    final isConnected = await networkInfo.isConnected;

    final result = await getPokemonListUseCase(
      PokemonListParams(offset: 0, limit: _pageSize),
    );

    result.fold((failure) => emit(PokemonListError(failure.message)), (
      pokemon,
    ) {
      _currentOffset = _pageSize;
      emit(
        PokemonListLoaded(
          pokemon: pokemon,
          hasReachedMax: pokemon.length < _pageSize,
          isOffline: !isConnected,
        ),
      );
    });
  }

  Future<void> _onLoadMorePokemon(
    LoadMorePokemon event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state is! PokemonListLoaded) return;

    final isConnected = await networkInfo.isConnected;

    final currentState = state as PokemonListLoaded;
    if (currentState.hasReachedMax) return;

    final result = await getPokemonListUseCase(
      PokemonListParams(offset: _currentOffset, limit: _pageSize),
    );

    result.fold((failure) {}, (newPokemon) {
      _currentOffset += _pageSize;
      emit(
        currentState.copyWith(
          pokemon: [...currentState.pokemon, ...newPokemon],
          hasReachedMax: newPokemon.length < _pageSize,
          isOffline: !isConnected,
        ),
      );
    });
  }

  Future<void> _onRefreshPokemonList(
    RefreshPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    await refreshPokemonListUseCase(NoParams());
    _currentOffset = 0;
    add(LoadPokemonList());
  }

  Future<void> _onNetworkStatusChanged(
    NetworkStatusChanged event,
    Emitter<PokemonListState> emit,
  ) async {
    if (state is PokemonListLoaded) {
      final loaded = state as PokemonListLoaded;
      emit(loaded.copyWith(isOffline: !event.isConnected));
    }
  }
}
