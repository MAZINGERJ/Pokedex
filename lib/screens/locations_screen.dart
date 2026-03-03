import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'location_detail_screen.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final _provider = PokedexProvider();
  List<ApiResult>? _locations;
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
      final data = await _provider.getLocationsList(limit: 50, offset: _offset);
      setState(() {
        _locations = data.results;
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
    if (_loading && _locations == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _locations == null) {
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
      itemCount: _locations!.length + 1,
      itemBuilder: (context, index) {
        if (index == _locations!.length) {
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
        final location = _locations![index];
        final id = int.tryParse(location.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.place)),
            title: Text(_capitalize(location.name.replaceAll('-', ' '))),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LocationDetailScreen(locationId: id),
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
