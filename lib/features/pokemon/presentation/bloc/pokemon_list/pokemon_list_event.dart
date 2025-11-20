import 'package:equatable/equatable.dart';

abstract class PokemonListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPokemonList extends PokemonListEvent {}

class LoadMorePokemon extends PokemonListEvent {}

class RefreshPokemonList extends PokemonListEvent {}

class NetworkStatusChanged extends PokemonListEvent {
  final bool isConnected;
  NetworkStatusChanged(this.isConnected);
}
