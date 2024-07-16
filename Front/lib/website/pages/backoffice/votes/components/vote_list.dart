import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/vote/vote.dart';
import 'package:front/website/pages/backoffice/votes/components/vote_list_item.dart';

class VoteList extends StatelessWidget {
  final List<Vote> votes;

  const VoteList({super.key, required this.votes});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (votes.isEmpty) {
      return Center(child: Text('backoffice_vote_no_vote'.tr()));
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 24),
      itemCount: votes.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 6);
      },
      itemBuilder: (BuildContext context, int index) {
        final vote = votes[index];
        return Center(
          child: VoteListItem(
            vote: vote,
          ),
        );
      },
    );
  }
}
