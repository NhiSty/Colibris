import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/invitation/invitation_service.dart';
import 'package:front/main.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';
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
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.add_reaction, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'invit_colocation_title'.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'invit_colocation_email'.tr(),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'email_required'.tr(),
                              Colors.orange,
                            ),
                          );

                          return;
                        }

                        if (!email.contains('@') || !email.contains('.')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'email_invalid'.tr(),
                              Colors.orange,
                            ),
                          );

                          return;
                        }

                        var res = await createInvitation(email, widget.colocationId);

                        if (res == 403) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'invit_colocation_user_already_here'.tr(),
                              Colors.lightBlue,
                            ),
                          );

                          return;
                        } else if (res == 404) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'invit_colocation_user_not_found'.tr(),
                              Colors.red,
                            ),
                          );
                          return;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            showSnackBarFeedback(
                              'invit_colocation_invitation_sent'.tr(),
                              Colors.green,
                            ),
                          );
                          context.pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 6.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('invit_colocation_submit'.tr(),
                      style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
