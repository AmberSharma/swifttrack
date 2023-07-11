import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class SoundRecordMp3 extends StatefulWidget {
  const SoundRecordMp3({super.key});

  @override
  State<SoundRecordMp3> createState() => _SoundRecordMp3State();
}

class _SoundRecordMp3State extends State<SoundRecordMp3> {
  String recordFilePath = "/abcd"; // Dummy File Path
  bool isRecording = false;

  Stream<int>? timerStream;
  StreamSubscription<int>? timerSubscription;
  String minutesStr = '00';
  String secondsStr = '00';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              '$minutesStr:$secondsStr',
              style: const TextStyle(fontSize: 40.0),
            ),
          ]),
          const SizedBox(
            height: 50.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (isRecording == false)
              GestureDetector(
                child: Container(
                  height: 48.0,
                  width: 48.0,
                  decoration: BoxDecoration(color: Colors.red.shade300),
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                    ),
                  ),
                ),
                onTap: () async {
                  startRecord();
                },
              ),
            if (isRecording == true)
              GestureDetector(
                child: Container(
                  height: 48.0,
                  width: 48.0,
                  decoration: BoxDecoration(color: Colors.blue.shade300),
                  child: Center(
                    child: RecordMp3.instance.status == RecordStatus.PAUSE
                        ? const Icon(
                            Icons.not_started,
                          )
                        : const Icon(
                            Icons.pause,
                          ),
                    //style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  pauseRecord();
                },
              ),

            if (isRecording == true)
              GestureDetector(
                child: Container(
                  height: 48.0,
                  width: 48.0,
                  decoration: BoxDecoration(color: Colors.green.shade300),
                  child: const Center(
                    child: Icon(Icons.stop),
                    // Text(
                    //   'stop',
                    //   style: TextStyle(color: Colors.white),
                    // ),
                  ),
                ),
                onTap: () {
                  stopRecord();
                  print(recordFilePath);
                  Navigator.pop(context, recordFilePath);
                },
              ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 20.0),
            //   child: Text(
            //     statusText,
            //     style: TextStyle(color: Colors.red, fontSize: 20),
            //   ),
            // ),
            // GestureDetector(
            //   behavior: HitTestBehavior.opaque,
            //   onTap: () {
            //     play();
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(top: 30),
            //     alignment: AlignmentDirectional.center,
            //     width: 100,
            //     height: 50,
            //     // ignore: unnecessary_null_comparison
            //     child: recordFilePath != null
            //         ? const Text(
            //             "play",
            //             style: TextStyle(color: Colors.red, fontSize: 20),
            //           )
            //         : Container(),
            //   ),
            // ),
          ]),
        ],
      ),
    );
  }

  // Record Mp3
  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      // statusText = "Recording...";
      recordFilePath = await getFilePath();
      // isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        // statusText = "Record error--->$type";
        setState(() {});
      });
      isRecording = true;

      timerStream = stopWatchStream();
      timerSubscription = timerStream!.listen((int newTick) {
        setState(() {
          minutesStr = ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
          secondsStr = (newTick % 60).floor().toString().padLeft(2, '0');
        });
      });
    }
    // else {
    //   statusText = "No microphone permission";
    // }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      timerSubscription!.resume();
      if (s) {
        // statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      timerSubscription!.pause();
      if (s) {
        // statusText = "Recording pause...";
        setState(() {});
      }
    }

    setState(() {});
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      timerSubscription!.cancel();
      timerStream = null;
      setState(() {
        minutesStr = '00';
        secondsStr = '00';
      });
      // statusText = "Record complete";
      // isComplete = true;

      print(recordFilePath);
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      // statusText = "Recording...";
      setState(() {});
    }
  }

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      // audioPlayer.play(recordFilePath, isLocal: true);
      audioPlayer.play(recordFilePath as Source);
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  // Stop Watch
  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration timerInterval = const Duration(seconds: 1);
    int counter = 0;

    bool isPaused = false;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      if (!isPaused) {
        counter++;
        streamController!.add(counter);
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    void pauseTimer() {
      isPaused = true;
    }

    void resumeTimer() {
      isPaused = false;
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: resumeTimer,
      onPause: pauseTimer,
    );

    return streamController.stream;
  }
}
