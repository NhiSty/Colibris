import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget(this.chatId, {super.key});
  final int? chatId;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    final Map<String, List<BottomNavigationBarItem>> routeIcons = {
      '/home': [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'navbar_home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'navbar_profile'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.logout_rounded),
          label: 'navbar_logout'.tr(),
        ),
      ],
      '/profile': [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'navbar_home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'navbar_profile'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.logout_rounded),
          label: 'navbar_logout'.tr(),
        ),
      ],
      '/colocation/task-list': [
        BottomNavigationBarItem(
          icon: const Icon(Icons.task),
          label: 'navbar_task_list'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'navbar_home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat),
          label: 'navbar_chat'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: 'navbar_profile'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.logout_rounded),
          label: 'navbar_logout'.tr(),
        ),
      ],
    };

    final List<BottomNavigationBarItem> defaultIcons = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: 'navbar_home'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: 'navbar_profile'.tr(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.logout_rounded),
        label: 'navbar_logout'.tr(),
      ),
    ];

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

    final icons = routeIcons[currentRoute] ?? defaultIcons;
    final routes = routeOrder[currentRoute] ?? ['/home', '/profile', '/login'];

    int currentIndex = routes.indexOf(currentRoute);
    if (currentIndex == -1) {
      currentIndex = 0;
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
          print(chatId);
          if (newRoute.isNotEmpty && newRoute != currentRoute) {
            Navigator.pushReplacementNamed(context, newRoute, arguments: {
              'chatId': chatId,
            });
          }
        }
      },
    );
  }
}
