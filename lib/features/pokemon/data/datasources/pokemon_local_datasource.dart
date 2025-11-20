import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../models/pokemon_detail_model.dart';
import '../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  Future<List<PokemonModel>> getCachedPokemonList(int offset, int limit);

  Future<void> cachePokemonList(List<PokemonModel> pokemon);

  Future<PokemonDetailModel> getCachedPokemonDetail(int id);

  Future<void> cachePokemonDetail(PokemonDetailModel detail);

  Future<bool> isListCacheValid();

  Future<bool> isCacheValid(int id);

  Future<void> clearCache();

  Future<void> updatePokemonImagePaths(int id, String listPath);

  Future<void> updatePokemonDetail(PokemonDetailModel detail);
}

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final AppDatabase database;
  static const cacheValidityDuration = Duration(hours: 24);

  PokemonLocalDataSourceImpl({required this.database});

  @override
  Future<List<PokemonModel>> getCachedPokemonList(int offset, int limit) async {
    final query = database.select(database.pokemonTable)
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map((row) => PokemonModel.fromDrift(row)).toList();
  }

  @override
  Future<void> cachePokemonList(List<PokemonModel> pokemon) async {
    await database.batch((batch) {
      batch.insertAll(
        database.pokemonTable,
        pokemon.map((p) => p.toDrift()).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<bool> isListCacheValid() async {
    try {
      final query =
          await (database.select(database.pokemonTable)
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.cachedAt,
                    mode: OrderingMode.desc,
                  ),
                ])
                ..limit(1))
              .getSingleOrNull();

      if (query == null) return false;

      final cacheAge = DateTime.now().difference(query.cachedAt);
      return cacheAge < cacheValidityDuration;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> isCacheValid(int id) async {
    final query = database.select(database.pokemonDetailTable)
      ..where((t) => t.pokemonId.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return false;

    final cacheAge = DateTime.now().difference(row.cachedAt);
    return cacheAge < cacheValidityDuration;
  }

  @override
  Future<void> clearCache() async {
    await database.delete(database.pokemonTable).go();
    await database.delete(database.pokemonDetailTable).go();
  }

  @override
  Future<void> updatePokemonImagePaths(int id, String listPath) async {
    await (database.update(database.pokemonTable)
          ..where((t) => t.id.equals(id)))
        .write(PokemonTableCompanion(listPathUrl: Value(listPath)));
  }

  @override
  Future<PokemonDetailModel> getCachedPokemonDetail(int id) async {
    final query = database.select(database.pokemonDetailTable)
      ..where((t) => t.pokemonId.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) {
      throw Exception("No cached detail found for Pokemon ID $id");
    }

    return PokemonDetailModel.fromDrift(row);
  }

  @override
  Future<void> cachePokemonDetail(PokemonDetailModel detail) async {
    await database
        .into(database.pokemonDetailTable)
        .insertOnConflictUpdate(
          detail.toDrift().copyWith(cachedAt: Value(DateTime.now())),
        );
  }

  @override
  Future<void> updatePokemonDetail(PokemonDetailModel detail) async {
    await database
        .into(database.pokemonDetailTable)
        .insertOnConflictUpdate(
      detail.toDrift().copyWith(cachedAt: Value(DateTime.now())),
    );
  }
}
