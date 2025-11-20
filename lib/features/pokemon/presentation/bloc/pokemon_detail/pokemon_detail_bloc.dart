import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_detail/pokemon_detail_event.dart';
import 'package:pokemon_explorer/features/pokemon/presentation/bloc/pokemon_detail/pokemon_detail_state.dart';

import '../../../../../core/network/network_info.dart';
import '../../../domain/usecases/get_pokemon_detail_use_case.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;
  final NetworkInfo networkInfo;
  StreamSubscription<bool>? _networkSub;

  PokemonDetailBloc({
    required this.getPokemonDetailUseCase,
    required this.networkInfo,
  }) : super(PokemonDetailInitial()) {
    on<LoadPokemonDetail>(_onLoadPokemonDetail);
    on<RefreshPokemonDetail>(_onRefreshPokemonDetail);
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

  Future<void> _onLoadPokemonDetail(
    LoadPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading());

    final isConnected = await networkInfo.isConnected;

    final result = await getPokemonDetailUseCase(
      PokemonDetailParams(id: event.pokemonId),
    );

    result.fold(
      (failure) => emit(PokemonDetailError(failure.message)),
      (pokemon) =>
          emit(PokemonDetailLoaded(pokemon: pokemon, isOffline: !isConnected)),
    );
  }

  Future<void> _onRefreshPokemonDetail(
    RefreshPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    final isConnected = await networkInfo.isConnected;

    final result = await getPokemonDetailUseCase(
      PokemonDetailParams(id: event.pokemonId, forceRefresh: true),
    );

    result.fold(
      (failure) {
        if (state is PokemonDetailLoaded) {
          return;
        }
        emit(PokemonDetailError(failure.message));
      },
      (pokemon) =>
          emit(PokemonDetailLoaded(pokemon: pokemon, isOffline: !isConnected)),
    );
  }

  Future<void> _onNetworkStatusChanged(
    NetworkStatusChanged event,
    Emitter<PokemonDetailState> emit,
  ) async {
    if (state is PokemonDetailLoaded) {
      final loaded = state as PokemonDetailLoaded;
      emit(loaded.copyWith(isOffline: !event.isConnected));
    }
  }
}
