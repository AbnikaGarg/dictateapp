import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioRecorderPage extends StatefulWidget {
  @override
  _AudioRecorderPageState createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<AudioRecorderPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? _recordingPath;
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _recorder.openRecorder();

    _player.openPlayer();
  }

  Duration _currentPosition = Duration.zero;

  Future<void> _startRecording() async {
    final dir = await getTemporaryDirectory();
    _recordingPath = '${dir.path}/audio.aac';
    _player.onProgress!.listen((event) {
      setState(() {
        _currentPosition = event.position;
      });
    });
    await _recorder.startRecorder(toFile: _recordingPath);
    setState(() {
      _isRecording = true;
      _isPaused = false;
    });
  }

  Future<void> _pauseRecording() async {
    await _recorder.pauseRecorder();
    setState(() => _isPaused = true);
  }

  Future<void> _resumeRecording() async {
    await _recorder.resumeRecorder();
    setState(() => _isPaused = false);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _isPaused = false;
    });
  }

  Future<void> _play() async {
    if (_recordingPath != null) {
      await _player.startPlayer(fromURI: _recordingPath);
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _pausePlayback() async {
    await _player.pausePlayer();
    setState(() => _isPlaying = false);
  }

  Future<void> _seekForward() async {
    final newPos = _currentPosition + Duration(seconds: 5);
    await _player
        .seekToPlayer(Duration(milliseconds: newPos.inMilliseconds + 5000));
  }

  Future<void> _seekBackward() async {
    var newPos = _currentPosition - Duration(seconds: 5);
    int newMs = newPos.inMilliseconds - 5000;
    if (newMs < 0) newMs = 0;
    await _player.seekToPlayer(Duration(milliseconds: newMs));
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRecording)
              ElevatedButton(
                  onPressed: _startRecording, child: Text("Start Recording")),
            if (_isRecording && !_isPaused)
              ElevatedButton(
                  onPressed: _pauseRecording, child: Text("Pause Recording")),
            if (_isRecording && _isPaused)
              ElevatedButton(
                  onPressed: _resumeRecording, child: Text("Resume Recording")),
            if (_isRecording)
              ElevatedButton(
                  onPressed: _stopRecording, child: Text("Stop Recording")),
            const SizedBox(height: 30),
            if (_recordingPath != null)
              Column(
                children: [
                  if (!_isPlaying)
                    ElevatedButton(onPressed: _play, child: Text("Play")),
                  if (_isPlaying)
                    ElevatedButton(
                        onPressed: _pausePlayback, child: Text("Pause")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.replay_5),
                        onPressed: _seekBackward,
                      ),
                      IconButton(
                        icon: Icon(Icons.forward_5),
                        onPressed: _seekForward,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
