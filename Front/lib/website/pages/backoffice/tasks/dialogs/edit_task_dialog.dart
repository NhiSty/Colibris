import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/task/task.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:time_range_picker/time_range_picker.dart';

void showEditTaskDialog({ required BuildContext context, required Task task }) {
  final taskBloc = BlocProvider.of<TaskBloc>(context);
  taskBloc.add(LoadAllUsersAndColocations());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: UpdateTaskDialog(task: task),
      );
    },
  );
}

class UpdateTaskDialog extends StatefulWidget {
  final Task task;

  UpdateTaskDialog({required this.task, Key? key}) : super(key: key);

  @override
  _UpdateTaskDialogState createState() => _UpdateTaskDialogState();
}

class _UpdateTaskDialogState extends State<UpdateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeRangeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dateController = TextEditingController();
  String? _selectedUserId;
  String? _selectedColocationId;

  @override
  void initState() {
    _titleController.text = widget.task.title;
    _timeRangeController.text = widget.task.duration.toString();
    _descriptionController.text = widget.task.description;
    dateController.text = widget.task.date;
    _selectedColocationId = widget.task.colocationId.toString();
    _selectedUserId = widget.task.userId.toString();
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
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    return CustomDialog(
      title: 'backoffice_task_update_task'.tr(),
      height: 500.0,
      width: 600.0,
      content: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('backoffice_task_task_updated_successfully'.tr(),
                    ),
                  )
              )
              );
            } else if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('task_update_error'.tr()),
                ),
              ));
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is UsersAndColocationsLoaded) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
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
                                child: Center(
                                    child: TextFormField(
                                      controller: dateController,
                                      decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: "task_create_date".tr()
                                      ),
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
                                            lastDate: DateTime(2100));

                                        if (pickedDate != null) {
                                          String formattedDate =
                                          DateFormat('dd/MM/yyyy').format(pickedDate);
                                          setState(() {
                                            dateController.text = formattedDate;
                                          });
                                        }
                                      },
                                    ))),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Center(
                                child: TextFormField(
                                  controller: _timeRangeController,
                                  readOnly: true,
                                  onTap: () async {
                                    TimeRange result = await showTimeRangePicker(
                                      context: context,
                                      padding: 30,
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
                            SizedBox(height: 30),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text('user'.tr()),
                              ),
                              value: _selectedUserId,
                              hint: Text(
                                  'backoffice_task_select_user_in_add_modal'
                                      .tr()),
                              onChanged: (value) {
                                setState(() {
                                  _selectedUserId = value;
                                });
                              },
                              items: state.users
                                  .map((user) => DropdownMenuItem<String>(
                                value: user.id.toString(),
                                child:
                                Text('${user.firstname} ${user.lastname}'),
                              ))
                                  .toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a user';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: Text('colocation'.tr()),
                              ),
                              value: _selectedColocationId,
                              hint: Text(
                                  'backoffice_task_select_colocation_in_add_modal'
                                      .tr()),
                              onChanged: (value) {
                                setState(() {
                                  _selectedColocationId = value;
                                });
                              },
                              items: state.colocations
                                  .map((coloc) => DropdownMenuItem<String>(
                                value: coloc['ID'].toString(),
                                child: Text(coloc['Name']),
                              ))
                                  .toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a colocation';
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ],
                    );
                  } else if (state is UsersAndColocationsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text('Loading...'));
                  }
                },
              ),
            ),
          )), actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          taskBloc.add(LoadTasks());
        },
        child: Text('cancel'.tr()),
      ),
      TextButton(
        onPressed: () {
          if (_titleController.text.isNotEmpty &&
              _descriptionController.text.isNotEmpty &&
              dateController.text.isNotEmpty &&
              _timeRangeController.text.isNotEmpty) {
            taskBloc.add(EditTask(
              taskId: widget.task.id,
              title: _titleController.text,
              description: _descriptionController.text,
              date: dateController.text,
              duration: int.parse(_timeRangeController.text),
              colocationId: int.parse(_selectedColocationId!),
              userId: int.parse(_selectedUserId!),
            ));
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('fill_all_fields'.tr()),
              ),
            ));
          }
        },
        child: Text('save'.tr()),
      ),
    ],
    );
  }
}
