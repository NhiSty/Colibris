import 'package:flutter/material.dart';
import 'package:front/invitation/invitation_service.dart';

class InvitationCreatePage extends StatefulWidget {
  const InvitationCreatePage({super.key, required this.colocationId});
  final int colocationId;

  @override
  _InvitationCreatePageState createState() => _InvitationCreatePageState();
}

class _InvitationCreatePageState extends State<InvitationCreatePage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invitation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Email is required'),
                    ));
                    return;
                  }

                  if (!email.contains('@') || !email.contains('.')) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invalid email'),
                    ));
                    return;
                  }

                  var res = await createInvitation(email, widget.colocationId);

                  print(res);

                  if (res == 403) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User already in colocation'),
                        backgroundColor: Colors.green));
                    return;
                  } else if (res == 404) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('User not found'),
                        backgroundColor: Colors.green));
                    return;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Invitation sent'),
                        backgroundColor: Colors.green));
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text('Envoyer l\'invitation')),
          ],
        ),
      ),
    );
  }
}
