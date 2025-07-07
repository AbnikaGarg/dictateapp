import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/homeController.dart';
import '../../theme/app_theme.dart';
import '../folder/folder.dart';
import '../setting/setting.dart';
import 'home.dart';
import 'record.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final controller = Get.put<HomepageController>(HomepageController());

  List bottomItems = [
    {"title": "Dictations", "svg": Icons.mic_none_rounded},
    {"title": "Folder", "svg": Icons.folder_copy_outlined},
    {"title": "Settings", "svg": CupertinoIcons.settings}
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (controller) => Scaffold(
        body: WillPopScope(
                onWillPop: () async {
                  if (controller.tabIndex == 0) {
                    SystemNavigator.pop();
                  } else {
                    // _navigatorKey.currentState!.pop();
                    controller.updateBack();
                    return false;
                  }
                  return false;
                },
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              AudioPage(),
              Home(type: 0, title: 'Main Folder',),
              Setting(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          decoration: BoxDecoration(
              // boxShadow: const [
              //   BoxShadow(
              //       color: Color.fromARGB(17, 0, 0, 0),
              //       blurRadius: 12,
              //       spreadRadius: 2,
              //       offset: Offset(1, 1)),
              // ],
              color: Color.fromARGB(255, 218, 232, 225),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  bottomItems.length,
                  (index) => InkWell(
                        onTap: () {
                          controller.changeTabIndex(index);
                        },
                        child: AnimatedContainer(
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 400),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(bottomItems[index]["svg"],
                                    size: 22,
                                    color: index == controller.tabIndex
                                            ? const Color.fromARGB(255, 21, 134, 6)
                                        : Colors.black38),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  bottomItems[index]["title"],
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: index == controller.tabIndex
                                          ? const Color.fromARGB(255, 21, 134, 6)
                                          : Colors.black38,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )),
                      ))),
        ),
      ),
    );
  }
}
