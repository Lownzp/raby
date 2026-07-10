// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RabbitsTable extends Rabbits with TableInfo<$RabbitsTable, RabbitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RabbitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adoptedDateMeta = const VerificationMeta(
    'adoptedDate',
  );
  @override
  late final GeneratedColumn<String> adoptedDate = GeneratedColumn<String>(
    'adopted_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _furColorMeta = const VerificationMeta(
    'furColor',
  );
  @override
  late final GeneratedColumn<String> furColor = GeneratedColumn<String>(
    'fur_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neuteredStatusMeta = const VerificationMeta(
    'neuteredStatus',
  );
  @override
  late final GeneratedColumn<String> neuteredStatus = GeneratedColumn<String>(
    'neutered_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neuteredDateMeta = const VerificationMeta(
    'neuteredDate',
  );
  @override
  late final GeneratedColumn<String> neuteredDate = GeneratedColumn<String>(
    'neutered_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chipNumberMeta = const VerificationMeta(
    'chipNumber',
  );
  @override
  late final GeneratedColumn<String> chipNumber = GeneratedColumn<String>(
    'chip_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _initialWeightGramsMeta =
      const VerificationMeta('initialWeightGrams');
  @override
  late final GeneratedColumn<int> initialWeightGrams = GeneratedColumn<int>(
    'initial_weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalityTagsJsonMeta =
      const VerificationMeta('personalityTagsJson');
  @override
  late final GeneratedColumn<String> personalityTagsJson =
      GeneratedColumn<String>(
        'personality_tags_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _favoriteFoodsMeta = const VerificationMeta(
    'favoriteFoods',
  );
  @override
  late final GeneratedColumn<String> favoriteFoods = GeneratedColumn<String>(
    'favorite_foods',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteToysMeta = const VerificationMeta(
    'favoriteToys',
  );
  @override
  late final GeneratedColumn<String> favoriteToys = GeneratedColumn<String>(
    'favorite_toys',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passedAwayDateMeta = const VerificationMeta(
    'passedAwayDate',
  );
  @override
  late final GeneratedColumn<String> passedAwayDate = GeneratedColumn<String>(
    'passed_away_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    sex,
    birthDate,
    adoptedDate,
    breed,
    furColor,
    avatarPath,
    source,
    neuteredStatus,
    neuteredDate,
    chipNumber,
    initialWeightGrams,
    personalityTagsJson,
    favoriteFoods,
    favoriteToys,
    passedAwayDate,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rabbits';
  @override
  VerificationContext validateIntegrity(
    Insertable<RabbitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('adopted_date')) {
      context.handle(
        _adoptedDateMeta,
        adoptedDate.isAcceptableOrUnknown(
          data['adopted_date']!,
          _adoptedDateMeta,
        ),
      );
    }
    if (data.containsKey('breed')) {
      context.handle(
        _breedMeta,
        breed.isAcceptableOrUnknown(data['breed']!, _breedMeta),
      );
    } else if (isInserting) {
      context.missing(_breedMeta);
    }
    if (data.containsKey('fur_color')) {
      context.handle(
        _furColorMeta,
        furColor.isAcceptableOrUnknown(data['fur_color']!, _furColorMeta),
      );
    } else if (isInserting) {
      context.missing(_furColorMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('neutered_status')) {
      context.handle(
        _neuteredStatusMeta,
        neuteredStatus.isAcceptableOrUnknown(
          data['neutered_status']!,
          _neuteredStatusMeta,
        ),
      );
    }
    if (data.containsKey('neutered_date')) {
      context.handle(
        _neuteredDateMeta,
        neuteredDate.isAcceptableOrUnknown(
          data['neutered_date']!,
          _neuteredDateMeta,
        ),
      );
    }
    if (data.containsKey('chip_number')) {
      context.handle(
        _chipNumberMeta,
        chipNumber.isAcceptableOrUnknown(data['chip_number']!, _chipNumberMeta),
      );
    }
    if (data.containsKey('initial_weight_grams')) {
      context.handle(
        _initialWeightGramsMeta,
        initialWeightGrams.isAcceptableOrUnknown(
          data['initial_weight_grams']!,
          _initialWeightGramsMeta,
        ),
      );
    }
    if (data.containsKey('personality_tags_json')) {
      context.handle(
        _personalityTagsJsonMeta,
        personalityTagsJson.isAcceptableOrUnknown(
          data['personality_tags_json']!,
          _personalityTagsJsonMeta,
        ),
      );
    }
    if (data.containsKey('favorite_foods')) {
      context.handle(
        _favoriteFoodsMeta,
        favoriteFoods.isAcceptableOrUnknown(
          data['favorite_foods']!,
          _favoriteFoodsMeta,
        ),
      );
    }
    if (data.containsKey('favorite_toys')) {
      context.handle(
        _favoriteToysMeta,
        favoriteToys.isAcceptableOrUnknown(
          data['favorite_toys']!,
          _favoriteToysMeta,
        ),
      );
    }
    if (data.containsKey('passed_away_date')) {
      context.handle(
        _passedAwayDateMeta,
        passedAwayDate.isAcceptableOrUnknown(
          data['passed_away_date']!,
          _passedAwayDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RabbitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RabbitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_date'],
      ),
      adoptedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adopted_date'],
      ),
      breed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed'],
      )!,
      furColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fur_color'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      neuteredStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neutered_status'],
      ),
      neuteredDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neutered_date'],
      ),
      chipNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chip_number'],
      ),
      initialWeightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_weight_grams'],
      ),
      personalityTagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personality_tags_json'],
      ),
      favoriteFoods: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_foods'],
      ),
      favoriteToys: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favorite_toys'],
      ),
      passedAwayDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}passed_away_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $RabbitsTable createAlias(String alias) {
    return $RabbitsTable(attachedDatabase, alias);
  }
}

