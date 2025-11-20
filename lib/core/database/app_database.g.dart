// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PokemonTableTable extends PokemonTable
    with TableInfo<$PokemonTableTable, PokemonTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokemonTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listPathUrlMeta = const VerificationMeta(
    'listPathUrl',
  );
  @override
  late final GeneratedColumn<String> listPathUrl = GeneratedColumn<String>(
    'list_path_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, url, listPathUrl, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokemon_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PokemonTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('list_path_url')) {
      context.handle(
        _listPathUrlMeta,
        listPathUrl.isAcceptableOrUnknown(
          data['list_path_url']!,
          _listPathUrlMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PokemonTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PokemonTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      listPathUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_path_url'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PokemonTableTable createAlias(String alias) {
    return $PokemonTableTable(attachedDatabase, alias);
  }
}

class PokemonTableData extends DataClass
    implements Insertable<PokemonTableData> {
  final int id;
  final String name;
  final String url;
  final String? listPathUrl;
  final DateTime cachedAt;
  const PokemonTableData({
    required this.id,
    required this.name,
    required this.url,
    this.listPathUrl,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || listPathUrl != null) {
      map['list_path_url'] = Variable<String>(listPathUrl);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PokemonTableCompanion toCompanion(bool nullToAbsent) {
    return PokemonTableCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      listPathUrl: listPathUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(listPathUrl),
      cachedAt: Value(cachedAt),
    );
  }

  factory PokemonTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PokemonTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      listPathUrl: serializer.fromJson<String?>(json['listPathUrl']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'listPathUrl': serializer.toJson<String?>(listPathUrl),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PokemonTableData copyWith({
    int? id,
    String? name,
    String? url,
    Value<String?> listPathUrl = const Value.absent(),
    DateTime? cachedAt,
  }) => PokemonTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    url: url ?? this.url,
    listPathUrl: listPathUrl.present ? listPathUrl.value : this.listPathUrl,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PokemonTableData copyWithCompanion(PokemonTableCompanion data) {
    return PokemonTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      listPathUrl: data.listPathUrl.present
          ? data.listPathUrl.value
          : this.listPathUrl,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PokemonTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('listPathUrl: $listPathUrl, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, url, listPathUrl, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PokemonTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.listPathUrl == this.listPathUrl &&
          other.cachedAt == this.cachedAt);
}

class PokemonTableCompanion extends UpdateCompanion<PokemonTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String?> listPathUrl;
  final Value<DateTime> cachedAt;
  const PokemonTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.listPathUrl = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  PokemonTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String url,
    this.listPathUrl = const Value.absent(),
    required DateTime cachedAt,
  }) : name = Value(name),
       url = Value(url),
       cachedAt = Value(cachedAt);
  static Insertable<PokemonTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? listPathUrl,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (listPathUrl != null) 'list_path_url': listPathUrl,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  PokemonTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? url,
    Value<String?>? listPathUrl,
    Value<DateTime>? cachedAt,
  }) {
    return PokemonTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      listPathUrl: listPathUrl ?? this.listPathUrl,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (listPathUrl.present) {
      map['list_path_url'] = Variable<String>(listPathUrl.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokemonTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('listPathUrl: $listPathUrl, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $PokemonDetailTableTable extends PokemonDetailTable
    with TableInfo<$PokemonDetailTableTable, PokemonDetailTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PokemonDetailTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pokemonIdMeta = const VerificationMeta(
    'pokemonId',
  );
  @override
  late final GeneratedColumn<int> pokemonId = GeneratedColumn<int>(
    'pokemon_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typesMeta = const VerificationMeta('types');
  @override
  late final GeneratedColumn<String> types = GeneratedColumn<String>(
    'types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilitiesMeta = const VerificationMeta(
    'abilities',
  );
  @override
  late final GeneratedColumn<String> abilities = GeneratedColumn<String>(
    'abilities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statsMeta = const VerificationMeta('stats');
  @override
  late final GeneratedColumn<String> stats = GeneratedColumn<String>(
    'stats',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spritesMeta = const VerificationMeta(
    'sprites',
  );
  @override
  late final GeneratedColumn<String> sprites = GeneratedColumn<String>(
    'sprites',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optimizedImagePathMeta =
      const VerificationMeta('optimizedImagePath');
  @override
  late final GeneratedColumn<String> optimizedImagePath =
      GeneratedColumn<String>(
        'optimized_image_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _detailImagePathMeta = const VerificationMeta(
    'detailImagePath',
  );
  @override
  late final GeneratedColumn<String> detailImagePath = GeneratedColumn<String>(
    'detail_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pokemonId,
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
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pokemon_detail_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PokemonDetailTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pokemon_id')) {
      context.handle(
        _pokemonIdMeta,
        pokemonId.isAcceptableOrUnknown(data['pokemon_id']!, _pokemonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pokemonIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('types')) {
      context.handle(
        _typesMeta,
        types.isAcceptableOrUnknown(data['types']!, _typesMeta),
      );
    } else if (isInserting) {
      context.missing(_typesMeta);
    }
    if (data.containsKey('abilities')) {
      context.handle(
        _abilitiesMeta,
        abilities.isAcceptableOrUnknown(data['abilities']!, _abilitiesMeta),
      );
    } else if (isInserting) {
      context.missing(_abilitiesMeta);
    }
    if (data.containsKey('stats')) {
      context.handle(
        _statsMeta,
        stats.isAcceptableOrUnknown(data['stats']!, _statsMeta),
      );
    } else if (isInserting) {
      context.missing(_statsMeta);
    }
    if (data.containsKey('sprites')) {
      context.handle(
        _spritesMeta,
        sprites.isAcceptableOrUnknown(data['sprites']!, _spritesMeta),
      );
    } else if (isInserting) {
      context.missing(_spritesMeta);
    }
    if (data.containsKey('optimized_image_path')) {
      context.handle(
        _optimizedImagePathMeta,
        optimizedImagePath.isAcceptableOrUnknown(
          data['optimized_image_path']!,
          _optimizedImagePathMeta,
        ),
      );
    }
    if (data.containsKey('detail_image_path')) {
      context.handle(
        _detailImagePathMeta,
        detailImagePath.isAcceptableOrUnknown(
          data['detail_image_path']!,
          _detailImagePathMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PokemonDetailTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PokemonDetailTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pokemonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pokemon_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      )!,
      types: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}types'],
      )!,
      abilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abilities'],
      )!,
      stats: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stats'],
      )!,
      sprites: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sprites'],
      )!,
      optimizedImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}optimized_image_path'],
      ),
      detailImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_image_path'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $PokemonDetailTableTable createAlias(String alias) {
    return $PokemonDetailTableTable(attachedDatabase, alias);
  }
}

class PokemonDetailTableData extends DataClass
    implements Insertable<PokemonDetailTableData> {
  final int id;
  final int pokemonId;
  final String name;
  final int height;
  final int weight;
  final String types;
  final String abilities;
  final String stats;
  final String sprites;
  final String? optimizedImagePath;
  final String? detailImagePath;
  final DateTime cachedAt;
  const PokemonDetailTableData({
    required this.id,
    required this.pokemonId,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.sprites,
    this.optimizedImagePath,
    this.detailImagePath,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pokemon_id'] = Variable<int>(pokemonId);
    map['name'] = Variable<String>(name);
    map['height'] = Variable<int>(height);
    map['weight'] = Variable<int>(weight);
    map['types'] = Variable<String>(types);
    map['abilities'] = Variable<String>(abilities);
    map['stats'] = Variable<String>(stats);
    map['sprites'] = Variable<String>(sprites);
    if (!nullToAbsent || optimizedImagePath != null) {
      map['optimized_image_path'] = Variable<String>(optimizedImagePath);
    }
    if (!nullToAbsent || detailImagePath != null) {
      map['detail_image_path'] = Variable<String>(detailImagePath);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PokemonDetailTableCompanion toCompanion(bool nullToAbsent) {
    return PokemonDetailTableCompanion(
      id: Value(id),
      pokemonId: Value(pokemonId),
      name: Value(name),
      height: Value(height),
      weight: Value(weight),
      types: Value(types),
      abilities: Value(abilities),
      stats: Value(stats),
      sprites: Value(sprites),
      optimizedImagePath: optimizedImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(optimizedImagePath),
      detailImagePath: detailImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(detailImagePath),
      cachedAt: Value(cachedAt),
    );
  }

  factory PokemonDetailTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PokemonDetailTableData(
      id: serializer.fromJson<int>(json['id']),
      pokemonId: serializer.fromJson<int>(json['pokemonId']),
      name: serializer.fromJson<String>(json['name']),
      height: serializer.fromJson<int>(json['height']),
      weight: serializer.fromJson<int>(json['weight']),
      types: serializer.fromJson<String>(json['types']),
      abilities: serializer.fromJson<String>(json['abilities']),
      stats: serializer.fromJson<String>(json['stats']),
      sprites: serializer.fromJson<String>(json['sprites']),
      optimizedImagePath: serializer.fromJson<String?>(
        json['optimizedImagePath'],
      ),
      detailImagePath: serializer.fromJson<String?>(json['detailImagePath']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pokemonId': serializer.toJson<int>(pokemonId),
      'name': serializer.toJson<String>(name),
      'height': serializer.toJson<int>(height),
      'weight': serializer.toJson<int>(weight),
      'types': serializer.toJson<String>(types),
      'abilities': serializer.toJson<String>(abilities),
      'stats': serializer.toJson<String>(stats),
      'sprites': serializer.toJson<String>(sprites),
      'optimizedImagePath': serializer.toJson<String?>(optimizedImagePath),
      'detailImagePath': serializer.toJson<String?>(detailImagePath),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PokemonDetailTableData copyWith({
    int? id,
    int? pokemonId,
    String? name,
    int? height,
    int? weight,
    String? types,
    String? abilities,
    String? stats,
    String? sprites,
    Value<String?> optimizedImagePath = const Value.absent(),
    Value<String?> detailImagePath = const Value.absent(),
    DateTime? cachedAt,
  }) => PokemonDetailTableData(
    id: id ?? this.id,
    pokemonId: pokemonId ?? this.pokemonId,
    name: name ?? this.name,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    types: types ?? this.types,
    abilities: abilities ?? this.abilities,
    stats: stats ?? this.stats,
    sprites: sprites ?? this.sprites,
    optimizedImagePath: optimizedImagePath.present
        ? optimizedImagePath.value
        : this.optimizedImagePath,
    detailImagePath: detailImagePath.present
        ? detailImagePath.value
        : this.detailImagePath,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  PokemonDetailTableData copyWithCompanion(PokemonDetailTableCompanion data) {
    return PokemonDetailTableData(
      id: data.id.present ? data.id.value : this.id,
      pokemonId: data.pokemonId.present ? data.pokemonId.value : this.pokemonId,
      name: data.name.present ? data.name.value : this.name,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      types: data.types.present ? data.types.value : this.types,
      abilities: data.abilities.present ? data.abilities.value : this.abilities,
      stats: data.stats.present ? data.stats.value : this.stats,
      sprites: data.sprites.present ? data.sprites.value : this.sprites,
      optimizedImagePath: data.optimizedImagePath.present
          ? data.optimizedImagePath.value
          : this.optimizedImagePath,
      detailImagePath: data.detailImagePath.present
          ? data.detailImagePath.value
          : this.detailImagePath,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PokemonDetailTableData(')
          ..write('id: $id, ')
          ..write('pokemonId: $pokemonId, ')
          ..write('name: $name, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('types: $types, ')
          ..write('abilities: $abilities, ')
          ..write('stats: $stats, ')
          ..write('sprites: $sprites, ')
          ..write('optimizedImagePath: $optimizedImagePath, ')
          ..write('detailImagePath: $detailImagePath, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pokemonId,
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
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PokemonDetailTableData &&
          other.id == this.id &&
          other.pokemonId == this.pokemonId &&
          other.name == this.name &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.types == this.types &&
          other.abilities == this.abilities &&
          other.stats == this.stats &&
          other.sprites == this.sprites &&
          other.optimizedImagePath == this.optimizedImagePath &&
          other.detailImagePath == this.detailImagePath &&
          other.cachedAt == this.cachedAt);
}

class PokemonDetailTableCompanion
    extends UpdateCompanion<PokemonDetailTableData> {
  final Value<int> id;
  final Value<int> pokemonId;
  final Value<String> name;
  final Value<int> height;
  final Value<int> weight;
  final Value<String> types;
  final Value<String> abilities;
  final Value<String> stats;
  final Value<String> sprites;
  final Value<String?> optimizedImagePath;
  final Value<String?> detailImagePath;
  final Value<DateTime> cachedAt;
  const PokemonDetailTableCompanion({
    this.id = const Value.absent(),
    this.pokemonId = const Value.absent(),
    this.name = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.types = const Value.absent(),
    this.abilities = const Value.absent(),
    this.stats = const Value.absent(),
    this.sprites = const Value.absent(),
    this.optimizedImagePath = const Value.absent(),
    this.detailImagePath = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  PokemonDetailTableCompanion.insert({
    this.id = const Value.absent(),
    required int pokemonId,
    required String name,
    required int height,
    required int weight,
    required String types,
    required String abilities,
    required String stats,
    required String sprites,
    this.optimizedImagePath = const Value.absent(),
    this.detailImagePath = const Value.absent(),
    required DateTime cachedAt,
  }) : pokemonId = Value(pokemonId),
       name = Value(name),
       height = Value(height),
       weight = Value(weight),
       types = Value(types),
       abilities = Value(abilities),
       stats = Value(stats),
       sprites = Value(sprites),
       cachedAt = Value(cachedAt);
  static Insertable<PokemonDetailTableData> custom({
    Expression<int>? id,
    Expression<int>? pokemonId,
    Expression<String>? name,
    Expression<int>? height,
    Expression<int>? weight,
    Expression<String>? types,
    Expression<String>? abilities,
    Expression<String>? stats,
    Expression<String>? sprites,
    Expression<String>? optimizedImagePath,
    Expression<String>? detailImagePath,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pokemonId != null) 'pokemon_id': pokemonId,
      if (name != null) 'name': name,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (types != null) 'types': types,
      if (abilities != null) 'abilities': abilities,
      if (stats != null) 'stats': stats,
      if (sprites != null) 'sprites': sprites,
      if (optimizedImagePath != null)
        'optimized_image_path': optimizedImagePath,
      if (detailImagePath != null) 'detail_image_path': detailImagePath,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  PokemonDetailTableCompanion copyWith({
    Value<int>? id,
    Value<int>? pokemonId,
    Value<String>? name,
    Value<int>? height,
    Value<int>? weight,
    Value<String>? types,
    Value<String>? abilities,
    Value<String>? stats,
    Value<String>? sprites,
    Value<String?>? optimizedImagePath,
    Value<String?>? detailImagePath,
    Value<DateTime>? cachedAt,
  }) {
    return PokemonDetailTableCompanion(
      id: id ?? this.id,
      pokemonId: pokemonId ?? this.pokemonId,
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
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pokemonId.present) {
      map['pokemon_id'] = Variable<int>(pokemonId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (types.present) {
      map['types'] = Variable<String>(types.value);
    }
    if (abilities.present) {
      map['abilities'] = Variable<String>(abilities.value);
    }
    if (stats.present) {
      map['stats'] = Variable<String>(stats.value);
    }
    if (sprites.present) {
      map['sprites'] = Variable<String>(sprites.value);
    }
    if (optimizedImagePath.present) {
      map['optimized_image_path'] = Variable<String>(optimizedImagePath.value);
    }
    if (detailImagePath.present) {
      map['detail_image_path'] = Variable<String>(detailImagePath.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PokemonDetailTableCompanion(')
          ..write('id: $id, ')
          ..write('pokemonId: $pokemonId, ')
          ..write('name: $name, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('types: $types, ')
          ..write('abilities: $abilities, ')
          ..write('stats: $stats, ')
          ..write('sprites: $sprites, ')
          ..write('optimizedImagePath: $optimizedImagePath, ')
          ..write('detailImagePath: $detailImagePath, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PokemonTableTable pokemonTable = $PokemonTableTable(this);
  late final $PokemonDetailTableTable pokemonDetailTable =
      $PokemonDetailTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pokemonTable,
    pokemonDetailTable,
  ];
}

typedef $$PokemonTableTableCreateCompanionBuilder =
    PokemonTableCompanion Function({
      Value<int> id,
      required String name,
      required String url,
      Value<String?> listPathUrl,
      required DateTime cachedAt,
    });
typedef $$PokemonTableTableUpdateCompanionBuilder =
    PokemonTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> url,
      Value<String?> listPathUrl,
      Value<DateTime> cachedAt,
    });

class $$PokemonTableTableFilterComposer
    extends Composer<_$AppDatabase, $PokemonTableTable> {
  $$PokemonTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listPathUrl => $composableBuilder(
    column: $table.listPathUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PokemonTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PokemonTableTable> {
  $$PokemonTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listPathUrl => $composableBuilder(
    column: $table.listPathUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PokemonTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PokemonTableTable> {
  $$PokemonTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get listPathUrl => $composableBuilder(
    column: $table.listPathUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PokemonTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PokemonTableTable,
          PokemonTableData,
          $$PokemonTableTableFilterComposer,
          $$PokemonTableTableOrderingComposer,
          $$PokemonTableTableAnnotationComposer,
          $$PokemonTableTableCreateCompanionBuilder,
          $$PokemonTableTableUpdateCompanionBuilder,
          (
            PokemonTableData,
            BaseReferences<_$AppDatabase, $PokemonTableTable, PokemonTableData>,
          ),
          PokemonTableData,
          PrefetchHooks Function()
        > {
  $$PokemonTableTableTableManager(_$AppDatabase db, $PokemonTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PokemonTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PokemonTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PokemonTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> listPathUrl = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => PokemonTableCompanion(
                id: id,
                name: name,
                url: url,
                listPathUrl: listPathUrl,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String url,
                Value<String?> listPathUrl = const Value.absent(),
                required DateTime cachedAt,
              }) => PokemonTableCompanion.insert(
                id: id,
                name: name,
                url: url,
                listPathUrl: listPathUrl,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PokemonTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PokemonTableTable,
      PokemonTableData,
      $$PokemonTableTableFilterComposer,
      $$PokemonTableTableOrderingComposer,
      $$PokemonTableTableAnnotationComposer,
      $$PokemonTableTableCreateCompanionBuilder,
      $$PokemonTableTableUpdateCompanionBuilder,
      (
        PokemonTableData,
        BaseReferences<_$AppDatabase, $PokemonTableTable, PokemonTableData>,
      ),
      PokemonTableData,
      PrefetchHooks Function()
    >;
typedef $$PokemonDetailTableTableCreateCompanionBuilder =
    PokemonDetailTableCompanion Function({
      Value<int> id,
      required int pokemonId,
      required String name,
      required int height,
      required int weight,
      required String types,
      required String abilities,
      required String stats,
      required String sprites,
      Value<String?> optimizedImagePath,
      Value<String?> detailImagePath,
      required DateTime cachedAt,
    });
typedef $$PokemonDetailTableTableUpdateCompanionBuilder =
    PokemonDetailTableCompanion Function({
      Value<int> id,
      Value<int> pokemonId,
      Value<String> name,
      Value<int> height,
      Value<int> weight,
      Value<String> types,
      Value<String> abilities,
      Value<String> stats,
      Value<String> sprites,
      Value<String?> optimizedImagePath,
      Value<String?> detailImagePath,
      Value<DateTime> cachedAt,
    });

class $$PokemonDetailTableTableFilterComposer
    extends Composer<_$AppDatabase, $PokemonDetailTableTable> {
  $$PokemonDetailTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pokemonId => $composableBuilder(
    column: $table.pokemonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get types => $composableBuilder(
    column: $table.types,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilities => $composableBuilder(
    column: $table.abilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stats => $composableBuilder(
    column: $table.stats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sprites => $composableBuilder(
    column: $table.sprites,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optimizedImagePath => $composableBuilder(
    column: $table.optimizedImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailImagePath => $composableBuilder(
    column: $table.detailImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PokemonDetailTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PokemonDetailTableTable> {
  $$PokemonDetailTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pokemonId => $composableBuilder(
    column: $table.pokemonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get types => $composableBuilder(
    column: $table.types,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilities => $composableBuilder(
    column: $table.abilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stats => $composableBuilder(
    column: $table.stats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sprites => $composableBuilder(
    column: $table.sprites,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optimizedImagePath => $composableBuilder(
    column: $table.optimizedImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailImagePath => $composableBuilder(
    column: $table.detailImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PokemonDetailTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PokemonDetailTableTable> {
  $$PokemonDetailTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pokemonId =>
      $composableBuilder(column: $table.pokemonId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get types =>
      $composableBuilder(column: $table.types, builder: (column) => column);

  GeneratedColumn<String> get abilities =>
      $composableBuilder(column: $table.abilities, builder: (column) => column);

  GeneratedColumn<String> get stats =>
      $composableBuilder(column: $table.stats, builder: (column) => column);

  GeneratedColumn<String> get sprites =>
      $composableBuilder(column: $table.sprites, builder: (column) => column);

  GeneratedColumn<String> get optimizedImagePath => $composableBuilder(
    column: $table.optimizedImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detailImagePath => $composableBuilder(
    column: $table.detailImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PokemonDetailTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PokemonDetailTableTable,
          PokemonDetailTableData,
          $$PokemonDetailTableTableFilterComposer,
          $$PokemonDetailTableTableOrderingComposer,
          $$PokemonDetailTableTableAnnotationComposer,
          $$PokemonDetailTableTableCreateCompanionBuilder,
          $$PokemonDetailTableTableUpdateCompanionBuilder,
          (
            PokemonDetailTableData,
            BaseReferences<
              _$AppDatabase,
              $PokemonDetailTableTable,
              PokemonDetailTableData
            >,
          ),
          PokemonDetailTableData,
          PrefetchHooks Function()
        > {
  $$PokemonDetailTableTableTableManager(
    _$AppDatabase db,
    $PokemonDetailTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PokemonDetailTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PokemonDetailTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PokemonDetailTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pokemonId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> weight = const Value.absent(),
                Value<String> types = const Value.absent(),
                Value<String> abilities = const Value.absent(),
                Value<String> stats = const Value.absent(),
                Value<String> sprites = const Value.absent(),
                Value<String?> optimizedImagePath = const Value.absent(),
                Value<String?> detailImagePath = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => PokemonDetailTableCompanion(
                id: id,
                pokemonId: pokemonId,
                name: name,
                height: height,
                weight: weight,
                types: types,
                abilities: abilities,
                stats: stats,
                sprites: sprites,
                optimizedImagePath: optimizedImagePath,
                detailImagePath: detailImagePath,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pokemonId,
                required String name,
                required int height,
                required int weight,
                required String types,
                required String abilities,
                required String stats,
                required String sprites,
                Value<String?> optimizedImagePath = const Value.absent(),
                Value<String?> detailImagePath = const Value.absent(),
                required DateTime cachedAt,
              }) => PokemonDetailTableCompanion.insert(
                id: id,
                pokemonId: pokemonId,
                name: name,
                height: height,
                weight: weight,
                types: types,
                abilities: abilities,
                stats: stats,
                sprites: sprites,
                optimizedImagePath: optimizedImagePath,
                detailImagePath: detailImagePath,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PokemonDetailTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PokemonDetailTableTable,
      PokemonDetailTableData,
      $$PokemonDetailTableTableFilterComposer,
      $$PokemonDetailTableTableOrderingComposer,
      $$PokemonDetailTableTableAnnotationComposer,
      $$PokemonDetailTableTableCreateCompanionBuilder,
      $$PokemonDetailTableTableUpdateCompanionBuilder,
      (
        PokemonDetailTableData,
        BaseReferences<
          _$AppDatabase,
          $PokemonDetailTableTable,
          PokemonDetailTableData
        >,
      ),
      PokemonDetailTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PokemonTableTableTableManager get pokemonTable =>
      $$PokemonTableTableTableManager(_db, _db.pokemonTable);
  $$PokemonDetailTableTableTableManager get pokemonDetailTable =>
      $$PokemonDetailTableTableTableManager(_db, _db.pokemonDetailTable);
}
