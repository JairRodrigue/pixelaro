import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:pixelaro/home_screen.dart';

void main() {
  runApp(const PixelaroApp());
}

class PixelaroApp extends StatelessWidget {
  const PixelaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixelaro Studio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
          primary: const Color(0xFF00E5FF),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}