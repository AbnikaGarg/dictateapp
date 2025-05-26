import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:just_audio/just_audio.dart';

import 'package:speechtotext/theme/app_theme.dart';

import '../../controllers/homeController.dart';
import '../../controllers/recordController.dart';

class AudioPlayerPage extends StatelessWidget {
  AudioPlayerPage({super.key});
  final controller = Get.put<HomepageController>(HomepageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictation'),
      ),
      body: GetBuilder<HomepageController>(builder: (controller) {
        return Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.centerEnd,
          children: [
            // Image.asset(
            //  "assets/images/pro.png",
            //   colorBlendMode: BlendMode.darken,
            //   color: AppTheme.whiteColor.withOpacity(0.8),
            //   alignment: Alignment.center,
            //   fit: BoxFit.cover,
            // ),
            // ImageFiltered(
            //     imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            //     child: Image.asset(
            //       "assets/images/shiv.png",
            //       fit: BoxFit.cover,
            //     )),
            Positioned.fill(
              left: 16,
              right: 16,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.mic,
                          size: 60,
                          color: AppTheme.whiteColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Text(
                        "${controller.selectedData!.filename}",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppTheme.black,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Obx(
                      () => SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 4,
                          rangeThumbShape: RoundRangeSliderThumbShape(
                            enabledThumbRadius: 8,
                            disabledThumbRadius: 5,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 4,
                          ),
                          activeTickMarkColor: Colors.transparent,
                          inactiveTickMarkColor: Colors.transparent,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Slider(
                            max: controller.max.value,
                            value: controller.slidervalue.value,
                            onChanged: (value) {
                              value = value;
                              controller.changeValueinDuration(value.toInt());
                            },
                            min: 0,
                            label: "2",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.postion.value,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                height: 0,
                                color: AppTheme.lightText,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            controller.duration.value,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                height: 0,
                                color: AppTheme.lightText,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.skip5SecondsBackward();
                          },
                          child: Icon(
                            Icons.fast_rewind,
                            color: AppTheme.lightText,
                            size: 36,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.pausePlaySong(controller.selectedData!.id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: AppTheme.lightText,
                                shape: BoxShape.circle),
                            child: Icon(
                              !controller.isPlaying == false
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40,
                              color: AppTheme.whiteColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.skip5SecondsForward();
                          },
                          child: Icon(
                            Icons.fast_forward,
                            color: AppTheme.lightText,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.deleteREcor();
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "Delete",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    height: 0,
                                    color: AppTheme.whiteColor,
                                    fontWeight: FontWeight.w500),
                              )),
                        )
                      ],
                    )
                  ]),
            )
          ],
        );
      }),
    );
  }
}
