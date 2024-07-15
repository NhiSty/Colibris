import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/website/pages/backoffice/votes/dialogs/add_vote_dialog.dart';


class AddVoteButton extends StatefulWidget {
  final int taskId;
  const AddVoteButton({super.key, required this.taskId});

  @override
  _AddVoteButtonState createState() => _AddVoteButtonState();
}

class _AddVoteButtonState
    extends State<AddVoteButton> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showAddVoteDialog(
          context: context,
          taskId: widget.taskId,
        );
      },
      child: Text('backoffice_vote_add_vote'.tr()),
    );
  }
}
