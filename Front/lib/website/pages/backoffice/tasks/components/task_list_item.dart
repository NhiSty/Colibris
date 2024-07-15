import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/task/task.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/tasks/dialogs/delete_task_dialog.dart';
import 'package:front/website/pages/backoffice/vote_handle_page.dart';
import 'package:go_router/go_router.dart';
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
        final screenSize = MediaQuery.of(context).size;

        if (screenSize.width < 768) {
          cardWidth = screenSize.width * 0.9;

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.task, color: Colors.blue[800], size: 32,),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
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
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('backoffice_task_error_loading_owner_info'.tr());
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
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only( left: 46.0 ),
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
                const SizedBox(height: 16),
                Row(
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
                ),
              ],
            ),
          );
        } else {
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
                Row(
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('backoffice_task_error_loading_owner_info'.tr());
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
                ),
                Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumbs_up_down, color: Colors.orange),
                      onPressed: () {
                        buildContext.push(
                          VoteHandlePage.routeName,
                          extra: {
                            'taskId': task.id,
                          },
                        );
                      },
                    ),
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
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
