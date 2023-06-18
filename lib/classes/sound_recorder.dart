import 'dart:convert';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

const pathToSaveAudio = "audio_example.mp4";

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  String? _filePath = "";
  bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone Permission Required");
    }
    await _audioRecorder!.openRecorder();
    _isRecorderInitialized = true;
  }

  void dispose() {
    if (!_isRecorderInitialized) return;

    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future _record() async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }

  Future _stop() async {
    if (!_isRecorderInitialized) return;

    _filePath = await _audioRecorder!.stopRecorder();
  }

  String? getAudioFilePath() {
    return _filePath;
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
