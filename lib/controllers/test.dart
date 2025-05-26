import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:record/record.dart';
import 'package:speechtotext/models/DictationsDataModel.dart';
import 'package:speechtotext/view/home/file_review.dart';
import 'package:intl/intl.dart';
import '../components/dailogs.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../services/shared_pref.dart';
import '../components/loaders.dart';
import '../services/home_repo.dart';
import 'package:permission_handler/permission_handler.dart';
import '../view/home/bottombar.dart';

class Recordcontroller extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer(handleInterruptions: false);

  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer flutterplayer = FlutterSoundPlayer();
  // static const platform = MethodChannel('com.yourapp/call');

  bool isRecording = false;
  String filePath = "";
  String? fileName = "";
  double currentPosition = 0;
  String totalDuration = "0";
  double doubleTotalDuration = 0;
  //int recordingSeconds = 0; // Timer counter
  Duration recordingSeconds = Duration.zero;

  Timer? timer;
  bool isPaused = false;
  bool isSilent = false;
  Timer? amplitudeTimer;
  //final PlayerController playerWaveformController = PlayerController();

  final RecorderController recorderController = RecorderController();
  late ScrollController scrollController;
  @override
  void dispose() {
    audioPlayer.dispose();
    flutterplayer.closePlayer();
    recorder.closeRecorder();
    timer?.cancel();
    amplitudeTimer?.cancel();
    super.dispose();
  }

  bool isLoaded = false;
  List<DictationsDataModel> dictationsDataList = [];
// Initialize the recorder
  // Future<void> _initializeRecorder() async {
  //   await recorder.();
  // }
  void getAllDictations() async {
    dictationsDataList.clear();
    recordingSeconds = Duration.zero;
    HomepageService().getDictations(1).then((value) {
      switch (value.statusCode) {
        case 200:
          isLoaded = true;
          final decodedData = jsonDecode(value.body);

          dictationsDataList.add(DictationsDataModel.fromJson(decodedData));
          // if (dictationsDataList.isNotEmpty) {
          //   if (dictationsDataList.first.data!.isNotEmpty) {
          //     Future.delayed(Duration(milliseconds: 800), () {
          //       setFile(dictationsDataList.first.data![0].dictationsdataUrl!);
          //     });
          //   }
          // }
          update();
          break;
        case 401:
          //   Get.offAndToNamed("/login");
          //DialogHelper.showErroDialog(description: "Token not valid");
          break;
        case 1:
          break;
        default:
          break;
      }
    });
  }

  double silenceThreshold = 2; //42; // Adjust based on testing (dB)
  int silenceDuration = 2; // How many seconds before detecting silence
  int _silentTime = 0;
  bool isPlaying = false;
  Future<bool> _requestPermission() async {
    // Check and request microphone permission
    PermissionStatus status = await Permission.microphone.request();
    return status.isGranted;
  }
  final Codec _codec = Codec.pcm16WAV;

  Duration currentPositionCurrent = Duration.zero;

  Future<void> startRecording() async {
    try {
      //  await checkAudioSession();
      if (isRecording) {
        // If already recording, don't start again
        print("Recording is already in progress.");
        return;
      }
      final directory = await getTemporaryDirectory();
      int fileNumber = 1;

      filePath = '${directory.path}audio.aac';

      // var config = RecordConfig(
      //     noiseSuppress: true,
      //     iosConfig: const IosRecordConfig(manageAudioSession: true),
      //     androidConfig: const AndroidRecordConfig(),
      //     encoder: AudioEncoder.wav,
      //     sampleRate: 44100,
      //     bitRate: 32000 //128000,
      //     );
      var recordingDataControllerUint8 = StreamController<Uint8List>();

      // Start recording and store the file path
      flutterplayer.onProgress!.listen((event) {
        recordingSeconds = event.position;
        print("flutterplayer" + recordingSeconds.toString());
        update();
      }); recordingDataControllerUint8.stream.listen((Uint8List data) {
        // Process my frame in data
        print("Received chunk: ${data.length} bytes");

      });
      await recorder.startRecorder(
      //  toFile: filePath,numChannels: 1,
     
        toStream: recordingDataControllerUint8.sink,
 codec: Codec.pcm16, // or another codec supported on iOS
  sampleRate: 44100,
  bitRate: 128000,
        //   bitRate: 128000,
        //   sampleRate: 44100,

        // sampleRate: 44100,
        // bitRate: 32000, //128000,
        // numChannels: 1,
      );
     
      recorder.onProgress!.listen((evwnt) {
        currentPositionCurrent = evwnt.duration;
        print("recorder:" + currentPositionCurrent.toString());

        update();
        final currentAmplitude = evwnt.decibels ?? -160.0; // default to silence
        if (!isRecording || isPaused) return;
        print(" v: $currentAmplitude dB");

        if (currentAmplitude < silenceThreshold) {
          _silentTime++;
          if (_silentTime >= silenceDuration) {
            isSilent = true;

            pauseRecording();

            print("⏸ Paused due to silence");
          }
        } else {
          _silentTime = 0;
          if (isPaused) {
            resumeRecording();
            print("▶ Resumed after silence");
          }
        }
      });
      await recorder.setSubscriptionDuration(
        Duration(seconds: 1), // 100 ms
      );
      recorderController.record();

      // flutterplayer.playerState
      update();
      // Start Timer (every second)
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        recordingSeconds += Duration(seconds: 1);
        recorderController.refresh();
        update();
      });

      //  Check for Silence Detection
      // final audioStream = await recorder.startStream(config);

      //  audioStream.listen((data) async {
      //  print(data);
      //  print("data");
      //  });
      //   print("ContentType$data");
      // if (channel.sink != null) {
      //   channel.sink.add(data);
      // }
      // await client.sendUserMessageContent([
      //   {"ContentType": data}, // Base64 encoded audio
      // ]);

      // amplitudeTimer =
      //     Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      //   print("Amplitude: start");
      //   if (!isRecording || isPaused) return;

      //   final amplitude = await recorder.getRecordURL();
      //   double currentAmplitude = amplitude.current;
      //   print("Amplitude: $currentAmplitude dB");

      //   if (currentAmplitude < silenceThreshold) {
      //     _silentTime++;
      //     if (_silentTime >= silenceDuration) {
      //       pauseRecording();
      //       print("⏸ Recording Paused due to Silence");
      //     }
      //   } else {
      //     _silentTime = 0;
      //     if (isPaused) {
      //       resumeRecording();
      //       print("▶ Recording Resumed after Silence");
      //     }
      //   }
      // });
      // });
