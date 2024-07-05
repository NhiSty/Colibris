
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/task/task.dart';
import 'package:front/vote/bloc/vote_bloc.dart';
import 'package:front/vote/vote_service.dart';

import '../vote/vote_dialog.dart';

class TaskListItem extends StatelessWidget {
  final Task item;
  final VoidCallback onViewPressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onDeletePressed;

  const TaskListItem({
    super.key,
    required this.item,
    required this.onViewPressed,
    this.onEditPressed,
    required this.onLikePressed,
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 0, left: 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(item.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    BlocBuilder<VoteBloc, VoteState>(
                        builder: (context, state) {
                          if (state is VoteLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is VoteError) {
                            return Center(
                              child: Text(state.message),
                            );
                          } else if (state is VoteLoaded) {
                            final votes = state.votes;
                            // Assuming `item` has an ID or some identifier to match with votes
                            final voteIndex = votes.indexWhere((vote) => vote.taskId == item.id);
                            final vote = voteIndex != -1 ? votes.elementAt(voteIndex) : null;
                            final taskIsAlreadyVoted = vote != null;

                            return PopupMenuButton(
                              itemBuilder: (context) =>
                              [
                                PopupMenuItem(
                                    onTap: onViewPressed,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.remove_red_eye_outlined),
                                        const SizedBox(width: 10),
                                        Text('task_action_details'.tr()),
                                      ],
                                    )
                                ),
                                if (onEditPressed != null)
                                  PopupMenuItem(
                                      onTap: onEditPressed,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.edit_outlined),
                                          const SizedBox(width: 10),
                                          Text('task_action_edit'.tr()),
                                        ],
                                      )
                                  ),
                                if(onLikePressed != null)
                                  PopupMenuItem(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return VoteDialog(
                                              taskId: item.id,
                                              vote: vote,
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (vote != null)
                                            vote.value == 1
                                                ? const Icon(Icons.thumb_up_outlined, color: Colors.green)
                                                : const Icon(Icons.thumb_down_outlined, color: Colors.red)
                                          else
                                            const Icon(Icons.thumb_up_outlined),
                                          const SizedBox(width: 10),
                                          Text('task_action_like'.tr()),
                                        ],
                                      )
                                  ),
                                if (onDeletePressed != null)
                                  PopupMenuItem(
                                      onTap: onDeletePressed,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.delete_outlined),
                                          const SizedBox(width: 10),
                                          Text('task_action_delete'.tr()),
                                        ],
                                      )
                                  ),
                              ],
                            );
                          } else {
                            return Center(
                                child: Text('vote_unknown_error'.tr()));
                          }
                        }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(item.date), Text("${item.pts} pts")],
        ),
      ),
    );
  }
}