import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    List<Widget> iconsForRoute(String route) {
      List<Widget> icons = [];

      if (route == '/home') {
        icons.add(
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              if (currentRoute != '/home') {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
        );
        icons.add(
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              // Add navigation or logic here
            },
          ),
        );
      } else if (route == '/colocation/task-list') {
        icons.add(
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              if (currentRoute != '/home') {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
        );
        icons.add(
          IconButton(
            icon: const Icon(Icons.chat),
            color: Colors.white,
            onPressed: () {
              // Add navigation or logic here
            },
          ),
        );
        icons.add(
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              // Add navigation or logic here
            },
          ),
        );
      }

      return icons;
    }

    final List<Widget> icons = iconsForRoute(currentRoute);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: icons,
      ),
    );
  }
}
