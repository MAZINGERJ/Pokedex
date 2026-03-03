import 'pokemon.dart';

class PokemonSpecies {
  final int id;
  final String name;
  final List<Genus> genera;
  final List<FlavorTextEntry> flavorTextEntries;
  final NamedResource? evolutionChain;
  final bool isLegendary;
  final bool isMythical;
  final NamedResource? habitat;
  final int captureRate;
  final int baseHappiness;
  final NamedResource? growthRate;
  final List<PokemonSpeciesVariety> varieties;

  PokemonSpecies({
    required this.id,
    required this.name,
    required this.genera,
    required this.flavorTextEntries,
    this.evolutionChain,
    required this.isLegendary,
    required this.isMythical,
    this.habitat,
    required this.captureRate,
    required this.baseHappiness,
    this.growthRate,
    required this.varieties,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    return PokemonSpecies(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      genera: (json['genera'] as List?)
              ?.map((e) => Genus.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      flavorTextEntries: (json['flavor_text_entries'] as List?)
              ?.map((e) =>
                  FlavorTextEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      evolutionChain: json['evolution_chain'] != null
          ? NamedResource.fromJson(
              json['evolution_chain'] as Map<String, dynamic>)
          : null,
      isLegendary: json['is_legendary'] ?? false,
      isMythical: json['is_mythical'] ?? false,
      habitat: json['habitat'] != null
          ? NamedResource.fromJson(json['habitat'] as Map<String, dynamic>)
          : null,
      captureRate: json['capture_rate'] ?? 0,
      baseHappiness: json['base_happiness'] ?? 0,
      growthRate: json['growth_rate'] != null
          ? NamedResource.fromJson(
              json['growth_rate'] as Map<String, dynamic>)
          : null,
      varieties: (json['varieties'] as List?)
              ?.map((e) =>
                  PokemonSpeciesVariety.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get description {
    final es = flavorTextEntries
        .where((e) => e.language.name == 'es')
        .toList();
    if (es.isNotEmpty) return es.first.flavorText;
    final en = flavorTextEntries
        .where((e) => e.language.name == 'en')
        .toList();
    return en.isNotEmpty ? en.first.flavorText : '';
  }

  String get genus {
    final es = genera.where((e) => e.language.name == 'es').toList();
    if (es.isNotEmpty) return es.first.genus;
    final en = genera.where((e) => e.language.name == 'en').toList();
    return en.isNotEmpty ? en.first.genus : '';
  }
}

class Genus {
  final String genus;
  final NamedResource language;

  Genus({required this.genus, required this.language});

  factory Genus.fromJson(Map<String, dynamic> json) {
    return Genus(
      genus: json['genus'] ?? '',
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FlavorTextEntry {
  final String flavorText;
  final NamedResource language;
  final NamedResource? version;

  FlavorTextEntry(
      {required this.flavorText, required this.language, this.version});

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) {
    return FlavorTextEntry(
      flavorText: (json['flavor_text'] ?? '').replaceAll('\n', ' '),
      language: NamedResource.fromJson(
          json['language'] as Map<String, dynamic>? ?? {}),
      version: json['version'] != null
          ? NamedResource.fromJson(json['version'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PokemonSpeciesVariety {
  final bool isDefault;
  final NamedResource pokemon;

  PokemonSpeciesVariety({required this.isDefault, required this.pokemon});

  factory PokemonSpeciesVariety.fromJson(Map<String, dynamic> json) {
    return PokemonSpeciesVariety(
      isDefault: json['is_default'] ?? false,
      pokemon: NamedResource.fromJson(
          json['pokemon'] as Map<String, dynamic>? ?? {}),
    );
  }
}
