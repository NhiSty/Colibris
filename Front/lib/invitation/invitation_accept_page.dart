import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/colocation/colocation_service.dart';
import 'package:front/invitation/bloc/invitation_bloc.dart';

class InvitationAcceptPage extends StatefulWidget {
  final int colocationId;
  final int invitationId;

  const InvitationAcceptPage(
      {super.key, required this.colocationId, required this.invitationId});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitation Accept Page'),
      ),
      body: Center(
        child: colocationData == null
            ? const CircularProgressIndicator()
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Adjust the height based on children
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InvitationCard(colocationData: colocationData),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.read<InvitationBloc>().add(
                                  InvitationAccept(
                                      state: 'accepted',
                                      invitationId: widget.invitationId));
                              Navigator.pushNamed(context, '/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Bouton vert
                            ),
                            child: const Text('Accepter',
                                style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<InvitationBloc>().add(
                                  InvitationReject(
                                      state: 'declined',
                                      invitationId: widget.invitationId));
                              Navigator.pushNamed(context, '/home');
                            }, // Texte blanc
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Bouton rouge
                            ),
                            child: const Text('Refuser',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
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
    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Center(child: Text(colocationData?['Name'] ?? '')),
              textColor: Colors.white,
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Vous êtes invité à rejoindre la colocation ${colocationData?['Name']} située à ${colocationData?['Address']} ${colocationData?['City']} ${colocationData?['ZipCode']} ${colocationData?['Country']} ! Cette colocation peut-être décrite de la manière suivante : ${colocationData?['Description'] ?? ''} ",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
