import 'package:flutter/material.dart';
import 'package:front/notification/invitation.dart';
import 'package:front/notification/invitation_accept_page.dart';

class InvitationListPage extends StatefulWidget {
  final List<Invitation> invitations; // List of invitations

  InvitationListPage({required this.invitations});

  @override
  _InvitationListPageState createState() => _InvitationListPageState();
}

class _InvitationListPageState extends State<InvitationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitation List'),
      ),
      body: ListView.builder(
        itemCount: widget.invitations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: const Text("Invitation à rejoindre une colocation"),
            subtitle: Text(
                "Invitation reçu le : ${DateTime.parse(widget.invitations[index].createdAt).toLocal().toString().split(' ')[0]}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvitationAcceptPage(
                      colocationId: widget.invitations[index].colocationId),
                ),
              );
            },
            leading: IconButton(
              icon: const Icon(Icons.email),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvitationAcceptPage(
                        colocationId: widget.invitations[index].colocationId),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
