import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sound Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SoundRecorder(),
    );
  }
}

class SoundRecorder extends StatefulWidget {
  @override
  _SoundRecorderState createState() => _SoundRecorderState();
}

class _SoundRecorderState extends State<SoundRecorder> {
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isRecorderInitialized = false;
  String _recordFilePath = '';

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission not granted.');
      return;
    }

    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    final storageDirectory = await getApplicationDocumentsDirectory();
    _recordFilePath = '${storageDirectory.path}/flutter_sound_record.aac';
    try {
      await _audioRecorder!.openRecorder();
      _isRecorderInitialized = true;
    } catch (e) {
      print('Failed to open recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      print('Recorder not initialized.');
      return;
    }

    await _audioRecorder!.startRecorder(toFile: _recordFilePath);
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playAudio() async {
    if (!_isRecorderInitialized || !File(_recordFilePath).existsSync()) {
      print('Audio file not found.');
      return;
    }

    try {
      await _audioPlayer!.startPlayer(fromURI: _recordFilePath);
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Failed to start player: $e');
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer!.pausePlayer();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      print('Failed to pause player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Sound Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPlaying ? _pauseAudio : _playAudio,
              child: Text(_isPlaying ? 'Pause Audio' : 'Play Audio'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioRecorder?.closeRecorder();
    _audioPlayer?.stopPlayer();
    _audioPlayer?.closePlayer();
    super.dispose();
  }
}
