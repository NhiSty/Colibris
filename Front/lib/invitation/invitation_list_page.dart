import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/invitation/invitation.dart';
import 'package:front/invitation/invitation_accept_page.dart';
import 'package:front/main.dart';
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
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.invitations.isEmpty
                ? Center(
                    child: Text(
                      'no_invitations'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
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
                        color: Colors.blueGrey.withOpacity(0.05),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'invitation_to_join_colocation'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "${'invitation_received_at'.tr()} ${DateTime.parse(widget.invitations[index].createdAt).toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            context
                                .push(InvitationAcceptPage.routeName, extra: {
                              'invitationId': widget.invitations[index].id,
                              'colocationId':
                                  widget.invitations[index].colocationId,
                            });
                          },
                          leading: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
