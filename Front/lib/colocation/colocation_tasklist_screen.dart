
import 'dart:ffi';

import 'package:flutter/material.dart';

/// Need l'id de la colocation
class ColocationTaskList extends StatefulWidget {
  final Int colocationId;
  const ColocationTaskList({super.key, required this.colocationId});

  static const routeName = '/colocation/task-list';

  @override
  State<ColocationTaskList> createState() => _ColocationTaskListState();
}

class _ColocationTaskListState extends State<ColocationTaskList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const SafeArea(
          child: Text('COUCOU'),
        ),
        appBar: AppBar(

          backgroundColor: Colors.green,
          title: const Text(),
        ),
    );
  }
}
