import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:speechtotext/models/DictationsDataModel.dart';
import 'package:speechtotext/services/shared_pref.dart';
import '../components/loaders.dart';
import '../services/home_repo.dart';
import '../view/home/bottombar.dart';
import '../view/home/play_audio.dart';
import 'recordController.dart';

class HomepageController extends GetxController {
  void changeTabIndex(int index) {
    tabIndex = index;
    debugPrint(index.toString());
    if (index == 1) {
      // getAllDictations(0);
      getAllFolders();
      getAllDictations(0);
      title = "Main Folder";
      type = 0;
      // Get.to(Home(
      //   type: 0,
      //   title: "Main Folder",
      // ));
    } else {
      Get.find<Recordcontroller>().checkPermission();
      // Get.find<Recordcontroller>().scrollController.animateTo(
      //       0.0,
      //       curve: Curves.easeOut,
      //       duration: const Duration(milliseconds: 600),
      //     );
      if (isPlaying) {
        audioPlayer.pause();
        isPlaying = false;
      }
    }
    update();
  }

  var tabIndex = 0;
  bool isPlaying = false;
  void dispose() {
    super.dispose();
  }

  updateBack() {
    tabIndex = 0;
    update();
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

  @override
  void onInit() {
    super.onInit();
    // getAllDictations();
    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        // countaa = countaa + 1;
        print("dcjdjbdcdcbdjbjd");
        isPlaying = false;
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
        debugPrint(playerState.playing.toString());
        update();
      }
    });
    tabIndex = 0;
    update();
    //getAllFolders();
    //clearFiles();
    //setupAudio() ;
    getAllFolders();
    getAllDictations(0);
    print("home");
  }

  skip5SecondsForward() {
    var currentPosition = audioPlayer.position.inSeconds;
    var newPosition = currentPosition + 5;

    // Ensure the new position does not exceed the maximum duration
    if (newPosition < max.value) {
      var duration = Duration(seconds: newPosition);
      audioPlayer.seek(duration);
    } else {
      audioPlayer.seek(Duration(seconds: max.value.toInt()));
    }

    update();
  }

  Data? selectedData;
  editDictation(Data data) {
    selectedData = data;
    isPlaying = false;
    audioPlayer.pause();
    setFile(data.dictationsdataUrl);
    update();
    Get.to(AudioPlayerPage());
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

    update();
  }

  pausePlaySong(id) {
    if (isPlaying) {
      audioPlayer.pause();
      isPlaying = false;
    } else {
      selectLastOpened(id.toString());
      audioPlayer.play();
      isPlaying = true;
    }

    update();
  }

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    int tenths =
        (duration.inMilliseconds % 1000) ~/ 100; // Get first decimal digit

    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$tenths";
  }

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isLoaded = false;
  bool isLoadedDic = false;
  List<DictationsDataModel> dictationsDataList = [];
  bool isSorted = false;

  sort() {
    isSorted = !isSorted;
    if (isSorted) {
      dictationsDataList.first.data!.sort((a, b) =>
          DateTime.parse(b.fileUploadedDateTime!)
              .compareTo(DateTime.parse(a.fileUploadedDateTime!)));
    } else {
      dictationsDataList.first.data!.sort((a, b) =>
          DateTime.parse(a.fileUploadedDateTime!)
              .compareTo(DateTime.parse(b.fileUploadedDateTime!)));
    }
    update();
  }

  int mainFolderCount = 0;

  List<Data> lastOpenedList = [];
  void getAllDictations(type) async {
    lastOpened = PreferenceUtils.getStringList('lastOpened');
    // if (type == -1) {
    //   type = 0;
    // }
    dictationsDataList.clear();
      isLoadedDic = false;update();
    HomepageService().getDictations(type == -1 ? 0 : type).then((value) {
      switch (value.statusCode) {
        case 200:
          isLoadedDic = true;
          final decodedData = jsonDecode(value.body);
          isSelecting = false;
          dictationsDataList.add(DictationsDataModel.fromJson(decodedData));
          update();

          if (dictationsDataList.isNotEmpty) {
            if (dictationsDataList.first.data!.isNotEmpty) {
              mainFolderCount = dictationsDataList.first.data!.where(
                (element) {
                  return element.is_local != false;
                },
              ).length;
                update();
              if (type == -1) {
                lastOpenedList = lastOpened
                    .map((id) => dictationsDataList.first.data!.firstWhere(
                          (item) {
                            print(id);
                            return item.id.toString() == id;
                          },
                          orElse: () => Data(), // Return null if not found
                        ))
                    .where((item) => item.id.toString() != "null")
                    .toList();
                if (lastOpenedList.isNotEmpty) {
                  setFile(lastOpenedList[0].dictationsdataUrl);
                }
              } else {
                setFile(dictationsDataList.first.data![0].dictationsdataUrl);
              }
            }
          }

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

  int selectedIndex = 0;
  changeIndex(value, file) {
    isPlaying = false;
    audioPlayer.pause();
    selectedIndex = value;
    update();
    setFile(file);
  }

  Future<void> setFile(file) async {
    try {
      if (file != null) {
        // if (!audioPlayer.playing) {
        await audioPlayer.setUrl(file!);
        updatePostion();
        //  }
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteREcor() async {
    Loaders.showLoading('Loading...');
    List selectedIds = dictationsDataList.first.data!
        .where((item) => item.isSelected!)
        .map((item) => item.id)
        .toList();

    HomepageService().DeleteDictationList(selectedIds, 1).then((value) {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);
          Loaders.successSnackBar(
              message: "Deleted Successfully", title: "Success");
          getAllDictations(0);
          //  selectEdit();
          isSelecting = false;
          update();
          //  Get.offAll(DashboardScreen());
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

  bool isSelecting = false; // Toggle selection mode
  updateDictationUrlSelected(index) {
    dictationsDataList.first.data![index].isSelected =
        !dictationsDataList.first.data![index].isSelected!;

    if (dictationsDataList.first.data!.any(
      (element) => element.isSelected == true,
    )) {
      isSelecting = true;
    } else {
      isSelecting = false;
    }

    update();
  }

  selectEdit() {
    isSelecting = !isSelecting;
    if (!isSelecting) {
      dictationsDataList.first.data!.forEach((item) {
        item.isSelected = false;
      });
    }
    update();
  }

  void saveMultipleRecording(type) async {
    Loaders.showLoading('Loading...');
    List selectedIds = dictationsDataList.first.data!
        .where((item) => item.isSelected! && item.is_ftp == false)
        .map((item) => item.id)
        .toList();
    HomepageService().uploadServcer(selectedIds).then((value) {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);
          Loaders.successSnackBar(
              message: "Uploaded Successfully", title: "Success");
          getAllDictations(type);
          //  selectEdit();
          isSelecting = false;
          update();
          //  Get.offAll(DashboardScreen());

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

  List folders = [];

  void getAllFolders() async {
      if (isPlaying) {
        audioPlayer.pause();
        isPlaying = false;
      }
    folders.clear();
    HomepageService().getFolders().then((value) {
      switch (value.statusCode) {
        case 200:
          isLoaded = true;
          final decodedData = jsonDecode(value.body);
          folders = decodedData["data"];
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

  List<String> lastOpened = [];

  Future<void> selectLastOpened(value) async {
    // Remove if it already exists to avoid duplicates
    lastOpened = PreferenceUtils.getStringList('lastOpened');

    lastOpened.remove(value);

    // Add to the front (most recent first)
    lastOpened.insert(0, value);

    // Keep only the last 10
    if (lastOpened.length > 10) {
      lastOpened = lastOpened.sublist(0, 10);
    }
    await PreferenceUtils.setStringList('lastOpened', lastOpened);

    print("🗂️ Recent Files: $lastOpened");
  }

  String title = "Main Folder";
  int type = 0;

  selectFoler(mainTitle, MainType) {
    title = mainTitle;
    type = MainType;
      if (isPlaying) {
        audioPlayer.pause();
        isPlaying = false;
      }
    Get.back();
    getAllDictations(type);
    update();
  }
}
