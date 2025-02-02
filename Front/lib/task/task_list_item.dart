import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/task/task.dart';
import 'package:front/vote/bloc/vote_bloc.dart';

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        margin: const EdgeInsets.all(0),
        color: Colors.blueGrey.withOpacity(0.05),
        child: ListTile(
          contentPadding: const EdgeInsets.only(right: 0, left: 16),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(item.title,
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<VoteBloc, CompositeVoteState>(
                        builder: (context, state) {
                          if (state.voteByUserState is VoteByUserLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state.voteByUserState is VoteByUserError) {
                            return Center(
                              child: Text(
                                  (state.voteByUserState as VoteByUserError)
                                      .message),
                            );
                          } else if (state.voteByUserState is VoteByUserLoaded) {
                            final votes =
                                (state.voteByUserState as VoteByUserLoaded).votes;

                            final voteIndex = votes
                                .indexWhere((vote) => vote.taskId == item.id);
                            final vote = voteIndex != -1
                                ? votes.elementAt(voteIndex)
                                : null;

                            return Theme(
                              data: Theme.of(context).copyWith(
                                popupMenuTheme: PopupMenuThemeData(
                                  color: Color(0xFF37474F).withOpacity(0.8),
                                  textStyle: const TextStyle(color: Colors.white),
                                ),
                              ),
                              child: PopupMenuButton(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.white),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: onViewPressed,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.remove_red_eye_outlined,
                                            color: Colors.white),
                                        const SizedBox(width: 10),
                                        Text('task_action_details'.tr(),
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  if (onEditPressed != null)
                                    PopupMenuItem(
                                      onTap: onEditPressed,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.edit_outlined,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('task_action_edit'.tr(),
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  if (onLikePressed != null)
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
                                                ? const Icon(
                                                Icons.thumb_up_outlined,
                                                color: Colors.green)
                                                : const Icon(
                                                Icons.thumb_down_outlined,
                                                color: Colors.red)
                                          else
                                            const Icon(Icons.thumb_up_outlined,
                                                color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('task_action_like'.tr(),
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  if (onDeletePressed != null)
                                    PopupMenuItem(
                                      onTap: onDeletePressed,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.delete_outlined,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          Text('task_action_delete'.tr(),
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          } else {
                            return Center(child: Text('vote_unknown_error'.tr()));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.date,
                style: const TextStyle(color: Colors.white),
              ),
              Text("${item.pts} pts",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        )
        ,
      ),
    );
  }
}
