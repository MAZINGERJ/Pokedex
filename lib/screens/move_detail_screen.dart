import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import '../utils/type_colors.dart';

class MoveDetailScreen extends StatelessWidget {
  final int moveId;

  const MoveDetailScreen({super.key, required this.moveId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Move>(
      future: PokedexProvider().getMove(moveId),
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
        final move = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(_capitalize(move.name)),
            backgroundColor: TypeColors.getColor(move.type.name),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(
                      backgroundColor: TypeColors.getColor(move.type.name),
                      label: Text(
                        _capitalize(move.type.name),
                        style: TextStyle(color: TypeColors.getContrastColor(move.type.name)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(_capitalize(move.damageClass.name.replaceAll('-', ' '))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatRow('Poder', move.power?.toString() ?? '-'),
                        _buildStatRow('Precisión', move.accuracy > 0 ? '${move.accuracy}%' : '-'),
                        _buildStatRow('PP', '${move.pp}'),
                        _buildStatRow('Prioridad', '${move.priority}'),
                      ],
                    ),
                  ),
                ),
                if (move.shortEffect.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Efecto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(move.shortEffect),
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
