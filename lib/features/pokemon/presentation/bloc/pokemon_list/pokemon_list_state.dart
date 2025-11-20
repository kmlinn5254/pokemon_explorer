import 'package:equatable/equatable.dart';

import '../../../domain/entities/pokemon.dart';

abstract class PokemonListState extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  final List<Pokemon> pokemon;
  final bool hasReachedMax;
  final bool isOffline;

  PokemonListLoaded({
    required this.pokemon,
    this.hasReachedMax = false,
    this.isOffline = false,
  });

  @override
  List<Object> get props => [pokemon, hasReachedMax, isOffline];

  PokemonListLoaded copyWith({
    List<Pokemon>? pokemon,
    bool? hasReachedMax,
    bool? isOffline,
  }) {
    return PokemonListLoaded(
      pokemon: pokemon ?? this.pokemon,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class PokemonListError extends PokemonListState {
  final String message;

  PokemonListError(this.message);

  @override
  List<Object> get props => [message];
}
