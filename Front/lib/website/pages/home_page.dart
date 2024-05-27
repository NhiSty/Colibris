import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'BackOffice d\'administration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth <= 600) {
                    return _buildGridView(context, 2);
                  } else if (constraints.maxWidth <= 900) {
                    return _buildGridView(context, 3);
                  } else {
                    return _buildGridView(context, 5);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, int crossAxisCount) {
    return Center(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          _buildCard(context, 'User', '/backoffice/user',
              'Gérer vos utilisateurs', Icons.person),
          _buildCard(context, 'Colocation', '/colocation_administration',
              'Gérer vos colocations', Icons.home),
          _buildCard(context, 'ColocMember', '/coloc_member_administration',
              'Gérer les membres des colocations', Icons.group),
          _buildCard(context, 'Service', '/service_administration',
              'Gérer les services des colocations', Icons.build),
          _buildCard(
              context,
              'AchievedService',
              '/achieved_service_administration',
              'Gérer les services réalisés des colocations',
              Icons.check),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String routeName,
      String description, IconData iconData) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
