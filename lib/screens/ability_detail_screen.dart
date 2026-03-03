import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'pokemon_detail_screen.dart';

class AbilityDetailScreen extends StatelessWidget {
  final int abilityId;

  const AbilityDetailScreen({super.key, required this.abilityId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ability>(
      future: PokedexProvider().getAbility(abilityId),
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
        final ability = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(_capitalize(ability.name))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ability.shortEffect.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Efecto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(ability.shortEffect),
                        ],
                      ),
                    ),
                  ),
                if (ability.effect.isNotEmpty && ability.effect != ability.shortEffect)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Efecto completo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(ability.effect),
                        ],
                      ),
                    ),
                  ),
                if (ability.pokemon.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Pokémon con esta habilidad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ability.pokemon.take(30).map((p) {
                      return ActionChip(
                        label: Text(_capitalize(p.name)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PokemonDetailScreen(pokemonId: p.idFromUrl),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (ability.pokemon.length > 30)
                    Text('+${ability.pokemon.length - 30} más', style: TextStyle(color: Colors.grey[600])),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
