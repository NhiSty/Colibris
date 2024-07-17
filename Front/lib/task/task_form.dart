import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'camera_screen.dart';

typedef SubmitForm = Future<int> Function(String title, String description,
    String date, int duration, String picture, int colocationId);

class TaskForm extends StatefulWidget {
  final String? title;
  final String? timeRange;
  final String? description;
  final String? date;
  final String? image;
  final bool isEditing;
  final int colocationId;
  final SubmitForm submitForm;
  final VoidCallback onSuccessfulSubmit;

  const TaskForm({
    super.key,
    this.title,
    this.timeRange,
    this.description,
    this.date,
    this.image,
    this.isEditing = false,
    required this.colocationId,
    required this.submitForm,
    required this.onSuccessfulSubmit,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeRangeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dateController = TextEditingController();
  String base64Image = '';

  @override
  void initState() {
    if (widget.isEditing) {
      _titleController.text = widget.title!;
      _timeRangeController.text = widget.timeRange!;
      _descriptionController.text = widget.description!;
      dateController.text = widget.date!;
      base64Image = widget.image!;
    } else {
      var currentDate = DateTime.now();
      dateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
    }
    super.initState();
  }

  void _onRangeSelected(TimeRange range) {
    setState(() {
      final dayInSeconds = const Duration(days: 1).inSeconds;
      final durationEndTime = Duration(hours: range.endTime.hour, minutes: range.endTime.minute).inSeconds;
      final durationStartTime = Duration(hours: range.startTime.hour, minutes: range.startTime.minute).inSeconds;
      int totalDurationInSeconds;

      if (durationEndTime - durationStartTime < 0) {
        totalDurationInSeconds = (durationEndTime + dayInSeconds) - durationStartTime;
      } else {
        totalDurationInSeconds = durationEndTime - durationStartTime;
      }

      var hours = '${(Duration(seconds: totalDurationInSeconds))}'.split('.')[0].split(':')[0];
      var minutes = '${(Duration(seconds: totalDurationInSeconds))}'.split('.')[0].split(':')[1];

      _timeRangeController.text = '$hours:$minutes';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.only(top: 50.0),
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'task_create_task_name'.tr(),
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'task_create_task_name_error'.tr();
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Center(
                child: TextFormField(
                  maxLines: 3,
                  minLines: 3,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'task_create_description'.tr(),
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorStyle: TextStyle(color: Colors.red[500], fontSize: 15),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'task_create_description_error'.tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Center(
                child: TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "task_create_date".tr(),
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorStyle: TextStyle(color: Colors.red[500], fontSize: 15),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'task_create_date_error'.tr();
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    }
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Center(
                child: TextFormField(
                  controller: _timeRangeController,
                  readOnly: true,
                  onTap: () async {
                    TimeRange result = await showTimeRangePicker(
                      context: context,
                    );
                    _onRangeSelected(result);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'task_create_past_time'.tr(),
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorStyle: TextStyle(color: Colors.red[500], fontSize: 15),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'task_create_duration_error'.tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(top: 30, bottom: 10),
              color: Colors.white,
              child: base64Image.isNotEmpty
                  ? Image.memory(
                base64Decode(base64Image),
                height: 200,
                fit: BoxFit.scaleDown,
              )
                  : const SizedBox.shrink(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () async {
                  final camera = await availableCameras();
                  final result = await context.push(CameraScreen.routeName, extra: {"camera": camera});

                  if (result != null && (result as Map<String, dynamic>)['fileName'] != null && (result)['base64Image'] != null) {
                    setState(() {
                      base64Image = (result)['base64Image'];
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: base64Image.isEmpty
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt),
                    const SizedBox(width: 10),
                    Text('task_create_take_picture'.tr())
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt),
                    const SizedBox(width: 10),
                    Text('task_create_retake_picture'.tr())
                  ],
                ),
              ),
            ),
            Align(
              heightFactor: 2,
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('cancel'.tr()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var statusCode = await widget.submitForm(
                            _titleController.text,
                            _descriptionController.text,
                            dateController.text,
                            int.parse(_timeRangeController.text.split(':')[0]) * 60 +
                                int.parse(_timeRangeController.text.split(':')[1]),
                            base64Image,
                            widget.colocationId,
                          );

                          if (statusCode == 201 || statusCode == 200) {
                            widget.onSuccessfulSubmit();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text(widget.isEditing ? 'edit'.tr() : 'add'.tr()),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
