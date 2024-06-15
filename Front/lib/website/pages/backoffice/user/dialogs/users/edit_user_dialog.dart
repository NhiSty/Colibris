import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_state.dart';
import 'package:front/website/share/custom_dialog.dart';

void showEditUserDialog(BuildContext context, User user) {
  TextEditingController firstNameController =
      TextEditingController(text: user.firstname);
  TextEditingController lastNameController =
      TextEditingController(text: user.lastname);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('User updated successfully'),
              ));
              Navigator.pop(context);
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to update user: ${state.message}'),
              ));
            }
          },
          child: CustomDialog(
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
                  if (firstNameController.text.isNotEmpty &&
                      lastNameController.text.isNotEmpty) {
                    context.read<UserBloc>().add(EditUser(
                          id: user.id.toString(),
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill all fields'),
                    ));
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
