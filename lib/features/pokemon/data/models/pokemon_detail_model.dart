import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon_detail.dart';
import '../../../../core/database/app_database.dart';

class PokemonDetailModel extends Equatable {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonTypeModel> types;
  final List<PokemonAbilityModel> abilities;
  final List<PokemonStatModel> stats;
  final PokemonSpritesModel sprites;
  final String? optimizedImagePath;
  final String? detailImagePath;
  final DateTime? cachedAt;

  const PokemonDetailModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.sprites,
    this.optimizedImagePath,
    this.detailImagePath,
    this.cachedAt,
  });

  PokemonDetail toEntity() {
    return PokemonDetail(
      id: id,
      name: name,
      height: height,
      weight: weight,
      types: types.map((t) => t.toEntity()).toList(),
      abilities: abilities.map((a) => a.toEntity()).toList(),
      stats: stats.map((s) => s.toEntity()).toList(),
      sprites: sprites.toEntity(),
      optimizedImagePath: optimizedImagePath,
      detailImagePath: detailImagePath,
    );
  }

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      types: (json['types'] as List)
          .map((t) => PokemonTypeModel.fromJson(t))
          .toList(),
      abilities: (json['abilities'] as List)
          .map((a) => PokemonAbilityModel.fromJson(a))
          .toList(),
      stats: (json['stats'] as List)
          .map((s) => PokemonStatModel.fromJson(s))
          .toList(),
      sprites: PokemonSpritesModel.fromJson(json['sprites']),
      detailImagePath:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${json['id'] as int}.png',
      cachedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'weight': weight,
      'types': types.map((t) => t.toJson()).toList(),
      'abilities': abilities.map((a) => a.toJson()).toList(),
      'stats': stats.map((s) => s.toJson()).toList(),
      'sprites': sprites.toJson(),
      'optimizedImagePath': optimizedImagePath,
    };
  }

  factory PokemonDetailModel.fromDrift(PokemonDetailTableData data) {
    return PokemonDetailModel(
      id: data.pokemonId,
      name: data.name,
      height: data.height,
      weight: data.weight,
      types: (jsonDecode(data.types) as List)
          .map((t) => PokemonTypeModel.fromJson(t))
          .toList(),
      abilities: (jsonDecode(data.abilities) as List)
          .map((a) => PokemonAbilityModel.fromJson(a))
          .toList(),
      stats: (jsonDecode(data.stats) as List)
          .map((s) => PokemonStatModel.fromJson(s))
          .toList(),
      sprites: PokemonSpritesModel.fromJson(jsonDecode(data.sprites)),
      optimizedImagePath: data.optimizedImagePath,
      cachedAt: data.cachedAt,
    );
  }

  PokemonDetailTableCompanion toDrift() {
    return PokemonDetailTableCompanion.insert(
      pokemonId: id,
      name: name,
      height: height,
      weight: weight,
      types: jsonEncode(types.map((t) => t.toJson()).toList()),
      abilities: jsonEncode(abilities.map((a) => a.toJson()).toList()),
      stats: jsonEncode(stats.map((s) => s.toJson()).toList()),
      sprites: jsonEncode(sprites.toJson()),
      optimizedImagePath: Value(optimizedImagePath),
      cachedAt: cachedAt ?? DateTime.now(),
    );
  }

  PokemonDetailModel copyWith({
    int? id,
    String? name,
    int? height,
    int? weight,
    List<PokemonTypeModel>? types,
    List<PokemonAbilityModel>? abilities,
    List<PokemonStatModel>? stats,
    PokemonSpritesModel? sprites,
    String? optimizedImagePath,
    String? detailImagePath,
    DateTime? cachedAt,
    List<String?>? spriteUrlPaths,
  }) {
    return PokemonDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      types: types ?? this.types,
      abilities: abilities ?? this.abilities,
      stats: stats ?? this.stats,
      sprites: sprites ?? this.sprites,
      optimizedImagePath: optimizedImagePath ?? this.optimizedImagePath,
      detailImagePath: detailImagePath ?? this.detailImagePath,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    height,
    weight,
    types,
    abilities,
    stats,
    sprites,
    optimizedImagePath,
    detailImagePath,
    cachedAt,
  ];
}

class PokemonTypeModel extends Equatable {
  final int slot;
  final String name;

  const PokemonTypeModel({required this.slot, required this.name});

  PokemonType toEntity() {
    return PokemonType(slot: slot, name: name);
  }

  factory PokemonTypeModel.fromJson(Map<String, dynamic> json) {
    return PokemonTypeModel(
      slot: json['slot'] as int,
      name: json['type']['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slot': slot,
      'type': {'name': name},
    };
  }

  @override
  List<Object?> get props => [slot, name];
}

class PokemonAbilityModel extends Equatable {
  final String name;
  final bool isHidden;
  final int slot;

  const PokemonAbilityModel({
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  PokemonAbility toEntity() {
    return PokemonAbility(name: name, isHidden: isHidden, slot: slot);
  }

  factory PokemonAbilityModel.fromJson(Map<String, dynamic> json) {
    return PokemonAbilityModel(
      name: json['ability']['name'] as String,
      isHidden: json['is_hidden'] as bool,
      slot: json['slot'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ability': {'name': name},
      'is_hidden': isHidden,
      'slot': slot,
    };
  }

  @override
  List<Object?> get props => [name, isHidden, slot];
}

class PokemonStatModel extends Equatable {
  final String name;
  final int baseStat;
  final int effort;

  const PokemonStatModel({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  PokemonStat toEntity() {
    return PokemonStat(name: name, baseStat: baseStat, effort: effort);
  }

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) {
    return PokemonStatModel(
      name: json['stat']['name'] as String,
      baseStat: json['base_stat'] as int,
      effort: json['effort'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stat': {'name': name},
      'base_stat': baseStat,
      'effort': effort,
    };
  }

  @override
  List<Object?> get props => [name, baseStat, effort];
}

class PokemonSpritesModel extends Equatable {
  final String? frontDefault;
  final String? frontShiny;
  final String? backDefault;
  final String? backShiny;
  final String? officialArtwork;

  const PokemonSpritesModel({
    this.frontDefault,
    this.frontShiny,
    this.backDefault,
    this.backShiny,
    this.officialArtwork,
  });

  PokemonSprites toEntity() {
    return PokemonSprites(
      frontDefault: frontDefault,
      frontShiny: frontShiny,
      backDefault: backDefault,
      backShiny: backShiny,
      officialArtwork: officialArtwork,
    );
  }

  factory PokemonSpritesModel.fromJson(Map<String, dynamic> json) {
    return PokemonSpritesModel(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
      backDefault: json['back_default'] as String?,
      backShiny: json['back_shiny'] as String?,
      officialArtwork:
          json['other']?['official-artwork']?['front_default'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'front_default': frontDefault,
      'front_shiny': frontShiny,
      'back_default': backDefault,
      'back_shiny': backShiny,
      'other': {
        'official-artwork': {'front_default': officialArtwork},
      },
    };
  }

  @override
  List<Object?> get props => [
    frontDefault,
    frontShiny,
    backDefault,
    backShiny,
    officialArtwork,
  ];
}
