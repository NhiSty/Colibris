import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_state.dart';
import 'package:front/website/share/custom_dialog.dart';

void showAddUserDialog(BuildContext context) {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<UserBloc>(context),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_users_user_added_successfully'.tr()),
                ),
              ));
              Navigator.pop(context);
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_users_user_added_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_users_add_user'.tr(),
            height: 200.0,
            width: 250.0,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'firstname'.tr()),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'lastname'.tr()),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'email'.tr()),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'password'.tr()),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  if (firstNameController.text.isNotEmpty &&
                      lastNameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    context.read<UserBloc>().add(AddUser(
                          email: emailController.text,
                          password: passwordController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('fill_all_fields'.tr()),
                      ),
                    ));
                  }
                },
                child: Text('add'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
