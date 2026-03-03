import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'move_detail_screen.dart';

class MovesScreen extends StatefulWidget {
  const MovesScreen({super.key});

  @override
  State<MovesScreen> createState() => _MovesScreenState();
}

class _MovesScreenState extends State<MovesScreen> {
  final _provider = PokedexProvider();
  List<ApiResult>? _moves;
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
      final data = await _provider.getMovesList(limit: 50, offset: _offset);
      setState(() {
        _moves = data.results;
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
    if (_loading && _moves == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _moves == null) {
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
      itemCount: _moves!.length + 1,
      itemBuilder: (context, index) {
        if (index == _moves!.length) {
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
        final move = _moves![index];
        final id = int.tryParse(move.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(_capitalize(move.name)),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MoveDetailScreen(moveId: id),
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
