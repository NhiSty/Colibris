import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {},
          ),
          const Text('1'),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
