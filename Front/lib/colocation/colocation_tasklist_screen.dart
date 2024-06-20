import 'package:easy_localization/easy_localization.dart';
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
                bottom:  TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.done_all),
                      child: Text('task_all_tasks'.tr()),
                    ),
                    Tab(
                      icon: const Icon(Icons.how_to_reg),
                      child: Text('task_my_tasks'.tr()),
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
                       Text(
                        'task_done_tasks'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                              final tasks = state.tasks.reversed.toList();
                              if (tasks.isEmpty) {
                                return  Center(
                                  child: Text(
                                    'task_no_task'.tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 80),
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
                                        onEditPressed: item.userId == userData['user_id'] ||
                                            widget.colocation.userId ==
                                                userData['user_id']
                                                  ? () async {
                                          final result = await Navigator.pushNamed(context, '/update-task',
                                              arguments: {
                                                'colocation': widget.colocation,
                                                'task': item,
                                              });
                                          if (result == true) {
                                            context.read<TaskBloc>().add(
                                                FetchTasks(widget.colocation.id));
                                          }
                                        } : null,
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
                              return  Center(
                                child: Text('task_unknown_error'.tr()),
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
                       Text(
                        'task_done_tasks'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                                return  Center(
                                  child: Text(
                                    'task_no_task'.tr(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 80),
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
                                          onEditPressed: item.userId == userData['user_id'] ||
                                              widget.colocation.userId ==
                                                  userData['user_id']
                                              ? () {
                                            Navigator.pushNamed(context, '/update-task',
                                                arguments: {
                                                  'colocation': widget.colocation,
                                                  'task': item,
                                                });
                                          } : null,
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
                              return Center(
                                child: Text('task_unknown_error'.tr()),
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
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, '/add-new-task',
                      arguments: {'colocation': widget.colocation});

                  if (result == true) {
                    context.read<TaskBloc>().add(FetchTasks(widget.colocation.id));
                  }
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
  final VoidCallback? onEditPressed;
  final VoidCallback onLikePressed;
  final VoidCallback? onDeletePressed;

  const TaskListItem({
    super.key,
    required this.item,
    required this.onViewPressed,
    this.onEditPressed,
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
                  children:  [
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: onViewPressed,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.remove_red_eye_outlined),
                                const SizedBox(width: 10),
                                Text('task_action_details'.tr()),
                              ],
                            )
                        ),
                        if (onEditPressed != null)
                          PopupMenuItem(
                              onTap: onEditPressed,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.edit_outlined),
                                  const SizedBox(width: 10),
                                  Text('task_action_edit'.tr()),
                                ],
                              )
                          ),
                        PopupMenuItem(
                            onTap: onLikePressed,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.thumb_up_outlined),
                                const SizedBox(width: 10),
                                Text('task_action_like'.tr()),
                              ],
                            )
                        ),
                        if (onDeletePressed != null)
                          PopupMenuItem(
                              onTap: onDeletePressed,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.delete_outlined),
                                  const SizedBox(width: 10),
                                  Text('task_action_delete'.tr()),
                                ],
                              )
                          ),
                      ],
                    )
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
