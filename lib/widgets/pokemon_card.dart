import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../models/pokemon.dart';
import '../utils/type_colors.dart';

class PokemonCard extends StatelessWidget {
  final dynamic pokemon; // Pokemon or ApiResult
  final VoidCallback? onTap;

  const PokemonCard({super.key, required this.pokemon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFull = pokemon is Pokemon;
    final name = isFull
        ? (pokemon as Pokemon).name
        : (pokemon as ApiResult).name;
    final id = isFull
        ? (pokemon as Pokemon).id
        : _idFromUrl((pokemon as ApiResult).url);
    final types = isFull ? (pokemon as Pokemon).types : <PokemonType>[];
    final imageUrl = isFull && (pokemon as Pokemon).imageUrl.isNotEmpty
        ? (pokemon as Pokemon).imageUrl
        : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.contain,
                placeholder: (_, __) => const CircularProgressIndicator(),
                errorWidget: (_, __, ___) => const Icon(Icons.pest_control, size: 60),
              ),
              const SizedBox(height: 8),
              Text(
                '#${id.toString().padLeft(3, '0')}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                _capitalize(name),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (types.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: types
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: TypeColors.getColor(t.type.name),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _capitalize(t.type.name),
                              style: TextStyle(
                                color: TypeColors.getContrastColor(t.type.name),
                                fontSize: 10,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}

int _idFromUrl(String url) {
  final parts = url.split('/');
  return int.tryParse(parts[parts.length - 1]) ?? 0;
}