class RabbitRow extends DataClass implements Insertable<RabbitRow> {
  final String id;
  final String name;
  final String sex;
  final String? birthDate;
  final String? adoptedDate;
  final String breed;
  final String furColor;
  final String? avatarPath;
  final String? source;
  final String? neuteredStatus;
  final String? neuteredDate;
  final String? chipNumber;
  final int? initialWeightGrams;
  final String? personalityTagsJson;
  final String? favoriteFoods;
  final String? favoriteToys;
  final String? passedAwayDate;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const RabbitRow({
    required this.id,
    required this.name,
    required this.sex,
    this.birthDate,
    this.adoptedDate,
    required this.breed,
    required this.furColor,
    this.avatarPath,
    this.source,
    this.neuteredStatus,
    this.neuteredDate,
    this.chipNumber,
    this.initialWeightGrams,
    this.personalityTagsJson,
    this.favoriteFoods,
    this.favoriteToys,
    this.passedAwayDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(birthDate);
    }
    if (!nullToAbsent || adoptedDate != null) {
      map['adopted_date'] = Variable<String>(adoptedDate);
    }
    map['breed'] = Variable<String>(breed);
    map['fur_color'] = Variable<String>(furColor);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || neuteredStatus != null) {
      map['neutered_status'] = Variable<String>(neuteredStatus);
    }
    if (!nullToAbsent || neuteredDate != null) {
      map['neutered_date'] = Variable<String>(neuteredDate);
    }
    if (!nullToAbsent || chipNumber != null) {
      map['chip_number'] = Variable<String>(chipNumber);
    }
    if (!nullToAbsent || initialWeightGrams != null) {
      map['initial_weight_grams'] = Variable<int>(initialWeightGrams);
    }
    if (!nullToAbsent || personalityTagsJson != null) {
      map['personality_tags_json'] = Variable<String>(personalityTagsJson);
    }
    if (!nullToAbsent || favoriteFoods != null) {
      map['favorite_foods'] = Variable<String>(favoriteFoods);
    }
    if (!nullToAbsent || favoriteToys != null) {
      map['favorite_toys'] = Variable<String>(favoriteToys);
    }
    if (!nullToAbsent || passedAwayDate != null) {
      map['passed_away_date'] = Variable<String>(passedAwayDate);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  RabbitsCompanion toCompanion(bool nullToAbsent) {
    return RabbitsCompanion(
      id: Value(id),
      name: Value(name),
      sex: Value(sex),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      adoptedDate: adoptedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(adoptedDate),
      breed: Value(breed),
      furColor: Value(furColor),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      neuteredStatus: neuteredStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(neuteredStatus),
      neuteredDate: neuteredDate == null && nullToAbsent
          ? const Value.absent()
          : Value(neuteredDate),
      chipNumber: chipNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chipNumber),
      initialWeightGrams: initialWeightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(initialWeightGrams),
      personalityTagsJson: personalityTagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(personalityTagsJson),
      favoriteFoods: favoriteFoods == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteFoods),
      favoriteToys: favoriteToys == null && nullToAbsent
          ? const Value.absent()
          : Value(favoriteToys),
      passedAwayDate: passedAwayDate == null && nullToAbsent
          ? const Value.absent()
          : Value(passedAwayDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory RabbitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RabbitRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sex: serializer.fromJson<String>(json['sex']),
      birthDate: serializer.fromJson<String?>(json['birthDate']),
      adoptedDate: serializer.fromJson<String?>(json['adoptedDate']),
      breed: serializer.fromJson<String>(json['breed']),
      furColor: serializer.fromJson<String>(json['furColor']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      source: serializer.fromJson<String?>(json['source']),
      neuteredStatus: serializer.fromJson<String?>(json['neuteredStatus']),
      neuteredDate: serializer.fromJson<String?>(json['neuteredDate']),
      chipNumber: serializer.fromJson<String?>(json['chipNumber']),
      initialWeightGrams: serializer.fromJson<int?>(json['initialWeightGrams']),
      personalityTagsJson: serializer.fromJson<String?>(
        json['personalityTagsJson'],
      ),
      favoriteFoods: serializer.fromJson<String?>(json['favoriteFoods']),
      favoriteToys: serializer.fromJson<String?>(json['favoriteToys']),
      passedAwayDate: serializer.fromJson<String?>(json['passedAwayDate']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'sex': serializer.toJson<String>(sex),
      'birthDate': serializer.toJson<String?>(birthDate),
      'adoptedDate': serializer.toJson<String?>(adoptedDate),
      'breed': serializer.toJson<String>(breed),
      'furColor': serializer.toJson<String>(furColor),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'source': serializer.toJson<String?>(source),
      'neuteredStatus': serializer.toJson<String?>(neuteredStatus),
      'neuteredDate': serializer.toJson<String?>(neuteredDate),
      'chipNumber': serializer.toJson<String?>(chipNumber),
      'initialWeightGrams': serializer.toJson<int?>(initialWeightGrams),
      'personalityTagsJson': serializer.toJson<String?>(personalityTagsJson),
      'favoriteFoods': serializer.toJson<String?>(favoriteFoods),
      'favoriteToys': serializer.toJson<String?>(favoriteToys),
      'passedAwayDate': serializer.toJson<String?>(passedAwayDate),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  RabbitRow copyWith({
    String? id,
    String? name,
    String? sex,
    Value<String?> birthDate = const Value.absent(),
    Value<String?> adoptedDate = const Value.absent(),
    String? breed,
    String? furColor,
    Value<String?> avatarPath = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> neuteredStatus = const Value.absent(),
    Value<String?> neuteredDate = const Value.absent(),
    Value<String?> chipNumber = const Value.absent(),
    Value<int?> initialWeightGrams = const Value.absent(),
    Value<String?> personalityTagsJson = const Value.absent(),
    Value<String?> favoriteFoods = const Value.absent(),
    Value<String?> favoriteToys = const Value.absent(),
    Value<String?> passedAwayDate = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => RabbitRow(
    id: id ?? this.id,
    name: name ?? this.name,
    sex: sex ?? this.sex,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    adoptedDate: adoptedDate.present ? adoptedDate.value : this.adoptedDate,
    breed: breed ?? this.breed,
    furColor: furColor ?? this.furColor,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    source: source.present ? source.value : this.source,
    neuteredStatus: neuteredStatus.present
        ? neuteredStatus.value
        : this.neuteredStatus,
    neuteredDate: neuteredDate.present ? neuteredDate.value : this.neuteredDate,
    chipNumber: chipNumber.present ? chipNumber.value : this.chipNumber,
    initialWeightGrams: initialWeightGrams.present
        ? initialWeightGrams.value
        : this.initialWeightGrams,
    personalityTagsJson: personalityTagsJson.present
        ? personalityTagsJson.value
        : this.personalityTagsJson,
    favoriteFoods: favoriteFoods.present
        ? favoriteFoods.value
        : this.favoriteFoods,
    favoriteToys: favoriteToys.present ? favoriteToys.value : this.favoriteToys,
    passedAwayDate: passedAwayDate.present
        ? passedAwayDate.value
        : this.passedAwayDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  RabbitRow copyWithCompanion(RabbitsCompanion data) {
    return RabbitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      adoptedDate: data.adoptedDate.present
          ? data.adoptedDate.value
          : this.adoptedDate,
      breed: data.breed.present ? data.breed.value : this.breed,
      furColor: data.furColor.present ? data.furColor.value : this.furColor,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      source: data.source.present ? data.source.value : this.source,
      neuteredStatus: data.neuteredStatus.present
          ? data.neuteredStatus.value
          : this.neuteredStatus,
      neuteredDate: data.neuteredDate.present
          ? data.neuteredDate.value
          : this.neuteredDate,
      chipNumber: data.chipNumber.present
          ? data.chipNumber.value
          : this.chipNumber,
      initialWeightGrams: data.initialWeightGrams.present
          ? data.initialWeightGrams.value
          : this.initialWeightGrams,
      personalityTagsJson: data.personalityTagsJson.present
          ? data.personalityTagsJson.value
          : this.personalityTagsJson,
      favoriteFoods: data.favoriteFoods.present
          ? data.favoriteFoods.value
          : this.favoriteFoods,
      favoriteToys: data.favoriteToys.present
          ? data.favoriteToys.value
          : this.favoriteToys,
      passedAwayDate: data.passedAwayDate.present
          ? data.passedAwayDate.value
          : this.passedAwayDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RabbitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('birthDate: $birthDate, ')
          ..write('adoptedDate: $adoptedDate, ')
          ..write('breed: $breed, ')
          ..write('furColor: $furColor, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('source: $source, ')
          ..write('neuteredStatus: $neuteredStatus, ')
          ..write('neuteredDate: $neuteredDate, ')
          ..write('chipNumber: $chipNumber, ')
          ..write('initialWeightGrams: $initialWeightGrams, ')
          ..write('personalityTagsJson: $personalityTagsJson, ')
          ..write('favoriteFoods: $favoriteFoods, ')
          ..write('favoriteToys: $favoriteToys, ')
          ..write('passedAwayDate: $passedAwayDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    sex,
    birthDate,
    adoptedDate,
    breed,
    furColor,
    avatarPath,
    source,
    neuteredStatus,
    neuteredDate,
    chipNumber,
    initialWeightGrams,
    personalityTagsJson,
    favoriteFoods,
    favoriteToys,
    passedAwayDate,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RabbitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sex == this.sex &&
          other.birthDate == this.birthDate &&
          other.adoptedDate == this.adoptedDate &&
          other.breed == this.breed &&
          other.furColor == this.furColor &&
          other.avatarPath == this.avatarPath &&
          other.source == this.source &&
          other.neuteredStatus == this.neuteredStatus &&
          other.neuteredDate == this.neuteredDate &&
          other.chipNumber == this.chipNumber &&
          other.initialWeightGrams == this.initialWeightGrams &&
          other.personalityTagsJson == this.personalityTagsJson &&
          other.favoriteFoods == this.favoriteFoods &&
          other.favoriteToys == this.favoriteToys &&
          other.passedAwayDate == this.passedAwayDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class RabbitsCompanion extends UpdateCompanion<RabbitRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> sex;
  final Value<String?> birthDate;
  final Value<String?> adoptedDate;
  final Value<String> breed;
  final Value<String> furColor;
  final Value<String?> avatarPath;
  final Value<String?> source;
  final Value<String?> neuteredStatus;
  final Value<String?> neuteredDate;
  final Value<String?> chipNumber;
  final Value<int?> initialWeightGrams;
  final Value<String?> personalityTagsJson;
  final Value<String?> favoriteFoods;
  final Value<String?> favoriteToys;
  final Value<String?> passedAwayDate;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const RabbitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.adoptedDate = const Value.absent(),
    this.breed = const Value.absent(),
    this.furColor = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.source = const Value.absent(),
    this.neuteredStatus = const Value.absent(),
    this.neuteredDate = const Value.absent(),
    this.chipNumber = const Value.absent(),
    this.initialWeightGrams = const Value.absent(),
    this.personalityTagsJson = const Value.absent(),
    this.favoriteFoods = const Value.absent(),
    this.favoriteToys = const Value.absent(),
    this.passedAwayDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RabbitsCompanion.insert({
    required String id,
    required String name,
    required String sex,
    this.birthDate = const Value.absent(),
    this.adoptedDate = const Value.absent(),
    required String breed,
    required String furColor,
    this.avatarPath = const Value.absent(),
    this.source = const Value.absent(),
    this.neuteredStatus = const Value.absent(),
    this.neuteredDate = const Value.absent(),
    this.chipNumber = const Value.absent(),
    this.initialWeightGrams = const Value.absent(),
    this.personalityTagsJson = const Value.absent(),
    this.favoriteFoods = const Value.absent(),
    this.favoriteToys = const Value.absent(),
    this.passedAwayDate = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sex = Value(sex),
       breed = Value(breed),
       furColor = Value(furColor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RabbitRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? sex,
    Expression<String>? birthDate,
    Expression<String>? adoptedDate,
    Expression<String>? breed,
    Expression<String>? furColor,
    Expression<String>? avatarPath,
    Expression<String>? source,
    Expression<String>? neuteredStatus,
    Expression<String>? neuteredDate,
    Expression<String>? chipNumber,
    Expression<int>? initialWeightGrams,
    Expression<String>? personalityTagsJson,
    Expression<String>? favoriteFoods,
    Expression<String>? favoriteToys,
    Expression<String>? passedAwayDate,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sex != null) 'sex': sex,
      if (birthDate != null) 'birth_date': birthDate,
      if (adoptedDate != null) 'adopted_date': adoptedDate,
      if (breed != null) 'breed': breed,
      if (furColor != null) 'fur_color': furColor,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (source != null) 'source': source,
      if (neuteredStatus != null) 'neutered_status': neuteredStatus,
      if (neuteredDate != null) 'neutered_date': neuteredDate,
      if (chipNumber != null) 'chip_number': chipNumber,
      if (initialWeightGrams != null)
        'initial_weight_grams': initialWeightGrams,
      if (personalityTagsJson != null)
        'personality_tags_json': personalityTagsJson,
      if (favoriteFoods != null) 'favorite_foods': favoriteFoods,
      if (favoriteToys != null) 'favorite_toys': favoriteToys,
      if (passedAwayDate != null) 'passed_away_date': passedAwayDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RabbitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? sex,
    Value<String?>? birthDate,
    Value<String?>? adoptedDate,
    Value<String>? breed,
    Value<String>? furColor,
    Value<String?>? avatarPath,
    Value<String?>? source,
    Value<String?>? neuteredStatus,
    Value<String?>? neuteredDate,
    Value<String?>? chipNumber,
    Value<int?>? initialWeightGrams,
    Value<String?>? personalityTagsJson,
    Value<String?>? favoriteFoods,
    Value<String?>? favoriteToys,
    Value<String?>? passedAwayDate,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return RabbitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      adoptedDate: adoptedDate ?? this.adoptedDate,
      breed: breed ?? this.breed,
      furColor: furColor ?? this.furColor,
      avatarPath: avatarPath ?? this.avatarPath,
      source: source ?? this.source,
      neuteredStatus: neuteredStatus ?? this.neuteredStatus,
      neuteredDate: neuteredDate ?? this.neuteredDate,
      chipNumber: chipNumber ?? this.chipNumber,
      initialWeightGrams: initialWeightGrams ?? this.initialWeightGrams,
      personalityTagsJson: personalityTagsJson ?? this.personalityTagsJson,
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
      favoriteToys: favoriteToys ?? this.favoriteToys,
      passedAwayDate: passedAwayDate ?? this.passedAwayDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (adoptedDate.present) {
      map['adopted_date'] = Variable<String>(adoptedDate.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (furColor.present) {
      map['fur_color'] = Variable<String>(furColor.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (neuteredStatus.present) {
      map['neutered_status'] = Variable<String>(neuteredStatus.value);
    }
    if (neuteredDate.present) {
      map['neutered_date'] = Variable<String>(neuteredDate.value);
    }
    if (chipNumber.present) {
      map['chip_number'] = Variable<String>(chipNumber.value);
    }
    if (initialWeightGrams.present) {
      map['initial_weight_grams'] = Variable<int>(initialWeightGrams.value);
    }
    if (personalityTagsJson.present) {
      map['personality_tags_json'] = Variable<String>(
        personalityTagsJson.value,
      );
    }
    if (favoriteFoods.present) {
      map['favorite_foods'] = Variable<String>(favoriteFoods.value);
    }
    if (favoriteToys.present) {
      map['favorite_toys'] = Variable<String>(favoriteToys.value);
    }
    if (passedAwayDate.present) {
      map['passed_away_date'] = Variable<String>(passedAwayDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RabbitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sex: $sex, ')
          ..write('birthDate: $birthDate, ')
          ..write('adoptedDate: $adoptedDate, ')
          ..write('breed: $breed, ')
          ..write('furColor: $furColor, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('source: $source, ')
          ..write('neuteredStatus: $neuteredStatus, ')
          ..write('neuteredDate: $neuteredDate, ')
          ..write('chipNumber: $chipNumber, ')
          ..write('initialWeightGrams: $initialWeightGrams, ')
          ..write('personalityTagsJson: $personalityTagsJson, ')
          ..write('favoriteFoods: $favoriteFoods, ')
          ..write('favoriteToys: $favoriteToys, ')
          ..write('passedAwayDate: $passedAwayDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiariesTable extends Diaries with TableInfo<$DiariesTable, DiaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rabbitIdMeta = const VerificationMeta(
    'rabbitId',
  );
  @override
  late final GeneratedColumn<String> rabbitId = GeneratedColumn<String>(
    'rabbit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rabbits (id)',
    ),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rabbitId,
    recordedAt,
    content,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rabbit_id')) {
      context.handle(
        _rabbitIdMeta,
        rabbitId.isAcceptableOrUnknown(data['rabbit_id']!, _rabbitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rabbitIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rabbitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rabbit_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DiariesTable createAlias(String alias) {
    return $DiariesTable(attachedDatabase, alias);
  }
}

class DiaryRow extends DataClass implements Insertable<DiaryRow> {
  final String id;
  final String rabbitId;
  final int recordedAt;
  final String? content;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const DiaryRow({
    required this.id,
    required this.rabbitId,
    required this.recordedAt,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rabbit_id'] = Variable<String>(rabbitId);
    map['recorded_at'] = Variable<int>(recordedAt);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  DiariesCompanion toCompanion(bool nullToAbsent) {
    return DiariesCompanion(
      id: Value(id),
      rabbitId: Value(rabbitId),
      recordedAt: Value(recordedAt),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DiaryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryRow(
      id: serializer.fromJson<String>(json['id']),
      rabbitId: serializer.fromJson<String>(json['rabbitId']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      content: serializer.fromJson<String?>(json['content']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rabbitId': serializer.toJson<String>(rabbitId),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'content': serializer.toJson<String?>(content),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  DiaryRow copyWith({
    String? id,
    String? rabbitId,
    int? recordedAt,
    Value<String?> content = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => DiaryRow(
    id: id ?? this.id,
    rabbitId: rabbitId ?? this.rabbitId,
    recordedAt: recordedAt ?? this.recordedAt,
    content: content.present ? content.value : this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DiaryRow copyWithCompanion(DiariesCompanion data) {
    return DiaryRow(
      id: data.id.present ? data.id.value : this.id,
      rabbitId: data.rabbitId.present ? data.rabbitId.value : this.rabbitId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryRow(')
          ..write('id: $id, ')
          ..write('rabbitId: $rabbitId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rabbitId,
    recordedAt,
    content,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryRow &&
          other.id == this.id &&
          other.rabbitId == this.rabbitId &&
          other.recordedAt == this.recordedAt &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DiariesCompanion extends UpdateCompanion<DiaryRow> {
  final Value<String> id;
  final Value<String> rabbitId;
  final Value<int> recordedAt;
  final Value<String?> content;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const DiariesCompanion({
    this.id = const Value.absent(),
    this.rabbitId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiariesCompanion.insert({
    required String id,
    required String rabbitId,
    required int recordedAt,
    this.content = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rabbitId = Value(rabbitId),
       recordedAt = Value(recordedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DiaryRow> custom({
    Expression<String>? id,
    Expression<String>? rabbitId,
    Expression<int>? recordedAt,
    Expression<String>? content,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rabbitId != null) 'rabbit_id': rabbitId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiariesCompanion copyWith({
    Value<String>? id,
    Value<String>? rabbitId,
    Value<int>? recordedAt,
    Value<String?>? content,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return DiariesCompanion(
      id: id ?? this.id,
      rabbitId: rabbitId ?? this.rabbitId,
      recordedAt: recordedAt ?? this.recordedAt,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rabbitId.present) {
      map['rabbit_id'] = Variable<String>(rabbitId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiariesCompanion(')
          ..write('id: $id, ')
          ..write('rabbitId: $rabbitId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryMediaItemsTable extends DiaryMediaItems
    with TableInfo<$DiaryMediaItemsTable, DiaryMediaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryMediaItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaryIdMeta = const VerificationMeta(
    'diaryId',
  );
  @override
  late final GeneratedColumn<String> diaryId = GeneratedColumn<String>(
    'diary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diaries (id)',
    ),
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diaryId,
    mediaType,
    relativePath,
    thumbnailPath,
    mimeType,
    width,
    height,
    fileSizeBytes,
    durationMs,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryMediaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('diary_id')) {
      context.handle(
        _diaryIdMeta,
        diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryIdMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryMediaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryMediaRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      diaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diary_id'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      relativePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DiaryMediaItemsTable createAlias(String alias) {
    return $DiaryMediaItemsTable(attachedDatabase, alias);
  }
}

class DiaryMediaRow extends DataClass implements Insertable<DiaryMediaRow> {
  final String id;
  final String diaryId;
  final String mediaType;
  final String relativePath;
  final String? thumbnailPath;
  final String? mimeType;
  final int? width;
  final int? height;
  final int? fileSizeBytes;
  final int? durationMs;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const DiaryMediaRow({
    required this.id,
    required this.diaryId,
    required this.mediaType,
    required this.relativePath,
    this.thumbnailPath,
    this.mimeType,
    this.width,
    this.height,
    this.fileSizeBytes,
    this.durationMs,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['diary_id'] = Variable<String>(diaryId);
    map['media_type'] = Variable<String>(mediaType);
    map['relative_path'] = Variable<String>(relativePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  DiaryMediaItemsCompanion toCompanion(bool nullToAbsent) {
    return DiaryMediaItemsCompanion(
      id: Value(id),
      diaryId: Value(diaryId),
      mediaType: Value(mediaType),
      relativePath: Value(relativePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      width: width == null && nullToAbsent
          ? const Value.absent()
          : Value(width),
      height: height == null && nullToAbsent
          ? const Value.absent()
          : Value(height),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DiaryMediaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryMediaRow(
      id: serializer.fromJson<String>(json['id']),
      diaryId: serializer.fromJson<String>(json['diaryId']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'diaryId': serializer.toJson<String>(diaryId),
      'mediaType': serializer.toJson<String>(mediaType),
      'relativePath': serializer.toJson<String>(relativePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'durationMs': serializer.toJson<int?>(durationMs),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  DiaryMediaRow copyWith({
    String? id,
    String? diaryId,
    String? mediaType,
    String? relativePath,
    Value<String?> thumbnailPath = const Value.absent(),
    Value<String?> mimeType = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<int?> fileSizeBytes = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => DiaryMediaRow(
    id: id ?? this.id,
    diaryId: diaryId ?? this.diaryId,
    mediaType: mediaType ?? this.mediaType,
    relativePath: relativePath ?? this.relativePath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    fileSizeBytes: fileSizeBytes.present
        ? fileSizeBytes.value
        : this.fileSizeBytes,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DiaryMediaRow copyWithCompanion(DiaryMediaItemsCompanion data) {
    return DiaryMediaRow(
      id: data.id.present ? data.id.value : this.id,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      relativePath: data.relativePath.present
          ? data.relativePath.value
          : this.relativePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryMediaRow(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('mediaType: $mediaType, ')
          ..write('relativePath: $relativePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    diaryId,
    mediaType,
    relativePath,
    thumbnailPath,
    mimeType,
    width,
    height,
    fileSizeBytes,
    durationMs,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryMediaRow &&
          other.id == this.id &&
          other.diaryId == this.diaryId &&
          other.mediaType == this.mediaType &&
          other.relativePath == this.relativePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.mimeType == this.mimeType &&
          other.width == this.width &&
          other.height == this.height &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.durationMs == this.durationMs &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DiaryMediaItemsCompanion extends UpdateCompanion<DiaryMediaRow> {
  final Value<String> id;
  final Value<String> diaryId;
  final Value<String> mediaType;
  final Value<String> relativePath;
  final Value<String?> thumbnailPath;
  final Value<String?> mimeType;
  final Value<int?> width;
  final Value<int?> height;
  final Value<int?> fileSizeBytes;
  final Value<int?> durationMs;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const DiaryMediaItemsCompanion({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryMediaItemsCompanion.insert({
    required String id,
    required String diaryId,
    required String mediaType,
    required String relativePath,
    this.thumbnailPath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.durationMs = const Value.absent(),
    required int sortOrder,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       diaryId = Value(diaryId),
       mediaType = Value(mediaType),
       relativePath = Value(relativePath),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DiaryMediaRow> custom({
    Expression<String>? id,
    Expression<String>? diaryId,
    Expression<String>? mediaType,
    Expression<String>? relativePath,
    Expression<String>? thumbnailPath,
    Expression<String>? mimeType,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? fileSizeBytes,
    Expression<int>? durationMs,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryId != null) 'diary_id': diaryId,
      if (mediaType != null) 'media_type': mediaType,
      if (relativePath != null) 'relative_path': relativePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (mimeType != null) 'mime_type': mimeType,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (durationMs != null) 'duration_ms': durationMs,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryMediaItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? diaryId,
    Value<String>? mediaType,
    Value<String>? relativePath,
    Value<String?>? thumbnailPath,
    Value<String?>? mimeType,
    Value<int?>? width,
    Value<int?>? height,
    Value<int?>? fileSizeBytes,
    Value<int?>? durationMs,
    Value<int>? sortOrder,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return DiaryMediaItemsCompanion(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      mediaType: mediaType ?? this.mediaType,
      relativePath: relativePath ?? this.relativePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      mimeType: mimeType ?? this.mimeType,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      durationMs: durationMs ?? this.durationMs,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<String>(diaryId.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryMediaItemsCompanion(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('mediaType: $mediaType, ')
          ..write('relativePath: $relativePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('mimeType: $mimeType, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rabbitIdMeta = const VerificationMeta(
    'rabbitId',
  );
  @override
  late final GeneratedColumn<String> rabbitId = GeneratedColumn<String>(
    'rabbit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rabbits (id)',
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
  static const VerificationMeta _tagKindMeta = const VerificationMeta(
    'tagKind',
  );
  @override
  late final GeneratedColumn<String> tagKind = GeneratedColumn<String>(
    'tag_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _colorTokenMeta = const VerificationMeta(
    'colorToken',
  );
  @override
  late final GeneratedColumn<String> colorToken = GeneratedColumn<String>(
    'color_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rabbitId,
    name,
    tagKind,
    isSystem,
    colorToken,
    iconName,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rabbit_id')) {
      context.handle(
        _rabbitIdMeta,
        rabbitId.isAcceptableOrUnknown(data['rabbit_id']!, _rabbitIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tag_kind')) {
      context.handle(
        _tagKindMeta,
        tagKind.isAcceptableOrUnknown(data['tag_kind']!, _tagKindMeta),
      );
    } else if (isInserting) {
      context.missing(_tagKindMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('color_token')) {
      context.handle(
        _colorTokenMeta,
        colorToken.isAcceptableOrUnknown(data['color_token']!, _colorTokenMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rabbitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rabbit_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      tagKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_kind'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      colorToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_token'],
      ),
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String? rabbitId;
  final String name;
  final String tagKind;
  final bool isSystem;
  final String? colorToken;
  final String? iconName;
  final int sortOrder;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const TagRow({
    required this.id,
    this.rabbitId,
    required this.name,
    required this.tagKind,
    required this.isSystem,
    this.colorToken,
    this.iconName,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || rabbitId != null) {
      map['rabbit_id'] = Variable<String>(rabbitId);
    }
    map['name'] = Variable<String>(name);
    map['tag_kind'] = Variable<String>(tagKind);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || colorToken != null) {
      map['color_token'] = Variable<String>(colorToken);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      rabbitId: rabbitId == null && nullToAbsent
          ? const Value.absent()
          : Value(rabbitId),
      name: Value(name),
      tagKind: Value(tagKind),
      isSystem: Value(isSystem),
      colorToken: colorToken == null && nullToAbsent
          ? const Value.absent()
          : Value(colorToken),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      rabbitId: serializer.fromJson<String?>(json['rabbitId']),
      name: serializer.fromJson<String>(json['name']),
      tagKind: serializer.fromJson<String>(json['tagKind']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      colorToken: serializer.fromJson<String?>(json['colorToken']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rabbitId': serializer.toJson<String?>(rabbitId),
      'name': serializer.toJson<String>(name),
      'tagKind': serializer.toJson<String>(tagKind),
      'isSystem': serializer.toJson<bool>(isSystem),
      'colorToken': serializer.toJson<String?>(colorToken),
      'iconName': serializer.toJson<String?>(iconName),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  TagRow copyWith({
    String? id,
    Value<String?> rabbitId = const Value.absent(),
    String? name,
    String? tagKind,
    bool? isSystem,
    Value<String?> colorToken = const Value.absent(),
    Value<String?> iconName = const Value.absent(),
    int? sortOrder,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => TagRow(
    id: id ?? this.id,
    rabbitId: rabbitId.present ? rabbitId.value : this.rabbitId,
    name: name ?? this.name,
    tagKind: tagKind ?? this.tagKind,
    isSystem: isSystem ?? this.isSystem,
    colorToken: colorToken.present ? colorToken.value : this.colorToken,
    iconName: iconName.present ? iconName.value : this.iconName,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      rabbitId: data.rabbitId.present ? data.rabbitId.value : this.rabbitId,
      name: data.name.present ? data.name.value : this.name,
      tagKind: data.tagKind.present ? data.tagKind.value : this.tagKind,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      colorToken: data.colorToken.present
          ? data.colorToken.value
          : this.colorToken,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('rabbitId: $rabbitId, ')
          ..write('name: $name, ')
          ..write('tagKind: $tagKind, ')
          ..write('isSystem: $isSystem, ')
          ..write('colorToken: $colorToken, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rabbitId,
    name,
    tagKind,
    isSystem,
    colorToken,
    iconName,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.rabbitId == this.rabbitId &&
          other.name == this.name &&
          other.tagKind == this.tagKind &&
          other.isSystem == this.isSystem &&
          other.colorToken == this.colorToken &&
          other.iconName == this.iconName &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String?> rabbitId;
  final Value<String> name;
  final Value<String> tagKind;
  final Value<bool> isSystem;
  final Value<String?> colorToken;
  final Value<String?> iconName;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.rabbitId = const Value.absent(),
    this.name = const Value.absent(),
    this.tagKind = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.colorToken = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    this.rabbitId = const Value.absent(),
    required String name,
    required String tagKind,
    this.isSystem = const Value.absent(),
    this.colorToken = const Value.absent(),
    this.iconName = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       tagKind = Value(tagKind),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? rabbitId,
    Expression<String>? name,
    Expression<String>? tagKind,
    Expression<bool>? isSystem,
    Expression<String>? colorToken,
    Expression<String>? iconName,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rabbitId != null) 'rabbit_id': rabbitId,
      if (name != null) 'name': name,
      if (tagKind != null) 'tag_kind': tagKind,
      if (isSystem != null) 'is_system': isSystem,
      if (colorToken != null) 'color_token': colorToken,
      if (iconName != null) 'icon_name': iconName,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String?>? rabbitId,
    Value<String>? name,
    Value<String>? tagKind,
    Value<bool>? isSystem,
    Value<String?>? colorToken,
    Value<String?>? iconName,
    Value<int>? sortOrder,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      rabbitId: rabbitId ?? this.rabbitId,
      name: name ?? this.name,
      tagKind: tagKind ?? this.tagKind,
      isSystem: isSystem ?? this.isSystem,
      colorToken: colorToken ?? this.colorToken,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rabbitId.present) {
      map['rabbit_id'] = Variable<String>(rabbitId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tagKind.present) {
      map['tag_kind'] = Variable<String>(tagKind.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (colorToken.present) {
      map['color_token'] = Variable<String>(colorToken.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('rabbitId: $rabbitId, ')
          ..write('name: $name, ')
          ..write('tagKind: $tagKind, ')
          ..write('isSystem: $isSystem, ')
          ..write('colorToken: $colorToken, ')
          ..write('iconName: $iconName, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryTagsTable extends DiaryTags
    with TableInfo<$DiaryTagsTable, DiaryTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaryIdMeta = const VerificationMeta(
    'diaryId',
  );
  @override
  late final GeneratedColumn<String> diaryId = GeneratedColumn<String>(
    'diary_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES diaries (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diaryId,
    tagId,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('diary_id')) {
      context.handle(
        _diaryIdMeta,
        diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryTagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      diaryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diary_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DiaryTagsTable createAlias(String alias) {
    return $DiaryTagsTable(attachedDatabase, alias);
  }
}

class DiaryTagRow extends DataClass implements Insertable<DiaryTagRow> {
  final String id;
  final String diaryId;
  final String tagId;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const DiaryTagRow({
    required this.id,
    required this.diaryId,
    required this.tagId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['diary_id'] = Variable<String>(diaryId);
    map['tag_id'] = Variable<String>(tagId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  DiaryTagsCompanion toCompanion(bool nullToAbsent) {
    return DiaryTagsCompanion(
      id: Value(id),
      diaryId: Value(diaryId),
      tagId: Value(tagId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DiaryTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryTagRow(
      id: serializer.fromJson<String>(json['id']),
      diaryId: serializer.fromJson<String>(json['diaryId']),
      tagId: serializer.fromJson<String>(json['tagId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'diaryId': serializer.toJson<String>(diaryId),
      'tagId': serializer.toJson<String>(tagId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  DiaryTagRow copyWith({
    String? id,
    String? diaryId,
    String? tagId,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => DiaryTagRow(
    id: id ?? this.id,
    diaryId: diaryId ?? this.diaryId,
    tagId: tagId ?? this.tagId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DiaryTagRow copyWithCompanion(DiaryTagsCompanion data) {
    return DiaryTagRow(
      id: data.id.present ? data.id.value : this.id,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryTagRow(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, diaryId, tagId, createdAt, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryTagRow &&
          other.id == this.id &&
          other.diaryId == this.diaryId &&
          other.tagId == this.tagId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DiaryTagsCompanion extends UpdateCompanion<DiaryTagRow> {
  final Value<String> id;
  final Value<String> diaryId;
  final Value<String> tagId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const DiaryTagsCompanion({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryTagsCompanion.insert({
    required String id,
    required String diaryId,
    required String tagId,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       diaryId = Value(diaryId),
       tagId = Value(tagId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DiaryTagRow> custom({
    Expression<String>? id,
    Expression<String>? diaryId,
    Expression<String>? tagId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryId != null) 'diary_id': diaryId,
      if (tagId != null) 'tag_id': tagId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryTagsCompanion copyWith({
    Value<String>? id,
    Value<String>? diaryId,
    Value<String>? tagId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return DiaryTagsCompanion(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      tagId: tagId ?? this.tagId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<String>(diaryId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryTagsCompanion(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('tagId: $tagId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightRecordsTable extends WeightRecords
    with TableInfo<$WeightRecordsTable, WeightRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rabbitIdMeta = const VerificationMeta(
    'rabbitId',
  );
  @override
  late final GeneratedColumn<String> rabbitId = GeneratedColumn<String>(
    'rabbit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rabbits (id)',
    ),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<int> recordedAt = GeneratedColumn<int>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bcsScoreMeta = const VerificationMeta(
    'bcsScore',
  );
  @override
  late final GeneratedColumn<int> bcsScore = GeneratedColumn<int>(
    'bcs_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rabbitId,
    recordedAt,
    weightGrams,
    note,
    photoPath,
    bcsScore,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rabbit_id')) {
      context.handle(
        _rabbitIdMeta,
        rabbitId.isAcceptableOrUnknown(data['rabbit_id']!, _rabbitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rabbitIdMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('bcs_score')) {
      context.handle(
        _bcsScoreMeta,
        bcsScore.isAcceptableOrUnknown(data['bcs_score']!, _bcsScoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rabbitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rabbit_id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at'],
      )!,
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      bcsScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bcs_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $WeightRecordsTable createAlias(String alias) {
    return $WeightRecordsTable(attachedDatabase, alias);
  }
}

class WeightRecordRow extends DataClass implements Insertable<WeightRecordRow> {
  final String id;
  final String rabbitId;
  final int recordedAt;
  final int weightGrams;
  final String? note;
  final String? photoPath;
  final int? bcsScore;
  final int createdAt;
  final int updatedAt;
  final int? deletedAt;
  const WeightRecordRow({
    required this.id,
    required this.rabbitId,
    required this.recordedAt,
    required this.weightGrams,
    this.note,
    this.photoPath,
    this.bcsScore,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rabbit_id'] = Variable<String>(rabbitId);
    map['recorded_at'] = Variable<int>(recordedAt);
    map['weight_grams'] = Variable<int>(weightGrams);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || bcsScore != null) {
      map['bcs_score'] = Variable<int>(bcsScore);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  WeightRecordsCompanion toCompanion(bool nullToAbsent) {
    return WeightRecordsCompanion(
      id: Value(id),
      rabbitId: Value(rabbitId),
      recordedAt: Value(recordedAt),
      weightGrams: Value(weightGrams),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      bcsScore: bcsScore == null && nullToAbsent
          ? const Value.absent()
          : Value(bcsScore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory WeightRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRecordRow(
      id: serializer.fromJson<String>(json['id']),
      rabbitId: serializer.fromJson<String>(json['rabbitId']),
      recordedAt: serializer.fromJson<int>(json['recordedAt']),
      weightGrams: serializer.fromJson<int>(json['weightGrams']),
      note: serializer.fromJson<String?>(json['note']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      bcsScore: serializer.fromJson<int?>(json['bcsScore']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rabbitId': serializer.toJson<String>(rabbitId),
      'recordedAt': serializer.toJson<int>(recordedAt),
      'weightGrams': serializer.toJson<int>(weightGrams),
      'note': serializer.toJson<String?>(note),
      'photoPath': serializer.toJson<String?>(photoPath),
      'bcsScore': serializer.toJson<int?>(bcsScore),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  WeightRecordRow copyWith({
    String? id,
    String? rabbitId,
    int? recordedAt,
    int? weightGrams,
    Value<String?> note = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<int?> bcsScore = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
  }) => WeightRecordRow(
    id: id ?? this.id,
    rabbitId: rabbitId ?? this.rabbitId,
    recordedAt: recordedAt ?? this.recordedAt,
    weightGrams: weightGrams ?? this.weightGrams,
    note: note.present ? note.value : this.note,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    bcsScore: bcsScore.present ? bcsScore.value : this.bcsScore,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  WeightRecordRow copyWithCompanion(WeightRecordsCompanion data) {
    return WeightRecordRow(
      id: data.id.present ? data.id.value : this.id,
      rabbitId: data.rabbitId.present ? data.rabbitId.value : this.rabbitId,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      note: data.note.present ? data.note.value : this.note,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      bcsScore: data.bcsScore.present ? data.bcsScore.value : this.bcsScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordRow(')
          ..write('id: $id, ')
          ..write('rabbitId: $rabbitId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath, ')
          ..write('bcsScore: $bcsScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rabbitId,
    recordedAt,
    weightGrams,
    note,
    photoPath,
    bcsScore,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRecordRow &&
          other.id == this.id &&
          other.rabbitId == this.rabbitId &&
          other.recordedAt == this.recordedAt &&
          other.weightGrams == this.weightGrams &&
          other.note == this.note &&
          other.photoPath == this.photoPath &&
          other.bcsScore == this.bcsScore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class WeightRecordsCompanion extends UpdateCompanion<WeightRecordRow> {
  final Value<String> id;
  final Value<String> rabbitId;
  final Value<int> recordedAt;
  final Value<int> weightGrams;
  final Value<String?> note;
  final Value<String?> photoPath;
  final Value<int?> bcsScore;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const WeightRecordsCompanion({
    this.id = const Value.absent(),
    this.rabbitId = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.bcsScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightRecordsCompanion.insert({
    required String id,
    required String rabbitId,
    required int recordedAt,
    required int weightGrams,
    this.note = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.bcsScore = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rabbitId = Value(rabbitId),
       recordedAt = Value(recordedAt),
       weightGrams = Value(weightGrams),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WeightRecordRow> custom({
    Expression<String>? id,
    Expression<String>? rabbitId,
    Expression<int>? recordedAt,
    Expression<int>? weightGrams,
    Expression<String>? note,
    Expression<String>? photoPath,
    Expression<int>? bcsScore,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rabbitId != null) 'rabbit_id': rabbitId,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (note != null) 'note': note,
      if (photoPath != null) 'photo_path': photoPath,
      if (bcsScore != null) 'bcs_score': bcsScore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? rabbitId,
    Value<int>? recordedAt,
    Value<int>? weightGrams,
    Value<String?>? note,
    Value<String?>? photoPath,
    Value<int?>? bcsScore,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return WeightRecordsCompanion(
      id: id ?? this.id,
      rabbitId: rabbitId ?? this.rabbitId,
      recordedAt: recordedAt ?? this.recordedAt,
      weightGrams: weightGrams ?? this.weightGrams,
      note: note ?? this.note,
      photoPath: photoPath ?? this.photoPath,
      bcsScore: bcsScore ?? this.bcsScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rabbitId.present) {
      map['rabbit_id'] = Variable<String>(rabbitId.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<int>(recordedAt.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (bcsScore.present) {
      map['bcs_score'] = Variable<int>(bcsScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordsCompanion(')
          ..write('id: $id, ')
          ..write('rabbitId: $rabbitId, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('note: $note, ')
          ..write('photoPath: $photoPath, ')
          ..write('bcsScore: $bcsScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RabbitsTable rabbits = $RabbitsTable(this);
  late final $DiariesTable diaries = $DiariesTable(this);
  late final $DiaryMediaItemsTable diaryMediaItems = $DiaryMediaItemsTable(
    this,
  );
  late final $TagsTable tags = $TagsTable(this);
  late final $DiaryTagsTable diaryTags = $DiaryTagsTable(this);
  late final $WeightRecordsTable weightRecords = $WeightRecordsTable(this);
  late final RabbitDao rabbitDao = RabbitDao(this as AppDatabase);
  late final DiaryDao diaryDao = DiaryDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final WeightDao weightDao = WeightDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rabbits,
    diaries,
    diaryMediaItems,
    tags,
    diaryTags,
    weightRecords,
  ];
}

typedef $$RabbitsTableCreateCompanionBuilder =
    RabbitsCompanion Function({
      required String id,
      required String name,
      required String sex,
      Value<String?> birthDate,
      Value<String?> adoptedDate,
      required String breed,
      required String furColor,
      Value<String?> avatarPath,
      Value<String?> source,
      Value<String?> neuteredStatus,
      Value<String?> neuteredDate,
      Value<String?> chipNumber,
      Value<int?> initialWeightGrams,
      Value<String?> personalityTagsJson,
      Value<String?> favoriteFoods,
      Value<String?> favoriteToys,
      Value<String?> passedAwayDate,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$RabbitsTableUpdateCompanionBuilder =
    RabbitsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> sex,
      Value<String?> birthDate,
      Value<String?> adoptedDate,
      Value<String> breed,
      Value<String> furColor,
      Value<String?> avatarPath,
      Value<String?> source,
      Value<String?> neuteredStatus,
      Value<String?> neuteredDate,
      Value<String?> chipNumber,
      Value<int?> initialWeightGrams,
      Value<String?> personalityTagsJson,
      Value<String?> favoriteFoods,
      Value<String?> favoriteToys,
      Value<String?> passedAwayDate,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$RabbitsTableReferences
    extends BaseReferences<_$AppDatabase, $RabbitsTable, RabbitRow> {
  $$RabbitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiariesTable, List<DiaryRow>> _diariesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.diaries,
    aliasName: $_aliasNameGenerator(db.rabbits.id, db.diaries.rabbitId),
  );

  $$DiariesTableProcessedTableManager get diariesRefs {
    final manager = $$DiariesTableTableManager(
      $_db,
      $_db.diaries,
    ).filter((f) => f.rabbitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_diariesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TagsTable, List<TagRow>> _tagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tags,
    aliasName: $_aliasNameGenerator(db.rabbits.id, db.tags.rabbitId),
  );

  $$TagsTableProcessedTableManager get tagsRefs {
    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.rabbitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeightRecordsTable, List<WeightRecordRow>>
  _weightRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.weightRecords,
    aliasName: $_aliasNameGenerator(db.rabbits.id, db.weightRecords.rabbitId),
  );

  $$WeightRecordsTableProcessedTableManager get weightRecordsRefs {
    final manager = $$WeightRecordsTableTableManager(
      $_db,
      $_db.weightRecords,
    ).filter((f) => f.rabbitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_weightRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RabbitsTableFilterComposer
    extends Composer<_$AppDatabase, $RabbitsTable> {
  $$RabbitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adoptedDate => $composableBuilder(
    column: $table.adoptedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get furColor => $composableBuilder(
    column: $table.furColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neuteredStatus => $composableBuilder(
    column: $table.neuteredStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neuteredDate => $composableBuilder(
    column: $table.neuteredDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chipNumber => $composableBuilder(
    column: $table.chipNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialWeightGrams => $composableBuilder(
    column: $table.initialWeightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalityTagsJson => $composableBuilder(
    column: $table.personalityTagsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteFoods => $composableBuilder(
    column: $table.favoriteFoods,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get favoriteToys => $composableBuilder(
    column: $table.favoriteToys,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passedAwayDate => $composableBuilder(
    column: $table.passedAwayDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> diariesRefs(
    Expression<bool> Function($$DiariesTableFilterComposer f) f,
  ) {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.rabbitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableFilterComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tagsRefs(
    Expression<bool> Function($$TagsTableFilterComposer f) f,
  ) {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.rabbitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weightRecordsRefs(
    Expression<bool> Function($$WeightRecordsTableFilterComposer f) f,
  ) {
    final $$WeightRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightRecords,
      getReferencedColumn: (t) => t.rabbitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightRecordsTableFilterComposer(
            $db: $db,
            $table: $db.weightRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RabbitsTableOrderingComposer
    extends Composer<_$AppDatabase, $RabbitsTable> {
  $$RabbitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adoptedDate => $composableBuilder(
    column: $table.adoptedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get furColor => $composableBuilder(
    column: $table.furColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neuteredStatus => $composableBuilder(
    column: $table.neuteredStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neuteredDate => $composableBuilder(
    column: $table.neuteredDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chipNumber => $composableBuilder(
    column: $table.chipNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialWeightGrams => $composableBuilder(
    column: $table.initialWeightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalityTagsJson => $composableBuilder(
    column: $table.personalityTagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteFoods => $composableBuilder(
    column: $table.favoriteFoods,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get favoriteToys => $composableBuilder(
    column: $table.favoriteToys,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passedAwayDate => $composableBuilder(
    column: $table.passedAwayDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RabbitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RabbitsTable> {
  $$RabbitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get adoptedDate => $composableBuilder(
    column: $table.adoptedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<String> get furColor =>
      $composableBuilder(column: $table.furColor, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get neuteredStatus => $composableBuilder(
    column: $table.neuteredStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get neuteredDate => $composableBuilder(
    column: $table.neuteredDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chipNumber => $composableBuilder(
    column: $table.chipNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialWeightGrams => $composableBuilder(
    column: $table.initialWeightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalityTagsJson => $composableBuilder(
    column: $table.personalityTagsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favoriteFoods => $composableBuilder(
    column: $table.favoriteFoods,
    builder: (column) => column,
  );

  GeneratedColumn<String> get favoriteToys => $composableBuilder(
    column: $table.favoriteToys,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passedAwayDate => $composableBuilder(
    column: $table.passedAwayDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> diariesRefs<T extends Object>(
    Expression<T> Function($$DiariesTableAnnotationComposer a) f,
  ) {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.rabbitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tagsRefs<T extends Object>(
    Expression<T> Function($$TagsTableAnnotationComposer a) f,
  ) {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.rabbitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weightRecordsRefs<T extends Object>(
    Expression<T> Function($$WeightRecordsTableAnnotationComposer a) f,
  ) {
    final $$WeightRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weightRecords,
      getReferencedColumn: (t) => t.rabbitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeightRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.weightRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RabbitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RabbitsTable,
          RabbitRow,
          $$RabbitsTableFilterComposer,
          $$RabbitsTableOrderingComposer,
          $$RabbitsTableAnnotationComposer,
          $$RabbitsTableCreateCompanionBuilder,
          $$RabbitsTableUpdateCompanionBuilder,
          (RabbitRow, $$RabbitsTableReferences),
          RabbitRow,
          PrefetchHooks Function({
            bool diariesRefs,
            bool tagsRefs,
            bool weightRecordsRefs,
          })
        > {
  $$RabbitsTableTableManager(_$AppDatabase db, $RabbitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RabbitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RabbitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RabbitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String?> birthDate = const Value.absent(),
                Value<String?> adoptedDate = const Value.absent(),
                Value<String> breed = const Value.absent(),
                Value<String> furColor = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> neuteredStatus = const Value.absent(),
                Value<String?> neuteredDate = const Value.absent(),
                Value<String?> chipNumber = const Value.absent(),
                Value<int?> initialWeightGrams = const Value.absent(),
                Value<String?> personalityTagsJson = const Value.absent(),
                Value<String?> favoriteFoods = const Value.absent(),
                Value<String?> favoriteToys = const Value.absent(),
                Value<String?> passedAwayDate = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RabbitsCompanion(
                id: id,
                name: name,
                sex: sex,
                birthDate: birthDate,
                adoptedDate: adoptedDate,
                breed: breed,
                furColor: furColor,
                avatarPath: avatarPath,
                source: source,
                neuteredStatus: neuteredStatus,
                neuteredDate: neuteredDate,
                chipNumber: chipNumber,
                initialWeightGrams: initialWeightGrams,
                personalityTagsJson: personalityTagsJson,
                favoriteFoods: favoriteFoods,
                favoriteToys: favoriteToys,
                passedAwayDate: passedAwayDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String sex,
                Value<String?> birthDate = const Value.absent(),
                Value<String?> adoptedDate = const Value.absent(),
                required String breed,
                required String furColor,
                Value<String?> avatarPath = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> neuteredStatus = const Value.absent(),
                Value<String?> neuteredDate = const Value.absent(),
                Value<String?> chipNumber = const Value.absent(),
                Value<int?> initialWeightGrams = const Value.absent(),
                Value<String?> personalityTagsJson = const Value.absent(),
                Value<String?> favoriteFoods = const Value.absent(),
                Value<String?> favoriteToys = const Value.absent(),
                Value<String?> passedAwayDate = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RabbitsCompanion.insert(
                id: id,
                name: name,
                sex: sex,
                birthDate: birthDate,
                adoptedDate: adoptedDate,
                breed: breed,
                furColor: furColor,
                avatarPath: avatarPath,
                source: source,
                neuteredStatus: neuteredStatus,
                neuteredDate: neuteredDate,
                chipNumber: chipNumber,
                initialWeightGrams: initialWeightGrams,
                personalityTagsJson: personalityTagsJson,
                favoriteFoods: favoriteFoods,
                favoriteToys: favoriteToys,
                passedAwayDate: passedAwayDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RabbitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                diariesRefs = false,
                tagsRefs = false,
                weightRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (diariesRefs) db.diaries,
                    if (tagsRefs) db.tags,
                    if (weightRecordsRefs) db.weightRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (diariesRefs)
                        await $_getPrefetchedData<
                          RabbitRow,
                          $RabbitsTable,
                          DiaryRow
                        >(
                          currentTable: table,
                          referencedTable: $$RabbitsTableReferences
                              ._diariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RabbitsTableReferences(
                                db,
                                table,
                                p0,
                              ).diariesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.rabbitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tagsRefs)
                        await $_getPrefetchedData<
                          RabbitRow,
                          $RabbitsTable,
                          TagRow
                        >(
                          currentTable: table,
                          referencedTable: $$RabbitsTableReferences
                              ._tagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RabbitsTableReferences(db, table, p0).tagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.rabbitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weightRecordsRefs)
                        await $_getPrefetchedData<
                          RabbitRow,
                          $RabbitsTable,
                          WeightRecordRow
                        >(
                          currentTable: table,
                          referencedTable: $$RabbitsTableReferences
                              ._weightRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RabbitsTableReferences(
                                db,
                                table,
                                p0,
                              ).weightRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.rabbitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RabbitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RabbitsTable,
      RabbitRow,
      $$RabbitsTableFilterComposer,
      $$RabbitsTableOrderingComposer,
      $$RabbitsTableAnnotationComposer,
      $$RabbitsTableCreateCompanionBuilder,
      $$RabbitsTableUpdateCompanionBuilder,
      (RabbitRow, $$RabbitsTableReferences),
      RabbitRow,
      PrefetchHooks Function({
        bool diariesRefs,
        bool tagsRefs,
        bool weightRecordsRefs,
      })
    >;
typedef $$DiariesTableCreateCompanionBuilder =
    DiariesCompanion Function({
      required String id,
      required String rabbitId,
      required int recordedAt,
      Value<String?> content,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$DiariesTableUpdateCompanionBuilder =
    DiariesCompanion Function({
      Value<String> id,
      Value<String> rabbitId,
      Value<int> recordedAt,
      Value<String?> content,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$DiariesTableReferences
    extends BaseReferences<_$AppDatabase, $DiariesTable, DiaryRow> {
  $$DiariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RabbitsTable _rabbitIdTable(_$AppDatabase db) => db.rabbits
      .createAlias($_aliasNameGenerator(db.diaries.rabbitId, db.rabbits.id));

  $$RabbitsTableProcessedTableManager get rabbitId {
    final $_column = $_itemColumn<String>('rabbit_id')!;

    final manager = $$RabbitsTableTableManager(
      $_db,
      $_db.rabbits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rabbitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DiaryMediaItemsTable, List<DiaryMediaRow>>
  _diaryMediaItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryMediaItems,
    aliasName: $_aliasNameGenerator(db.diaries.id, db.diaryMediaItems.diaryId),
  );

  $$DiaryMediaItemsTableProcessedTableManager get diaryMediaItemsRefs {
    final manager = $$DiaryMediaItemsTableTableManager(
      $_db,
      $_db.diaryMediaItems,
    ).filter((f) => f.diaryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _diaryMediaItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DiaryTagsTable, List<DiaryTagRow>>
  _diaryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryTags,
    aliasName: $_aliasNameGenerator(db.diaries.id, db.diaryTags.diaryId),
  );

  $$DiaryTagsTableProcessedTableManager get diaryTagsRefs {
    final manager = $$DiaryTagsTableTableManager(
      $_db,
      $_db.diaryTags,
    ).filter((f) => f.diaryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DiariesTableFilterComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RabbitsTableFilterComposer get rabbitId {
    final $$RabbitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableFilterComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> diaryMediaItemsRefs(
    Expression<bool> Function($$DiaryMediaItemsTableFilterComposer f) f,
  ) {
    final $$DiaryMediaItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryMediaItems,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryMediaItemsTableFilterComposer(
            $db: $db,
            $table: $db.diaryMediaItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> diaryTagsRefs(
    Expression<bool> Function($$DiaryTagsTableFilterComposer f) f,
  ) {
    final $$DiaryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableFilterComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RabbitsTableOrderingComposer get rabbitId {
    final $$RabbitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableOrderingComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$RabbitsTableAnnotationComposer get rabbitId {
    final $$RabbitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableAnnotationComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> diaryMediaItemsRefs<T extends Object>(
    Expression<T> Function($$DiaryMediaItemsTableAnnotationComposer a) f,
  ) {
    final $$DiaryMediaItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryMediaItems,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryMediaItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryMediaItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> diaryTagsRefs<T extends Object>(
    Expression<T> Function($$DiaryTagsTableAnnotationComposer a) f,
  ) {
    final $$DiaryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.diaryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DiariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiariesTable,
          DiaryRow,
          $$DiariesTableFilterComposer,
          $$DiariesTableOrderingComposer,
          $$DiariesTableAnnotationComposer,
          $$DiariesTableCreateCompanionBuilder,
          $$DiariesTableUpdateCompanionBuilder,
          (DiaryRow, $$DiariesTableReferences),
          DiaryRow,
          PrefetchHooks Function({
            bool rabbitId,
            bool diaryMediaItemsRefs,
            bool diaryTagsRefs,
          })
        > {
  $$DiariesTableTableManager(_$AppDatabase db, $DiariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rabbitId = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiariesCompanion(
                id: id,
                rabbitId: rabbitId,
                recordedAt: recordedAt,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rabbitId,
                required int recordedAt,
                Value<String?> content = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiariesCompanion.insert(
                id: id,
                rabbitId: rabbitId,
                recordedAt: recordedAt,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                rabbitId = false,
                diaryMediaItemsRefs = false,
                diaryTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (diaryMediaItemsRefs) db.diaryMediaItems,
                    if (diaryTagsRefs) db.diaryTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (rabbitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.rabbitId,
                                    referencedTable: $$DiariesTableReferences
                                        ._rabbitIdTable(db),
                                    referencedColumn: $$DiariesTableReferences
                                        ._rabbitIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (diaryMediaItemsRefs)
                        await $_getPrefetchedData<
                          DiaryRow,
                          $DiariesTable,
                          DiaryMediaRow
                        >(
                          currentTable: table,
                          referencedTable: $$DiariesTableReferences
                              ._diaryMediaItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiariesTableReferences(
                                db,
                                table,
                                p0,
                              ).diaryMediaItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diaryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (diaryTagsRefs)
                        await $_getPrefetchedData<
                          DiaryRow,
                          $DiariesTable,
                          DiaryTagRow
                        >(
                          currentTable: table,
                          referencedTable: $$DiariesTableReferences
                              ._diaryTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DiariesTableReferences(
                                db,
                                table,
                                p0,
                              ).diaryTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.diaryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DiariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiariesTable,
      DiaryRow,
      $$DiariesTableFilterComposer,
      $$DiariesTableOrderingComposer,
      $$DiariesTableAnnotationComposer,
      $$DiariesTableCreateCompanionBuilder,
      $$DiariesTableUpdateCompanionBuilder,
      (DiaryRow, $$DiariesTableReferences),
      DiaryRow,
      PrefetchHooks Function({
        bool rabbitId,
        bool diaryMediaItemsRefs,
        bool diaryTagsRefs,
      })
    >;
typedef $$DiaryMediaItemsTableCreateCompanionBuilder =
    DiaryMediaItemsCompanion Function({
      required String id,
      required String diaryId,
      required String mediaType,
      required String relativePath,
      Value<String?> thumbnailPath,
      Value<String?> mimeType,
      Value<int?> width,
      Value<int?> height,
      Value<int?> fileSizeBytes,
      Value<int?> durationMs,
      required int sortOrder,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$DiaryMediaItemsTableUpdateCompanionBuilder =
    DiaryMediaItemsCompanion Function({
      Value<String> id,
      Value<String> diaryId,
      Value<String> mediaType,
      Value<String> relativePath,
      Value<String?> thumbnailPath,
      Value<String?> mimeType,
      Value<int?> width,
      Value<int?> height,
      Value<int?> fileSizeBytes,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$DiaryMediaItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DiaryMediaItemsTable, DiaryMediaRow> {
  $$DiaryMediaItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DiariesTable _diaryIdTable(_$AppDatabase db) =>
      db.diaries.createAlias(
        $_aliasNameGenerator(db.diaryMediaItems.diaryId, db.diaries.id),
      );

  $$DiariesTableProcessedTableManager get diaryId {
    final $_column = $_itemColumn<String>('diary_id')!;

    final manager = $$DiariesTableTableManager(
      $_db,
      $_db.diaries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryMediaItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryMediaItemsTable> {
  $$DiaryMediaItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DiariesTableFilterComposer get diaryId {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableFilterComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryMediaItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryMediaItemsTable> {
  $$DiaryMediaItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiariesTableOrderingComposer get diaryId {
    final $$DiariesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableOrderingComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryMediaItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryMediaItemsTable> {
  $$DiaryMediaItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$DiariesTableAnnotationComposer get diaryId {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryMediaItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryMediaItemsTable,
          DiaryMediaRow,
          $$DiaryMediaItemsTableFilterComposer,
          $$DiaryMediaItemsTableOrderingComposer,
          $$DiaryMediaItemsTableAnnotationComposer,
          $$DiaryMediaItemsTableCreateCompanionBuilder,
          $$DiaryMediaItemsTableUpdateCompanionBuilder,
          (DiaryMediaRow, $$DiaryMediaItemsTableReferences),
          DiaryMediaRow,
          PrefetchHooks Function({bool diaryId})
        > {
  $$DiaryMediaItemsTableTableManager(
    _$AppDatabase db,
    $DiaryMediaItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryMediaItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryMediaItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryMediaItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> diaryId = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryMediaItemsCompanion(
                id: id,
                diaryId: diaryId,
                mediaType: mediaType,
                relativePath: relativePath,
                thumbnailPath: thumbnailPath,
                mimeType: mimeType,
                width: width,
                height: height,
                fileSizeBytes: fileSizeBytes,
                durationMs: durationMs,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String diaryId,
                required String mediaType,
                required String relativePath,
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<int?> fileSizeBytes = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                required int sortOrder,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryMediaItemsCompanion.insert(
                id: id,
                diaryId: diaryId,
                mediaType: mediaType,
                relativePath: relativePath,
                thumbnailPath: thumbnailPath,
                mimeType: mimeType,
                width: width,
                height: height,
                fileSizeBytes: fileSizeBytes,
                durationMs: durationMs,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryMediaItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diaryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diaryId,
                                referencedTable:
                                    $$DiaryMediaItemsTableReferences
                                        ._diaryIdTable(db),
                                referencedColumn:
                                    $$DiaryMediaItemsTableReferences
                                        ._diaryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiaryMediaItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryMediaItemsTable,
      DiaryMediaRow,
      $$DiaryMediaItemsTableFilterComposer,
      $$DiaryMediaItemsTableOrderingComposer,
      $$DiaryMediaItemsTableAnnotationComposer,
      $$DiaryMediaItemsTableCreateCompanionBuilder,
      $$DiaryMediaItemsTableUpdateCompanionBuilder,
      (DiaryMediaRow, $$DiaryMediaItemsTableReferences),
      DiaryMediaRow,
      PrefetchHooks Function({bool diaryId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      Value<String?> rabbitId,
      required String name,
      required String tagKind,
      Value<bool> isSystem,
      Value<String?> colorToken,
      Value<String?> iconName,
      Value<int> sortOrder,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String?> rabbitId,
      Value<String> name,
      Value<String> tagKind,
      Value<bool> isSystem,
      Value<String?> colorToken,
      Value<String?> iconName,
      Value<int> sortOrder,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, TagRow> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RabbitsTable _rabbitIdTable(_$AppDatabase db) => db.rabbits
      .createAlias($_aliasNameGenerator(db.tags.rabbitId, db.rabbits.id));

  $$RabbitsTableProcessedTableManager? get rabbitId {
    final $_column = $_itemColumn<String>('rabbit_id');
    if ($_column == null) return null;
    final manager = $$RabbitsTableTableManager(
      $_db,
      $_db.rabbits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rabbitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DiaryTagsTable, List<DiaryTagRow>>
  _diaryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.diaryTags.tagId),
  );

  $$DiaryTagsTableProcessedTableManager get diaryTagsRefs {
    final manager = $$DiaryTagsTableTableManager(
      $_db,
      $_db.diaryTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagKind => $composableBuilder(
    column: $table.tagKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorToken => $composableBuilder(
    column: $table.colorToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RabbitsTableFilterComposer get rabbitId {
    final $$RabbitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableFilterComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> diaryTagsRefs(
    Expression<bool> Function($$DiaryTagsTableFilterComposer f) f,
  ) {
    final $$DiaryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableFilterComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagKind => $composableBuilder(
    column: $table.tagKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorToken => $composableBuilder(
    column: $table.colorToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RabbitsTableOrderingComposer get rabbitId {
    final $$RabbitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableOrderingComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get tagKind =>
      $composableBuilder(column: $table.tagKind, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get colorToken => $composableBuilder(
    column: $table.colorToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$RabbitsTableAnnotationComposer get rabbitId {
    final $$RabbitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableAnnotationComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> diaryTagsRefs<T extends Object>(
    Expression<T> Function($$DiaryTagsTableAnnotationComposer a) f,
  ) {
    final $$DiaryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          TagRow,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagRow, $$TagsTableReferences),
          TagRow,
          PrefetchHooks Function({bool rabbitId, bool diaryTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> rabbitId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> tagKind = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> colorToken = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                rabbitId: rabbitId,
                name: name,
                tagKind: tagKind,
                isSystem: isSystem,
                colorToken: colorToken,
                iconName: iconName,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> rabbitId = const Value.absent(),
                required String name,
                required String tagKind,
                Value<bool> isSystem = const Value.absent(),
                Value<String?> colorToken = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                rabbitId: rabbitId,
                name: name,
                tagKind: tagKind,
                isSystem: isSystem,
                colorToken: colorToken,
                iconName: iconName,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({rabbitId = false, diaryTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (diaryTagsRefs) db.diaryTags],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (rabbitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.rabbitId,
                                referencedTable: $$TagsTableReferences
                                    ._rabbitIdTable(db),
                                referencedColumn: $$TagsTableReferences
                                    ._rabbitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (diaryTagsRefs)
                    await $_getPrefetchedData<TagRow, $TagsTable, DiaryTagRow>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._diaryTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).diaryTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      TagRow,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagRow, $$TagsTableReferences),
      TagRow,
      PrefetchHooks Function({bool rabbitId, bool diaryTagsRefs})
    >;
typedef $$DiaryTagsTableCreateCompanionBuilder =
    DiaryTagsCompanion Function({
      required String id,
      required String diaryId,
      required String tagId,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$DiaryTagsTableUpdateCompanionBuilder =
    DiaryTagsCompanion Function({
      Value<String> id,
      Value<String> diaryId,
      Value<String> tagId,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$DiaryTagsTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryTagsTable, DiaryTagRow> {
  $$DiaryTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiariesTable _diaryIdTable(_$AppDatabase db) => db.diaries
      .createAlias($_aliasNameGenerator(db.diaryTags.diaryId, db.diaries.id));

  $$DiariesTableProcessedTableManager get diaryId {
    final $_column = $_itemColumn<String>('diary_id')!;

    final manager = $$DiariesTableTableManager(
      $_db,
      $_db.diaries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias($_aliasNameGenerator(db.diaryTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryTagsTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryTagsTable> {
  $$DiaryTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DiariesTableFilterComposer get diaryId {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableFilterComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryTagsTable> {
  $$DiaryTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DiariesTableOrderingComposer get diaryId {
    final $$DiariesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableOrderingComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryTagsTable> {
  $$DiaryTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$DiariesTableAnnotationComposer get diaryId {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.diaryId,
      referencedTable: $db.diaries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiariesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryTagsTable,
          DiaryTagRow,
          $$DiaryTagsTableFilterComposer,
          $$DiaryTagsTableOrderingComposer,
          $$DiaryTagsTableAnnotationComposer,
          $$DiaryTagsTableCreateCompanionBuilder,
          $$DiaryTagsTableUpdateCompanionBuilder,
          (DiaryTagRow, $$DiaryTagsTableReferences),
          DiaryTagRow,
          PrefetchHooks Function({bool diaryId, bool tagId})
        > {
  $$DiaryTagsTableTableManager(_$AppDatabase db, $DiaryTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> diaryId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryTagsCompanion(
                id: id,
                diaryId: diaryId,
                tagId: tagId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String diaryId,
                required String tagId,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryTagsCompanion.insert(
                id: id,
                diaryId: diaryId,
                tagId: tagId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (diaryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.diaryId,
                                referencedTable: $$DiaryTagsTableReferences
                                    ._diaryIdTable(db),
                                referencedColumn: $$DiaryTagsTableReferences
                                    ._diaryIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$DiaryTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$DiaryTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DiaryTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryTagsTable,
      DiaryTagRow,
      $$DiaryTagsTableFilterComposer,
      $$DiaryTagsTableOrderingComposer,
      $$DiaryTagsTableAnnotationComposer,
      $$DiaryTagsTableCreateCompanionBuilder,
      $$DiaryTagsTableUpdateCompanionBuilder,
      (DiaryTagRow, $$DiaryTagsTableReferences),
      DiaryTagRow,
      PrefetchHooks Function({bool diaryId, bool tagId})
    >;
typedef $$WeightRecordsTableCreateCompanionBuilder =
    WeightRecordsCompanion Function({
      required String id,
      required String rabbitId,
      required int recordedAt,
      required int weightGrams,
      Value<String?> note,
      Value<String?> photoPath,
      Value<int?> bcsScore,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });
typedef $$WeightRecordsTableUpdateCompanionBuilder =
    WeightRecordsCompanion Function({
      Value<String> id,
      Value<String> rabbitId,
      Value<int> recordedAt,
      Value<int> weightGrams,
      Value<String?> note,
      Value<String?> photoPath,
      Value<int?> bcsScore,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> rowid,
    });

final class $$WeightRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WeightRecordsTable, WeightRecordRow> {
  $$WeightRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RabbitsTable _rabbitIdTable(_$AppDatabase db) =>
      db.rabbits.createAlias(
        $_aliasNameGenerator(db.weightRecords.rabbitId, db.rabbits.id),
      );

  $$RabbitsTableProcessedTableManager get rabbitId {
    final $_column = $_itemColumn<String>('rabbit_id')!;

    final manager = $$RabbitsTableTableManager(
      $_db,
      $_db.rabbits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rabbitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeightRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bcsScore => $composableBuilder(
    column: $table.bcsScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RabbitsTableFilterComposer get rabbitId {
    final $$RabbitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableFilterComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bcsScore => $composableBuilder(
    column: $table.bcsScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RabbitsTableOrderingComposer get rabbitId {
    final $$RabbitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableOrderingComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightRecordsTable> {
  $$WeightRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get bcsScore =>
      $composableBuilder(column: $table.bcsScore, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$RabbitsTableAnnotationComposer get rabbitId {
    final $$RabbitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rabbitId,
      referencedTable: $db.rabbits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RabbitsTableAnnotationComposer(
            $db: $db,
            $table: $db.rabbits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeightRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightRecordsTable,
          WeightRecordRow,
          $$WeightRecordsTableFilterComposer,
          $$WeightRecordsTableOrderingComposer,
          $$WeightRecordsTableAnnotationComposer,
          $$WeightRecordsTableCreateCompanionBuilder,
          $$WeightRecordsTableUpdateCompanionBuilder,
          (WeightRecordRow, $$WeightRecordsTableReferences),
          WeightRecordRow,
          PrefetchHooks Function({bool rabbitId})
        > {
  $$WeightRecordsTableTableManager(_$AppDatabase db, $WeightRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rabbitId = const Value.absent(),
                Value<int> recordedAt = const Value.absent(),
                Value<int> weightGrams = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> bcsScore = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightRecordsCompanion(
                id: id,
                rabbitId: rabbitId,
                recordedAt: recordedAt,
                weightGrams: weightGrams,
                note: note,
                photoPath: photoPath,
                bcsScore: bcsScore,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rabbitId,
                required int recordedAt,
                required int weightGrams,
                Value<String?> note = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int?> bcsScore = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeightRecordsCompanion.insert(
                id: id,
                rabbitId: rabbitId,
                recordedAt: recordedAt,
                weightGrams: weightGrams,
                note: note,
                photoPath: photoPath,
                bcsScore: bcsScore,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeightRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({rabbitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (rabbitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.rabbitId,
                                referencedTable: $$WeightRecordsTableReferences
                                    ._rabbitIdTable(db),
                                referencedColumn: $$WeightRecordsTableReferences
                                    ._rabbitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeightRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightRecordsTable,
      WeightRecordRow,
      $$WeightRecordsTableFilterComposer,
      $$WeightRecordsTableOrderingComposer,
      $$WeightRecordsTableAnnotationComposer,
      $$WeightRecordsTableCreateCompanionBuilder,
      $$WeightRecordsTableUpdateCompanionBuilder,
      (WeightRecordRow, $$WeightRecordsTableReferences),
      WeightRecordRow,
      PrefetchHooks Function({bool rabbitId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RabbitsTableTableManager get rabbits =>
      $$RabbitsTableTableManager(_db, _db.rabbits);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db, _db.diaries);
  $$DiaryMediaItemsTableTableManager get diaryMediaItems =>
      $$DiaryMediaItemsTableTableManager(_db, _db.diaryMediaItems);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$DiaryTagsTableTableManager get diaryTags =>
      $$DiaryTagsTableTableManager(_db, _db.diaryTags);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db, _db.weightRecords);
}

mixin _$RabbitDaoMixin on DatabaseAccessor<AppDatabase> {
  $RabbitsTable get rabbits => attachedDatabase.rabbits;
  $DiariesTable get diaries => attachedDatabase.diaries;
  $DiaryMediaItemsTable get diaryMediaItems => attachedDatabase.diaryMediaItems;
  $TagsTable get tags => attachedDatabase.tags;
  $DiaryTagsTable get diaryTags => attachedDatabase.diaryTags;
  $WeightRecordsTable get weightRecords => attachedDatabase.weightRecords;
  RabbitDaoManager get managers => RabbitDaoManager(this);
}

class RabbitDaoManager {
  final _$RabbitDaoMixin _db;
  RabbitDaoManager(this._db);
  $$RabbitsTableTableManager get rabbits =>
      $$RabbitsTableTableManager(_db.attachedDatabase, _db.rabbits);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db.attachedDatabase, _db.diaries);
  $$DiaryMediaItemsTableTableManager get diaryMediaItems =>
      $$DiaryMediaItemsTableTableManager(
        _db.attachedDatabase,
        _db.diaryMediaItems,
      );
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$DiaryTagsTableTableManager get diaryTags =>
      $$DiaryTagsTableTableManager(_db.attachedDatabase, _db.diaryTags);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db.attachedDatabase, _db.weightRecords);
}

mixin _$DiaryDaoMixin on DatabaseAccessor<AppDatabase> {
  $RabbitsTable get rabbits => attachedDatabase.rabbits;
  $DiariesTable get diaries => attachedDatabase.diaries;
  $DiaryMediaItemsTable get diaryMediaItems => attachedDatabase.diaryMediaItems;
  $TagsTable get tags => attachedDatabase.tags;
  $DiaryTagsTable get diaryTags => attachedDatabase.diaryTags;
  DiaryDaoManager get managers => DiaryDaoManager(this);
}

class DiaryDaoManager {
  final _$DiaryDaoMixin _db;
  DiaryDaoManager(this._db);
  $$RabbitsTableTableManager get rabbits =>
      $$RabbitsTableTableManager(_db.attachedDatabase, _db.rabbits);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db.attachedDatabase, _db.diaries);
  $$DiaryMediaItemsTableTableManager get diaryMediaItems =>
      $$DiaryMediaItemsTableTableManager(
        _db.attachedDatabase,
        _db.diaryMediaItems,
      );
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
  $$DiaryTagsTableTableManager get diaryTags =>
      $$DiaryTagsTableTableManager(_db.attachedDatabase, _db.diaryTags);
}

mixin _$TagDaoMixin on DatabaseAccessor<AppDatabase> {
  $RabbitsTable get rabbits => attachedDatabase.rabbits;
  $TagsTable get tags => attachedDatabase.tags;
  TagDaoManager get managers => TagDaoManager(this);
}

class TagDaoManager {
  final _$TagDaoMixin _db;
  TagDaoManager(this._db);
  $$RabbitsTableTableManager get rabbits =>
      $$RabbitsTableTableManager(_db.attachedDatabase, _db.rabbits);
  $$TagsTableTableManager get tags =>
      $$TagsTableTableManager(_db.attachedDatabase, _db.tags);
}

mixin _$WeightDaoMixin on DatabaseAccessor<AppDatabase> {
  $RabbitsTable get rabbits => attachedDatabase.rabbits;
  $WeightRecordsTable get weightRecords => attachedDatabase.weightRecords;
  WeightDaoManager get managers => WeightDaoManager(this);
}

class WeightDaoManager {
  final _$WeightDaoMixin _db;
  WeightDaoManager(this._db);
  $$RabbitsTableTableManager get rabbits =>
      $$RabbitsTableTableManager(_db.attachedDatabase, _db.rabbits);
  $$WeightRecordsTableTableManager get weightRecords =>
      $$WeightRecordsTableTableManager(_db.attachedDatabase, _db.weightRecords);
}
