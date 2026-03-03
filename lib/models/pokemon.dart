class Pokemon {
  final int id;
  final String name;
  final int height;
  final int weight;
  final int baseExperience;
  final List<PokemonAbility> abilities;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final PokemonSprites sprites;
  final List<PokemonMoveRef> moves;
  final NamedResource species;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.abilities,
    required this.types,
    required this.stats,
    required this.sprites,
    required this.moves,
    required this.species,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      height: json['height'] ?? 0,
      weight: json['weight'] ?? 0,
      baseExperience: json['base_experience'] ?? 0,
      abilities: (json['abilities'] as List?)
              ?.map((e) => PokemonAbility.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      types: (json['types'] as List?)
              ?.map((e) => PokemonType.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stats: (json['stats'] as List?)
              ?.map((e) => PokemonStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sprites: PokemonSprites.fromJson(
          json['sprites'] as Map<String, dynamic>? ?? {}),
      moves: (json['moves'] as List?)
              ?.map((e) => PokemonMoveRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      species: NamedResource.fromJson(
          json['species'] as Map<String, dynamic>? ?? {}),
    );
  }

  String get imageUrl =>
      sprites.other?.officialArtwork?.frontDefault ?? sprites.frontDefault ?? '';
}

class PokemonAbility {
  final NamedResource ability;
  final bool isHidden;
  final int slot;

  PokemonAbility(
      {required this.ability, required this.isHidden, required this.slot});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      ability: NamedResource.fromJson(
          json['ability'] as Map<String, dynamic>? ?? {}),
      isHidden: json['is_hidden'] ?? false,
      slot: json['slot'] ?? 0,
    );
  }
}

class PokemonType {
  final NamedResource type;
  final int slot;

  PokemonType({required this.type, required this.slot});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      type: NamedResource.fromJson(json['type'] as Map<String, dynamic>? ?? {}),
      slot: json['slot'] ?? 0,
    );
  }
}

class PokemonStat {
  final NamedResource stat;
  final int baseStat;
  final int effort;

  PokemonStat(
      {required this.stat, required this.baseStat, required this.effort});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      stat: NamedResource.fromJson(json['stat'] as Map<String, dynamic>? ?? {}),
      baseStat: json['base_stat'] ?? 0,
      effort: json['effort'] ?? 0,
    );
  }
}

class PokemonSprites {
  final String? frontDefault;
  final String? frontShiny;
  final SpritesOther? other;

  PokemonSprites({this.frontDefault, this.frontShiny, this.other});

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    return PokemonSprites(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
      other: json['other'] != null
          ? SpritesOther.fromJson(json['other'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SpritesOther {
  final OfficialArtwork? officialArtwork;

  SpritesOther({this.officialArtwork});

  factory SpritesOther.fromJson(Map<String, dynamic> json) {
    return SpritesOther(
      officialArtwork: json['official-artwork'] != null
          ? OfficialArtwork.fromJson(
              json['official-artwork'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OfficialArtwork {
  final String? frontDefault;
  final String? frontShiny;

  OfficialArtwork({this.frontDefault, this.frontShiny});

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) {
    return OfficialArtwork(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
    );
  }
}

class PokemonMoveRef {
  final NamedResource move;
  final List<VersionGroupDetail> versionGroupDetails;

  PokemonMoveRef({required this.move, required this.versionGroupDetails});

  factory PokemonMoveRef.fromJson(Map<String, dynamic> json) {
    return PokemonMoveRef(
      move: NamedResource.fromJson(json['move'] as Map<String, dynamic>? ?? {}),
      versionGroupDetails: (json['version_group_details'] as List?)
              ?.map((e) =>
                  VersionGroupDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class VersionGroupDetail {
  final int levelLearnedAt;
  final NamedResource moveLearnMethod;

  VersionGroupDetail(
      {required this.levelLearnedAt, required this.moveLearnMethod});

  factory VersionGroupDetail.fromJson(Map<String, dynamic> json) {
    return VersionGroupDetail(
      levelLearnedAt: json['level_learned_at'] ?? 0,
      moveLearnMethod: NamedResource.fromJson(
          json['move_learn_method'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class NamedResource {
  final String name;
  final String url;

  NamedResource({required this.name, required this.url});

  factory NamedResource.fromJson(Map<String, dynamic> json) {
    return NamedResource(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  int get idFromUrl {
    final parts = url.split('/');
    return int.tryParse(parts[parts.length - 1]) ?? 0;
  }
}
