import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/task/task.dart';
import 'package:front/website/pages/backoffice/tasks/components/task_list_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (tasks.isEmpty) {
      return Center(child: Text('backoffice_task_no_task'.tr()));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      itemCount: tasks.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final task = tasks[index];
        return Center(
          child: TaskListItem(
            task: task,
          ),
        );
      },
    );
  }
}