//    Update state to indicate that recording is in progress
      isRecording = true;
      isPaused = false;
      recordingSeconds = Duration.zero;
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> pauseRecording() async {
    try {
      if (isRecording && !isPaused) {
        recorderController.pause();

        await recorder.pauseRecorder();

        // Pause the timer
        timer?.cancel();
        // await Future.delayed(
        //     Duration(milliseconds: 500)); // give it time to flush

        isPaused = true;
        if (isPaused) {
          //  await flutterplayer.startPlayer(fromURI: filePath);
          // final file = File(filePath);
          // Create a copy to make it playable
          // final partialPath = "${filePath.replaceFirst('.wav', '')}_partial.wav";

          // await File(filePath).copy(
          //   partialPath,
          // );

          // print("🔄 Playing copied file: $partialPath");

          //  if (await partialPath.exists()) {
          await Future.delayed(
              Duration(milliseconds: 500)); // give time to flush

          await audioPlayer.setFilePath(filePath);
//         playerWaveformController.preparePlayer(path: filePath);
// playerWaveformController.setVolume(0);
          audioPlayer.load();
          totalDuration = formatDuration(audioPlayer.duration!);
          doubleTotalDuration = audioPlayer.duration?.inSeconds.toDouble() ?? 0;
          updatePostion();
          update();
        }

        update();
        print("⏸ Recording Paused");
      }
    } catch (e) {
      print(e);
    }
  }

  // startPartialREcord() async {
  //   await flutterplayer.startPlayer(fromURI: filePath);
  //   print(currentPositionCurrent);
  // }

  Future<void> resumeRecording() async {
    if (isRecording && isPaused) {
      await recorder.resumeRecorder();
      recorderController.record();
      _silentTime = 0;
      isSilent = false;
      // Restart the timer
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        recordingSeconds += Duration(seconds: 1);
        recorderController.refresh();
        update();
      });
      if (isPlaying) {
        audioPlayer.pause();
        isPlaying = false;
      }
      isPaused = false;
      update();
      print("▶ Recording Resumed");
    }
  }

  Future<void> deleteAllLocalFiles() async {
    try {
      // Get the app's documents directory
      final dir = await getApplicationDocumentsDirectory();

      // List all files in the directory
      final files = dir.listSync(recursive: true);

      for (var file in files) {
        try {
          if (file is File) {
            await file.delete();
            print("🗑️ Deleted file: ${file.path}");
          } else if (file is Directory) {
            await file.delete(recursive: true);
            print("📁 Deleted directory: ${file.path}");
          }
        } catch (e) {
          print("⚠️ Error deleting ${file.path}: $e");
        }
      }

      print("✅ All local files deleted.");
    } catch (e) {
      print("❌ Failed to delete local files: $e");
    }
  }
  // String currentFilePath = "";
  // String currentFileName = "";
  // var CurrentFileduration = "".obs;
  // var CurrentFilepostion = ''.obs;
  // int CurrentFileselectedid = 0;

  // var CurrentFilemax = 0.0.obs;
  // var CurrentFileslidervalue = 0.0.obs;
  // bool CurrentFileisPlaying = false;
  bool isSaved = false;
  Future<void> stopRecording(type) async {
    // TDialogs.defaultDialog(
    //   title: "Save",
    //   content: "Are you sure you want to save the Recording",
    //   context: Get.context!,
    //   onConfirm: () async {

    //   },
    // );
    await recorder.stopRecorder();
    recorderController.stop();
    if (isPlaying) {
      audioPlayer.pause();
      isPlaying = false;
    }
    timer?.cancel();
    amplitudeTimer?.cancel();
    isSaved = true;
    isRecording = false;
    isPaused = false;
    _silentTime = 0;
    saveRecording(type);
    // currentFilePath = filePath;
    // currentFileName = fileName!;
    // Get.to(ReviewFile(
    //   fileName: fileName!,
    //   filePath: filePath,
    // ));
    //
    // getFileData();
    // await audioPlayer.setFilePath(filePath);
    // totalDuration = formatDuration(audioPlayer.duration!);
    // doubleTotalDuration = audioPlayer.duration?.inSeconds.toDouble() ?? 0;
    // updatePostion();
    update();
  }

  // getFileData(file) async {
  //   await audioPlayer.setFilePath(filePath);
  //   totalDuration = formatDuration(audioPlayer.duration!);
  //   doubleTotalDuration = audioPlayer.duration?.inSeconds.toDouble() ?? 0;
  //   setFile(file);
  //   update();
  // }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    int tenths =
        (duration.inMilliseconds % 1000) ~/ 100; // Get first decimal digit

    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$tenths";
  }

  var duration = "".obs;
  var postion = ''.obs;
  int selectedid = 0;
  var max = 0.0.obs;
  var slidervalue = 0.0.obs;

  void updatePostion() {
    audioPlayer.durationStream.listen((event) {
      if (event != null) {
        duration.value = formatDuration(event);
        max.value = event.inSeconds.toDouble();
      }
    });

    audioPlayer.positionStream.listen((event) {
      postion.value = formatDuration(event);
      slidervalue.value = event.inSeconds.toDouble();
    });

    update();
  }

  changeValueinDuration(seconds) {
    if (audioPlayer.playing) {
      isPlaying = true;
    }
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
    update();
  }

  Future<void> setFile(String file) async {
    try {
      if (file != "") {
        if (!audioPlayer.playing) {
          await audioPlayer.setUrl(file);
          updatePostion();
          update();
        }
      }
    } catch (e) {}
  }

  @override
  void onInit() {
    super.onInit();
    recorder.openRecorder();
    flutterplayer.openPlayer();
    // GetClose();
    scrollController = ScrollController();
    deleteAllLocalFiles();
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // countaa = countaa + 1;
        print("dcjdjbdcdcbdjbjd");
        isPlaying = false;
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
        //  playerWaveformController.seekTo(0); // Reset waveform
        //   playerWaveformController.setRefresh(true); // Reset waveform

        debugPrint(playerState.playing.toString());
        update();
      }
    });
    // playerWaveformController.setFinishMode(finishMode: FinishMode.loop);

    // playerWaveformController.onCompletion.listen((s) {
    //         playerWaveformController.seekTo(0);

    //   playerWaveformController.startPlayer();
    //   update();
    // }); // Triggers events every time when an audio file is finished playing.
    checkAudioSession();
    getAllDictations();
    checkPermission();
    getSetting();
    //  listofFiles();
    print("dhn");
  }

  Future<void> checkAudioSession() async {
    try {
      final session = await AudioSession.instance;

      // It's important to configure the session before doing anything else
      // Set the session to recording-compatible config
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.record,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));

      print("🔊 Audio session configured.");
      if (await session.setActive(true)) {
        print("🔊 Audio session setActive.");
      } else {
        print("🔊 Audio session not active.");
      }
      // Listen for noisy audio interruptions (like unplugged headphones)
      session.becomingNoisyEventStream.listen((_) {
        print("🎧 Becoming noisy (e.g., headphones unplugged)");
      });

      // Listen for system-level interruptions (like phone calls or Siri)
      session.interruptionEventStream.listen((event) async {
        if (event.begin) {
          print("📞 Audio interrupted: ${event.type}");
          if (isRecording) {
            await pauseRecording();
            //   stopRecording(2);
          }
          // Pause or mute audio here
        } else {
          print("✅ Audio interruption ended: ${event.type}");
          // Resume audio here if needed
        }
      });
    } catch (e) {
      print("❌ Audio error: $e");
    }
  }

  // GetClose() async {
  //   try {
  //     platform.setMethodCallHandler((call) async {
  //       if (call.method == 'incoming_call') {
  //         print("Incoming call detected!");
  //       } else if (call.method == 'call_picked') {
  //         print("call_picked call detected!");
  //         if (isRecording) {
  //           await pauseRecording();
  //           stopRecording(2);
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  bool micAllowed = false;
  //bool phoneStatus = false;
  Future<void> checkPermission() async {
    final status = await Permission.microphone.status;
    // final status2 = await Permission.phone.status;
    micAllowed = status.isGranted;
    //  phoneStatus = status2.isGranted;
    update();
  }

  Future<void> handleToggle(bool newValue) async {
    if (newValue) {
      final result = await Permission.microphone.request();
      openAppSettings();
      micAllowed = result.isGranted;
      update();
    } else {
      // Can't revoke permission programmatically, so open settings
      openAppSettings();
    }
  }

  // void getAllDictations() async {
  //   dictationsDataList.clear();
  //   HomepageService().getDictations(0).then((value) {
  //     switch (value.statusCode) {
  //       case 200:
  //         isLoaded = true;
  //         final decodedData = jsonDecode(value.body);

  //         dictationsDataList.add(DictationsDataModel.fromJson(decodedData));

  //         update();
  //         break;
  //       case 401:
  //         //   Get.offAndToNamed("/login");
  //         //DialogHelper.showErroDialog(description: "Token not valid");
  //         break;
  //       case 1:
  //         break;
  //       default:
  //         break;
  //     }
  //   });
  // }

