import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTabTapped,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Início'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Pesquisa'),
        NavigationDestination(icon: Icon(Icons.login), label: 'Login'),
      ],
    );
  }
}

class AdminNavBar extends StatelessWidget {
   final int currentIndex;
  final ValueChanged<int> onTabTapped;

  const AdminNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTabTapped,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Início'),
        NavigationDestination(icon: Icon(Icons.login), label: 'Sair'),
      ],
    );
  }
}
