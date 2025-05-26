// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:speechtotext/controllers/homeController.dart';
// import 'package:speechtotext/models/DictationsDataModel.dart';
// import 'package:speechtotext/theme/app_theme.dart';
// import 'package:speechtotext/view/home/play_audio.dart';
// import 'package:speechtotext/view/home/record.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class UploaddedData extends StatelessWidget {
//   UploaddedData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         backgroundColor: AppTheme.whiteDullColor,
//         title: Text(
//           "Uploaded Files",
//           style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         child: GetBuilder<HomepageController>(builder: (_controller) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 if (_controller.dictationsDataList.isNotEmpty)
//                   ListView.builder(
//                     itemCount:
//                         _controller.dictationsDataList.first.data!.length,
//                     shrinkWrap: true,
//                     primary: false,
//                     itemBuilder: (context, index) {
//                       // bool isSelected = selectedIndexes.contains(index);
//                       return buildFolderRow(context, index,
//                           _controller.dictationsDataList.first.data![index]);
//                     },
//                   ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget buildFolderRow(BuildContext context, int index, Data data) {
//     return GestureDetector(
//       onLongPress: () {},
//       onTap: () {
//         //  Get.to(AudioPlayerPage(),transition: Transition.downToUp);
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: AppTheme.whiteColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Image.asset("assets/images/pro.png"),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${data.filename}",
//                     style: GoogleFonts.inter(
//                         fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 4),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "${data.fileUploadedDateTime!.substring(0, 10)}",
//                         style: GoogleFonts.inter(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             color: AppTheme.lightText),
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             "${data.fileDuration!}  ",
//                             style: GoogleFonts.inter(
//                                 color: AppTheme.primaryColor,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           Icon(
//                             Icons.play_circle_rounded,
//                             size: 30,
//                             color: AppTheme.primaryColor,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
