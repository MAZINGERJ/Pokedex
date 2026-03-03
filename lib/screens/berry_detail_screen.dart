import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';

class BerryDetailScreen extends StatelessWidget {
  final int berryId;

  const BerryDetailScreen({super.key, required this.berryId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Berry>(
      future: PokedexProvider().getBerry(berryId),
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
        final berry = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(_capitalize(berry.name))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.red.withOpacity(0.3),
                  child: const Icon(Icons.grass, size: 64),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Tamaño', '${berry.size}'),
                        _buildRow('Suavidad', '${berry.smoothness}'),
                        _buildRow('Sequedad del suelo', '${berry.soilDryness}'),
                        _buildRow('Firmeza', _capitalize(berry.firmness.name.replaceAll('-', ' '))),
                        _buildRow('Tipo de regalo natural', _capitalize(berry.naturalGiftType.name.replaceAll('-', ' '))),
                        if (berry.flavors.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('Sabores', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...berry.flavors.map((f) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('${_capitalize(f.flavor.name)}: ${f.potency}'),
                          )),
                        ],
                      ],
                    ),
                  ),
                ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
