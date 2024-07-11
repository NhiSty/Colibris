import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/invitation/invitation_service.dart';
import 'package:go_router/go_router.dart';

class InvitationCreatePage extends StatefulWidget {
  const InvitationCreatePage({super.key, required this.colocationId});
  final int colocationId;
  static const routeName = "/create-invitation";

  @override
  _InvitationCreatePageState createState() => _InvitationCreatePageState();
}

class _InvitationCreatePageState extends State<InvitationCreatePage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('invit_colocation_title'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'invit_colocation_email'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('email_required'.tr()),
                    ));
                    return;
                  }

                  if (!email.contains('@') || !email.contains('.')) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('email_invalid'.tr()),
                    ));
                    return;
                  }

                  var res = await createInvitation(email, widget.colocationId);

                  if (res == 403) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('invit_colocation_user_already_here'.tr()),
                        backgroundColor: Colors.lightBlue));
                    return;
                  } else if (res == 404) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('invit_colocation_user_not_found'.tr()),
                        backgroundColor: Colors.red));
                    return;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('invit_colocation_invitation_sent'.tr()),
                        backgroundColor: Colors.green));
                    context.pop();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text('invit_colocation_submit'.tr())),
          ],
        ),
      ),
    );
  }
}
