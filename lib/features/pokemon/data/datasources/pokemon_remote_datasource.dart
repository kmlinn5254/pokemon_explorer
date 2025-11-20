import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemonList(int offset, int limit);

  Future<PokemonDetailModel> getPokemonDetail(int id);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio dio;

  PokemonRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PokemonModel>> getPokemonList(int offset, int limit) async {
    try {
      final response = await dio.get(
        '/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      final results = response.data['results'] as List;
      return results.map((json) => PokemonModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<PokemonDetailModel> getPokemonDetail(int id) async {
    try {
      final response = await dio.get('/pokemon/$id');
      return PokemonDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
}
