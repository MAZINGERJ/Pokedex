import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'region_detail_screen.dart';

class RegionsScreen extends StatelessWidget {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaginatedResponse<ApiResult>>(
      future: PokedexProvider().getRegionsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
              ],
            ),
          );
        }
        final regions = snapshot.data!.results;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: regions.length,
          itemBuilder: (context, index) {
            final region = regions[index];
            final id = int.tryParse(region.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.3),
                  child: Text(_capitalize(region.name)[0]),
                ),
                title: Text(_capitalize(region.name)),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegionDetailScreen(regionId: id),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
