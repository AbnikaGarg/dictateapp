// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../components/dailogs.dart';

// import '../../controllers/file_reviewControoller.dart';
// import '../../theme/app_theme.dart';
// import 'bottombar.dart';

// class ReviewFile extends StatefulWidget {
//   const ReviewFile({super.key, required this.fileName, required this.filePath});
//   final String fileName;
//   final String filePath;

//   @override
//   State<ReviewFile> createState() => _ReviewFileState();
// }

// class _ReviewFileState extends State<ReviewFile> {
//   final controller = Get.put<FileReviewcontrooller>(FileReviewcontrooller());

//   Future<bool> _onWillPop() async {
//     TDialogs.defaultDialog(
//       title: "Discard",
//       content: "Are you sure you don't want to save the file",
//       context: Get.context!,
//       onConfirm: () {
//         Get.offAll(DashboardScreen());
//       },
//     );
//     return true;
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller.setFile(widget.filePath);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('File Review'),
//             elevation: 0,
//             backgroundColor: AppTheme.whiteColor,
//           ),
//           body: GetBuilder<FileReviewcontrooller>(builder: (_controller) {
//             return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14),
//                 child: Obx(
//                   () => Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 20),
//                       Text(
//                         widget.fileName,
//                         style: GoogleFonts.inter(
//                             color: AppTheme.black,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 30),
//                       SliderTheme(
//                         data: const SliderThemeData(
//                           trackHeight: 4,
//                           rangeThumbShape: RoundRangeSliderThumbShape(
//                             enabledThumbRadius: 8,
//                             disabledThumbRadius: 5,
//                           ),
//                           overlayShape: RoundSliderOverlayShape(
//                             overlayRadius: 4,
//                           ),
//                           activeTickMarkColor: Colors.transparent,
//                           inactiveTickMarkColor: Colors.transparent,
//                         ),
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: Slider(
//                             max: _controller.max.value,
//                             value: _controller.slidervalue.value,
//                             onChanged: (value) {
//                               value = value;
//                               _controller.changeValueinDuration(value.toInt());
//                             },
//                             min: 0,
//                             label: "2",
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 3),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _controller.postion.value,
//                             style: GoogleFonts.poppins(
//                                 fontSize: 12,
//                                 height: 0,
//                                 color: AppTheme.lightText,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           Text(
//                             _controller.duration.value,
//                             style: GoogleFonts.poppins(
//                                 fontSize: 12,
//                                 height: 0,
//                                 color: AppTheme.lightText,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         onPressed: _controller.pausePlaySong,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.primaryColor,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 30, vertical: 12),
//                         ),
//                         child: Text(
//                           _controller.isPlaying
//                               ? 'Pause Recording'
//                               : 'Play Recording',
//                           style: TextStyle(
//                               color: AppTheme.whiteColor, fontSize: 16),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         onPressed: () {
//                           TDialogs.defaultDialog(
//                             title: "Save",
//                             content:
//                                 "Are you sure you want to save the file",
//                             context: Get.context!,
//                             onConfirm: () {
//                                 _controller.saveRecording(widget.filePath,widget.fileName);
//                             },
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.darkprimaryColor,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 30, vertical: 12),
//                         ),
//                         child: Text(
//                           'Share Recording',
//                           style: TextStyle(
//                               color: AppTheme.whiteColor, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ));
//           })),
//     );
//   }
// }
