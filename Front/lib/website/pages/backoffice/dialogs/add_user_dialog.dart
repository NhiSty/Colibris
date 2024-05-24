import 'package:flutter/material.dart';
import 'package:front/auth/auth_service.dart';
import 'package:front/website/share/custom_dialog.dart';

void showAddUserDialog(BuildContext context) {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        title: 'Add user',
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
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              register(
                emailController.text,
                passwordController.text,
                firstNameController.text,
                lastNameController.text,
              ).then((responseCode) {
                if (responseCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('User added successfully'),
                  ));
                  Navigator.pop(context);
                } else {
                  if (responseCode == 400) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Error : Verify your inputs'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Error while adding user : code error : $responseCode'),
                    ));
                  }
                }
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('Error while adding user : code error : $error'),
                ));
              });
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
