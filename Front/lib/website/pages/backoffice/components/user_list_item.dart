import 'package:flutter/material.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/dialogs/delete_user_dialog.dart';
import 'package:front/website/pages/backoffice/dialogs/edit_user_dialog.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onUpdate;

  const UserListItem({super.key, required this.user, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.person),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.firstname} - ${user.lastname}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user.email),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showEditUserDialog(context, user, onUpdate);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDeleteUserDialog(context, user, onUpdate);
            },
          ),
        ],
      ),
    );
  }
}
