// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../components/text_feilds.dart';
// import '../../controllers/homeController.dart';
// import '../../theme/app_theme.dart';

// class Favorites extends StatefulWidget {
//   const Favorites({super.key});

//   @override
//   State<Favorites> createState() => _FavoritesState();
// }

// class _FavoritesState extends State<Favorites> {
//   List selectedIndexes = []; // Store selected item indexes
//   bool isSelecting = false; // Toggle selection mode

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         titleSpacing: 0,
//         backgroundColor: AppTheme.whiteDullColor,
//         title: Text(
//           isSelecting ? "${selectedIndexes.length} Selected" : "Local Files",
//           style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
//         ),
//         actions: isSelecting
//             ? [
//                 // IconButton(
//                 //   icon: Icon(CupertinoIcons.cloud_upload,
//                 //       size: 26, color: Colors.blue),
//                 //   onPressed: () {
//                 //     setState(() {
//                 //       selectedIndexes.clear();
//                 //       isSelecting = false;
//                 //     });
//                 //   },
//                 // ),
//                 IconButton(
//                   icon:
//                       Icon(CupertinoIcons.delete, size: 20, color: Colors.red),
//                   onPressed: () {
//                     setState(() {
//                       Get.find<HomepageController>()
//                           .deleteFiles(selectedIndexes);
//                       selectedIndexes.clear();
//                       isSelecting = false;
//                     });
//                   },
//                 )
//               ]
//             : [],
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: isSelecting
//           ? InkWell(
//               onTap: () {
//                 Get.find<HomepageController>().saveRecording(selectedIndexes);
//                 // profileBottomsheet(
//                 //   context,
//                 //   () {},
//                 //   () {},
//                 // );
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 45,
//                 margin: EdgeInsets.symmetric(horizontal: 30),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                     color: AppTheme.primaryColor,
//                     borderRadius: BorderRadius.circular(50)),
//                 child: Text(
//                   "Upload to FTP",
//                   style: GoogleFonts.inter(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.whiteColor),
//                 ),
//               ),
//             )
//           : Container(),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             MyTextField(
//                 preicon: Icon(CupertinoIcons.search),
//                 hintText: " Search.....",
//                 color: const Color(0xff585A60)),
//             SizedBox(height: 20),
//             GetBuilder<HomepageController>(builder: (_controller) {
//               return _controller.isLoadeedLocal
//                   ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : _controller.fileNames.length > 0
//                       ? Expanded(
//                           child: ListView.builder(
//                             itemCount: _controller.fileNames.length,
//                             itemBuilder: (context, index) {
//                               bool isSelected = selectedIndexes.contains(
//                                   _controller.fileNames[index]["path"]);
//                               return buildFolderRow(context, index, isSelected,
//                                   _controller.fileNames[index]);
//                             },
//                           ),
//                         )
//                       : Center(
//                           child: Text("No Data"),
//                         );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildFolderRow(
//       BuildContext context, int index, bool isSelected, var data) {
//     return GestureDetector(
//       onLongPress: () {
//         setState(() {
//           isSelecting = true;
//           if (!selectedIndexes.contains(data["path"])) {
//             selectedIndexes.add(data["path"]);
//             Get.find<HomepageController>().selectedList(index);
//           }
//         });
//       },
//       onTap: () {
//         if (isSelecting) {
//           setState(() {
//             if (selectedIndexes.contains(data["path"])) {
//               selectedIndexes.remove(data["path"]);
//               Get.find<HomepageController>().selectedList(index);
//             } else {
//               selectedIndexes.add(data["path"]);
//               Get.find<HomepageController>().selectedList(index);
//             }
//             if (selectedIndexes.isEmpty) isSelecting = false;
//           });
//         } else {
//           Get.to(Favorites());
//         }
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 10),
//         padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.shade100 : AppTheme.whiteColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             isSelecting
//                 ? Checkbox(
//                     value: isSelected,
//                     onChanged: (value) {
//                       setState(() {
//                         if (value == true) {
//                           selectedIndexes.add(data["path"]);
//                         } else {
//                           selectedIndexes.remove(index);
//                         }
//                         if (selectedIndexes.isEmpty) isSelecting = false;
//                       });
//                     },
//                   )
//                 : Image.asset("assets/images/pro.png"),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${data["name"]}",
//                     style: GoogleFonts.inter(
//                         fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "${data["date"]}",
//                     style: GoogleFonts.inter(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: AppTheme.lightText),
//                   ),
//                 ],
//               ),
//             ),
//             // Row(
//             //   children: [
//             //     Text(
//             //       "5:00  ",
//             //       style: GoogleFonts.inter(
//             //           color: AppTheme.primaryColor,
//             //           fontSize: 14,
//             //           fontWeight: FontWeight.w500),
//             //     ),
//             //     Icon(
//             //       Icons.play_circle_rounded,
//             //       size: 30,
//             //       color: AppTheme.primaryColor,
//             //     ),
//             //   ],
//             // )
//           ],
//         ),
//       ),
//     );
//   }

