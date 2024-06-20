import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'backoffice_title'.tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                right: 16.0,
                top: 16.0,
                child: Row(
                  children: [
                    const Text('🇺🇸', style: TextStyle(fontSize: 32)),
                    Switch(
                      value: context.locale == const Locale('fr'),
                      onChanged: (value) {
                        setState(() {
                          context.setLocale(
                              value ? const Locale('fr') : const Locale('en'));
                        });
                      },
                    ),
                    const Text(
                      '🇫🇷',
                      style: TextStyle(fontSize: 32),
                    )
                  ],
                ),
              ),
            ],
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
          _buildCard(
              context,
              'backoffice_homepage_users'.tr(),
              '/backoffice/user',
              'backoffice_homepage_users_description'.tr(),
              Icons.person),
          _buildCard(
              context,
              'backoffice_homepage_logs'.tr(),
              '/backoffice/logs',
              'backoffice_homepage_logs_description'.tr(),
              Icons.note_alt),
          _buildCard(
              context,
              'backoffice_homepage_colocations'.tr(),
              '/colocation_administration',
              'backoffice_homepage_colocations_description'.tr(),
              Icons.home),
          _buildCard(
              context,
              'backoffice_homepage_coloc_members'.tr(),
              '/coloc_member_administration',
              'backoffice_homepage_coloc_members_description'.tr(),
              Icons.group),
          _buildCard(context, 'backoffice_homepage_messages'.tr(), '/messages',
              'backoffice_homepage_messages_description'.tr(), Icons.build),
          _buildCard(context, 'backoffice_homepage_tasks'.tr(), '/tasks',
              'backoffice_homepage_tasks_description'.tr(), Icons.check),
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
