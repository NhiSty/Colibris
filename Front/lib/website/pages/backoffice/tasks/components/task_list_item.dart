import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/task/task.dart';
import 'package:front/services/user_service.dart';
//import 'package:front/website/pages/backoffice/tasks/dialogs/tasks/delete_task_dialog.dart';
//import 'package:front/website/pages/backoffice/tasks/dialogs/tasks/edit_task_dialog.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  Future<Map<String, dynamic>> fetchOwnerData(int userId) async {
    UserService userService = UserService();
    return await userService.getUserById(userId);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.8;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Icon(Icons.home, color: Colors.blue[800]),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchOwnerData(task.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text(
                                'backoffice_task_error_loading_owner_info'
                                    .tr());
                          } else {
                            final owner = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${'backoffice_task_owned_by'.tr()} ${owner['Firstname']} - ${owner['Lastname']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${owner['Email']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      task.description.isNotEmpty == true
                          ? task.description
                          : 'backoffice_task_no_description'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.message, color: Colors.green[800]),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/backoffice/tasks/${task.id}/messages',
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue[800]),
                onPressed: () {
                  //showEditTaskDialog(context, task);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[800]),
                onPressed: () {
                  //showDeleteTaskDialog(context, task);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
