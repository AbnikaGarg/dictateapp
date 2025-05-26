import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speechtotext/components/loaders.dart';
import 'package:speechtotext/controllers/recordController.dart';
import 'package:speechtotext/view/auth/login.dart';
import 'package:speechtotext/view/setting/profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/text_feilds.dart';

import '../../services/shared_pref.dart';
import '../../theme/app_theme.dart';

class Setting extends StatefulWidget {
  Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  double _currentSliderSecondaryValue = 50;

  RangeValues currentRangeValues = const RangeValues(0, 50000);

  onchangeFilter(value) {
    currentRangeValues = value;
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void dialog() {
    Loaders.showLoading();
    Future.delayed(Duration(milliseconds: 400), () {
      PreferenceUtils().clearSharedPref();

      Get.deleteAll();
      Get.offAll(LoginWidget());
    });

    //   PreferenceUtils().remove("Token");
    //    PreferenceUtils().remove("Token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: AppTheme.whiteDullColor,
        title: Text(
          "Setting",
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: GetBuilder<Recordcontroller>(builder: (_controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.getUser();
                    Get.to(Profile());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.person_alt_circle,
                          size: 60,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              PreferenceUtils.getString("name"),
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              PreferenceUtils.getString("email"),
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.lightText),
                            ),
                          ],
                        )),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "Microphone Permission",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: AppTheme.black,
                                    fontWeight: FontWeight.w500),
                              )),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      _controller.micAllowed
                                          ? 'Granted'
                                          : 'Denied',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: AppTheme.lightText,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Switch(
                                        // This bool value toggles the switch.
                                        value: _controller.micAllowed,

                                        onChanged: _controller.handleToggle,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          //  Row(
                          //   children: [
                          //     Expanded(
                          //         child: Text(
                          //       "Call Permission",
                          //       style: GoogleFonts.inter(
                          //           fontSize: 16,
                          //           color: AppTheme.black,
                          //           fontWeight: FontWeight.w500),
                          //     )),
                          //     Row(
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.only(right: 8),
                          //           child: Text(
                          //             _controller.phoneStatus
                          //                 ? 'Granted'
                          //                 : 'Denied',
                          //             style: GoogleFonts.inter(
                          //                 fontSize: 14,
                          //                 color: AppTheme.lightText,
                          //                 fontWeight: FontWeight.w500),
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           height: 30,
                          //           child: FittedBox(
                          //             fit: BoxFit.cover,
                          //             child: Switch(
                          //               // This bool value toggles the switch.
                          //               value: _controller.phoneStatus,

                          //               onChanged: _controller.handleToggle2,
                          //             ),
                          //           ),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // ),

                          // SizedBox(
                          //   height: 20,
                          // ),

                          buildrow(context, "Microphone Sensitivity",
                              isSwitch: true,
                              subtitle: _controller.selectedSenivity),
                          SizedBox(
                            height: 8,
                          ),
                          SliderTheme(
                            data: const SliderThemeData(
                              trackHeight: 6,
                              rangeThumbShape: RoundRangeSliderThumbShape(
                                  enabledThumbRadius: 8),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 8),
                              activeTickMarkColor: Colors.transparent,
                              inactiveTickMarkColor: Colors.transparent,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Slider(
                                value: _controller.sliderValueMicroPhone,
                                min: 0,
                                max: 2,
                                onChanged: (double value) {
                                  _controller.setQuality(value);
                                },
                                onChangeEnd: (value) {
                                  _controller.updateSetting();
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Low"), Text("High")],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // buildrow(context, "Audio Quality",
                          //     isSwitch: true, subtitle: "24 KHZ"),
                          // SizedBox(
                          //   height: 8,
                          // ),
                          // SliderTheme(
                          //   data: SliderTheme.of(context).copyWith(
                          //     trackHeight: 6,
                          //     rangeThumbShape: RoundRangeSliderThumbShape(
                          //         enabledThumbRadius: 8),
                          //     overlayShape:
                          //         RoundSliderOverlayShape(overlayRadius: 8),
                          //     activeTickMarkColor: Colors.transparent,
                          //     inactiveTickMarkColor: Colors.transparent,
                          //   ),
                          //   child: Slider(
                          //     value: _currentSliderSecondaryValue,
                          //     min: 0,
                          //     max: 100,
                          //     label:
                          //         _currentSliderSecondaryValue.round().toString(),
                          //     onChanged: (double value) {},
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [Text("Low"), Text("High")],
                          // ),
                        ],
                      )),
                ),
                // SwitchListTile(
                // dense: true,
                //   title: Text('Microphone Access'),

                //   value: _controller.micAllowed,

                //   onChanged: _controller.handleToggle,
                //   subtitle: Text(
                //     _controller.micAllowed
                //         ? 'Microphone access is granted'
                //         : 'Microphone access is denied',
                //   ),
                // ),
                SizedBox(
                  height: 12,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Loaders.showModal(context, _controller.autoFile,
                                  (value) {
                                _controller.updateSelectedautoDelete(value);
                              }, _controller.selectedautoDelete);
                            },
                            child: buildrow(context, "Auto File Deletion",
                                isSwitch: true,
                                subtitle: _controller.selectedautoDelete)),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Loaders.showModal(context, _controller.dateFormat,
                                (value) {
                              print(value);
                              _controller.updateSelectedDateFormat(value);
                            }, _controller.selectedDateFormat);
                          },
                          child: buildrow(context, "Date Format",
                              subtitle: _controller.selectedDateFormat),
                        )
                      ],
                    )),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchUrl(
                                  "https://www.pilottechtranscription.com/contactus.php");
                            },
                            child: buildrow(context, "Help & Support"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchUrl(
                                  "https://www.pilottechtranscription.com/security.php");
                            },
                            child: buildrow(context, "Privacy Policy"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                _launchUrl(
                                    "https://www.pilottechtranscription.com/services.php");
                              },
                              child: buildrow(context, "Terms of use")),
                        ],
                      )),
                ),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      //  context: Get.context,//
                      CupertinoAlertDialog(
                        title: const Text('Logout'),
                        insetAnimationCurve: Curves.linear,
                        insetAnimationDuration: Duration(milliseconds: 500),
                        content: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Are you sure you want to logout",
                          ),
                        ),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            /// This parameter indicates this action is the default,
                            /// and turns the action's text to bold text.
                            isDefaultAction: true,
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                          CupertinoDialogAction(
                            /// This parameter indicates the action would perform
                            /// a destructive action such as deletion, and turns
                            /// the action's text color to red.
                            isDestructiveAction: true,
                            onPressed: () {
                              dialog();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: buildrow(context, "Logout")),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  buildrow(context, title, {subtitle = "", isSwitch = false}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          style: GoogleFonts.inter(
              fontSize: 16,
              color: title == "Logout" ? Colors.red : AppTheme.black,
              fontWeight: FontWeight.w500),
        )),
        Row(
          children: [
            if (subtitle != "")
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  subtitle,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.lightText,
                      fontWeight: FontWeight.w500),
                ),
              ),
            if (isSwitch)
              SizedBox(
                height: 30,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: true,

                    onChanged: (value) {},
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: title == "Logout" ? Colors.red : AppTheme.lightText,
              ),
          ],
        )
      ],
    );
  }
}
