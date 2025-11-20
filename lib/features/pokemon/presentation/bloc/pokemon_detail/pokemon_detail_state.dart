import 'package:equatable/equatable.dart';

import '../../../domain/entities/pokemon_detail.dart';

abstract class PokemonDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final PokemonDetail pokemon;
  final bool isOffline;

  PokemonDetailLoaded({required this.pokemon, this.isOffline = false});

  @override
  List<Object> get props => [pokemon, isOffline];

  PokemonDetailLoaded copyWith({PokemonDetail? pokemon, bool? isOffline}) {
    return PokemonDetailLoaded(
      pokemon: pokemon ?? this.pokemon,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class PokemonDetailError extends PokemonDetailState {
  final String message;

  PokemonDetailError(this.message);

  @override
  List<Object> get props => [message];
}
