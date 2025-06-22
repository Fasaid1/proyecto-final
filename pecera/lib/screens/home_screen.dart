import 'package:flutter/material.dart';
import 'homeContent_screem.dart';
import 'reportes_screen.dart';
import 'comida_screem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [
    const ReportesScreen(),
    const HomeContent(),
    const ComidaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC9F0FF),
      appBar: AppBar(
        title: const Text(
          'Gestión de Peceras',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF009788),
        elevation: 0,
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF009788),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(size: 32, color: Colors.white);
              }
              return const IconThemeData(size: 30, color: Colors.white70);
            }),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.white.withOpacity(0.3),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.description),
                selectedIcon: Icon(Icons.description),
                label: 'Reportes',
              ),
              NavigationDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.food_bank),
                selectedIcon: Icon(Icons.food_bank),
                label: 'Comidas',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
