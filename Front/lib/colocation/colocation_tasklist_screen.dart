import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/services/user_service.dart';
import 'package:front/shared.widget/bottom_navigation_bar.dart';

class ColocationTasklistScreen extends StatefulWidget {
  final Colocation colocation;
  final int userId;
  const ColocationTasklistScreen(
      {super.key, required this.colocation, required this.userId});

  static const routeName = '/colocation/task-list';

  @override
  State<ColocationTasklistScreen> createState() =>
      _ColocationTasklistScreenState();
}

class _ColocationTasklistScreenState extends State<ColocationTasklistScreen> {
  var userData = decodeToken();
  @override
  void initState() {
    print(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            tabs: [
              Tab(
                icon: Icon(Icons.done_all),
                child: Text('Toutes les tâches'),
              ),
              Tab(
                icon: Icon(Icons.how_to_reg),
                child: Text('Mes tâches'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          title: Text(
            'Colocation name . ${widget.colocation.name}',
            style: const TextStyle(color: Colors.white),
          ),
          actions: widget.colocation.userId == widget.userId
              ? [
                  IconButton(
                      onPressed:
                          () {}, // todo rediriger sur le screen pour les settings de la colocation
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ))
                ]
              : null,
        ),
        body: TabBarView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Tâches effecutées',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(right: 0, left: 16),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                    child: Text('Tâche',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        onPressed:
                                            () {}, // todo rediriger sur le détails d'une tâches
                                        icon: const Icon(Icons.more_vert)),
                                  ),
                                )
                              ],
                            ),
                            subtitle: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Par: Hamidou'),
                                Text('Le: 12/01/2024'),
                                Text('Pour: 120pts')
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Mes tâches effecutées',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(right: 0, left: 16),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                    child: Text('Tâche',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        onPressed:
                                            () {}, // todo rediriger sur le détails d'une tâches
                                        icon: const Icon(Icons.more_vert)),
                                  ),
                                )
                              ],
                            ),
                            subtitle: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Le: 12/01/2024'),
                                Text('Pour: 120pts')
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
        bottomNavigationBar: const BottomNavigationBarWidget(),
      ),
    ));
  }
}
