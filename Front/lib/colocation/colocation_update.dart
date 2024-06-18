import 'package:flutter/material.dart';
import 'package:front/colocation/colocation_service.dart';

class ColocationUpdatePage extends StatefulWidget {
  final int colocationId;
  const ColocationUpdatePage({super.key, required this.colocationId});

  @override
  _ColocationUpdateWidgetState createState() => _ColocationUpdateWidgetState();
}

class _ColocationUpdateWidgetState extends State<ColocationUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  late Map<String, dynamic> _colocationData;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool isPermanent = false;

  @override
  void initState() {
    super.initState();
    fetchColocation(widget.colocationId).then((colocation) {
      setState(() {
        _colocationData = colocation;
        _isLoading = false;
        _nameController.text = _colocationData['Name'];
        _descriptionController.text = _colocationData['Description'];
        isPermanent = _colocationData['IsPermanent'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mise à jour Colocation'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Colocation permanente'),
                        value: isPermanent,
                        checkColor: Colors.white,
                        activeColor: Colors.green,
                        onChanged: (bool? value) {
                          setState(() {
                            isPermanent = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var res = await updateColocation(
                              widget.colocationId,
                              _nameController.text,
                              _descriptionController.text,
                              isPermanent,
                            );

                            if (res == 200) {
                              Navigator.pushNamed(context, '/colocation_manage',
                                  arguments: {
                                    'colocationId': widget.colocationId
                                  });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Colocation mise à jour'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Erreur lors de la mise à jour'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          minimumSize: const Size(
                              double.infinity, 50), // Bouton en pleine largeur
                        ),
                        child: const Text('Mettre à jour'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
