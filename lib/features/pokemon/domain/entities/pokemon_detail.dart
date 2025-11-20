import 'package:equatable/equatable.dart';

class PokemonDetail extends Equatable {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonType> types;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;
  final PokemonSprites sprites;
  final String? optimizedImagePath;
  final String? detailImagePath;

  const PokemonDetail({
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
  });

  String get capitalizedName {
    return name[0].toUpperCase() + name.substring(1);
  }

  String get formattedHeight {
    final meters = height / 10;
    return '${meters.toStringAsFixed(1)} m';
  }

  String get formattedWeight {
    final kg = weight / 10;
    return '${kg.toStringAsFixed(1)} kg';
  }

  String get primaryType {
    return types.isNotEmpty ? types[0].name : 'unknown';
  }

  List<String> get typeNames {
    return types.map((t) => t.name).toList();
  }

  String get mainImageUrl {
    return detailImagePath ??
        optimizedImagePath ??
        sprites.officialArtwork ??
        sprites.frontDefault ??
        '';
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
  ];
}

class PokemonType extends Equatable {
  final int slot;
  final String name;

  const PokemonType({required this.slot, required this.name});

  String get capitalizedName {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  List<Object?> get props => [slot, name];
}

class PokemonAbility extends Equatable {
  final String name;
  final bool isHidden;
  final int slot;

  const PokemonAbility({
    required this.name,
    required this.isHidden,
    required this.slot,
  });

  String get formattedName {
    return name
        .split('-')
        .map((word) {
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  @override
  List<Object?> get props => [name, isHidden, slot];
}

class PokemonStat extends Equatable {
  final String name;
  final int baseStat;
  final int effort;

  const PokemonStat({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  String get displayName {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }

  double get percentage {
    return (baseStat / 100).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [name, baseStat, effort];
}

class PokemonSprites extends Equatable {
  final String? frontDefault;
  final String? frontShiny;
  final String? backDefault;
  final String? backShiny;
  final String? officialArtwork;

  const PokemonSprites({
    this.frontDefault,
    this.frontShiny,
    this.backDefault,
    this.backShiny,
    this.officialArtwork,
  });

  List<String> get allSprites {
    return [
      if (officialArtwork != null) officialArtwork!,
      if (frontDefault != null) frontDefault!,
      if (frontShiny != null) frontShiny!,
      if (backDefault != null) backDefault!,
      if (backShiny != null) backShiny!,
    ];
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
