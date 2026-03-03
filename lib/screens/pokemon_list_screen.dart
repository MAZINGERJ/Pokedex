import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final _provider = PokedexProvider();
  final _searchController = TextEditingController();
  PaginatedResponse<ApiResult>? _data;
  Pokemon? _searchResult;
  bool _loading = true;
  bool _searching = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResult = null;
        _searching = false;
      });
      return;
    }
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final pokemon = await _provider.getPokemonByName(query.trim());
      setState(() {
        _searchResult = pokemon;
        _searching = false;
      });
    } catch (e) {
      setState(() {
        _searchResult = null;
        _searching = false;
        _error = 'No se encontró: $query';
      });
    }
  }

  Future<void> _load({int offset = 0}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _provider.getPokemonList(limit: 24, offset: offset);
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _loadNext() {
    if (_data?.next != null && !_loading) {
      final uri = Uri.parse(_data!.next!);
      final offset = int.tryParse(uri.queryParameters['offset'] ?? '0') ?? 0;
      _load(offset: offset);
    }
  }

  void _loadPrev() {
    if (_data?.previous != null && !_loading) {
      final uri = Uri.parse(_data!.previous!);
      final offset = int.tryParse(uri.queryParameters['offset'] ?? '0') ?? 0;
      _load(offset: offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _load(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final results = _data!.results;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar Pokémon por nombre...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResult = null;
                    _error = null;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            onSubmitted: _search,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _searchResult = null;
                  _error = null;
                });
              }
            },
          ),
        ),
        if (_searching)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_searchResult != null)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: PokemonCard(
                pokemon: _searchResult!,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PokemonDetailScreen(
                      pokemonId: _searchResult!.id,
                    ),
                  ),
                ),
              ),
            ),
          )
        else if (_error != null && _searchController.text.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: Text(_error!)),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${_data!.count} Pokémon encontrados',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: results.length + 1,
              itemBuilder: (context, index) {
                if (index == results.length) {
                  return _buildPagination();
                }
                final item = results[index];
                final id = item.url.split('/').where((s) => s.isNotEmpty).last;
                return PokemonCard(
                  pokemon: item,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PokemonDetailScreen(
                        pokemonId: int.tryParse(id) ?? 0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _data?.previous != null && !_loading
                ? _loadPrev
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
          ),
          if (_loading) const CircularProgressIndicator(),
          ElevatedButton.icon(
            onPressed: _data?.next != null && !_loading ? _loadNext : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}
