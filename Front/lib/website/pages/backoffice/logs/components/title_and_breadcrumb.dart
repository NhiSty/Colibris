import 'package:flutter/material.dart';

class TitleAndBreadcrumb extends StatelessWidget {
  const TitleAndBreadcrumb({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        const Text(
          'Logs of application',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            Navigator.pop(context, "/home");
          },
          child: const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  ' > Logs',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
