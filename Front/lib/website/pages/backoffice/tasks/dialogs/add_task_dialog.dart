import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_bloc.dart';
import 'package:front/website/pages/backoffice/colocMembers/bloc/colocMember_state.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_bloc.dart';
import 'package:front/website/pages/backoffice/tasks/bloc/task_state.dart';
import 'package:front/website/share/custom_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:time_range_picker/time_range_picker.dart';

void showAddTaskDialog(BuildContext context) {
  context.read<TaskBloc>().add(LoadAllUsersAndColocationsForTask());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: const AddTaskDialog(),
      );
    },
  ).then((_) {
    context.read<TaskBloc>().add(LoadTasks());
  });
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUserId;
  String? _selectedColocationId;
  final _titleController = TextEditingController();
  final _timeRangeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dateController = TextEditingController();
  String base64Image = '';

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
  Widget build(BuildContext widgetContext) {

    return CustomDialog(
      title: 'backoffice_task_add_task'.tr(),
      width: 600.0,
      height: 500.0,
      content: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskAdded) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(state.message),
                )
            ));
            Navigator.of(context).pop();
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(state.message),
              ),
            ));
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is UsersAndColocationsLoadedForTask) {
                  final usersAndColocationsState = state;
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(height: 30),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
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
                          items: usersAndColocationsState.colocations
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
                        ),
                        SizedBox(height: 30),
                        BlocProvider.value(
                            value: BlocProvider.of<ColocMemberBloc>(widgetContext),
                            child: BlocBuilder<ColocMemberBloc, ColocMemberState>(
                              builder: (context, state) {
                                if (state is ColocMemberLoading) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (state is ColocMemberLoaded) {
                                  var colocationData = _selectedColocationId != null && _selectedColocationId!.isNotEmpty
                                      ? state.colocationData.entries.firstWhere((element) => element.key == int.parse(_selectedColocationId!)).value['result']
                                      : null;

                                  print(colocationData);

                                  var colocationMembersUserIds = colocationData != null
                                      ? colocationData['ColocMembers'].map((e) => e['UserID']).toList()
                                      : [];

                                  print(colocationMembersUserIds);

                                  return DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
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
                                    items: state.userData.values.toList()
                                        .where((user) => colocationMembersUserIds.contains(user['ID']))
                                        .map((user) => DropdownMenuItem<String>(
                                      value: user['ID'].toString(),
                                      child: Text('${user['Firstname']} ${user['Lastname']} (${user['Email']})'),
                                    ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'please_select_user_in_add_modal'.tr();
                                      }
                                      return null;
                                    },
                                  );
                                } else if (state is ColocMemberError) {
                                  return Center(child: Text(state.message));
                                } else {
                                  return Center(child: Text('- Error -'));
                                }
                              },
                            ),
                        ),
                      ],
                    ),
                  );
                } else if (state is UsersAndColocationsLoadingForTask) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(child: Text('Loading...'));
                }
              },
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text('cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final int userId = int.parse(_selectedUserId!);
              final int colocationId = int.parse(_selectedColocationId!);
              final title = _titleController.text;
              final description = _descriptionController.text;
              final date = dateController.text;


              context.read<TaskBloc>().add(AddTask(
                title: title,
                description: description,
                date: date,
                duration: int.parse(_timeRangeController.text.split(':')[0]) * 60 + int.parse(_timeRangeController.text.split(':')[1]),
                userId: userId,
                colocationId: colocationId,
              ));
            }
          },
          child: Text('save'.tr()),
        ),
      ],
    );
  }
}
