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
      final durationEndTime =
          Duration(hours: range.endTime.hour, minutes: range.endTime.minute)
              .inSeconds;
      final durationStartTime =
          Duration(hours: range.startTime.hour, minutes: range.startTime.minute)
              .inSeconds;
      int totalDurationInSeconds;

      if (durationEndTime - durationStartTime < 0) {
        totalDurationInSeconds =
            (durationEndTime + dayInSeconds) - durationStartTime;
      } else {
        totalDurationInSeconds = durationEndTime - durationStartTime;
      }

      var hours = '${(Duration(seconds: totalDurationInSeconds))}'
          .split('.')[0]
          .split(':')[0];
      var minutes = '${(Duration(seconds: totalDurationInSeconds))}'
          .split('.')[0]
          .split(':')[1];

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
              ),
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'task_create_description_error'.tr();
                    }
                    return null;
                  },
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                //height: MediaQuery.of(context).size.width / 3,
                child: Center(
                    child: TextFormField(
                  controller: dateController,
                  //editing controller of this TextField
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "task_create_date".tr() //label text of field
                      ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'task_create_date_error'.tr();
                    }
                    return null;
                  },
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                ))),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Center(
                child: TextFormField(
                  controller: _timeRangeController,
                  readOnly: true, // Prevent manual editing
                  onTap: () async {
                    TimeRange result = await showTimeRangePicker(
                      context: context,
                    );
                    _onRangeSelected(result);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'task_create_past_time'.tr(),
                  ),
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
                  final result = await await context
                      .push(CameraScreen.routeName, extra: {"camera": camera});

                  if (result != null &&
                      (result as Map<String, dynamic>)['fileName'] != null &&
                      (result)['base64Image'] != null) {
                    setState(() {
                      base64Image = (result)['base64Image'];
                    });
                  }
                },
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
                      child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('cancel'.tr()),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: OutlinedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var statusCode = await widget.submitForm(
                            _titleController.text,
                            _descriptionController.text,
                            dateController.text,
                            int.parse(_timeRangeController.text.split(':')[0]) *
                                    60 +
                                int.parse(
                                    _timeRangeController.text.split(':')[1]),
                            base64Image,
                            widget.colocationId);

                        print('statusCode: $statusCode');

                        if (statusCode == 201 || statusCode == 200) {
                          widget.onSuccessfulSubmit();
                        }
                      }
                    },
                    child: Text(
                      widget.isEditing ? 'edit'.tr() : 'add'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
