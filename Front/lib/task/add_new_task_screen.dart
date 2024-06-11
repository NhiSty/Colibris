import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/task/camera_screen.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timeRangeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late String fileName;
  late String base64Image;

  @override
  void initState() {
    var currentDate = DateTime.now();
    dateController.text = DateFormat('dd/MM/yyyy').format(currentDate);
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
      }
      else {
        totalDurationInSeconds = durationEndTime - durationStartTime;
      }

      var hours = '${(Duration(seconds: totalDurationInSeconds))}'.split('.')[0].split(':')[0];
      var minutes = '${(Duration(seconds: totalDurationInSeconds))}'.split('.')[0].split(':')[1];

      _timeRangeController.text = '$hours:$minutes';
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text(
              'Ajouter une nouvelle tâche',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Intitulé de la tâche',
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 30),
                      //height: MediaQuery.of(context).size.width / 3,
                      child: Center(
                          child: TextField(
                            controller: dateController,
                            //editing controller of this TextField
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Date" //label text of field
                            ),
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
                      child: TextField(
                        controller: _timeRangeController,
                        readOnly: true, // Prevent manual editing
                        onTap: () async {
                          TimeRange result = await showTimeRangePicker(
                            context: context,
                          );
                          _onRangeSelected(result);
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Temps passé',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: () async {
                        final camera = await availableCameras();
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CameraScreen(cameras: camera)),
                        );

                        if (result != null && result['fileName'] != null && result['base64Image'] != null) {
                          setState(() {
                            fileName = result['fileName'];
                            base64Image = result['base64Image'];
                          });
                        }
                      },
                      child: const Text('Take a Picture'),
                    ),
                  ),
                  Align(
                    heightFactor: 5,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Annuler'),
                            )
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: OutlinedButton(
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.green
                                  )
                              ),
                              onPressed: () {
                                print('-----Title ----- : ${_titleController.text}');
                                print('-----Date ----- : ${dateController.text}');
                                print('-----Duration ----- : ${_timeRangeController.text}');
                                print('-----Picture name ----- : $fileName');
                                print('-----Picture base64 ----- : $base64Image');
                              }, // TODO faire le submit du form
                              child: const Text(
                                'Ajouter',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
