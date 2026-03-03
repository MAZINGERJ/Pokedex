import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import '../utils/type_colors.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokemonListByTypeScreen extends StatelessWidget {
  final int typeId;
  final String typeName;

  const PokemonListByTypeScreen({
    super.key,
    required this.typeId,
    required this.typeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipo: ${_capitalize(typeName)}'),
        backgroundColor: TypeColors.getColor(typeName),
      ),
      body: FutureBuilder<PokeType>(
        future: PokedexProvider().getType(typeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final type = snapshot.data!;
          final pokemonList = type.pokemon;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (type.damageRelations.doubleDamageTo.isNotEmpty ||
                  type.damageRelations.halfDamageFrom.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Relaciones de daño', style: TextStyle(fontWeight: FontWeight.bold)),
                          if (type.damageRelations.doubleDamageTo.isNotEmpty)
                            Text('Super efectivo contra: ${type.damageRelations.doubleDamageTo.map((t) => _capitalize(t.name)).join(', ')}'),
                          if (type.damageRelations.halfDamageFrom.isNotEmpty)
                            Text('Resiste a: ${type.damageRelations.halfDamageFrom.map((t) => _capitalize(t.name)).join(', ')}'),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: pokemonList.length,
                  itemBuilder: (context, index) {
                    final ref = pokemonList[index].pokemon;
                    final id = ref.idFromUrl;
                    return FutureBuilder<Pokemon>(
                      future: PokedexProvider().getPokemon(id),
                      builder: (context, pokemonSnap) {
                        if (!pokemonSnap.hasData) {
                          return const Card(child: Center(child: CircularProgressIndicator()));
                        }
                        return PokemonCard(
                          pokemon: pokemonSnap.data!,
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