//   profileBottomsheet(context, VoidCallback setting, VoidCallback editprofile) {
//     Get.bottomSheet(
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       GestureDetector(
//         behavior: HitTestBehavior.opaque, // add this
//         onTap: (() {
//           Get.back();
//         }),
//         child: DraggableScrollableSheet(
//             initialChildSize: 0.3,
//             minChildSize: 0.3,
//             maxChildSize: 0.9,
//             builder: (_, controller) {
//               return IgnorePointer(
//                 ignoring: false,
//                 child: GestureDetector(
//                   onTap: () => null,
//                   child: Container(
//                       decoration: BoxDecoration(
//                         color: Get.theme.scaffoldBackgroundColor,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(25.0),
//                           topRight: Radius.circular(25.0),
//                         ),
//                       ),
//                       alignment: Alignment.center,
//                       child: Stack(
//                         children: [
//                           Column(
//                             children: [
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Center(
//                                 child: Container(
//                                   width: 40,
//                                   height: 3,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 16),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {},
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.email_outlined,
//                                             size: 22,
//                                           ),
//                                           Text(
//                                             "  Email ",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(fontSize: 16),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                     ),
//                                     GestureDetector(
//                                       behavior: HitTestBehavior.opaque,
//                                       onTap: editprofile,
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.cloud_upload_outlined,
//                                             size: 22,
//                                           ),
//                                           Text(
//                                             "  Upload into FTP",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(fontSize: 16),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 30,
//                                     ),
//                                     GestureDetector(
//                                       behavior: HitTestBehavior.opaque,
//                                       onTap: setting,
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.drive_folder_upload_outlined,
//                                             size: 22,
//                                           ),
//                                           Text(
//                                             "  Upload into Drive",
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .displayLarge!
//                                                 .copyWith(fontSize: 16),
//                                           )
//                                         ],
//                                       ),
//                                     ),

//                                     // Row(
//                                     //   children: [
//                                     //     Image.asset(
//                                     //         "assets/images/appIcon.png"),
//                                     //     //   SvgPicture.asset("assets/icons/menem.svg"),
//                                     //     ShaderMask(
//                                     //       shaderCallback: (size) =>
//                                     //           const LinearGradient(
//                                     //         colors: [
//                                     //           Color.fromRGBO(38, 130, 255, 1),
//                                     //           Color.fromRGBO(255, 227, 2, 1),
//                                     //         ],
//                                     //         begin: Alignment.topCenter,
//                                     //         end: Alignment.bottomCenter,
//                                     //       ).createShader(
//                                     //         Rect.fromLTWH(0, 0, size.width,
//                                     //             size.height + 5),
//                                     //       ),
//                                     //       child: Text(
//                                     //         '  Use AI to auto generate',
//                                     //         style: GoogleFonts.inter(
//                                     //           fontSize: 16.sp,
//                                     //           fontWeight: FontWeight.w400,
//                                     //           color: Colors.white,
//                                     //         ),
//                                     //       ),
//                                     //     ),
//                                     //   ],
//                                     // ),
//                                     //  GestureDetector(
//                                     //   behavior: HitTestBehavior.opaque,
//                                     //   onTap: (() {
//                                     //     Get.back();
//                                     //     Get.toNamed(Routes.ADDEBATTLE);
//                                     //   }),
//                                     //   child: Row(
//                                     //     children: [
//                                     //       SvgPicture.asset(
//                                     //         "assets/icons/explore.svg",
//                                     //         color:
//                                     //             Theme.of(context).canvasColor,
//                                     //       ),
//                                     //       Text(
//                                     //         "  Create a Activity",
//                                     //         style: Theme.of(context)
//                                     //             .textTheme
//                                     //             .displayLarge!
//                                     //             .copyWith(fontSize: 16.sp),
//                                     //       )
//                                     //     ],
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )),
//                 ),
//               );
//             }),
//       ),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//     );
//   }
// }
