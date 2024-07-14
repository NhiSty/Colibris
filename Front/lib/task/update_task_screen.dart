import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:front/colocation/colocation.dart';
import 'package:front/main.dart';
import 'package:front/shared.widget/snack_bar_feedback_handling.dart';
import 'package:front/task/task.dart';
import 'package:front/task/task_form.dart';
import 'package:front/task/task_service.dart';
import 'package:go_router/go_router.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Colocation colocation;
  final Task task;
  const UpdateTaskScreen(
      {super.key, required this.colocation, required this.task});

  static const routeName = '/update-task';

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  @override
  void initState() {
    super.initState();
  }

  String convertMinutesToHHMM(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr';
  }

  Future<int> _submitForm(
    String title,
    String description,
    String date,
    int duration,
    String picture,
    int colocationId,
  ) async {
    return await updateTask(widget.task.id, title, description, date, duration,
        picture, colocationId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
                appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'task_update'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
                ),
                body: SingleChildScrollView(
          child: TaskForm(
            colocationId: widget.colocation.id,
            title: widget.task.title,
            description: widget.task.description,
            date: widget.task.date,
            timeRange: convertMinutesToHHMM(widget.task.duration),
            image: widget.task.picture,
            isEditing: true,
            submitForm: _submitForm,
            onSuccessfulSubmit: () {
              context.pop();

              ScaffoldMessenger.of(context).showSnackBar(
                showSnackBarFeedback(
                  'task_update_success'.tr(),
                  Colors.green,
                ),
              );
            },
          ),
                ),
              ),
        )
    );
  }
}
