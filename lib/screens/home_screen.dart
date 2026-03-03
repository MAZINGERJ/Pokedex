import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import 'abilities_screen.dart';
import 'berries_screen.dart';
import 'generations_screen.dart';
import 'items_screen.dart';
import 'locations_screen.dart';
import 'moves_screen.dart';
import 'pokemon_list_screen.dart';
import 'profile_screen.dart';
import 'regions_screen.dart';
import 'types_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem('Pokémon', Icons.pest_control, PokemonListScreen()),
    _NavItem('Tipos', Icons.category, TypesScreen()),
    _NavItem('Habilidades', Icons.auto_awesome, AbilitiesScreen()),
    _NavItem('Movimientos', Icons.sports_martial_arts, MovesScreen()),
    _NavItem('Objetos', Icons.inventory_2, ItemsScreen()),
    _NavItem('Bayas', Icons.grass, BerriesScreen()),
    _NavItem('Ubicaciones', Icons.place, LocationsScreen()),
    _NavItem('Regiones', Icons.public, RegionsScreen()),
    _NavItem('Generaciones', Icons.generating_tokens, GenerationsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_navItems[_selectedIndex].title),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Consumer<ProfileProvider>(
              builder: (context, profile, _) {
                return DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              child: profile.hasPhoto && profile.photoPath != null
                                  ? ClipOval(
                                      child: Image.file(
                                        File(profile.photoPath!),
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.person, color: Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.person, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.userName.isNotEmpty
                                        ? profile.userName
                                        : 'Entrenador',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    'Toca para editar perfil',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pokédex',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'PokeAPI completa',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ...List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              return ListTile(
                leading: Icon(item.icon),
                title: Text(item.title),
                selected: _selectedIndex == index,
                onTap: () {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        child: _navItems[_selectedIndex].screen,
      ),
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final Widget screen;

  const _NavItem(this.title, this.icon, this.screen);
}
