import 'package:flutter/material.dart';
import 'package:invfox_mtravelorder/screens/home_navigator.dart';
import 'package:invfox_mtravelorder/screens/home_screen.dart';
import 'package:invfox_mtravelorder/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 184, 230)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPageIndex,
        children: _pages,
      ),
      bottomNavigationBar: (currentPageIndex == 0 || currentPageIndex == 1)
          ? NavigationBar(
              backgroundColor: Colors.grey[200],
              selectedIndex: currentPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.edit_document),
                  label: 'Potni nalogi',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.account_circle),
                  icon: Icon(Icons.account_circle),
                  label: 'Nastavitve',
                ),
              ],
            )
          : null,
    );
  }
}
