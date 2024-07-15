import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showDeleteVoteDialog({
  required BuildContext context,
  required int voteId,
  required int taskId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<VoteBloc>(context),
        child: BlocListener<VoteBloc, VoteState>(
          listener: (context, state) {
            if (state is VoteDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      'backoffice_vote_vote_deleted_successfully'.tr()),
                ),
              ));
              context.pop();
            } else if (state is VoteError) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('backoffice_vote_vote_deleted_error'.tr()),
                ),
              ));
            }
          },
          child: CustomDialog(
            title: 'backoffice_vote_vote_delete'.tr(),
            height: 50.0,
            width: 150.0,
            content: Text('backoffice_vote_vote_deleted_confirm'.tr()),
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
                      .read<VoteBloc>()
                      .add(DeleteVote(voteId: voteId));
                },
                child: Text('delete'.tr()),
              ),
            ],
          ),
        ),
      );
    },
  ).then((_) {
    context.read<VoteBloc>().add(LoadVotes(taskId: taskId));
  });
}
