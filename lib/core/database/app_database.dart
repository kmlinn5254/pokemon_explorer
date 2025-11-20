import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

class PokemonTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  TextColumn get listPathUrl => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();
}

class PokemonDetailTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pokemonId => integer().unique()();
  TextColumn get name => text()();
  IntColumn get height => integer()();
  IntColumn get weight => integer()();
  TextColumn get types => text()();
  TextColumn get abilities => text()();
  TextColumn get stats => text()();
  TextColumn get sprites => text()();
  TextColumn get optimizedImagePath => text().nullable()();
  TextColumn get detailImagePath => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();
}

@DriftDatabase(tables: [PokemonTable, PokemonDetailTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'pokemon.db'));
      return NativeDatabase(file);
    });
  }
}