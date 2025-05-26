import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/recordController.dart';
import '../../services/shared_pref.dart';
import '../../theme/app_theme.dart';

class Profile extends StatelessWidget {
   Profile({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: AppTheme.whiteDullColor,
        title: Text(
          "Profile",
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: GetBuilder<Recordcontroller>(builder: (_controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _controller.userDetails != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 14,
                    ),
                    Center(
                      child: Text(
                        "Make your profile uniquely yours - it's your creative canvas!",
                        style: GoogleFonts.inter(
                            color: AppTheme.lightText,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Icon(
                            CupertinoIcons.person_alt_circle,
                            size: 100,
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        _controller.userDetails!["name"],
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        _controller.userDetails!["username"],
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        "Quota: ${_controller.userDetails!["quota"].toString()}",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Text(
                        "Country: ${_controller.userDetails!["country"].toString()}",
                        style: GoogleFonts.inter(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
