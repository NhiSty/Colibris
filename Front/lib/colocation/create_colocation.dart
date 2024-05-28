import 'package:flutter/material.dart';
import 'package:front/colocation/colocation_service.dart';

class CreateColocationPage extends StatefulWidget {
  @override
  _CreateColocationPageState createState() => _CreateColocationPageState();
}

class _CreateColocationPageState extends State<CreateColocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _colocType = false;
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une colocation'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Colocation permanente'),
                value: _colocType,
                checkColor: Colors.white,
                activeColor: Colors.green,
                onChanged: (bool? value) {
                  setState(() {
                    _colocType = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createColocation(_nameController.text,
                        _descriptionController.text, _colocType);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Créer la colocation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
