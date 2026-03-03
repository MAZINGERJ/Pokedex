import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'location_detail_screen.dart';

class RegionDetailScreen extends StatelessWidget {
  final int regionId;

  const RegionDetailScreen({super.key, required this.regionId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Region>(
      future: PokedexProvider().getRegion(regionId),
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
        final region = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(_capitalize(region.name))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (region.names.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nombres', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...region.names.map((n) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('${n.language.name}: ${n.name}'),
                          )),
                        ],
                      ),
                    ),
                  ),
                if (region.locations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Ubicaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...region.locations.map((l) {
                    final id = l.idFromUrl;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(_capitalize(l.name.replaceAll('-', ' '))),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LocationDetailScreen(locationId: id),
                          ),
                        ),
                      ),
                    );
                  }),
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
