import 'package:mockito/annotations.dart';
import 'package:pokemon_explorer/core/network/network_info.dart';
import 'package:pokemon_explorer/core/services/image_optimization_service.dart';
import 'package:pokemon_explorer/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:pokemon_explorer/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokemon_explorer/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/get_pokemon_detail_use_case.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokemon_explorer/features/pokemon/domain/usecases/refresh_pokemon_list_use_case.dart';

@GenerateMocks([
  // Data Sources
  PokemonRemoteDataSource,
  PokemonLocalDataSource,

  // Repository
  PokemonRepository,

  // Use Cases
  GetPokemonListUseCase,
  GetPokemonDetailUseCase,
  RefreshPokemonListUseCase,

  // Core Services
  NetworkInfo,
  ImageOptimizationService,
])
void main() {}
