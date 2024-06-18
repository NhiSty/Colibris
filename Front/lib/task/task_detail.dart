import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/task/task.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(task.picture);
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(task.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Titre:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              task.title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              task.description,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'Date de réalisation:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              task.date,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'Durée de la tâche :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              "${(task.duration / 60).toStringAsPrecision(2)} h",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'Cette tâche à rapporté :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              "${task.pts} points",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Text(
              'Preuve visuelle:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Card(
              child: Image.memory(
                bytes,
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
