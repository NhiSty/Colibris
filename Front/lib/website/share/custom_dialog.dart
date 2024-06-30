import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final double width;
  final double height;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.width = 500.0,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: width,
        height: height,
        child: content,
      ),
      actions: actions,
    );
  }
}
