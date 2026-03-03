import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../models/pokemon_species.dart';
import '../providers/pokedex_provider.dart';
import '../utils/type_colors.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;

  const PokemonDetailScreen({super.key, required this.pokemonId});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final _provider = PokedexProvider();
  Pokemon? _pokemon;
  PokemonSpecies? _species;
  EvolutionChain? _evolutionChain;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final pokemon = await _provider.getPokemon(widget.pokemonId);
      final species = await _provider.getPokemonSpecies(widget.pokemonId);
      EvolutionChain? chain;
      if (species.evolutionChain != null) {
        final chainId = species.evolutionChain!.idFromUrl;
        chain = await _provider.getEvolutionChain(chainId);
      }
      setState(() {
        _pokemon = pokemon;
        _species = species;
        _evolutionChain = chain;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _pokemon == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null && _pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final p = _pokemon!;
    final s = _species!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_capitalize(p.name)),
        backgroundColor: p.types.isNotEmpty
            ? TypeColors.getColor(p.types.first.type.name)
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(p, s),
            _buildStats(p),
            _buildAbilities(p),
            _buildTypes(p),
            _buildMoves(p),
            if (_evolutionChain != null) _buildEvolution(_evolutionChain!),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Pokemon p, PokemonSpecies s) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: p.types.isNotEmpty
          ? TypeColors.getColor(p.types.first.type.name).withOpacity(0.3)
          : null,
      child: Column(
        children: [
          if (s.isLegendary || s.isMythical)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (s.isLegendary)
                    Chip(
                      label: const Text('Legendario'),
                      backgroundColor: Colors.amber,
                    ),
                  if (s.isLegendary && s.isMythical) const SizedBox(width: 8),
                  if (s.isMythical)
                    Chip(
                      label: const Text('Mítico'),
                      backgroundColor: Colors.purple,
                    ),
                ],
              ),
            ),
          CachedNetworkImage(
            imageUrl: p.imageUrl,
            height: 200,
            fit: BoxFit.contain,
            placeholder: (_, __) => const CircularProgressIndicator(),
            errorWidget: (_, __, ___) => const Icon(Icons.pest_control, size: 120),
          ),
          Text(
            '#${p.id.toString().padLeft(3, '0')}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          if (s.genus.isNotEmpty)
            Text(
              s.genus,
              style: TextStyle(
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          if (s.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                s.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip('Altura', '${p.height / 10} m'),
              const SizedBox(width: 16),
              _buildInfoChip('Peso', '${p.weight / 10} kg'),
              const SizedBox(width: 16),
              _buildInfoChip('EXP', '${p.baseExperience}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStats(Pokemon p) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Estadísticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...p.stats.map((s) {
            final name = _capitalize(s.stat.name.replaceAll('-', ' '));
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 120, child: Text(name)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (s.baseStat / 255).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 30,
                    child: Text('${s.baseStat}'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAbilities(Pokemon p) {
    if (p.abilities.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Habilidades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: p.abilities.map((a) {
              return Chip(
                label: Text(
                  '${_capitalize(a.ability.name)}${a.isHidden ? ' (oculta)' : ''}',
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTypes(Pokemon p) {
    if (p.types.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tipos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: p.types.map((t) {
              final color = TypeColors.getColor(t.type.name);
              return Chip(
                backgroundColor: color,
                label: Text(
                  _capitalize(t.type.name),
                  style: TextStyle(color: TypeColors.getContrastColor(t.type.name)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoves(Pokemon p) {
    if (p.moves.isEmpty) return const SizedBox.shrink();
    final moves = p.moves.take(15).toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Movimientos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moves.map((m) => Chip(label: Text(_capitalize(m.move.name)))).toList(),
          ),
          if (p.moves.length > 15)
            Text('+${p.moves.length - 15} más', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildEvolution(EvolutionChain chain) {
    final speciesIds = <int>[];
    void collect(ChainLink link) {
      speciesIds.add(link.species.idFromUrl);
      for (final next in link.evolvesTo) {
        collect(next);
      }
    }
    collect(chain.chain);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cadena de evolución', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: speciesIds.length,
              separatorBuilder: (_, __) => const Icon(Icons.arrow_forward),
              itemBuilder: (context, index) {
                final id = speciesIds[index];
                return FutureBuilder<Pokemon>(
                  future: _provider.getPokemon(id),
                  builder: (context, snap) {
                    if (!snap.hasData) return const SizedBox(width: 60);
                    final pokemon = snap.data!;
                    return GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PokemonDetailScreen(pokemonId: pokemon.id),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                          Text(_capitalize(pokemon.name), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
