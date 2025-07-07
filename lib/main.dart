import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speechtotext/services/shared_pref.dart';
import 'package:speechtotext/view/home/home.dart';
import 'package:speechtotext/view/home/play_audio.dart';
import 'package:speechtotext/view/home/test.dart';

import 'bindings/init_bindings.dart';
import 'splash.dart';
import 'theme/app_theme.dart';
import 'view/auth/login.dart';
import 'view/home/bottombar.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  //calling DependencyInjection init method
  WidgetsFlutterBinding.ensureInitialized();

  DependencyInjection.init();
  await Future.delayed(const Duration(milliseconds: 400));
  _requestPermission();
  runApp(MyApp());
}

Future<bool> _requestPermission() async {
  // Check and request microphone permission
 
  PermissionStatus status = await Permission.microphone.request();
 // await Permission.phone.request();
  return status.isGranted;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Speech Text',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppTheme.whiteDullColor,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.black),
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(backgroundColor: Colors.white)),

        // getPages:appRoutes(),
        //  initialRoute: Routes.addblog,
        //  unknownRoute: GetPage(name: "/page_not_found", page:()=> Scaffold(body: Center(child: Text("Page not found"),),)),
        home: SplashScreen());
  }
}

// class AudioRecord extends StatefulWidget {
//   const AudioRecord({super.key});

//   @override
//   State<AudioRecord> createState() => _AudioRecordState();
// }

// class _AudioRecordState extends State<AudioRecord> {


//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   NoiseMeter? _noiseMeter;
//   StreamSubscription<NoiseReading>? _noiseSubscription;
//   bool _isRecording = false;
//   bool _isStartingRecording = false;
//   bool _isPlaying = false;
//   String? _filePath;
//   DateTime? _lastDecisionTime;

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   Future<void> _init() async {
//     await _requestPermissions();
//     await _recorder.openRecorder();
//     await _player.openPlayer();
//     _noiseMeter = NoiseMeter();
//     _startListening();
//   }

//   Future<void> _requestPermissions() async {
//     var micStatus = await Permission.microphone.request();
//     if (!micStatus.isGranted) throw Exception('Microphone permission denied');
//   }

//   void _startListening() {
//     _noiseSubscription = _noiseMeter!.noise.listen(
//           (NoiseReading reading) {
//         _handleNoiseLevel(reading.meanDecibel);
//       },
//       onError: (error) {
//         print('Noise meter error: $error');
//       },
//     );
//   }

//   Future<void> _handleNoiseLevel(double dB) async {
//     final now = DateTime.now();

//     if (_lastDecisionTime != null &&
//         now.difference(_lastDecisionTime!) < const Duration(seconds: 1)) {
//       return;
//     }

//     _lastDecisionTime = now;

//     if (dB > 50 && !_isRecording) {
//       await _startRecording();
//     } else if (dB < 30 && _isRecording) {
//       await _stopRecording();
//     }
//   }

//   Future<void> _startRecording() async {
//     if (_isStartingRecording || _isRecording) return;
//     _isStartingRecording = true;

//     try {
//       final tempDir = await getTemporaryDirectory();
//       _filePath =
//       '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//       await _recorder.startRecorder(
//         toFile: _filePath,
//         codec: Codec.aacADTS,
//       );

//       setState(() {
//         _isRecording = true;
//       });

//       print('Started recording: $_filePath');
//     } catch (e) {
//       print('Failed to start recording: $e');
//     } finally {
//       _isStartingRecording = false;
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder.stopRecorder();

//       setState(() {
//         _isRecording = false;
//       });

//       print('Stopped recording.');
//     } catch (e) {
//       print('Failed to stop recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_filePath == null || _isPlaying) return;

//     try {
//       setState(() => _isPlaying = true);

//       await _player.startPlayer(
//         fromURI: _filePath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           setState(() => _isPlaying = false);
//           print('Playback finished');
//         },
//       );

//       print('Playing: $_filePath');
//     } catch (e) {
//       print('Playback error: $e');
//       setState(() => _isPlaying = false);
//     }
//   }

//   Future<void> _stopPlayback() async {
//     await _player.stopPlayer();
//     setState(() => _isPlaying = false);
//   }

//   @override
//   void dispose() {
//     _noiseSubscription?.cancel();
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Voice Activated Recorder')),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _isRecording ? '🎤 Recording...' : '👂 Listening for sound...',
//               style: const TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.stop),
//               label: const Text("Manually Stop Recording"),
//               onPressed: _isRecording ? _stopRecording : null,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
//               label: Text(_isPlaying ? "Stop Playback" : "Play Recording"),
//               onPressed: _filePath == null
//                   ? null
//                   : _isPlaying
//                   ? _stopPlayback
//                   : _playRecording,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }