import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
  // runApp rendert das erste Widget (hier: MyApp) als Wurzel der App.
  runApp(const MyApp());
}

// MyApp ist das Root-Widget. StatelessWidget reicht hier, weil wir in dieser Klasse keinen Zustand verwalten.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Seed-Farbe für das globale Theme (pink).
  static const _seedPink = Color(0xFFF48FB1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App-Titel (z.B. für Task Switcher / System-Infos)
      title: 'Einkaufsliste',

      // Debug-Banner oben rechts entfernen (wirkt professioneller im Video)
      debugShowCheckedModeBanner: false,

      // Globales Theme für die ganze App:
      // -> konsistente Farben, Buttons, AppBars, Input-Felder
      theme: ThemeData(
        useMaterial3: true,

        // Farbschema aus Seed-Farbe ableiten (helles Theme)
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedPink,
          brightness: Brightness.light,
        ),

        // AppBar: Titel immer mittig (einheitliche Überschriften)
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),

        // Input-Felder: standardmäßig Outline-Rahmen (sauber & einheitlich)
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),

        // FloatingActionButton: pink + weißes Icon (UI-Style)
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _seedPink,
          foregroundColor: Colors.white,
        ),
      ),

      // Startseite der App: Dort liegt der State (Liste, Favoriten, erledigt) -> StatefulWidget
      home: const HomeScreen(),
    );
  }
}
