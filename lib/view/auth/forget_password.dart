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
import 'reset_screen.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final controller = Get.put<AuthController>(AuthController());
  final forgetKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<AuthController>(builder: (_controller) {
        return SafeArea(
          child: SingleChildScrollView(
              child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),

                Image.asset(
                  "assets/images/forget.png",
                ),
                // SizedBox(
                //   height: getProportionateScreenHeight(12),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Form(
                    key: forgetKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: GoogleFonts.inter(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Please provide us with your email"
                          "address, and we will send you a link to"
                          "regain access to your account.",
                          style: GoogleFonts.inter(
                            color: AppTheme.lightText,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                "Email Address",
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
                            preicon: SvgPicture.asset("assets/icons/mail.svg",
                                height: 5, width: 5, fit: BoxFit.scaleDown),
                            textEditingController: _controller.emailForgot,
                            validation: (value) {
                              RegExp emailValidatorRegExp = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              } else if (!emailValidatorRegExp
                                  .hasMatch(value.trim())) {
                                return "Enter valid Email";
                              }
                              return null;
                            },
                            hintText: "Enter Email",
                            color: const Color(0xff585A60)),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Button(
                            title: "Send Login link",
                            ontap: () {
                              if (forgetKey.currentState!.validate()) {
                            _controller.sentOtpSubmit();
                              }
                            },
                            textcolor: AppTheme.whiteColor,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        );
      }),
    );
  }
}
