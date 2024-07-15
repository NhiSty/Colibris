import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colibris/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:colibris/website/pages/backoffice/colocMembers/bloc/colocMember_state.dart';
import 'package:colibris/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showDeleteColocMemberDialog(BuildContext context, int colocMemberId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<ColocMemberBloc>(context),
        child: BlocListener<ColocMemberBloc, ColocMemberState>(
          listener: (context, state) {
            if (state is ColocMemberLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      'backoffice_colocMember_user_deleted_successfully'.tr()),
                ),
              ));
              context.pop();
            } else if (state is ColocMemberError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_colocMember_user_deleted_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_colocMember_user_delete'.tr(),
            height: 50.0,
            width: 150.0,
            content: Text('backoffice_colocMember_user_deleted_confirm'.tr()),
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
                      .read<ColocMemberBloc>()
                      .add(DeleteColocMember(colocMemberId: colocMemberId));
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
