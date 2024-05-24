import 'package:flutter/material.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/share/custom_dialog.dart';

void showEditUserDialog(
    BuildContext context, User user, VoidCallback onUpdate) {
  TextEditingController firstNameController =
      TextEditingController(text: user.firstname);
  TextEditingController lastNameController =
      TextEditingController(text: user.lastname);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Edit User',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'Firstname'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Lastname'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              UserService().updateUser(user.id, {
                'firstname': firstNameController.text,
                'lastname': lastNameController.text,
              }).then((value) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('User updated successfully'),
                ));
                Navigator.pop(context);
                onUpdate();
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to update user'),
                ));
              });
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