// Skip forward by 5 seconds
  skip5SecondsForward() {
    var currentPosition = audioPlayer.position.inSeconds;
    var newPosition = currentPosition + 5;

    // Ensure the new position does not exceed the maximum duration
    if (newPosition < max.value) {
      var duration = Duration(seconds: newPosition);
      audioPlayer.seek(duration);
      //  playerWaveformController.seekTo(newPosition);
    } else {
      audioPlayer.seek(Duration(seconds: max.value.toInt()));
    }
    if (!isPlaying) {
      //   playerWaveformController.pausePlayer();

      audioPlayer.play();
      isPlaying = true;
    }
    update();
    recorderController.setScrolledPositionDuration(5);
  }

// Skip backward by 5 seconds
  skip5SecondsBackward() {
    var currentPosition = audioPlayer.position.inSeconds;
    var newPosition = currentPosition - 5;

    // Ensure the new position doesn't go below 0
    if (newPosition > 0) {
      var duration = Duration(seconds: newPosition);
      audioPlayer.seek(duration);
    } else {
      audioPlayer.seek(Duration(seconds: 0));
    }
    if (!isPlaying) {
      //   playerWaveformController.pausePlayer();

      audioPlayer.play();
      isPlaying = true;
    }
    update();
  }

// Jump to start
  void skipToStart() {
    if (!isPlaying) {
      //   playerWaveformController.pausePlayer();

      audioPlayer.play();
      isPlaying = true;
    }
    audioPlayer.seek(Duration.zero);
    update();
  }

