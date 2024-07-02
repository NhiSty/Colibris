
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final item;
  final VoidCallback onViewPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDeletePressed;

  const TaskListItem({
    super.key,
    required this.item,
    required this.onViewPressed,
    this.onEditPressed,
    required this.onLikePressed,
    this.onDeletePressed,
  });

  void _showDialog(BuildContext context, VoidCallback onLikePressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Donne ton avis'),
          content: const Text('Es-tu satisfait de la tâche effectuée par l\'un de tes coloc ?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.thumb_up, color: Colors.green,),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.thumb_down, color: Colors.red,),
            )
          ],
        );
      },
    );
  }

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
                        if(onLikePressed != null)
                          PopupMenuItem(
                              onTap: () {
                                _showDialog(context, onLikePressed!);
                              },
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