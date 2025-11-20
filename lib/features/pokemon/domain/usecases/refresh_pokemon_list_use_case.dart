import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/pokemon_repository.dart';

class RefreshPokemonListUseCase implements UseCase<Unit, NoParams> {
  final PokemonRepository repository;

  RefreshPokemonListUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.refreshPokemonList();
  }
}
