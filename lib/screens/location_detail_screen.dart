import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';

class LocationDetailScreen extends StatelessWidget {
  final int locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Location>(
      future: PokedexProvider().getLocation(locationId),
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
        final location = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(_capitalize(location.name.replaceAll('-', ' ')))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Región', _capitalize(location.region.name.replaceAll('-', ' '))),
                        if (location.names.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('Nombres en otros idiomas', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...location.names.map((n) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('${n.language.name}: ${n.name}'),
                          )),
                        ],
                      ],
                    ),
                  ),
                ),
                if (location.areas.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Áreas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...location.areas.map((a) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(_capitalize(a.name.replaceAll('-', ' '))),
                    ),
                  )),
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
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
