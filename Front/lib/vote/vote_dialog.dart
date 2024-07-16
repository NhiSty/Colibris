import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/services/vote_service.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';
import 'package:front/vote/vote.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'bloc/vote_bloc.dart';

class VoteDialog extends StatefulWidget {
  final Vote? vote;
  final int taskId;
  const VoteDialog({super.key, this.vote, required this.taskId});

  @override
  State<VoteDialog> createState() => _VoteDialogState();
}

class _VoteDialogState extends State<VoteDialog> {
  var userData = {};
  String buttonIsLoading = '';

  VoteService voteService = VoteService();

  @override
  void initState() {
    fetchUserData() async {
      var user = await decodeToken();
      setState(() {
        userData = user;
      });
    }

    fetchUserData();
    super.initState();
  }

  Future<dynamic> _voteTask(int taskId, int? voteId, bool liked) async {
    setState(() {
      buttonIsLoading = liked ? 'like' : 'dislike';
    });
    final likeValue = liked ? 1 : -1;
    dynamic response;

    if (voteId != null) {
      response = await voteService.updateVote(voteId, likeValue);
      return response;
    } else {
      response = await voteService.addVote(
        taskId: taskId,
        value: likeValue,
        userId: userData['user_id'],
      );
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vote = widget.vote;
    final userId = userData['user_id'];
    final taskId = widget.taskId;

    return AlertDialog(
      title: Text('give_your_opinion'.tr()),
      content: Text(
          'are_you_satisfied_with_the_work_done_by_one_of_your_flatmates'.tr()),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50),
            ),
            onPressed: vote?.value != 1
                ? () async {
              var response = await _voteTask(taskId, vote?.id, true);
              context.read<VoteBloc>().add(FetchUserVote(userId));

              if (response['statusCode'] == 201 ||
                  response['statusCode'] == 200) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    showSnackBarFeedback(
                      'your_opinion_has_been_taken_into_account'.tr(),
                      Colors.green,
                    )
                );
                setState(() {
                  buttonIsLoading = '';
                });
              } else if (response['statusCode'] == 422) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    showSnackBarFeedback(
                      '${response['message']}'.tr(),
                      Colors.red,
                    )
                );
                setState(() {
                  buttonIsLoading = '';
                });
              }
            }
                : null,
            child: buttonIsLoading == 'like'
                ? const CircularProgressIndicator()
                : const Icon(
              Icons.thumb_up,
              color: Colors.green,
            )),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50),
            ),
            onPressed: vote?.value != -1
                ? () async {
              var response = await _voteTask(taskId, vote?.id, false);
              context.read<VoteBloc>().add(FetchUserVote(userId));

              if (response['statusCode'] == 201 ||
                  response['statusCode'] == 200) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    showSnackBarFeedback(
                      'your_opinion_has_been_taken_into_account'.tr(),
                      Colors.green,
                    )
                );
                setState(() {
                  buttonIsLoading = '';
                });
              } else if (response['statusCode'] == 422) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    showSnackBarFeedback(
                      '${response['message']}'.tr(),
                      Colors.orange,
                    )
                );
                setState(() {
                  buttonIsLoading = '';
                });
              }
            }
                : null,
            child: buttonIsLoading == 'dislike'
                ? const CircularProgressIndicator()
                : const Icon(
              Icons.thumb_down,
              color: Colors.red,
            ))
      ],
    );
  }
}
