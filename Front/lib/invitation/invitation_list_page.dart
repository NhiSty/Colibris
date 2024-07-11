import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/invitation/invitation.dart';
import 'package:front/invitation/invitation_accept_page.dart';
import 'package:go_router/go_router.dart';

class InvitationListPage extends StatefulWidget {
  final List<Invitation> invitations;
  static const routeName = "/invitations";

  const InvitationListPage({super.key, required this.invitations});

  @override
  _InvitationListPageState createState() => _InvitationListPageState();
}

class _InvitationListPageState extends State<InvitationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('invitation_title'.tr()),
      ),
      body: ListView.builder(
        itemCount: widget.invitations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("invitation_to_join_colocation".tr()),
            subtitle: Text(
                "${"invitation_received_at".tr()} ${DateTime.parse(widget.invitations[index].createdAt).toLocal().toString().split(' ')[0]}"),
            onTap: () {
              context.push(InvitationAcceptPage.routeName, extra: {
                'invitationId': widget.invitations[index].id,
                'colocationId': widget.invitations[index].colocationId
              });
            },
            leading: IconButton(
              icon: const Icon(Icons.email),
              onPressed: () {
                context.push(InvitationAcceptPage.routeName, extra: {
                  'invitationId': widget.invitations[index].id,
                  'colocationId': widget.invitations[index].colocationId
                });
              },
            ),
          );
        },
      ),
    );
  }
}
