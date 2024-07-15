import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/services/user_service.dart';
import 'package:colibris/website/pages/backoffice/user/bloc/user_bloc.dart';
import 'package:colibris/website/pages/backoffice/user/bloc/user_state.dart';
import 'package:colibris/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showDeleteUserDialog(BuildContext context, User user) {
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
                      Text('backoffice_users_user_deleted_successfully'.tr()),
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
                  child: Text('backoffice_users_user_deleted_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_users_user_delete'.tr(),
            height: 50.0,
            width: 150.0,
            content: Text('backoffice_users_user_deleted_confirm'.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text('cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<UserBloc>()
                      .add(DeleteUser(id: user.id.toString()));
                },
                child: Text('delete'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  );
}
