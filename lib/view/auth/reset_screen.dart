import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/app_urls.dart';
import '../../components/button.dart';
import '../../components/text_feilds.dart';
import '../../controllers/authController.dart';
import '../../theme/app_theme.dart';
import 'otp_screen.dart';
import 'package:pinput/pinput.dart';

class ResetScreen extends StatelessWidget {
  ResetScreen({super.key});

  final controller = Get.put<AuthController>(AuthController());
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AuthController>(builder: (_controller) {
        return SafeArea(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  Image.asset(
                    "assets/images/mail.png",
                    height: 80,
                  ),
                  // SizedBox(
                  //   height: getProportionateScreenHeight(12),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Reset Password",
                          style: GoogleFonts.inter(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Text(
                        //   " An email containing instructions to reset your password has been sent to abnikagarg10@gmail.com",
                        //   style: GoogleFonts.inter(
                        //     color: AppTheme.lightText,
                        //     fontSize: 16,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                        // SizedBox(
                        //   height: 100,
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                "New Password",
                                style: GoogleFonts.inter(
                                  color: AppTheme.lightText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        MyTextField(
                            isSuffixIcon: true,
                            preicon: SvgPicture.asset("assets/icons/lock.svg",
                                height: 5, width: 5, fit: BoxFit.scaleDown),
                            obsecureText: !_controller.passwordLoginVisibility1,
                            ontapSuffix: () {
                              _controller.showPassword1();
                            },
                            textEditingController: _controller.newpassword,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                            hintText: "New Password",
                            color: const Color(0xff585A60)),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                "Confirm New Password",
                                style: GoogleFonts.inter(
                                  color: AppTheme.lightText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        MyTextField(
                            isSuffixIcon: true,
                            preicon: SvgPicture.asset("assets/icons/lock.svg",
                                height: 5, width: 5, fit: BoxFit.scaleDown),
                            obsecureText: !_controller.passwordLoginVisibility2,
                            ontapSuffix: () {
                              _controller.showPassword2();
                            },
                            textEditingController: _controller.cofirmpassword,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                            hintText: "Confirm New Password",
                            color: const Color(0xff585A60)),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Button(
                            title: "Submit",
                            ontap: () {
                              if (formkey.currentState!.validate()) {
                                _controller.verifyOtp();
                              }

                              // Get.to(otpScreen());
                            },
                            textcolor: AppTheme.whiteColor,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        );
      }),
    );
  }
}
