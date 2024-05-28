import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/colocation/colocation_service.dart';

class InvitationAcceptPage extends StatefulWidget {
  final int colocationId;

  const InvitationAcceptPage({Key? key, required this.colocationId})
      : super(key: key);

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
                              // TODO: Handle accept invitation
                            },
                            child: const Text('Accepter',
                                style: TextStyle(
                                    color: Colors.white)), // Texte blanc
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Bouton vert
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Handle refuse invitation
                            },
                            child: const Text('Refuser',
                                style: TextStyle(
                                    color: Colors.white)), // Texte blanc
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Bouton rouge
                            ),
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
  const InvitationCard({Key? key, this.colocationData}) : super(key: key);

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
                "Vous êtes invité à rejoindre la colocation ${colocationData?['Name']}située à ${colocationData?['Address']} ${colocationData?['City']} ${colocationData?['ZipCode']} ${colocationData?['Country']} ! Cette colocation peut-être décrite de la manière suivante : ${colocationData?['Description'] ?? ''} ",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
