import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';

void showAddVoteDialog({required BuildContext context, required int taskId}) {
  context.read<VoteBloc>().add(LoadUsersColocation(taskId: taskId));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<VoteBloc>(context),
        child: AddVoteDialog(taskId: taskId),
      );
    },
  ).then((_) {
    context.read<VoteBloc>().add(LoadVotes(taskId: taskId));
  });
}

class AddVoteDialog extends StatefulWidget {
  final dynamic taskId;

  const AddVoteDialog({super.key, required this.taskId});

  @override
  _AddVoteDialogState createState() => _AddVoteDialogState();
}

class _AddVoteDialogState extends State<AddVoteDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;
  int _valueController = 0;


  @override
  Widget build(BuildContext context) {

    return CustomDialog(
      title: 'backoffice_vote_add_vote'.tr(),
      width: 600.0,
      height: 180.0,
      content: BlocListener<VoteBloc, VoteState>(
        listener: (context, state) {
          if (state is VoteAdded) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${state.message}'.tr()),
                )
            ));
            Navigator.of(context).pop();
          } else if (state is VoteError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${state.message}'.tr()),
              ),
            ));
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BlocBuilder<VoteBloc, VoteState>(
              builder: (context, state) {
                if (state is UserColocationLoaded) {
                  print('users: ${state.users}');
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                          ),
                          value: _userId,
                          hint: Text(
                              'backoffice_vote_select_user_in_add_modal'
                                  .tr()),
                          onChanged: (value) {
                            setState(() {
                              _userId = value!;
                            });
                          },
                          items: state.users
                              .map((user) => DropdownMenuItem<String>(
                            value: user.id.toString(),
                            child:
                            Text('${user.firstname} ${user.lastname}'),
                          ))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_select_user_in_add_modal'.tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 60,
                              onPressed: () {
                                setState(() {
                                  _valueController = 1;
                                });
                              },
                              icon: Icon(Icons.thumb_up, color: _valueController == 1 ? Colors.green[800] : Colors.grey),
                            ),
                            IconButton(
                              iconSize: 60,
                              onPressed: () {
                                setState(() {
                                  _valueController = -1;
                                });
                              },
                              icon: Icon(Icons.thumb_down, color: _valueController == -1 ? Colors.red[800] : Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                } else if (state is UserColocationLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is VoteError) {
                  context.pop();
                  return SizedBox();
                } else {
                  return Center(child: Text('Loading...'));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final vote = _valueController;

              if (vote == 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('please_select_your_opinion'.tr()),
                  ),
                ));
                return;
              }

              context.read<VoteBloc>().add(AddVote(
                userId: int.parse(_userId!),
                vote: _valueController,
                taskId: widget.taskId,
              ));

              //context.pop();
            }
          },
          child: Text('save'.tr()),
        ),
      ],
    );
  }
}
