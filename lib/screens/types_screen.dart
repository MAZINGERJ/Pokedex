import 'package:flutter/material.dart';

import '../models/api_models.dart';
import '../providers/pokedex_provider.dart';
import '../utils/type_colors.dart';
import 'pokemon_list_by_type_screen.dart';

class TypesScreen extends StatefulWidget {
  const TypesScreen({super.key});

  @override
  State<TypesScreen> createState() => _TypesScreenState();
}

class _TypesScreenState extends State<TypesScreen> {
  final _provider = PokedexProvider();
  List<ApiResult>? _types;
  bool _loading = true;
  String? _error;

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
      final data = await _provider.getTypesList();
      setState(() {
        _types = data.results.where((t) => t.name != 'unknown' && t.name != 'shadow').toList();
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
    if (_loading && _types == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _types == null) {
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

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _types!.length,
      itemBuilder: (context, index) {
        final type = _types![index];
        final id = int.tryParse(type.url.split('/').where((s) => s.isNotEmpty).last) ?? 0;
        final color = TypeColors.getColor(type.name);
        return Card(
          elevation: 2,
          color: color,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PokemonListByTypeScreen(typeId: id, typeName: type.name),
              ),
            ),
            child: Center(
              child: Text(
                _capitalize(type.name),
                style: TextStyle(
                  color: TypeColors.getContrastColor(type.name),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
