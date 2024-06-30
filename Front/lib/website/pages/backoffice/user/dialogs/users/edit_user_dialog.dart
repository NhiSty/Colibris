import 'package:easy_localization/easy_localization.dart';
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
              Navigator.pop(context);
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
            height: 100.0,
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
