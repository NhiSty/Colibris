import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/home_screen.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';
import 'package:front/main.dart';
import 'package:go_router/go_router.dart';

class InvitationAcceptPage extends StatefulWidget {
  final int colocationId;
  final int invitationId;

  static const routeName = "/invitation/accept";

  const InvitationAcceptPage({
    super.key,
    required this.colocationId,
    required this.invitationId,
  });

  @override
  _InvitationAcceptPageState createState() => _InvitationAcceptPageState();
}

class _InvitationAcceptPageState extends State<InvitationAcceptPage> {
  Map<String, dynamic>? colocationData;

  @override
  void initState() {
    super.initState();
    fetchColocationData();
  }

  void fetchColocationData() async {
    var data = await fetchColocation(widget.colocationId);
    setState(() {
      colocationData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'invitation_accept_title'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: colocationData == null
                ? const CircularProgressIndicator()
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InvitationCard(colocationData: colocationData),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<InvitationBloc>().add(
                                  InvitationAccept(
                                      state: 'accepted',
                                      invitationId:
                                      widget.invitationId));
                              context.push(HomeScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                            ),
                            child: Text(
                              'invitation_accept_accept'.tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<InvitationBloc>().add(
                                  InvitationReject(
                                      state: 'declined',
                                      invitationId:
                                      widget.invitationId));
                              context.push(HomeScreen.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                            ),
                            child: Text(
                              'invitation_accept_refuse'.tr(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InvitationCard extends StatelessWidget {
  final Map<String, dynamic>? colocationData;
  const InvitationCard({super.key, this.colocationData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  colocationData?['Name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "${'invitation_accept_message1'.tr()} ${colocationData?['Name']} ${'invitation_accept_message2'.tr()} ${colocationData?['Location']} ${'invitation_accept_message3'.tr()} ${colocationData?['Description'] ?? ''}",
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
