import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../models/pokemon_species.dart';

class PokeApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  final http.Client _client = http.Client();

  // ============ POKÉMON ============

  Future<PaginatedResponse<ApiResult>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'),
    );
    return _parsePaginated(response);
  }

  Future<Pokemon> getPokemon(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/pokemon/$id'));
    return Pokemon.fromJson(_parseJson(response));
  }

  Future<Pokemon> getPokemonByName(String name) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/pokemon/${name.toLowerCase()}'));
    return Pokemon.fromJson(_parseJson(response));
  }

  Future<PokemonSpecies> getPokemonSpecies(int id) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/pokemon-species/$id'));
    return PokemonSpecies.fromJson(_parseJson(response));
  }

  // ============ TIPOS ============

  Future<PaginatedResponse<ApiResult>> getTypesList() async {
    final response = await _client.get(Uri.parse('$_baseUrl/type'));
    return _parsePaginated(response);
  }

  Future<PokeType> getType(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/type/$id'));
    return PokeType.fromJson(_parseJson(response));
  }

  Future<PokeType> getTypeByName(String name) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/type/${name.toLowerCase()}'));
    return PokeType.fromJson(_parseJson(response));
  }

  // ============ HABILIDADES ============

  Future<PaginatedResponse<ApiResult>> getAbilitiesList({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/ability?limit=$limit&offset=$offset'),
    );
    return _parsePaginated(response);
  }

  Future<Ability> getAbility(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/ability/$id'));
    return Ability.fromJson(_parseJson(response));
  }

  // ============ MOVIMIENTOS ============

  Future<PaginatedResponse<ApiResult>> getMovesList({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/move?limit=$limit&offset=$offset'),
    );
    return _parsePaginated(response);
  }

  Future<Move> getMove(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/move/$id'));
    return Move.fromJson(_parseJson(response));
  }

  // ============ OBJETOS ============

  Future<PaginatedResponse<ApiResult>> getItemsList({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/item?limit=$limit&offset=$offset'),
    );
    return _parsePaginated(response);
  }

  Future<PokeItem> getItem(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/item/$id'));
    return PokeItem.fromJson(_parseJson(response));
  }

  // ============ BAYAS ============

  Future<PaginatedResponse<ApiResult>> getBerriesList({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/berry?limit=$limit&offset=$offset'),
    );
    return _parsePaginated(response);
  }

  Future<Berry> getBerry(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/berry/$id'));
    return Berry.fromJson(_parseJson(response));
  }

  // ============ UBICACIONES ============

  Future<PaginatedResponse<ApiResult>> getLocationsList({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/location?limit=$limit&offset=$offset'),
    );
    return _parsePaginated(response);
  }

  Future<Location> getLocation(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/location/$id'));
    return Location.fromJson(_parseJson(response));
  }

  // ============ REGIONES ============

  Future<PaginatedResponse<ApiResult>> getRegionsList() async {
    final response = await _client.get(Uri.parse('$_baseUrl/region'));
    return _parsePaginated(response);
  }

  Future<Region> getRegion(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/region/$id'));
    return Region.fromJson(_parseJson(response));
  }

  // ============ CADENAS DE EVOLUCIÓN ============

  Future<EvolutionChain> getEvolutionChain(int id) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/evolution-chain/$id'));
    return EvolutionChain.fromJson(_parseJson(response));
  }

  // ============ GENERACIONES ============

  Future<PaginatedResponse<ApiResult>> getGenerationsList() async {
    final response = await _client.get(Uri.parse('$_baseUrl/generation'));
    return _parsePaginated(response);
  }

  Future<Generation> getGeneration(int id) async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/generation/$id'));
    return Generation.fromJson(_parseJson(response));
  }

  // ============ HÁBITATS ============

  Future<PaginatedResponse<ApiResult>> getHabitatsList() async {
    final response =
        await _client.get(Uri.parse('$_baseUrl/pokemon-habitat'));
    return _parsePaginated(response);
  }

  // ============ POKEDEX ============

  Future<PaginatedResponse<ApiResult>> getPokedexList() async {
    final response = await _client.get(Uri.parse('$_baseUrl/pokedex'));
    return _parsePaginated(response);
  }

  // ============ HELPERS ============

  PaginatedResponse<ApiResult> _parsePaginated(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PaginatedResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List?)
              ?.map((e) => ApiResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> _parseJson(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Error: ${response.statusCode}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void dispose() {
    _client.close();
  }
}
