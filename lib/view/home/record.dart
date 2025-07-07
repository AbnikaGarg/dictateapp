import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechtotext/theme/app_theme.dart';
import 'package:speechtotext/view/setting/profile.dart';
import '../../controllers/recordController.dart';
import '../../models/DictationsDataModel.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final controller = Get.put<Recordcontroller>(Recordcontroller());
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final tenths = (duration.inMilliseconds.remainder(1000) ~/ 100);

    return "$hours.$minutes.$seconds.$tenths";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Recordcontroller>(builder: (_controller) {
      return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_controller.isRecording) {
                      _controller.discardRecord();
                    }
                  },
                  child: Text(
                    "New",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: _controller.isRecording
                            ? AppTheme.primaryColor
                            : Color.fromARGB(255, 21, 134, 6)),
                  ),
                ),
              ),
            ),
            title: Text(
              _controller.isSilent ? "No Voice" : 'Dictation',
              style: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600, fontSize: 18),
            ),
            elevation: 0,
            centerTitle: true,
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 20),
              //   child: GestureDetector(
              //     onTap: () {
              //       if (_controller.isRecording) {
              //         _controller.stopRecording();
              //       }
              //     },
              //     child: Text(
              //       "Share",
              //       style: GoogleFonts.inter(
              //           fontWeight: FontWeight.w600,
              //           fontSize: 14,
              //           color: _controller.isRecording
              //               ? AppTheme.primaryColor
              //               : AppTheme.textBlackColor),
              //     ),
              //   ),
              // )
              Container(
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                    onTap: () {
                      _controller.getUser();
                      Get.to(Profile());
                      //  }
                    },
                    child: Icon(
                      CupertinoIcons.person_alt_circle,
                      size: 30,
                    )),
              ),
            ],
            backgroundColor: _controller.isSilent
                ? Color.fromARGB(255, 244, 227, 76)
                : AppTheme.whiteColor,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: controller.isSelecting
              ? Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.saveMultipleRecording(
                                controller.selectedIndexes);
                            // profileBottomsheet(
                            //   context,
                            //   () {},
                            //   () {},
                            // );
                          },
                          child: Container(
                            height: 45,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Upload",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.whiteColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.deleteFiles(controller.selectedIndexes);
                            // profileBottomsheet(
                            //   context,
                            //   () {},
                            //   () {},
                            // );
                          },
                          child: Container(
                            height: 45,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Delete",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.whiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text(
                //   _controller.isRecording
                //       ? "Recording: ${formatDuration(_controller.recordingSeconds)} sec"
                //       : "Start Recording",
                //   style: GoogleFonts.inter(
                //       fontSize: 16, fontWeight: FontWeight.w500),
                // ),
                // const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 218, 232, 225),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(207, 0, 0, 0),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(17, 77, 76, 76),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: Offset(1, 1)),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        AudioWaveforms(
                          enableGesture: true,
                          shouldCalculateScrolledPosition: true,
                          size: Size(MediaQuery.of(context).size.width, 120),
                          recorderController: _controller.recorderController,
                          waveStyle: const WaveStyle(
                            scaleFactor: 60,
                            waveColor: Color.fromARGB(255, 30, 91, 157),
                            extendWaveform: true,
                            spacing: 7,
                            middleLineColor: Colors.blue,
                            showMiddleLine: false,
                            showTop: true,
                            waveThickness: 3,
                            waveCap: StrokeCap.butt,
                          ),
                          padding: const EdgeInsets.only(left: 18),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        SizedBox(height: 20),

                        Text(
                          _controller.isPaused && !_controller.isSilent
                              ? "⏸ Recording Paused"
                              : _controller.isSilent
                                  ? "⏸ Recording Paused (Silence Detected)"
                                  : "🎙 Recording: ${formatDuration(_controller.recordingSeconds)} sec",
                          style: TextStyle(
                              fontSize: 18,
                              color: _controller.isSilent
                                  ? const Color.fromARGB(255, 212, 196, 56)
                                  : AppTheme.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Obx(() => Column(children: [
                                SizedBox(height: 20),
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor:
                                        Colors.blue, // Customize as needed,
                                    trackHeight: 3,
                                    thumbShape: VerticalBarThumbShape(
                                      width: 3,
                                      height: 20,
                                      color: Colors.blue, // Customize as needed
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    activeTickMarkColor: Colors.transparent,
                                    inactiveTickMarkColor: Colors.transparent,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Slider(
                                      max: _controller.max.value,
                                      value: _controller.slidervalue.value,
                                      inactiveColor: const Color.fromARGB(
                                          255, 180, 183, 180),
                                      onChanged: (value) {
                                        value = value;
                                        _controller.changeValueinDuration(
                                            value.toInt());
                                      },
                                      min: 0,
                                      label: "2",
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _controller.postion.value,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          height: 0,
                                          color: AppTheme.lightText,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      formatDuration(_controller.recordingSeconds),
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          height: 0,
                                          color: AppTheme.lightText,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ])),
                        ),
                        SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         _controller.skip5SecondsBackward();
                        //       },
                        //       child: Icon(
                        //         Icons.fast_rewind,
                        //         color: AppTheme.black,
                        //         size: 40,
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         if (_controller.isRecording &&
                        //             _controller.isPaused) {
                        //           _controller.pausePlaySong();
                        //         }
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //             color: AppTheme.black,
                        //             shape: BoxShape.circle),
                        //         child: Icon(
                        //           !_controller.isPlaying == false
                        //               ? Icons.pause
                        //               : Icons.play_arrow,
                        //           size: 30,
                        //           color: AppTheme.whiteColor,
                        //         ),
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         _controller.skip5SecondsForward();
                        //       },
                        //       child: Icon(
                        //         Icons.fast_forward,
                        //         color: AppTheme.black,
                        //         size: 40,
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_controller.isRecording &&
                                    _controller.isPaused) {
                                  _controller.skipToStart();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: _controller.isRecording &&
                                            _controller.isPaused
                                        ? Color.fromRGBO(204, 204, 204, 1)
                                        : Color.fromRGBO(215, 214, 216, 1),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.skip_previous,
                                  size: 25,
                                ),
                              ),
                            ),
                            // GestureDetector(
                            //
                            //   onTap: () {
                            //     if (!_controller.isRecording) {
                            //       _controller.startRecording();
                            //     } else {
                            //       if (_controller.isPaused) {
                            //         _controller.resumeRecording();
                            //       } else {
                            //         _controller.pauseRecording();
                            //       }
                            //     }
                            //   },
                            //   child: Container(
                            //       height: 80,
                            //       width: 80,
                            //       decoration: BoxDecoration(
                            //           color: Colors.red, shape: BoxShape.circle),
                            //       child: Center(
                            //         child: Text("Record",
                            //             style: GoogleFonts.inter(
                            //                 fontSize: 14,
                            //                 color: AppTheme.whiteColor,
                            //                 fontWeight: FontWeight.bold)),
                            //       )),
                            // ),
                            GestureDetector(
                              onTap: () {
                                if (!_controller.isRecording) {
                                  _controller.startRecording();
                                } else {
                                  if (_controller.isPaused) {
                                    _controller.resumeRecording();
                                  } else {
                                    _controller.pauseRecording();
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                    color: _controller.isSilent?Color.fromARGB(255, 231, 214, 61): Colors.red, shape: BoxShape.circle),
                                child: Icon(
                                  !_controller.isPaused &&
                                          _controller.isRecording
                                      ? Icons.pause
                                      : Icons.mic,
                                  size: 30,
                                  color: AppTheme.whiteColor,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_controller.isRecording &&
                                    _controller.isPaused) {
                                  _controller.skipToEnd();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: _controller.isRecording &&
                                            _controller.isPaused
                                        ? Color.fromRGBO(204, 204, 204, 1)
                                        : Color.fromRGBO(215, 214, 216, 1),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.skip_next,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (!_controller.isSaved)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                if (_controller.isRecording) {
                                  _controller.stopRecording(2);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                    color: _controller.isRecording
                                        ? AppTheme.primaryColor
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "Save and Share",
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppTheme.whiteColor),
                                ),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: _controller.isSaving
                                          ? Image.asset(
                                              "assets/images/check-circle.gif")
                                          : CircularProgressIndicator()),
                                  Text(
                                    _controller.isSaving
                                        ? "   Uploaded Successfully"
                                        : "   Loading...",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: AppTheme.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )

                //   Spacer(),
                //  if (_controller.isRecording && _controller.isPaused)
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 14,
                //   ),
                //   decoration: BoxDecoration(
                //     color: AppTheme.whiteColor,
                //     borderRadius: BorderRadius.circular(12),
                //     boxShadow: const [
                //       BoxShadow(
                //           color: Color.fromARGB(17, 0, 0, 0),
                //           blurRadius: 12,
                //           spreadRadius: 2,
                //           offset: Offset(1, 1)),
                //     ],
                //   ),
                //   child: Column(
                //     children: [
                //       // SizedBox(height: 20),
                //       // SliderTheme(
                //       //   data: const SliderThemeData(
                //       //     trackHeight: 4,
                //       //     rangeThumbShape: RoundRangeSliderThumbShape(
                //       //       enabledThumbRadius: 8,
                //       //       disabledThumbRadius: 5,
                //       //     ),
                //       //     overlayShape: RoundSliderOverlayShape(
                //       //       overlayRadius: 4,
                //       //     ),
                //       //     activeTickMarkColor: Colors.transparent,
                //       //     inactiveTickMarkColor: Colors.transparent,
                //       //   ),
                //       //   child: SizedBox(
                //       //     width: double.infinity,
                //       //     child: Slider(
                //       //       max: _controller.max.value,
                //       //       value: _controller.slidervalue.value,
                //       //       onChanged: (value) {
                //       //         value = value;
                //       //         _controller
                //       //             .changeValueinDuration(value.toInt());
                //       //       },
                //       //       min: 0,
                //       //       label: "2",
                //       //     ),
                //       //   ),
                //       // ),
                //       // SizedBox(height: 3),
                //       // Row(
                //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       //   children: [
                //       //     Text(
                //       //       _controller.postion.value,
                //       //       style: GoogleFonts.poppins(
                //       //           fontSize: 12,
                //       //           height: 0,
                //       //           color: AppTheme.lightText,
                //       //           fontWeight: FontWeight.w500),
                //       //     ),
                //       //     Text(
                //       //       _controller.duration.value,
                //       //       style: GoogleFonts.poppins(
                //       //           fontSize: 12,
                //       //           height: 0,
                //       //           color: AppTheme.lightText,
                //       //           fontWeight: FontWeight.w500),
                //       //     ),
                //       //   ],
                //       // ),
                //       SizedBox(height: 8),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               _controller.skip5SecondsBackward();
                //             },
                //             child: Icon(
                //               Icons.fast_rewind,
                //               color: AppTheme.lightText,
                //               size: 40,
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               if (_controller.isRecording &&
                //                   _controller.isPaused) {
                //                 _controller.pausePlaySong();
                //               }
                //             },
                //             child: Container(
                //               padding: EdgeInsets.all(10),
                //               decoration: BoxDecoration(
                //                   color: AppTheme.lightText,
                //                   shape: BoxShape.circle),
                //               child: Icon(
                //                 !_controller.isPlaying == false
                //                     ? Icons.pause
                //                     : Icons.play_arrow,
                //                 size: 30,
                //                 color: AppTheme.whiteColor,
                //               ),
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               _controller.skip5SecondsForward();
                //             },
                //             child: Icon(
                //               Icons.fast_forward,
                //               color: AppTheme.lightText,
                //               size: 40,
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(height: 8),
                //     ],
                //   ),
                // ),
                // // if (_controller.isRecording && _controller.isPaused)
                // SizedBox(height: 20),

                // PolygonWaveform(
                //   samples: [],
                //   height: 300,
                //   width: double.infinity,
                //   //  maxDuration: _controller.max,
                //   //  elapsedDuration: elapsedDuration,
                // )
                // if (_controller.filePath != "") const SizedBox(height: 20),
                // if (_controller.filePath != "")
                //   Container(
                //     padding:
                //         EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                //     decoration: BoxDecoration(
                //       color: AppTheme.whiteColor,
                //       borderRadius: BorderRadius.circular(12),
                //       boxShadow: const [
                //         BoxShadow(
                //             color: Color.fromARGB(17, 0, 0, 0),
                //             blurRadius: 12,
                //             spreadRadius: 2,
                //             offset: Offset(1, 1)),
                //       ],
                //     ),
                //     width: double.infinity,
                //     child: Column(
                //       children: [
                //         Obx(
                //           () => Column(
                //             children: [
                //               const SizedBox(height: 20),
                //               Text(
                //                 _controller.fileName!,
                //                 style: GoogleFonts.inter(
                //                     color: AppTheme.black,
                //                     fontSize: 16,
                //                     fontWeight: FontWeight.w500),
                //                 textAlign: TextAlign.center,
                //               ),
                //               SizedBox(height: 10),
                //               SliderTheme(
                //                 data: const SliderThemeData(
                //                   trackHeight: 4,
                //                   rangeThumbShape: RoundRangeSliderThumbShape(
                //                     enabledThumbRadius: 8,
                //                     disabledThumbRadius: 5,
                //                   ),
                //                   overlayShape: RoundSliderOverlayShape(
                //                     overlayRadius: 4,
                //                   ),
                //                   activeTickMarkColor: Colors.transparent,
                //                   inactiveTickMarkColor: Colors.transparent,
                //                 ),
                //                 child: SizedBox(
                //                   width: double.infinity,
                //                   child: Slider(
                //                     max: controller.max.value,
                //                     value: controller.slidervalue.value,
                //                     onChanged: (value) {
                //                       value = value;
                //                       controller.changeValueinDuration(
                //                           value.toInt());
                //                     },
                //                     min: 0,
                //                     label: "2",
                //                   ),
                //                 ),
                //               ),
                //               SizedBox(height: 3),
                //               Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text(
                //                     controller.postion.value,
                //                     style: GoogleFonts.poppins(
                //                         fontSize: 12,
                //                         height: 0,
                //                         color: AppTheme.lightText,
                //                         fontWeight: FontWeight.w500),
                //                   ),
                //                   Text(
                //                     controller.duration.value,
                //                     style: GoogleFonts.poppins(
                //                         fontSize: 12,
                //                         height: 0,
                //                         color: AppTheme.lightText,
                //                         fontWeight: FontWeight.w500),
                //                   ),
                //                 ],
                //               ),
                //               Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceEvenly,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   GestureDetector(
                //                     onTap: () {
                //                       controller.skip5SecondsBackward();
                //                     },
                //                     child: Icon(
                //                       Icons.fast_rewind,
                //                       color: AppTheme.lightText,
                //                       size: 30,
                //                     ),
                //                   ),
                //                   GestureDetector(
                //                     onTap: () {
                //                       _controller.startPartialREcord();
                //                     },
                //                     child: Container(
                //                       padding: EdgeInsets.all(6),
                //                       decoration: BoxDecoration(
                //                           color: AppTheme.lightText,
                //                           shape: BoxShape.circle),
                //                       child: Icon(
                //                         !controller.isPlaying == false
                //                             ? Icons.pause
                //                             : Icons.play_arrow,
                //                         size: 22,
                //                         color: AppTheme.whiteColor,
                //                       ),
                //                     ),
                //                   ),
                //                   GestureDetector(
                //                     onTap: () {
                //                       controller.skip5SecondsForward();
                //                     },
                //                     child: Icon(
                //                       Icons.fast_forward,
                //                       color: AppTheme.lightText,
                //                       size: 30,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(height: 8),
                //             ],
                //           ),
                //         ),
                //         SizedBox(height: 10),
                //         Row(
                //           children: [
                //             Expanded(
                //               child: InkWell(
                //                 onTap: () {
                //                   controller.saveLocalRecording(
                //                     _controller.filePath,
                //                     _controller.fileName,
                //                   );
                //                 },
                //                 child: Container(
                //                   height: 45,
                //                   margin:
                //                       EdgeInsets.symmetric(horizontal: 10),
                //                   alignment: Alignment.center,
                //                   decoration: BoxDecoration(
                //                       color: AppTheme.primaryColor,
                //                       borderRadius:
                //                           BorderRadius.circular(50)),
                //                   child: Text(
                //                     "Upload",
                //                     style: GoogleFonts.inter(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.w600,
                //                         color: AppTheme.whiteColor),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             Expanded(
                //               child: InkWell(
                //                 onTap: () {
                //                   controller.deleteLocalFile(
                //                     _controller.filePath,
                //                   );
                //                 },
                //                 child: Container(
                //                   height: 45,
                //                   margin:
                //                       EdgeInsets.symmetric(horizontal: 10),
                //                   alignment: Alignment.center,
                //                   decoration: BoxDecoration(
                //                       color: Colors.red,
                //                       borderRadius:
                //                           BorderRadius.circular(50)),
                //                   child: Text(
                //                     "Delete",
                //                     style: GoogleFonts.inter(
                //                         fontSize: 16,
                //                         fontWeight: FontWeight.w600,
                //                         color: AppTheme.whiteColor),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // const SizedBox(height: 20),
                ///if (_controller.filePath == "")
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Recent Dictations",
                //       style: GoogleFonts.inter(
                //           color: AppTheme.black,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600),
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   height: 5,
                // ),
                // // if (_controller.filePath == "")
                // !_controller.isLoaded
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     : (_controller.dictationsDataList.isNotEmpty)
                //         ? ListView.builder(
                //             itemCount: _controller
                //                 .dictationsDataList.first.data!.length,
                //             shrinkWrap: true,
                //             primary: false,
                //             itemBuilder: (context, index) {
                //               return buildFolderRow(
                //                   context,
                //                   index,
                //                   _controller
                //                       .dictationsDataList.first.data![index],
                //                   _controller);
                //             },
                //           )
                //         : Center(
                //             child: Text("No Data"),
                //           )
              ],
            ),
          ));
    });
  }

  Widget buildFolderRow(BuildContext context, int index, Data data,
      Recordcontroller _controller) {
    return GestureDetector(
      onTap: () {
        _controller.changeIndex(index, data.dictationsdataUrl);
      },
      // onTap: () {
      //   _controller.changeIndex(index, data.dictationsdataUrl);
      // },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (data.file_status == 1)
                  Icon(
                    CupertinoIcons.arrow_turn_right_up,
                    size: 18,
                    color: Colors.lightBlue,
                  ),
                //  if (data.file_status == 1)
                SizedBox(width: 4),
                Container(
                  height: 48,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    Icons.mic,
                    size: 24,
                    color: AppTheme.whiteColor,
                  ),
                ),
                // Image.asset("assets/images/pro.png"),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              "${data.filename}",
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          // if (_controller.selectedIndex == index)
                          //   InkWell(
                          //     onTap: () {
                          //       _controller.editDictation(data);
                          //     },
                          //     child: Icon(
                          //       Icons.edit_rounded,
                          //       color: Colors.red,
                          //       size: 20,
                          //     ),
                          //   )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${data.fileUploadedDateTime!.substring(0, 10)}",
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.lightText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_controller.selectedIndex == index)
              Obx(
                () => Column(
                  children: [
                    SizedBox(height: 20),
                    SliderTheme(
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
                          max: _controller.max.value,
                          value: _controller.slidervalue.value,
                          onChanged: (value) {
                            value = value;
                            _controller.changeValueinDuration(value.toInt());
                          },
                          min: 0,
                          label: "2",
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _controller.postion.value,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              height: 0,
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          _controller.duration.value,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              height: 0,
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.skip5SecondsBackward();
                          },
                          child: Icon(
                            Icons.fast_rewind,
                            color: AppTheme.lightText,
                            size: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.pausePlaySong();
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: AppTheme.lightText,
                                shape: BoxShape.circle),
                            child: Icon(
                              !_controller.isPlaying == false
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 22,
                              color: AppTheme.whiteColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.skip5SecondsForward();
                          },
                          child: Icon(
                            Icons.fast_forward,
                            color: AppTheme.lightText,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

class VerticalBarThumbShape extends SliderComponentShape {
  final double width;
  final double height;
  final Color color;

  VerticalBarThumbShape({
    this.width = 2,
    this.height = 20,
    this.color = Colors.blue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter? labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(width / 2)),
      paint,
    );
  }
}
