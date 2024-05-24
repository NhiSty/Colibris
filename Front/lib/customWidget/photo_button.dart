
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:front/screen/camera_screen.dart';

class PhotoButton extends StatefulWidget {
  const PhotoButton({super.key});

  @override
  State<PhotoButton> createState() => _PhotoButtonState();
}

class _PhotoButtonState extends State<PhotoButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await availableCameras().then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (_) => CameraScreen(cameras: value))));
      },
      child: const Text("Take a Picture"),
    );
  }
}
