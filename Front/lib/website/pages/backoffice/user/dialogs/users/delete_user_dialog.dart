import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_state.dart';
import 'package:front/website/share/custom_dialog.dart';

void showDeleteUserDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('User deleted successfully'),
              ));
              Navigator.pop(context);
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to delete user: ${state.message}'),
              ));
            }
          },
          child: CustomDialog(
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
                  context
                      .read<UserBloc>()
                      .add(DeleteUser(id: user.id.toString()));
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
