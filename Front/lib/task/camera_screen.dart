import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;

class CameraScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraScreen({super.key, required this.cameras});
  static const routeName = "/camera";

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future takePicture(BuildContext context) async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      final File imageFile = File(picture.path);
      final String fileName = path.basename(imageFile.path);
      final bytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(bytes);

      context.pop({
        'fileName': fileName,
        'base64Image': base64Image,
      });
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        _cameraController.value.isInitialized
            ? CameraPreview(_cameraController)
            : const Center(child: CircularProgressIndicator()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                color: Colors.transparent),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: IconButton(
                  color: Colors.white,
                  iconSize: 30,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      _isRearCameraSelected = !_isRearCameraSelected;
                    });
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                  icon: Icon(_isRearCameraSelected
                      ? Icons.flip_camera_ios
                      : Icons.flip_camera_ios_outlined),
                )),
                Expanded(
                    child: IconButton(
                  onPressed: () => takePicture(context),
                  icon: const Icon(Icons.radio_button_checked),
                  color: Colors.white,
                  iconSize: 60,
                  padding: EdgeInsets.zero,
                )),
                const Spacer()
              ],
            ),
          ),
        )
      ],
    )));
  }
}
