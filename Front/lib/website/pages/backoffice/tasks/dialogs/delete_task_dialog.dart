import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showDeleteTaskDialog({
  required BuildContext context,
  required int taskId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final colocMemberProvider = BlocProvider.of<ColocMemberBloc>(context);
      return BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      'backoffice_task_task_deleted_successfully'.tr()),
                ),
              ));
              context.pop();
            } else if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_task_task_deleted_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_task_task_delete'.tr(),
            height: 50.0,
            width: 150.0,
            content: Text('backoffice_task_task_deleted_confirm'.tr()),
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
                      .read<TaskBloc>()
                      .add(DeleteTask(id: taskId));
                  colocMemberProvider.add(LoadColocMembers());
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
