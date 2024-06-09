import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    // Define routes and their corresponding icons
    final Map<String, List<BottomNavigationBarItem>> routeIcons = {
      '/home': [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.logout_rounded),
          label: 'Logout',
        ),
      ],
      '/profile': [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.logout_rounded),
          label: 'Logout',
        ),
      ],
      '/colocation/task-list': [
        const BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: 'Task List',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.logout_rounded),
          label: 'Logout',
        ),
      ],
    };

    // Default set of routes to display in the BottomNavigationBar
    final List<BottomNavigationBarItem> defaultIcons = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.logout_rounded),
        label: 'Logout',
      ),
    ];

    // Define routes in the order they should appear in the BottomNavigationBar
    final Map<String, List<String>> routeOrder = {
      '/home': ['/home', '/profile', '/login'],
      '/colocation/task-list': [
        '/colocation/task-list',
        '/home',
        '/chat',
        '/profile',
        '/login'
      ],
      '/profile': ['/home', '/profile', '/login'],
    };

    // Get icons and routes for the current route
    final icons = routeIcons[currentRoute] ?? defaultIcons;
    final routes = routeOrder[currentRoute] ?? ['/home', '/profile', '/login'];

    // Find the current index
    int currentIndex = routes.indexOf(currentRoute);
    if (currentIndex == -1) {
      currentIndex = 0; // Default to the first item if current route not found
    }

    return BottomNavigationBar(
      items: icons,
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.7),
      backgroundColor: Colors.green,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index >= 0 && index < routes.length) {
          final newRoute = routes[index];
          if (newRoute.isNotEmpty && newRoute != currentRoute) {
            Navigator.pushReplacementNamed(context, newRoute);
          }
        }
      },
    );
  }
}
