
import 'package:equatable/equatable.dart';

abstract class PokemonDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPokemonDetail extends PokemonDetailEvent {
  final int pokemonId;

  LoadPokemonDetail(this.pokemonId);

  @override
  List<Object> get props => [pokemonId];
}

class RefreshPokemonDetail extends PokemonDetailEvent {
  final int pokemonId;

  RefreshPokemonDetail(this.pokemonId);

  @override
  List<Object> get props => [pokemonId];
}

class NetworkStatusChanged extends PokemonDetailEvent {
  final bool isConnected;
  NetworkStatusChanged(this.isConnected);
}
