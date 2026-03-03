import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Pokédex',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            darkTheme: themeProvider.darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
