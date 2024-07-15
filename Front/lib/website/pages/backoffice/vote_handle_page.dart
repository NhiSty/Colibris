import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_bloc.dart';
import 'package:front/website/pages/backoffice/votes/bloc/vote_state.dart';
//import 'package:front/website/pages/backoffice/votes/components/vote_list.dart';
import 'package:front/website/pages/backoffice/votes/components/title_and_breadcrumb.dart';
import 'package:front/website/pages/backoffice/votes/components/vote_list.dart';

class VoteHandlePage extends StatelessWidget {
  final int taskId;
  const VoteHandlePage({super.key, required this.taskId});

  static const routeName = "/backoffice/votes";

  @override
  Widget build(BuildContext context) {
    context.read<VoteBloc>().add(LoadVotes(taskId: taskId));
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          TitleAndBreadcrumb(
            taskId: taskId,
          ),
          BlocBuilder<VoteBloc, VoteState>(
            builder: (context, state) {
              if (state is VoteLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VoteLoaded) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(child: VoteList(votes: state.votes)) //VoteList(votes: state.votes)),
                    ],
                  ),
                );
              } else if (state is VoteError) {
                return Center(child: Text(state.message));
              } else {
                return Center(
                    child: Text('backoffice_vote_no_vote'.tr()));
              }
            },
          ),
        ],
      ),
    );
  }
}
