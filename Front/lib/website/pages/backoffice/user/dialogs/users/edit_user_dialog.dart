import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:front/website/pages/backoffice/user/bloc/user_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showEditUserDialog(BuildContext context, User user) {
  TextEditingController firstNameController =
      TextEditingController(text: user.firstname);
  TextEditingController lastNameController =
      TextEditingController(text: user.lastname);

  String selectedRole = user.roles;

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
                  child:
                      Text('backoffice_users_user_updated_successfully'.tr()),
                ),
              ));
              context.pop();
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_users_user_updated_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_users_update_user'.tr(),
            height: 200.0,
            width: 300.0,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'firstname'.tr()),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'lastname'.tr()),
                  ),
                  SizedBox(height: 16),
                  Text('select_role'.tr()),
                  ToggleButtons(
                    isSelected: [
                      selectedRole == 'ROLE_USER',
                      selectedRole == 'ROLE_ADMIN'
                    ],
                    onPressed: (index) {
                      String newRole = index == 0 ? 'ROLE_USER' : 'ROLE_ADMIN';
                      context.read<UserBloc>().add(UpdateUserRole(
                            id: user.id.toString(),
                            roles: newRole,
                          ));
                      selectedRole = newRole; // Update the local selectedRole
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('ROLE_USER'.tr()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('ROLE_ADMIN'.tr()),
                      ),
                    ],
                    fillColor: Colors.blue.withOpacity(0.2),
                    selectedColor: Colors.white,
                    borderWidth: 1,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text('cancel'.tr()),
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
                child: Text('save'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
