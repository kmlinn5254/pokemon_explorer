import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pokemon_detail.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonDetailUseCase implements UseCase<PokemonDetail, PokemonDetailParams> {
  final PokemonRepository repository;

  GetPokemonDetailUseCase(this.repository);

  @override
  Future<Either<Failure, PokemonDetail>> call(
    PokemonDetailParams params,
  ) async {
    return await repository.getPokemonDetail(
      id: params.id,
      forceRefresh: params.forceRefresh,
    );
  }
}

class PokemonDetailParams extends Equatable {
  final int id;
  final bool forceRefresh;

  const PokemonDetailParams({required this.id, this.forceRefresh = false});

  @override
  List<Object> get props => [id, forceRefresh];
}
