import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Apariencia',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              _buildThemeTile(
                context,
                themeProvider,
                AppThemeMode.light,
                'Claro',
                'Tema claro con colores Pokémon',
                Icons.light_mode,
              ),
              _buildThemeTile(
                context,
                themeProvider,
                AppThemeMode.dark,
                'Oscuro',
                'Tema oscuro para uso nocturno',
                Icons.dark_mode,
              ),
              _buildThemeTile(
                context,
                themeProvider,
                AppThemeMode.contrast,
                'Alto contraste',
                'Mayor legibilidad',
                Icons.contrast,
              ),
              _buildThemeTile(
                context,
                themeProvider,
                AppThemeMode.amoled,
                'AMOLED',
                'Negro puro para pantallas OLED',
                Icons.brightness_2,
              ),
              const Divider(height: 32),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Acerca de',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Versión'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.api),
                title: const Text('Datos'),
                subtitle: const Text('PokeAPI v2'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    ThemeProvider themeProvider,
    AppThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = themeProvider.themeMode == mode;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () => themeProvider.setTheme(mode),
    );
  }
}
