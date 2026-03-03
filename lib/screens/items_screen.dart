import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import 'item_detail_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _provider = PokedexProvider();
  List<ApiResult>? _items;
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
      final data = await _provider.getItemsList(limit: 50, offset: _offset);
      setState(() {
        _items = data.results;
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
    if (_loading && _items == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _items == null) {
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
      itemCount: _items!.length + 1,
      itemBuilder: (context, index) {
        if (index == _items!.length) {
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
        final item = _items![index];
        final id = int.tryParse(item.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
        final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/${item.name}.png';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorWidget: (_, __, ___) => const Icon(Icons.inventory_2),
            ),
            title: Text(_capitalize(item.name)),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ItemDetailScreen(itemId: id),
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
