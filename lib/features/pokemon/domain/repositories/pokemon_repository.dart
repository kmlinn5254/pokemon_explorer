import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pokemon.dart';
import '../entities/pokemon_detail.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    required int offset,
    required int limit,
    bool forceRefresh = false,
  });

  Future<Either<Failure, PokemonDetail>> getPokemonDetail({
    required int id,
    bool forceRefresh = false,
  });

  Future<Either<Failure, Unit>> refreshPokemonList();
}