import 'package:flutter/material.dart';
import 'package:front/user/user.dart';
import 'package:front/user/user_service.dart';
import 'package:front/website/share/custom_dialog.dart';

void showDeleteUserDialog(
    BuildContext context, User user, VoidCallback onUpdate) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Delete User',
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteUser(user.id).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('User deleted successfully'),
                ));
                Navigator.pop(context);
                onUpdate();
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to delete user'),
                ));
              });
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
