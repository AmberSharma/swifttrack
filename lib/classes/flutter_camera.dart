import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';

class FlutterCameraPage extends StatelessWidget {
  const FlutterCameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterCamera(
      color: Colors.amber,
      onImageCaptured: (photo) {
        final path = photo.path;
        print("::::::::::::::::::::::::::::::::: $path");

        List filesList = [
          {"name": "camera-photo", "data": photo}
        ];

        Navigator.pop(context, filesList);

        // if (path.contains('.jpg')) {
        //   showDialog(
        //       context: context,
        //       builder: (context) {
        //         return AlertDialog(
        //           content: Image.file(File(path)),
        //         );
        //       });
        // }
      },
      onVideoRecorded: (video) {
        //final path = video.path;
        print('::::::::::::::::::::::::;; dkdkkd $video.path');

        List filesList = [
          {"name": "camera-video", "data": video}
        ];

        Navigator.pop(context, filesList);
      },
    );
    // return Container();
  }
}
