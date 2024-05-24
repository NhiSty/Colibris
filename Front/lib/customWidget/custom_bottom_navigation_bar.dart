
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.white,
            onPressed: () {
              print('clicked on home button');
            },
          ),
          IconButton(
            icon: const Icon(Icons.thumbs_up_down),
            color: Colors.white,
            onPressed: () {
              print('clicked on like/dislike button');
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            color: Colors.white,
            onPressed: () {
              print('clicked on chat button');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              print('clicked on profile button');
            },
          ),
        ],
      ),
    );
  }
}
