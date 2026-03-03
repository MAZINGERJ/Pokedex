import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'berry_detail_screen.dart';

class BerriesScreen extends StatefulWidget {
  const BerriesScreen({super.key});

  @override
  State<BerriesScreen> createState() => _BerriesScreenState();
}

class _BerriesScreenState extends State<BerriesScreen> {
  final _provider = PokedexProvider();
  List<ApiResult>? _berries;
  bool _loading = true;
  String? _error;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _provider.getBerriesList(limit: 50, offset: _offset);
      setState(() {
        _berries = data.results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _berries == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _berries == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _berries!.length + 1,
      itemBuilder: (context, index) {
        if (index == _berries!.length) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _offset > 0
                      ? () {
                          setState(() => _offset -= 50);
                          _load();
                        }
                      : null,
                  child: const Text('Anterior'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _offset += 50);
                    _load();
                  },
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          );
        }
        final berry = _berries![index];
        final id = int.tryParse(berry.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.3),
              child: const Icon(Icons.grass),
            ),
            title: Text(_capitalize(berry.name)),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BerryDetailScreen(berryId: id),
              ),
            ),
          ),
        );
      },
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';
}
