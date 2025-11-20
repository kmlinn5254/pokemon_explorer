import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonListUseCase implements UseCase<List<Pokemon>, PokemonListParams> {
  final PokemonRepository repository;

  GetPokemonListUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pokemon>>> call(PokemonListParams params) {
    return repository.getPokemonList(
      offset: params.offset,
      limit: params.limit,
      forceRefresh: params.forceRefresh,
    );
  }
}

class PokemonListParams extends Equatable {
  final int offset;
  final int limit;
  final bool forceRefresh;

  const PokemonListParams({
    required this.offset,
    required this.limit,
    this.forceRefresh = false,
  });

  @override
  List<Object> get props => [offset, limit, forceRefresh];
}