import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'generation_detail_screen.dart';

class GenerationsScreen extends StatelessWidget {
  const GenerationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaginatedResponse<ApiResult>>(
      future: PokedexProvider().getGenerationsList(),
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
        final generations = snapshot.data!.results;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: generations.length,
          itemBuilder: (context, index) {
            final gen = generations[index];
            final id = int.tryParse(gen.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.3),
                  child: Text('${index + 1}'),
                ),
                title: Text(_capitalize(gen.name)),
                subtitle: Text('Generación ${index + 1}'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GenerationDetailScreen(generationId: id),
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
