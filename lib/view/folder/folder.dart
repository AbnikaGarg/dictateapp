import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechtotext/services/shared_pref.dart';
import 'package:speechtotext/view/folder/uploaded_data.dart';

import '../../components/text_feilds.dart';
import '../../controllers/homeController.dart';
import '../../theme/app_theme.dart';
import '../home/home.dart';
import 'favorites.dart';

class Folder extends StatelessWidget {
  Folder({super.key});
  final controller = Get.put<HomepageController>(HomepageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.whiteDullColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///  Image.asset("assets/images/pro.png"),
            Text(
              "   Folder",
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: GetBuilder<HomepageController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: controller.folders.isNotEmpty
              ? Column(
                  children: [
                    //   MyTextField(
                    //     preicon: Icon(CupertinoIcons.search),
                    //     //  textEditingController: _controller.email,

                    //     hintText: " Search.....",
                    //     color: const Color(0xff585A60)),
                    // SizedBox(
                    //   height: 30,
                    // ),
                    // buildFolderRow(context, "Local Audios", Image.asset("assets/images/playlist.png", height: 20,), () {
                    //   Get.to(Favorites());
                    // }),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          buildFolderRow(
                              context,
                              "Last Opened",
                              Image.asset(
                                "assets/images/clock.png",
                                height: 16,
                              ), () {
                            controller.selectFoler("Last Opened", -1);
                            //  Get.find<HomepageController>().getAllDictations(-1);
                            // Get.to(Home(
                            //   type: -1,
                            //   title: "Last Opened",
                            // ));
                          }, ""),
                          Divider(
                            height: 40,
                            thickness: 0.6,
                          ),
                          buildFolderRow(
                              context,
                              "Last Created",
                              Icon(
                                CupertinoIcons.create,
                                size: 18,
                              ), () {
                                 controller.selectFoler( "Last Created",1);
                           // Get.find<HomepageController>().getAllDictations(1);
                           
                          }, controller.folders[0]["count"]),
                          Divider(
                            height: 40,
                            thickness: 0.6,
                          ),
                          buildFolderRow(
                              context,
                              "Shared Files",
                              Icon(
                                CupertinoIcons.cloud_upload,
                                size: 18,
                              ), () {
                             controller.selectFoler( "Shared Files",2);
                          
                          }, controller.folders[1]["count"]),
                          Divider(
                            height: 40,
                            thickness: 0.6,
                          ),
                          buildFolderRow(
                              context,
                              "Unshared Files",
                              Icon(
                                CupertinoIcons.clock,
                                size: 18,
                              ), () {
                                 controller.selectFoler( "Unshared Files",3);
                         //   Get.find<HomepageController>().getAllDictations(3);
                            // Get.to(Home(
                            //   type: 3,
                            //   title: "Unshared Files",
                            // ));
                          }, controller.folders[2]["count"]),
                          Divider(
                            height: 40,
                            thickness: 0.6,
                          ),
                          buildFolderRow(
                              context,
                              "Trash Files",
                              Icon(
                                CupertinoIcons.delete,
                                size: 18,
                              ), () {
                                  controller.selectFoler("Trash Files",4);
                           
                          }, controller.folders[3]["count"])
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (controller.dictationsDataList.isNotEmpty)
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                              color: AppTheme.whiteColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [
                            buildFolderRow(
                                context,
                                "Main Folder",
                                Icon(
                                  CupertinoIcons.folder,
                                  size: 18,
                                ), () {
                                   controller.selectFoler("Main Folder",0);
                            
                            },
                                controller.mainFolderCount
                                    .toString()),
                          ]))
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }

  buildFolderRow(context, title, icon, ontap, count) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          icon,
          Expanded(
              child: Text(
            "   $title",
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          )),
          Text(
            "   $count",
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
