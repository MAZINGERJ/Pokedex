import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'ability_detail_screen.dart';

class AbilitiesScreen extends StatefulWidget {
  const AbilitiesScreen({super.key});

  @override
  State<AbilitiesScreen> createState() => _AbilitiesScreenState();
}

class _AbilitiesScreenState extends State<AbilitiesScreen> {
  final _provider = PokedexProvider();
  List<ApiResult>? _abilities;
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
      final data = await _provider.getAbilitiesList(limit: 50, offset: _offset);
      setState(() {
        _abilities = data.results;
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
    if (_loading && _abilities == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _abilities == null) {
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
      itemCount: _abilities!.length + 1,
      itemBuilder: (context, index) {
        if (index == _abilities!.length) {
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
        final ability = _abilities![index];
        final id = int.tryParse(ability.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(_capitalize(ability.name)),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AbilityDetailScreen(abilityId: id),
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
