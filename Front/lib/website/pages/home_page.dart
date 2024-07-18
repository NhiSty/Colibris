import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/website/pages/auth/login_page.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = "/home";

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
          LayoutBuilder(
            builder: (context, constraints) {
              double fontSize = constraints.maxWidth > 600 ? 20 : 12;
              double buttonSize = constraints.maxWidth > 600 ? 40 : 16;

              return Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      iconSize: buttonSize,
                      onPressed: () async {
                        await deleteToken();
                        context.go(
                          LoginPage.routeName,
                        );
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'backoffice_title'.tr(),
                          style: TextStyle(
                            fontSize: fontSize + 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text('🇺🇸', style: TextStyle(fontSize: buttonSize)),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: context.locale == const Locale('fr'),
                            onChanged: (value) {
                              setState(() {
                                context.setLocale(value
                                    ? const Locale('fr')
                                    : const Locale('en'));
                              });
                            },
                          ),
                        ),
                        Text(
                          '🇫🇷',
                          style: TextStyle(fontSize: buttonSize),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double fontSize = constraints.maxWidth > 600 ? 20 : 16;
                  double buttonSize = constraints.maxWidth > 600 ? 40 : 32;

                  if (constraints.maxWidth <= 600) {
                    return _buildGridView(context, 2, fontSize, buttonSize);
                  } else if (constraints.maxWidth <= 900) {
                    return _buildGridView(context, 3, fontSize, buttonSize);
                  } else {
                    return _buildGridView(context, 5, fontSize, buttonSize);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, int crossAxisCount,
      double fontSize, double buttonSize) {
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
              Icons.person,
              fontSize,
              buttonSize),
          _buildCard(
              context,
              'backoffice_homepage_logs'.tr(),
              '/backoffice/logs',
              'backoffice_homepage_logs_description'.tr(),
              Icons.note_alt,
              fontSize,
              buttonSize),
          _buildCard(
              context,
              'backoffice_homepage_colocations'.tr(),
              '/backoffice/colocations',
              'backoffice_homepage_colocations_description'.tr(),
              Icons.home,
              fontSize,
              buttonSize),
          _buildCard(
              context,
              'backoffice_homepage_coloc_members'.tr(),
              '/backoffice/coloc-members',
              'backoffice_homepage_coloc_members_description'.tr(),
              Icons.group,
              fontSize,
              buttonSize),_buildCard(
              context,
              'backoffice_homepage_tasks'.tr(),
              '/backoffice/tasks',
              'backoffice_homepage_tasks_description'.tr(),
              Icons.check,
              fontSize,
              buttonSize),
          _buildCard(
              context,
              'backoffice_homepage_flipping'.tr(),
              '/feature-flipping',
              'backoffice_homepage_flipping_description'.tr(),
              Icons.flag,
              fontSize,
              buttonSize),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      String routeName,
      String description,
      IconData iconData,
      double fontSize,
      double buttonSize) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.push(routeName);
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
                size: buttonSize,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: fontSize, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  description,
                  style: TextStyle(fontSize: fontSize - 5, color: Colors.white),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
