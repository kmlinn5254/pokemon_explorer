import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';
import '../../../../core/database/app_database.dart';

class PokemonModel extends Equatable {
  final int id;
  final String name;
  final String url;
  final String? listPathUrl;
  final DateTime? cachedAt;

  const PokemonModel({
    required this.id,
    required this.name,
    required this.url,
    this.listPathUrl,
    this.cachedAt,
  });

  Pokemon toEntity() {
    return Pokemon(id: id, name: name, url: url, listPathUrl: listPathUrl);
  }

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(url.split('/').where((s) => s.isNotEmpty).last);

    return PokemonModel(
      id: id,
      name: json['name'] as String,
      url: url,
      listPathUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      cachedAt: DateTime.now(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url, 'imageUrl': listPathUrl};
  }

  // From Drift Database
  factory PokemonModel.fromDrift(PokemonTableData data) {
    return PokemonModel(
      id: data.id,
      name: data.name,
      url: data.url,
      listPathUrl: data.listPathUrl,
      cachedAt: data.cachedAt,
    );
  }

  // To Drift Database
  PokemonTableCompanion toDrift() {
    return PokemonTableCompanion.insert(
      id: Value(id),
      name: name,
      url: url,
      listPathUrl: Value(listPathUrl),
      cachedAt: cachedAt ?? DateTime.now(),
    );
  }

  // CopyWith method
  PokemonModel copyWith({
    int? id,
    String? name,
    String? url,
    String? imageUrl,
    DateTime? cachedAt,
  }) {
    return PokemonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      listPathUrl: imageUrl ?? this.listPathUrl,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, url, listPathUrl, cachedAt];
}
