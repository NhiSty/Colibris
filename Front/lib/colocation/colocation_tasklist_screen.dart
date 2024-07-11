import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/main.dart';
import 'package:front/shared.widget/bottom_navigation_bar.dart';
import 'package:front/task/bloc/task_bloc.dart';
import 'package:front/task/task_list_item.dart';
import 'package:front/task/task_service.dart';
import 'package:front/vote/bloc/vote_bloc.dart';
import 'package:front/website/share/secure_storage.dart';

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
    context.read<VoteBloc>().add(FetchUserVote(widget.colocation.userId));

    return SafeArea(
      child: GradientBackground(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              bottom: TabBar(
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                widget.colocation.name,
                style: const TextStyle(color: Colors.white),
              ),
              actions: widget.colocation.userId == userData['user_id']
                  ? [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/colocation_manage',
                          arguments: {'colocationId': widget.colocation.id});
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
                _buildTaskTab(context, true),
                _buildTaskTab(context, false),
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
              backgroundColor: Colors.blueGrey,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTab(BuildContext context, bool allTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          'task_done_tasks'.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
                  child: Text(state.message, style: const TextStyle(color: Colors.white)),
                );
              } else if (state is TaskLoaded) {
                final tasks = allTasks ? state.tasks.reversed.toList() : state.tasks.where((task) => task.userId == userData['user_id']).toList();
                if (tasks.isEmpty) {
                  return _buildEmptyState(context);
                } else {
                  return RefreshIndicator(
                    displacement: 50,
                    onRefresh: () async {
                      context.read<TaskBloc>().add(FetchTasks(widget.colocation.id));
                      context.read<VoteBloc>().add(FetchUserVote(widget.colocation.userId));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final item = tasks[index];
                        return GestureDetector(
                          child: TaskListItem(
                            item: item,
                            onViewPressed: () {
                              Navigator.pushNamed(context, '/task_detail', arguments: {'task': item});
                            },
                            onEditPressed: item.userId == userData['user_id'] || widget.colocation.userId == userData['user_id']
                                ? () async {
                              final result = await Navigator.pushNamed(context, '/update-task',
                                  arguments: {
                                    'colocation': widget.colocation,
                                    'task': item,
                                  });
                              if (result == true) {
                                context.read<TaskBloc>().add(FetchTasks(widget.colocation.id));
                              }
                            }
                                : null,
                            onLikePressed: item.userId != userData['user_id']
                                ? () {
                              // on laisse vide pcq géré direct dans task_list_item
                            }
                                : null,
                            onDeletePressed: item.userId == userData['user_id'] || widget.colocation.userId == userData['user_id']
                                ? () async {
                              await deleteTask(item.id);
                              context.read<TaskBloc>().add(FetchTasks(widget.colocation.id));
                            }
                                : null,
                          ),
                        );
                      },
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text('task_unknown_error'.tr(), style: const TextStyle(color: Colors.white)),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox,
            size: 80,
            color: Colors.white70,
          ),
          const SizedBox(height: 20),
          Text(
            'task_no_task'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add-new-task', arguments: {'colocation': widget.colocation});
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'task_create_title'.tr(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
