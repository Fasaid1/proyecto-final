import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PecerasApp());
}

class PecerasApp extends StatelessWidget {
  const PecerasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gestión de Peceras',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