// Jump to end
  void skipToEnd() {
    final totalDuration = audioPlayer.duration;
    if (totalDuration != null) {
      audioPlayer.seek(totalDuration);
      update();
    }
  }

  pausePlaySong() {
    if (isPlaying) {
      //   playerWaveformController.pausePlayer();
      audioPlayer.pause();
      isPlaying = false;
    } else {
      //   playerWaveformController.startPlayer();
      audioPlayer.play();
      isPlaying = true;
    }

    update();
  }

  deleteLocalFile(filePath2) async {
    final file = File(filePath2);
    if (await file.exists()) {
      await file.delete();
    }
    Loaders.successSnackBar(message: "Deleted Successfully", title: "Success");
    Future.delayed(Duration(milliseconds: 900), () {
      Get.offAll(DashboardScreen());
    });
  }

  resetRecording() {
    duration.value = "";
    postion.value = '';

    max.value = 0.0;
    slidervalue.value = 0.0;
    update();
  }

  bool isSaving = false;
  void saveRecording(type) async {
    //  Loaders.showLoading('Loading...');
    final file = File(filePath);
    List<int> fileBytes = await file.readAsBytes();
    DateTime now = DateTime.now().toUtc();

    // Format it to the desired format (ISO 8601 with milliseconds and UTC 'Z')
    String formattedDate = now.toIso8601String();
    // Encode the file bytes to Base64
    String base64String = base64Encode(fileBytes);
    final prefix =
        PreferenceUtils.getString("name").substring(0, 2).toUpperCase();
    final now2 = DateTime.now();
    final formatter = DateFormat('${selectedDateFormat}_hh:mm:ssa');
    final timestamp = formatter.format(now2);
    fileName = '${prefix}_$timestamp.aac';
    HomepageService()
        .createDictation(
            fileName, formattedDate, base64String, "1 mb", totalDuration, type)
        .then((value) async {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);

          isSaving = true;

          update();
          Future.delayed(Duration(seconds: 4), () {
            isSaving = false;
            isSaved = false;
            update();
          });
          resetRecording();
          // Future.delayed(Duration(seconds: 2), () {
          //    isSaved = false;
          //     update();
          // });

          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
          }
          // Loaders.successSnackBar(
          //     message: "Uploaded Successfully", title: "Success");
          // Future.delayed(Duration(milliseconds: 800), () {
          //   // Get.delete<Recordcontroller>();
          //   Get.back();
          // });

          getAllDictations();
          break;
        case 400:
          // if (value.data["detail"] == "User is not verified") {
          //   DialogHelper.showErroDialog(
          //       description: "your email not registered with us");
          //   // Get.toNamed(
          //   //   Routes.SIGNUP,
          //   // );
          // }
          Loaders.errorSnackBar(
              message: "Something went wromg", title: "Error");

          break;
        case 401:
          Loaders.errorSnackBar(
              message: "Something went wromg", title: "Error");
          break;

        case 1:
          break;
        default:
          Loaders.errorSnackBar(
              message: "Something went wromg", title: "Error");
          break;
      }
    });
  }

  int selectedIndex = -1;
  changeIndex(value, file) {
    isPlaying = false;
    audioPlayer.pause();
    selectedIndex = value;
    update();
    setFile(file);
  }

  discardRecord() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("File not Saved"),
          actionsPadding: EdgeInsets.only(bottom: 6),
          content: Text("Do you want to save or delete?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isRecording) {
                  stopRecording(2);
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () async {
                final file = File(filePath!);
                if (await file.exists()) {
                  file.delete();
                }
                Get.offAll(DashboardScreen());
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // var selectedData;
  // editDictation(var data) {
  //   selectedData = data;
  //   isPlaying = false;
  //   audioPlayer.pause();
  //   setFile(data["path"]);
  //   update();
  //   Get.to(LocalPlayerPage());
  // }

  bool isLoadeedLocal = false;
  void deleteFiles(filePahs) async {
    for (int i = 0; i < filePahs.length; i++) {
      print(filePahs);
      try {
        // Create a File instance for each file path
        final file = File(filePahs[i]);

        // Check if the file exists before attempting to delete
        if (await file.exists()) {
          // Delete the file
          await file.delete();

          update();
          print('File deleted: ${filePahs[i]}');
        } else {
          print('File not found: ${filePahs[i]}');
        }
      } catch (e) {
        print('Error deleting file ');
      }
    }

    listofFiles();
  }

  selectedList(index) {
    fileNames[index]["isSelected"] = !fileNames[index]["isSelected"];
    update();
  }

  List fileNames = []; // List to hold file names
  void listofFiles() async {
    String directory;
    fileNames.clear();
    isLoadeedLocal = true;
    update();
    // Get the application documents directory
    directory = (await getApplicationDocumentsDirectory()).path;

    // List all files in the directory
    Directory(directory).listSync().forEach((fileSystemEntity) async {
      if (fileSystemEntity is File) {
        // Check if it's a file (not a directory)
        // fileNames.add(fileSystemEntity.uri.pathSegments.last); // Add file name to the list
        FileStat fileStat = fileSystemEntity.statSync();

        // Get the last modified date and time
        DateTime lastModified = fileStat.modified;
        var duration = "5";

        fileNames.add({
          "name": fileSystemEntity.uri.pathSegments.last,
          "path": fileSystemEntity.uri.path,
          "date":
              "${DateFormat(selectedDateFormat).format(lastModified.toLocal())}",
          "duration": duration,
          "isSelected": false
        });
      }
    });

    isLoadeedLocal = false;
    isSelecting = false;
    update();
    // Print the file names
    print(fileNames);
    if (fileNames.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 1200));
      setFile(fileNames[0]["path"].toString());
    }
  }

  void clearFiles() async {
    String directory;

    // Get the application documents directory
    directory = (await getApplicationDocumentsDirectory()).path;

    // List all files in the directory
    Directory(directory).listSync().forEach((fileSystemEntity) {
      if (fileSystemEntity is File) {
        // Check if it's a file (not a directory)
        // Delete the file
        fileSystemEntity
            .deleteSync(); // This deletes the file from the directory
        print('Deleted: ${fileSystemEntity.uri.pathSegments.last}');
      }
    });
  }

  void saveMultipleRecording(filePahs) async {
    Loaders.showLoading('Loading...');
    List newData = [];
    fileNames.forEach(
      (element) async {
        if (element["isSelected"]) {
          final file = File(element["path"]);
          List<int> fileBytes = await file.readAsBytes();

          // Encode the file bytes to Base64
          String base64String = base64Encode(fileBytes);
          newData.add({
            "dictationsdata_url": base64String,
            "filename": element["name"],
            "file_size": "10 MB",
            "file_duration": "5",
            "status": 1
          });
        }
      },
    );

    HomepageService().createDictationList(newData).then((value) {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);
          Loaders.successSnackBar(
              message: "Uploaded Successfully", title: "Success");
          isSelecting = false;
          update();
          deleteFiles(filePahs);
          break;
        case 400:
          // if (value.data["detail"] == "User is not verified") {
          //   DialogHelper.showErroDialog(
          //       description: "your email not registered with us");
          //   // Get.toNamed(
          //   //   Routes.SIGNUP,
          //   // );
          // }
          Loaders.errorSnackBar(
              message: "Something went wromg", title: "Error");

          break;
        case 401:
          Loaders.errorSnackBar(
              message: "Something went wromg", title: "Error");
          break;

        case 1:
          break;
        default:
          Loaders.errorSnackBar(
              message: "Something went wromg", title: "Error");
          break;
      }
    });
  }

  // Future<void> seekForward() async {
  //   if (isRecording && isPaused) {
  //     //
  //     /// print(currentPositionCurrent);
  //     try {
  //       //  recordingSeconds = recordingSeconds + Duration(seconds: 5);
  //       // final newPos = recordingSeconds;
  //       // await flutterplayer
  //       //     .seekToPlayer(Duration(milliseconds: newPos.inMilliseconds));

  //       await flutterplayer.startPlayer(fromURI: filePath);
  //       update();
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  // Future<void> seekBackward() async {
  //   if (isRecording && isPaused) {
  //     // await flutterplayer.startPlayer(fromURI: filePath);
  //     try {
  //       print(recordingSeconds);
  //       recordingSeconds = recordingSeconds - Duration(seconds: 5);
  //       var newPos = recordingSeconds;
  //       int newMs = newPos.inMilliseconds;
  //       if (newMs < 0) newMs = 0;
  //       //await flutterplayer.stopPlayer();

  //       await flutterplayer.seekToPlayer(Duration(milliseconds: newMs));
  //       //  playingWavrController.record(path: filePath);
  //       await flutterplayer.startPlayer(fromURI: filePath); //

  //       //  flutterplayer.onProgress
  //       //  recorderController.record(path: filePath);
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  // // void saveLocalRecording(file2, name) async {
  // //   Loaders.showLoading('Loading...');
  //   List newData = [];
  //   final file = File(file2);
  //   List<int> fileBytes = await file.readAsBytes();

  //   // Encode the file bytes to Base64
  //   String base64String = base64Encode(fileBytes);
  //   newData.add({
  //     "dictationsdata_url": base64String,
  //     "filename": name,
  //     "file_size": "10 MB",
  //     "file_duration": "5",
  //     "status": 1
  //   });

  //   HomepageService().createDictationList(newData).then((value) {
  //     print(value.statusCode);
  //     Loaders.hideLoading();
  //     switch (value.statusCode) {
  //       case 200:
  //         var data2 = jsonDecode(value.body);
  //         print(data2);
  //         Loaders.successSnackBar(
  //             message: "Uploaded Successfully", title: "Success");

  //         deleteFiles([file2]);
  //         Future.delayed(Duration(milliseconds: 900), () {
  //           Get.offAll(DashboardScreen());
  //         });
  //         break;
  //       case 400:
  //         // if (value.data["detail"] == "User is not verified") {
  //         //   DialogHelper.showErroDialog(
  //         //       description: "your email not registered with us");
  //         //   // Get.toNamed(
  //         //   //   Routes.SIGNUP,
  //         //   // );
  //         // }
  //         Loaders.errorSnackBar(
  //             message: "Something went wromg", title: "Error");

  //         break;
  //       case 401:
  //         Loaders.errorSnackBar(
  //             message: "Something went wromg", title: "Error");
  //         break;

  //       case 1:
  //         break;
  //       default:
  //         Loaders.errorSnackBar(
  //             message: "Something went wromg", title: "Error");
  //         break;
  //     }
  //   });
  // }

  List selectedIndexes = []; // Store selected item indexes
  bool isSelecting = false; // Toggle selection mode
  int bitRate = 320000; // Default Bitrate for "High"
  int sampleRate = 44100; // Default Sample Rate for "High"
  double sliderValueMicroPhone = 1; // Default value for medium quality
  List micriphoneSensitivityList = ['Low', 'Medium', 'High'];
  String selectedSenivity = "Medium";
  void setQuality(double value) {
    if (value < 0.5) {
      bitRate = 64000; // Lower bit rate
      sampleRate = 16000; // Lower sample rate
      selectedSenivity = "Low";
    } else if (value >= 0.5 && value < 1.5) {
      bitRate = 128000; // Medium bit rate
      sampleRate = 22050; // Medium sample rate
      selectedSenivity = "Medium";
    } else {
      bitRate = 320000; // High bit rate
      sampleRate = 44100; // High sample rate
      selectedSenivity = "High";
    }
    sliderValueMicroPhone = value;

    update();
  }

  void checkDays(value) {
    if (value == "1 day") {
      selectedDeleteFiles = 1;
    } else if (value == "7 days") {
      selectedDeleteFiles = 7;
    } else if (value == "14 days") {
      selectedDeleteFiles = 14;
    } else {
      selectedDeleteFiles = 30;
    }

    update();
  }

  int selectedDeleteFiles = 0;
  List dateFormat = ["dd-MM-yyyy", "MM-dd-yyyy"];
  List autoFile = ["1 day", "7 days", "14 Days"];
  bool IsloadedSetting = false;
  String selectedDateFormat = "";
  String selectedautoDelete = "";
  updateSelectedDateFormat(value) {
    selectedDateFormat = value;
    update();
    updateSetting();
  }

  updateSelectedautoDelete(value) {
    selectedautoDelete = value;
    update();
    checkDays(value);
    updateSetting();
  }

  void getSetting() async {
    HomepageService().getSeting().then((value) {
      switch (value.statusCode) {
        case 200:
          IsloadedSetting = true;
          final decodedData = jsonDecode(value.body);
          // Extract the items array
          var items = decodedData['data']['items'];

          // Filter the item where 'userid' == 3
          var filteredItem = items.firstWhere((item) => item['userid'] == 11,
              orElse: () => null);

          selectedDateFormat = filteredItem["date_format"];
          selectedSenivity = filteredItem["microphone_sensitivity"];
          if (selectedSenivity == "Low") {
            bitRate = 64000; // Lower bit rate
            sampleRate = 16000; // Lower sample rate
            sliderValueMicroPhone = 0.5;
          } else if (selectedSenivity == "Medium") {
            bitRate = 128000; // Medium bit rate
            sampleRate = 22050; // Medium sample rate
            sliderValueMicroPhone = 1;
          } else {
            bitRate = 320000; // High bit rate
            sampleRate = 44100; // High sample rate
            sliderValueMicroPhone = 2;
          }
          selectedDeleteFiles = filteredItem["auto_file_deletion"];
          if (selectedDeleteFiles == 1) {
            selectedautoDelete = "1 day";
          } else if (selectedDeleteFiles == 7) {
            selectedautoDelete = "7 days";
          } else if (selectedDeleteFiles == 14) {
            selectedautoDelete = "14 Days";
          }
          update();
          break;
        case 401:
          //   Get.offAndToNamed("/login");
          //DialogHelper.showErroDialog(description: "Token not valid");
          break;
        case 1:
          break;
        default:
          break;
      }
    });
  }

  var userDetails;
  void getUser() async {
    HomepageService().getUser().then((value) {
      switch (value.statusCode) {
        case 200:
          final decodedData = jsonDecode(value.body);
          userDetails = decodedData["data"];
          update();
          break;
        case 401:
          //   Get.offAndToNamed("/login");
          //DialogHelper.showErroDialog(description: "Token not valid");
          break;
        case 1:
          break;
        default:
          break;
      }
    });
  }

  void updateSetting() async {
    HomepageService()
        .updateSetting(
            selectedSenivity, selectedDateFormat, selectedDeleteFiles)
        .then((value) {
      switch (value.statusCode) {
        case 200:
          Loaders.customToast(message: "Setting Updated");
          update();
          break;
        case 401:
          //   Get.offAndToNamed("/login");
          //DialogHelper.showErroDialog(description: "Token not valid");
          break;
        case 1:
          break;
        default:
          break;
      }
    });
  }
}
