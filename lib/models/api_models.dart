import 'pokemon.dart';

class PaginatedResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  PaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ApiResult {
  final String name;
  final String url;

  ApiResult({required this.name, required this.url});

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class PokeType {
  final int id;
  final String name;
  final TypeDamageRelations damageRelations;
  final List<TypePokemon> pokemon;

  PokeType({
    required this.id,
    required this.name,
    required this.damageRelations,
    required this.pokemon,
  });

  factory PokeType.fromJson(Map<String, dynamic> json) {
    return PokeType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      damageRelations: json['damage_relations'] != null
          ? TypeDamageRelations.fromJson(
              json['damage_relations'] as Map<String, dynamic>)
          : TypeDamageRelations(noDamageTo: [], halfDamageTo: [], doubleDamageTo: [], noDamageFrom: [], halfDamageFrom: [], doubleDamageFrom: []),
      pokemon: (json['pokemon'] as List?)
              ?.map((e) => TypePokemon.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TypeDamageRelations {
  final List<NamedResource> noDamageTo;
  final List<NamedResource> halfDamageTo;
  final List<NamedResource> doubleDamageTo;
  final List<NamedResource> noDamageFrom;
  final List<NamedResource> halfDamageFrom;
  final List<NamedResource> doubleDamageFrom;

  TypeDamageRelations({
    required this.noDamageTo,
    required this.halfDamageTo,
    required this.doubleDamageTo,
    required this.noDamageFrom,
    required this.halfDamageFrom,
    required this.doubleDamageFrom,
  });

  factory TypeDamageRelations.fromJson(Map<String, dynamic> json) {
    return TypeDamageRelations(
      noDamageTo: _parseList(json['no_damage_to']),
      halfDamageTo: _parseList(json['half_damage_to']),
      doubleDamageTo: _parseList(json['double_damage_to']),
      noDamageFrom: _parseList(json['no_damage_from']),
      halfDamageFrom: _parseList(json['half_damage_from']),
      doubleDamageFrom: _parseList(json['double_damage_from']),
    );
  }

  static List<NamedResource> _parseList(dynamic list) {
    if (list is! List) return [];
    return list
        .map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class TypePokemon {
  final int slot;
  final NamedResource pokemon;

  TypePokemon({required this.slot, required this.pokemon});

  factory TypePokemon.fromJson(Map<String, dynamic> json) {
    return TypePokemon(
      slot: json['slot'] ?? 0,
      pokemon: NamedResource.fromJson(
          json['pokemon'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Ability {
  final int id;
  final String name;
  final bool isMainSeries;
  final List<AbilityEffectEntry> effectEntries;
  final List<AbilityFlavorText> flavorTextEntries;
  final List<NamedResource> pokemon;

  Ability({
    required this.id,
    required this.name,
    required this.isMainSeries,
    required this.effectEntries,
    required this.flavorTextEntries,
    required this.pokemon,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isMainSeries: json['is_main_series'] ?? false,
      effectEntries: (json['effect_entries'] as List?)
              ?.map((e) =>
                  AbilityEffectEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      flavorTextEntries: (json['flavor_text_entries'] as List?)
              ?.map((e) =>
                  AbilityFlavorText.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pokemon: (json['pokemon'] as List?)
              ?.map((e) {
                final p = (e as Map<String, dynamic>)['pokemon'];
                return NamedResource.fromJson(p as Map<String, dynamic>? ?? {});
              })
              .toList() ??
          [],
    );
  }

  String get effect {
    final en = effectEntries.where((e) => e.language.name == 'en').toList();
    return en.isNotEmpty ? en.first.effect : '';
  }

  String get shortEffect {
    final en = effectEntries.where((e) => e.language.name == 'en').toList();
    return en.isNotEmpty ? en.first.shortEffect : '';
  }
}

class AbilityEffectEntry {
  final String effect;
  final String shortEffect;
  final NamedResource language;

  AbilityEffectEntry(
      {required this.effect, required this.shortEffect, required this.language});

  factory AbilityEffectEntry.fromJson(Map<String, dynamic> json) {
    return AbilityEffectEntry(
      effect: json['effect'] ?? '',
      shortEffect: json['short_effect'] ?? '',
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class AbilityFlavorText {
  final String flavorText;
  final NamedResource language;

  AbilityFlavorText({required this.flavorText, required this.language});

  factory AbilityFlavorText.fromJson(Map<String, dynamic> json) {
    return AbilityFlavorText(
      flavorText: (json['flavor_text'] ?? '').replaceAll('\n', ' '),
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Move {
  final int id;
  final String name;
  final int accuracy;
  final int? power;
  final int pp;
  final int priority;
  final NamedResource type;
  final NamedResource damageClass;
  final List<MoveEffectEntry> effectEntries;
  final List<MoveFlavorText> flavorTextEntries;

  Move({
    required this.id,
    required this.name,
    required this.accuracy,
    this.power,
    required this.pp,
    required this.priority,
    required this.type,
    required this.damageClass,
    required this.effectEntries,
    required this.flavorTextEntries,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      accuracy: json['accuracy'] ?? 0,
      power: json['power'],
      pp: json['pp'] ?? 0,
      priority: json['priority'] ?? 0,
      type: NamedResource.fromJson(
          json['type'] as Map<String, dynamic>? ?? {}),
      damageClass: NamedResource.fromJson(
          json['damage_class'] as Map<String, dynamic>? ?? {}),
      effectEntries: (json['effect_entries'] as List?)
              ?.map((e) =>
                  MoveEffectEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      flavorTextEntries: (json['flavor_text_entries'] as List?)
              ?.map((e) =>
                  MoveFlavorText.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get effect {
    final en = effectEntries.where((e) => e.language.name == 'en').toList();
    return en.isNotEmpty ? en.first.effect : '';
  }

  String get shortEffect {
    final en = effectEntries.where((e) => e.language.name == 'en').toList();
    return en.isNotEmpty ? en.first.shortEffect : '';
  }
}

class MoveEffectEntry {
  final String effect;
  final String shortEffect;
  final NamedResource language;

  MoveEffectEntry(
      {required this.effect, required this.shortEffect, required this.language});

  factory MoveEffectEntry.fromJson(Map<String, dynamic> json) {
    return MoveEffectEntry(
      effect: json['effect'] ?? '',
      shortEffect: json['short_effect'] ?? '',
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MoveFlavorText {
  final String flavorText;
  final NamedResource language;
  final NamedResource versionGroup;

  MoveFlavorText(
      {required this.flavorText,
      required this.language,
      required this.versionGroup});

  factory MoveFlavorText.fromJson(Map<String, dynamic> json) {
    return MoveFlavorText(
      flavorText: (json['flavor_text'] ?? '').replaceAll('\n', ' '),
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
      versionGroup: NamedResource.fromJson(
          json['version_group'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class PokeItem {
  final int id;
  final String name;
  final int cost;
  final int? flingPower;
  final List<ItemEffectEntry> effectEntries;
  final NamedResource category;
  final List<NamedResource> attributes;
  final String? spritesDefault;

  PokeItem({
    required this.id,
    required this.name,
    required this.cost,
    this.flingPower,
    required this.effectEntries,
    required this.category,
    required this.attributes,
    this.spritesDefault,
  });

  factory PokeItem.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>?;
    return PokeItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cost: json['cost'] ?? 0,
      flingPower: json['fling_power'],
      effectEntries: (json['effect_entries'] as List?)
              ?.map((e) =>
                  ItemEffectEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      category: NamedResource.fromJson(
          json['category'] as Map<String, dynamic>? ?? {}),
      attributes: (json['attributes'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      spritesDefault: sprites?['default'] as String?,
    );
  }

  String get effect {
    final en = effectEntries.where((e) => e.language.name == 'en').toList();
    return en.isNotEmpty ? en.first.effect : '';
  }
}

class ItemEffectEntry {
  final String effect;
  final NamedResource language;

  ItemEffectEntry({required this.effect, required this.language});

  factory ItemEffectEntry.fromJson(Map<String, dynamic> json) {
    return ItemEffectEntry(
      effect: json['effect'] ?? '',
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Berry {
  final int id;
  final String name;
  final int size;
  final int smoothness;
  final int soilDryness;
  final NamedResource firmness;
  final List<BerryFlavorMap> flavors;
  final NamedResource item;
  final NamedResource naturalGiftType;

  Berry({
    required this.id,
    required this.name,
    required this.size,
    required this.smoothness,
    required this.soilDryness,
    required this.firmness,
    required this.flavors,
    required this.item,
    required this.naturalGiftType,
  });

  factory Berry.fromJson(Map<String, dynamic> json) {
    return Berry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      size: json['size'] ?? 0,
      smoothness: json['smoothness'] ?? 0,
      soilDryness: json['soil_dryness'] ?? 0,
      firmness: NamedResource.fromJson(
          json['firmness'] as Map<String, dynamic>? ?? {}),
      flavors: (json['flavors'] as List?)
              ?.map((e) =>
                  BerryFlavorMap.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      item: NamedResource.fromJson(
          json['item'] as Map<String, dynamic>? ?? {}),
      naturalGiftType: NamedResource.fromJson(
          json['natural_gift_type'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class BerryFlavorMap {
  final int potency;
  final NamedResource flavor;

  BerryFlavorMap({required this.potency, required this.flavor});

  factory BerryFlavorMap.fromJson(Map<String, dynamic> json) {
    return BerryFlavorMap(
      potency: json['potency'] ?? 0,
      flavor: NamedResource.fromJson(
          json['flavor'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Location {
  final int id;
  final String name;
  final NamedResource region;
  final List<LocationName> names;
  final List<NamedResource> areas;

  Location({
    required this.id,
    required this.name,
    required this.region,
    required this.names,
    required this.areas,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      region: NamedResource.fromJson(
          json['region'] as Map<String, dynamic>? ?? {}),
      names: (json['names'] as List?)
              ?.map((e) => LocationName.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      areas: (json['areas'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class LocationName {
  final String name;
  final NamedResource language;

  LocationName({required this.name, required this.language});

  factory LocationName.fromJson(Map<String, dynamic> json) {
    return LocationName(
      name: json['name'] ?? '',
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Region {
  final int id;
  final String name;
  final List<NamedResource> locations;
  final List<NamedResource> mainGeneration;
  final List<RegionName> names;

  Region({
    required this.id,
    required this.name,
    required this.locations,
    required this.mainGeneration,
    required this.names,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      locations: (json['locations'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      mainGeneration: (json['main_generation'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      names: (json['names'] as List?)
              ?.map((e) => RegionName.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RegionName {
  final String name;
  final NamedResource language;

  RegionName({required this.name, required this.language});

  factory RegionName.fromJson(Map<String, dynamic> json) {
    return RegionName(
      name: json['name'] ?? '',
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class EvolutionChain {
  final int id;
  final ChainLink chain;

  EvolutionChain({required this.id, required this.chain});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(
      id: json['id'] ?? 0,
      chain: ChainLink.fromJson(
          json['chain'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class ChainLink {
  final NamedResource species;
  final List<EvolutionDetail> evolutionDetails;
  final List<ChainLink> evolvesTo;

  ChainLink({
    required this.species,
    required this.evolutionDetails,
    required this.evolvesTo,
  });

  factory ChainLink.fromJson(Map<String, dynamic> json) {
    return ChainLink(
      species: NamedResource.fromJson(
          json['species'] as Map<String, dynamic>? ?? {}),
      evolutionDetails: (json['evolution_details'] as List?)
              ?.map((e) =>
                  EvolutionDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolvesTo: (json['evolves_to'] as List?)
              ?.map((e) => ChainLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class EvolutionDetail {
  final NamedResource? item;
  final NamedResource? trigger;
  final int? minLevel;
  final String? minHappiness;
  final String? minAffection;
  final String? timeOfDay;
  final NamedResource? knownMoveType;
  final String? gender;
  final NamedResource? location;
  final String? minBeauty;
  final bool needsOverworldRain;
  final NamedResource? partySpecies;
  final NamedResource? partyType;
  final int? relativePhysicalStats;
  final bool turnUpsideDown;

  EvolutionDetail({
    this.item,
    this.trigger,
    this.minLevel,
    this.minHappiness,
    this.minAffection,
    this.timeOfDay,
    this.knownMoveType,
    this.gender,
    this.location,
    this.minBeauty,
    required this.needsOverworldRain,
    this.partySpecies,
    this.partyType,
    this.relativePhysicalStats,
    required this.turnUpsideDown,
  });

  factory EvolutionDetail.fromJson(Map<String, dynamic> json) {
    return EvolutionDetail(
      item: json['item'] != null
          ? NamedResource.fromJson(json['item'] as Map<String, dynamic>)
          : null,
      trigger: json['trigger'] != null
          ? NamedResource.fromJson(json['trigger'] as Map<String, dynamic>)
          : null,
      minLevel: json['min_level'],
      minHappiness: json['min_happiness']?.toString(),
      minAffection: json['min_affection']?.toString(),
      timeOfDay: json['time_of_day'] as String?,
      knownMoveType: json['known_move_type'] != null
          ? NamedResource.fromJson(
              json['known_move_type'] as Map<String, dynamic>)
          : null,
      gender: json['gender']?.toString(),
      location: json['location'] != null
          ? NamedResource.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      minBeauty: json['min_beauty']?.toString(),
      needsOverworldRain: json['needs_overworld_rain'] ?? false,
      partySpecies: json['party_species'] != null
          ? NamedResource.fromJson(
              json['party_species'] as Map<String, dynamic>)
          : null,
      partyType: json['party_type'] != null
          ? NamedResource.fromJson(
              json['party_type'] as Map<String, dynamic>)
          : null,
      relativePhysicalStats: json['relative_physical_stats'],
      turnUpsideDown: json['turn_upside_down'] ?? false,
    );
  }
}

class Generation {
  final int id;
  final String name;
  final List<NamedResource> abilities;
  final List<NamedResource> moves;
  final List<NamedResource> types;
  final List<NamedResource> versionGroups;
  final List<NamedResource> pokemonSpecies;

  Generation({
    required this.id,
    required this.name,
    required this.abilities,
    required this.moves,
    required this.types,
    required this.versionGroups,
    required this.pokemonSpecies,
  });

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      abilities: (json['abilities'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      moves: (json['moves'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      types: (json['types'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      versionGroups: (json['version_groups'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pokemonSpecies: (json['pokemon_species'] as List?)
              ?.map((e) => NamedResource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
