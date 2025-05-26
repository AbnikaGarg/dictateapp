// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:record/record.dart';
// import 'package:speechtotext/models/DictationsDataModel.dart';
// import 'package:speechtotext/view/home/file_review.dart';
// import 'package:intl/intl.dart';
// import '../components/loaders.dart';
// import '../services/home_repo.dart';
// import '../view/home/bottombar.dart';

// class FileReviewcontrooller extends GetxController {
//   var duration = "".obs;
//   var postion = ''.obs;
//   int selectedid = 0;

//   var max = 0.0.obs;
//   var slidervalue = 0.0.obs;
//   bool isPlaying = false;
//   final AudioPlayer audioPlayer = AudioPlayer();
//   @override
//   void onInit() {
//     super.onInit();
//     audioPlayer.playerStateStream.listen((playerState) {
//       if (playerState.processingState == ProcessingState.completed) {
//         // countaa = countaa + 1;
//         print("dcjdjbdcdcbdjbjd");
//         isPlaying = false;
//         audioPlayer.seek(Duration.zero);
//         audioPlayer.pause();
//         debugPrint(playerState.playing.toString());
//         update();
//       }
//     });

//     print("Player");
//   }

//   pausePlaySong() {
//     if (isPlaying) {
//       audioPlayer.pause();
//       isPlaying = false;
//     } else {
//       audioPlayer.play();
//       isPlaying = true;
//     }

//     update();
//   }

//   updatePostion() {
//     audioPlayer.durationStream.listen((event) {
//       duration.value = event.toString().split(".")[0];
//       max.value = event!.inSeconds.toDouble();
//     });
//     audioPlayer.positionStream.listen((event) {
//       postion.value = event.toString().split(".")[0];
//       slidervalue.value = event.inSeconds.toDouble();
//     });

//     update();
//   }
// //0:00:00.0
//   changeValueinDuration(seconds) {
//     if (audioPlayer.playing) {
//       isPlaying = true;
//     }
//     var duration = Duration(seconds: seconds);
//     audioPlayer.seek(duration);
//     update();
//   }

//   Future<void> setFile(file) async {
//     if (file != null) {
//       if (!audioPlayer.playing) {
//         await audioPlayer.setAsset(file!);
//         updatePostion();
//       }
//     }
//   }

//   void saveRecording(filepath, fileName) async {
//     Loaders.showLoading('Loading...');
//     final file = File(filepath!);
//     List<int> fileBytes = await file.readAsBytes();

//     // Encode the file bytes to Base64
//     String base64String = base64Encode(fileBytes);
//     HomepageService()
//         .createDictation(fileName, "2025-03-21T10:08:51.490Z", base64String,
//             "1 mb", duration.value.toString())
//         .then((value) {
//       print(value.statusCode);
//       Loaders.hideLoading();
//       switch (value.statusCode) {
//         case 200:
//           var data2 = jsonDecode(value.body);
//           print(data2);
//           Loaders.successSnackBar(
//               message: "Uploaded Successfully", title: "Success");
//           Get.offAll(DashboardScreen());
//           break;
//         case 400:
//           // if (value.data["detail"] == "User is not verified") {
//           //   DialogHelper.showErroDialog(
//           //       description: "your email not registered with us");
//           //   // Get.toNamed(
//           //   //   Routes.SIGNUP,
//           //   // );
//           // }
//           Loaders.errorSnackBar(
//               message: "Something went wromg", title: "Error");

//           break;
//         case 401:
//           Loaders.errorSnackBar(
//               message: "Something went wromg", title: "Error");
//           break;

//         case 1:
//           break;
//         default:
//           Loaders.errorSnackBar(
//               message: "Something went wromg", title: "Error");
//           break;
//       }
//     });
//   }
// }
