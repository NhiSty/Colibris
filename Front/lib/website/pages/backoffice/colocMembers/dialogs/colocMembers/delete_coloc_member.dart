import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_state.dart';
import 'package:front/website/share/custom_dialog.dart';

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
              Navigator.pop(context);
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
                  Navigator.pop(context);
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
