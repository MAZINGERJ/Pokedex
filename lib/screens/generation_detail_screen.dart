import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import '../utils/type_colors.dart';
import '../widgets/pokemon_card.dart';
import 'ability_detail_screen.dart';
import 'move_detail_screen.dart';
import 'pokemon_detail_screen.dart';

class GenerationDetailScreen extends StatelessWidget {
  final int generationId;

  const GenerationDetailScreen({super.key, required this.generationId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Generation>(
      future: PokedexProvider().getGeneration(generationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final gen = snapshot.data!;

        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text(_capitalize(gen.name)),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Pokémon'),
                  Tab(text: 'Movimientos'),
                  Tab(text: 'Habilidades'),
                  Tab(text: 'Tipos'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildPokemonTab(context, gen.pokemonSpecies),
                _buildMovesTab(context, gen.moves),
                _buildAbilitiesTab(context, gen.abilities),
                _buildTypesTab(gen.types),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPokemonTab(BuildContext context, List<NamedResource> species) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: species.length,
      itemBuilder: (ctx, index) {
        final s = species[index];
        final id = s.idFromUrl;
        return FutureBuilder(
          future: PokedexProvider().getPokemon(id),
          builder: (ctx, snap) {
            if (!snap.hasData) return const Card(child: Center(child: CircularProgressIndicator()));
            return PokemonCard(
              pokemon: snap.data!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PokemonDetailScreen(pokemonId: id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMovesTab(BuildContext context, List<NamedResource> moves) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: moves.length,
      itemBuilder: (context, index) {
        final m = moves[index];
        final id = m.idFromUrl;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(_capitalize(m.name)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MoveDetailScreen(moveId: id),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAbilitiesTab(BuildContext context, List<NamedResource> abilities) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: abilities.length,
      itemBuilder: (context, index) {
        final a = abilities[index];
        final id = a.idFromUrl;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(_capitalize(a.name)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AbilityDetailScreen(abilityId: id),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypesTab(List<NamedResource> types) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final t = types[index];
        final color = TypeColors.getColor(t.name);
        return Card(
          color: color,
          child: Center(
            child: Text(
              _capitalize(t.name),
              style: TextStyle(
                color: TypeColors.getContrastColor(t.name),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
