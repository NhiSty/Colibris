import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/colocation.dart';

import 'package:front/shared.widget/bottom_navigation_bar.dart';
import 'package:front/task/task_service.dart';
import 'package:front/website/share/secure_storage.dart';

import '../task/bloc/task_bloc.dart';

class ColocationTasklistScreen extends StatefulWidget {
  final Colocation colocation;

  const ColocationTasklistScreen({super.key, required this.colocation});

  static const routeName = '/colocation/task-list';

  @override
  State<ColocationTasklistScreen> createState() =>
      _ColocationTasklistScreenState();
}

class _ColocationTasklistScreenState extends State<ColocationTasklistScreen> {
  var userData = {};
  @override
  void initState() {
    fetchUserData() async {
      var user = await decodeToken();
      setState(() {
        userData = user;
      });
    }

    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(FetchTasks(widget.colocation.id));

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
              widget.colocation.name,
              style: const TextStyle(color: Colors.white),
            ),
            actions: widget.colocation.userId == userData['user_id']
                ? [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/colocation_manage',
                              arguments: {
                                'colocationId': widget.colocation.id
                              });
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
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
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        if (state is TaskLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else if (state is TaskLoaded) {
                          final tasks = state.tasks;
                          if (tasks.isEmpty) {
                            return const Center(
                              child: Text(
                                'Aucune tâche trouvée',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final item = tasks[index];
                                return GestureDetector(
                                  child: TaskListItem(
                                    item: item,
                                    onViewPressed: () {
                                      Navigator.pushNamed(
                                          context, '/task_detail',
                                          arguments: {'task': item});
                                    },
                                    onLikePressed: () {
                                      // Ajoutez ici l'action pour le deuxième bouton
                                    },
                                    onDeletePressed:
                                        item.userId == userData['user_id'] ||
                                                widget.colocation.userId ==
                                                    userData['user_id']
                                            ? () async {
                                                await deleteTask(item.id);
                                                context.read<TaskBloc>().add(
                                                    FetchTasks(
                                                        widget.colocation.id));
                                              }
                                            : null,
                                  ),
                                );
                              },
                            );
                          }
                        } else {
                          return const Center(
                            child: Text('Erreur inconnue'),
                          );
                        }
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
                    'Tâches effecutées',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        if (state is TaskLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else if (state is TaskLoaded) {
                          final tasks = state.tasks;
                          if (tasks.isEmpty) {
                            return const Center(
                              child: Text(
                                'Aucune tâche trouvée',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final item = tasks[index];
                                if (item.userId != userData['user_id']) {
                                  return const SizedBox.shrink();
                                }
                                return GestureDetector(
                                    child: TaskListItem(
                                  item: item,
                                  onViewPressed: () {
                                    Navigator.pushNamed(context, '/task_detail',
                                        arguments: {'task': item});
                                  },
                                  onLikePressed: () {
                                    // Ajoutez ici l'action pour le deuxième bouton
                                  },
                                  onDeletePressed: item.userId ==
                                              userData['user_id'] ||
                                          widget.colocation.userId ==
                                              userData['user_id']
                                      ? () async {
                                          await deleteTask(item.id);
                                          context.read<TaskBloc>().add(
                                              FetchTasks(widget.colocation.id));
                                        }
                                      : null,
                                ));
                              },
                            );
                          }
                        } else {
                          return const Center(
                            child: Text('Erreur inconnue'),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBarWidget(widget.colocation.id),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-new-task',
                  arguments: {'colocation': widget.colocation});
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
          )),
    ));
  }
}

class TaskListItem extends StatelessWidget {
  final item;
  final VoidCallback onViewPressed;
  final VoidCallback onLikePressed;
  final VoidCallback? onDeletePressed;

  const TaskListItem({
    super.key,
    required this.item,
    required this.onViewPressed,
    required this.onLikePressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 0, left: 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(item.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onViewPressed,
                      icon: const Icon(Icons.remove_red_eye_outlined),
                    ),
                    IconButton(
                      onPressed: onLikePressed,
                      icon: const Icon(Icons.thumb_up_outlined),
                    ),
                    onDeletePressed != null
                        ? IconButton(
                            onPressed: onDeletePressed ?? () {},
                            icon: const Icon(Icons.delete_outlined),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(item.date), Text("${item.pts} pts")],
        ),
      ),
    );
  }
}

class TaskItem {
  final String title;
  final String date;
  final double duration;

  TaskItem({required this.title, required this.date, required this.duration});
}
