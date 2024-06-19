import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/task/task_form.dart';
import 'package:front/task/task_service.dart';

class AddNewTaskScreen extends StatefulWidget {
  final Colocation colocation;
  const AddNewTaskScreen({super.key, required this.colocation});

  static const routeName = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<int> _submitForm(
      String title,
      String description,
      String date,
      int duration,
      String picture,
      int colocationId,
      ) async {
    return await createTask(
        title,
        description,
        date,
        duration,
        picture,
        colocationId
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text(
              'Ajouter une nouvelle tâche',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: TaskForm(
              colocationId: widget.colocation.id,
              submitForm: _submitForm,
              onSuccessfulSubmit: () {
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tâche ajoutée'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
        ));
  }
}
