import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';

class ItemDetailScreen extends StatelessWidget {
  final int itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokeItem>(
      future: PokedexProvider().getItem(itemId),
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
        final item = snapshot.data!;

        final imageUrl = item.spritesDefault ?? 
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/${item.name}.png';

        return Scaffold(
          appBar: AppBar(title: Text(_capitalize(item.name))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Icon(Icons.inventory_2, size: 96),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Precio', '${item.cost} ₽'),
                        if (item.flingPower != null)
                          _buildRow('Poder de lanzamiento', '${item.flingPower}'),
                        _buildRow('Categoría', _capitalize(item.category.name.replaceAll('-', ' '))),
                        if (item.attributes.isNotEmpty)
                          _buildRow('Atributos', item.attributes.map((a) => _capitalize(a.name.replaceAll('-', ' '))).join(', ')),
                      ],
                    ),
                  ),
                ),
                if (item.effect.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Efecto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(item.effect),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
