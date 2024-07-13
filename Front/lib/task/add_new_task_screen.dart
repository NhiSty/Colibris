import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';
import 'package:front/task/task_form.dart';
import 'package:front/task/task_service.dart';
import 'package:front/main.dart';
import 'package:go_router/go_router.dart';

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
        title, description, date, duration, picture, colocationId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'task_create_title'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TaskForm(
                  colocationId: widget.colocation.id,
                  submitForm: _submitForm,
                  onSuccessfulSubmit: () {
                    context.pop(true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      showSnackBarFeedback(
                        'task_create_success'.tr(),
                        Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
