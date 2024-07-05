
import 'package:flutter/material.dart';
import 'package:front/vote/vote.dart';
import 'package:front/vote/vote_service.dart';
import 'package:front/website/share/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  Future<void> _voteTask(int taskId, int? voteId, bool liked) async {
    setState(() {
      buttonIsLoading = liked ? 'like' : 'dislike';
    });
    final likeValue = liked ? 1 : -1;
    if (voteId != null) {
      await updateVote(voteId, likeValue);

    } else {
      await addVote(taskId, likeValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vote = widget.vote;
    final userId = userData['user_id'];
    final taskId = widget.taskId;

    return AlertDialog(
      title: const Text('Donne ton avis'),
      content: const Text('Es-tu satisfait de la tâche effectuée par l\'un de tes coloc ?'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 50),
          ),
          onPressed: vote?.value != 1
              ? () async {
            await _voteTask(taskId, vote?.id, true);
            context.read<VoteBloc>().add(FetchUserVote(userId));
            setState(() {
              buttonIsLoading = '';
            });
            Navigator.of(context).pop();
          } : null,
            child: buttonIsLoading == 'like'
                ? const CircularProgressIndicator()
                : const Icon(Icons.thumb_up, color: Colors.green, )
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 50),
          ),
          onPressed: vote?.value != -1
              ? () async {
            await _voteTask(taskId, vote?.id, false);
            context.read<VoteBloc>().add(FetchUserVote(userId));
            setState(() {
              buttonIsLoading = '';
            });
            Navigator.of(context).pop();
          } : null,
          child: buttonIsLoading == 'dislike'
              ? const CircularProgressIndicator()
              : const Icon(Icons.thumb_down, color: Colors.red, )
        )
      ],
    );
  }
}
