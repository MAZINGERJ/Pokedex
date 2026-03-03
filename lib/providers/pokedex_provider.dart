import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../models/pokemon_species.dart';
import '../services/poke_api_service.dart';

class PokedexProvider {
  final PokeApiService _api = PokeApiService();

  Future<PaginatedResponse<ApiResult>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) =>
      _api.getPokemonList(limit: limit, offset: offset);

  Future<Pokemon> getPokemon(int id) => _api.getPokemon(id);

  Future<Pokemon> getPokemonByName(String name) =>
      _api.getPokemonByName(name);

  Future<PokemonSpecies> getPokemonSpecies(int id) =>
      _api.getPokemonSpecies(id);

  Future<PaginatedResponse<ApiResult>> getTypesList() =>
      _api.getTypesList();

  Future<PokeType> getType(int id) => _api.getType(id);

  Future<PaginatedResponse<ApiResult>> getAbilitiesList({
    int limit = 50,
    int offset = 0,
  }) =>
      _api.getAbilitiesList(limit: limit, offset: offset);

  Future<Ability> getAbility(int id) => _api.getAbility(id);

  Future<PaginatedResponse<ApiResult>> getMovesList({
    int limit = 50,
    int offset = 0,
  }) =>
      _api.getMovesList(limit: limit, offset: offset);

  Future<Move> getMove(int id) => _api.getMove(id);

  Future<PaginatedResponse<ApiResult>> getItemsList({
    int limit = 50,
    int offset = 0,
  }) =>
      _api.getItemsList(limit: limit, offset: offset);

  Future<PokeItem> getItem(int id) => _api.getItem(id);

  Future<PaginatedResponse<ApiResult>> getBerriesList({
    int limit = 50,
    int offset = 0,
  }) =>
      _api.getBerriesList(limit: limit, offset: offset);

  Future<Berry> getBerry(int id) => _api.getBerry(id);

  Future<PaginatedResponse<ApiResult>> getLocationsList({
    int limit = 50,
    int offset = 0,
  }) =>
      _api.getLocationsList(limit: limit, offset: offset);

  Future<Location> getLocation(int id) => _api.getLocation(id);

  Future<PaginatedResponse<ApiResult>> getRegionsList() =>
      _api.getRegionsList();

  Future<Region> getRegion(int id) => _api.getRegion(id);

  Future<EvolutionChain> getEvolutionChain(int id) =>
      _api.getEvolutionChain(id);

  Future<PaginatedResponse<ApiResult>> getGenerationsList() =>
      _api.getGenerationsList();

  Future<Generation> getGeneration(int id) => _api.getGeneration(id);

  Future<PaginatedResponse<ApiResult>> getHabitatsList() =>
      _api.getHabitatsList();

  Future<PaginatedResponse<ApiResult>> getPokedexList() =>
      _api.getPokedexList();
}
