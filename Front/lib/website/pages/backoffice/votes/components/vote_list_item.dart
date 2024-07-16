import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/services/vote_service.dart';
import 'package:front/vote/vote.dart';
import 'package:front/services/user_service.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_state.dart';
import 'package:front/website/pages/backoffice/votes/dialogs/delete_vote_dialog.dart';

class VoteListItem extends StatefulWidget {
  final Vote vote;

  const VoteListItem({super.key, required this.vote});

  @override
  State<VoteListItem> createState() => _VoteListItemState();
}

class _VoteListItemState extends State<VoteListItem> {
  final voteService = VoteService();
  late Vote _currentVote;

  Future<Map<String, dynamic>> fetchOwnerData(int userId) async {
    UserService userService = UserService();
    return await userService.getUserById(userId);
  }

  @override
  void initState() {
    _currentVote = widget.vote;
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 0.8;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16.0),
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.thumbs_up_down, color: Colors.blue[800], size: 32,),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: fetchOwnerData(_currentVote.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('backoffice_vote_error_loading_owner_info'.tr());
                          } else {
                            final owner = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${'backoffice_vote_owned_by'.tr()} ${owner['Firstname']} - ${owner['Lastname']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${owner['Email']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),

              BlocListener<VoteBloc, VoteState>(
                listener: (context, state) {
                  if (state is Vote422Error) {
                    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
                      content: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${state.message}'.tr()),
                      ),
                    ));
                    context.read<VoteBloc>().add(LoadVotes(taskId: _currentVote.taskId));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: _currentVote.value == 1 ? Colors.green[800] : Colors.grey),
                      onPressed: () async {
                        if (_currentVote.value != 1) {
                          final voteUpdated = await voteService.updateVote(_currentVote.id, 1);

                          if (voteUpdated['statusCode'] == 200) {
                            setState(() {
                              _currentVote = voteUpdated['vote'];
                            });

                            ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
                              content: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${voteUpdated['message']}'.tr()),
                              ),
                            ));

                          } else {
                            ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
                              content: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${voteUpdated['message']}'.tr()),
                              ),
                            ));
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down, color: _currentVote.value == -1 ? Colors.red[800] : Colors.grey),
                      onPressed: () async {
                        if (_currentVote.value != -1) {
                          final voteUpdated = await voteService.updateVote(_currentVote.id, -1);

                          if (voteUpdated['statusCode'] == 200) {
                            setState(() {
                              _currentVote = voteUpdated['vote'];
                            });

                            ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
                              content: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${voteUpdated['message']}'.tr()),
                              ),
                            ));

                          } else {
                            ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
                              content: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('${voteUpdated['message']}'.tr()),
                              ),
                            ));
                          }
                        }
                      },
                    ),
                    SizedBox(width: 40),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDeleteVoteDialog(context: context, voteId: _currentVote.id, taskId: _currentVote.taskId);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
