import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:swifttrack/classes/flutter_camera.dart';
import 'package:swifttrack/classes/sound_record_mp3.dart';
import 'package:swifttrack/classes/sound_recorder.dart';
import 'package:swifttrack/inc/base_constants.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_camera/flutter_camera.dart';
// import 'package:lumineux_rewards_app/common/AppBarAction.dart';

// import 'BaseConstants.dart';

class FilePickerOrCamera extends StatefulWidget {
  static String tag = "file-camera";
  const FilePickerOrCamera({Key? key}) : super(key: key);

  @override
  State<FilePickerOrCamera> createState() => _FilePickerOrCameraState();
}

class _FilePickerOrCameraState extends State<FilePickerOrCamera> {
  int apiCall = 0;
  final recorder = SoundRecorder();
  late String recordFilePath = "/abcd";

  @override
  void initState() {
    super.initState();

    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  Widget audioButton() {
    // final isRecording = recorder.isRecording;
    // final icon = isRecording ? Icons.stop : Icons.graphic_eq;
    // final text = isRecording ? "STOP" : BaseConstants.addAudioLabel;
    // final primaryColor = isRecording ? Colors.red : Colors.white;
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.graphic_eq),
          iconSize: 75.0,
          color: Colors.white,
          onPressed: () async {
            // await recorder.toggleRecording();

            // if (isRecording) {
            //   List filesList = [
            //     {"name": "audio", "data": recorder.getAudioFilePath()}
            //   ];

            //   if (!mounted) return;
            //   Navigator.pop(context, filesList);
            // }
            // setState(() {});

            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const SoundRecordMp3();
                },
              ),
            );

            if (result != null && result.isNotEmpty) {
              List filesList = [
                {"name": "audio", "data": result}
              ];

              if (!mounted) return;
              Navigator.pop(context, filesList);
            }
          },
        ),
        const Text(
          BaseConstants.addAudioLabel,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: apiCall == 1
              ? const SpinKitRing(
                  color: Colors.white,
                )
              : Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            BaseConstants.addEvidenceLabel,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          label: const Text(''),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    const Flexible(
                      child: FractionallySizedBox(
                        heightFactor: 0.8,
                        widthFactor: 1,
                      ),
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: [
                            IconButton(
                              icon: Image.asset("images/add-file.png"),
                              iconSize: 75.0,
                              color: Colors.white,
                              onPressed: () async {
                                FilePickerResult? filesPicked =
                                    (await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'jpg',
                                    'pdf',
                                    'jpeg',
                                    'png'
                                  ],
                                ));

                                List filesList = [
                                  {"name": "file", "data": filesPicked}
                                ];

                                if (!mounted) return;
                                Navigator.pop(context, filesList);
                              },
                            ),
                            const Text(
                              BaseConstants.addAFileLabel,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Image.asset("images/add-camera.png"),
                              iconSize: 75.0,
                              color: Colors.white,
                              onPressed: () async {
                                // final XFile? photo = await ImagePicker()
                                //     .pickImage(source: ImageSource.camera);

                                // if (photo != null) {
                                //   List filesList = [
                                //     {"name": "camera", "data": photo}
                                //   ];

                                //   if (!mounted) return;
                                //   Navigator.pop(context, filesList);
                                // }

                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //       return const FlutterCameraPage();
                                //     },
                                //   ),
                                // );

                                _navigateAndDisplaySelection(context);
                              },
                            ),
                            const Text(
                              BaseConstants.addFromCameraLabel,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Flexible(
                      child: FractionallySizedBox(
                        heightFactor: 0.1,
                        widthFactor: 1,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[audioButton()],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<dynamic> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    var result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => const FlutterCameraPage()),
    ).then((value) {
      print(value);
    });

    if (!mounted) return;

    print(result);

    //Navigator.pop(context, "mnop");
  }
}
