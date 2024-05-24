
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:front/customWidget/date_picker.dart';
import 'package:front/customWidget/photo_button.dart';
import 'package:front/customWidget/time_range_picker.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
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
          body: Container(
            margin: const EdgeInsets.only(top: 50.0),
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Intitulé de la tâche',
                  ),
                ),
                const DatePicker(),
                const TimeRangePicker(),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: const PhotoButton(),
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
                            onPressed: () {}, // TODO faire le submit du form
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
        )
    );
  }
}
