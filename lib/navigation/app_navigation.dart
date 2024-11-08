
// lib/presentation/navigation/app_navigation.dart
import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/todo/todo_screen.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentPageIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    TodoScreen(),
    ActivityScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.task),
            icon: Icon(Icons.task_outlined),
            label: 'Todo',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_activity),
            icon: Icon(Icons.local_activity_outlined),
            label: 'Activity',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
