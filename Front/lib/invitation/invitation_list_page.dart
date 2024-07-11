import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/invitation/invitation.dart';
import 'package:front/invitation/invitation_accept_page.dart';

class InvitationListPage extends StatefulWidget {
  final List<Invitation> invitations;

  const InvitationListPage({super.key, required this.invitations});

  @override
  _InvitationListPageState createState() => _InvitationListPageState();
}

class _InvitationListPageState extends State<InvitationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.email, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'invitation_title'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.invitations.isEmpty
            ? Center(
          child: Text(
            'no_invitations'.tr(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: widget.invitations.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  'invitation_to_join_colocation'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${'invitation_received_at'.tr()} ${DateTime.parse(widget.invitations[index].createdAt).toLocal().toString().split(' ')[0]}",
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvitationAcceptPage(
                        invitationId: widget.invitations[index].id,
                        colocationId: widget.invitations[index].colocationId,
                      ),
                    ),
                  );
                },
                leading: const Icon(
                  Icons.email,
                  color: Colors.green,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
