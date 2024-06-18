import 'package:flutter/material.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/user/dialogs/users/delete_user_dialog.dart';
import 'package:front/website/pages/backoffice/user/dialogs/users/edit_user_dialog.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

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
              Icon(Icons.person, color: Colors.blue[800]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${user.firstname} ${user.lastname}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(user.email),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue[800]),
                onPressed: () {
                  showEditUserDialog(context, user);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red[800]),
                onPressed: () {
                  showDeleteUserDialog(context, user);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
