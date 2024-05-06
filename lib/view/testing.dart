import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';  // Replace with your actual import

class RecorderExample extends StatefulWidget {
  @override
  _RecorderExampleState createState() => _RecorderExampleState();
}

class _RecorderExampleState extends State<RecorderExample> {
  AnotherAudioRecorder? _recorder;
  List<Recording> recordings = [];
  AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  int playingIndex = -1;  // To keep track of which recording is currently playing
  Timer? _timer;
  Duration _currentDuration = Duration();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String path = '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
    _recorder = AnotherAudioRecorder(path, audioFormat: AudioFormat.WAV);
    await _recorder?.initialized;
  }

  void _startRecording() async {
    await _recorder?.start();
    setState(() {
      isRecording = true;
      _currentDuration = Duration();
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _currentDuration += Duration(seconds: 1);
      });
    });
  }

  void _stopRecording() async {
    if (isRecording) {
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
      Recording? recording = await _recorder?.stop();
      if (recording != null) {
        recording.duration = _currentDuration;  // Assuming `duration` is a field in `Recording`
        setState(() {
          recordings.add(recording);
          isRecording = false;
          _currentDuration = Duration();
        });
      }
    }
  }

  void togglePlayPause(String path, int index) async {
    if (isPlaying && playingIndex == index) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      Source source;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        source = UrlSource(path);
      } else {
        source = DeviceFileSource(path);
      }
      await audioPlayer.play(source);
      setState(() {
        isPlaying = true;
        playingIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Recorder')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recording Timer: ${formatDuration(_currentDuration)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _startRecording,
            child: Text('Start Recording'),
          ),
          ElevatedButton(
            onPressed: _stopRecording,
            child: Text('Stop Recording'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Recording ${index + 1}'),
                  subtitle: Text('Duration: ${formatDuration(recordings[index].duration)}'),
                  trailing: IconButton(
                    icon: Icon(
                      isPlaying && playingIndex == index ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () => togglePlayPause(recordings[index].path!, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return "00:00:00";  // Default display for null durations
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

