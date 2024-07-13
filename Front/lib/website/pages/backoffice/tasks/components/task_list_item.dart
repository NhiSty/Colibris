import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/services/colocation_service.dart';
import 'package:front/task/task.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/dialogs/delete_task_dialog.dart';
import '../dialogs/edit_task_dialog.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({super.key, required this.task});

  Future<Map<String, dynamic>> fetchOwnerData(int userId) async {
    UserService userService = UserService();
    return await userService.getUserById(userId);
  }

  @override
  Widget build(BuildContext buildContext) {
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
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.task, color: Colors.blue[800], size: 32,),
                      const SizedBox(width: 12),
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
                                      '${'backoffice_task_colocation_id'.tr()}: ${task.colocationId ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 14,
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
                  )
              ),
              const SizedBox(width: 64),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: cardWidth * 0.4,
                      child: Text(
                        task.description.isNotEmpty == true
                            ? '${'description'.tr()}: ${task.description}'
                            : 'backoffice_task_no_description'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,

                      ),
                    ),
                    Text(
                      '${'backoffice_task_date'.tr()}: ${task.date}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${'backoffice_task_points'.tr()}: ${task.pts}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${'backoffice_task_duration'.tr()}: ${task.duration} min',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue[800]),
                        onPressed: () {
                          showEditTaskDialog(
                            context: buildContext,
                            task: task,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red[800]),
                        onPressed: () {
                          showDeleteTaskDialog(
                              context: context,
                              taskId: task.id
                          );
                        },
                      ),
                    ],
                  )
              )
            ],
          ),
        );
      },
    );
  }
}
