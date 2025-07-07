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
import '../home/bottombar.dart';
import 'forget_password.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final controller = Get.put<AuthController>(AuthController());
  final loginformKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  "assets/images/logo2.png",
                  height: 150,width: 150,
                  fit: BoxFit.cover,
                ),
                // SizedBox(
                //   height: getProportionateScreenHeight(12),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Form(
                    key: loginformKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: GoogleFonts.inter(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        MyTextField(
                            preicon: SvgPicture.asset("assets/icons/mail.svg",
                                height: 5, width: 5, fit: BoxFit.scaleDown),
                            textEditingController: _controller.email,
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
                            hintText: "Email",
                            color: const Color(0xff585A60)),
                        SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                            isSuffixIcon: true,
                            preicon: SvgPicture.asset("assets/icons/lock.svg",
                                height: 5, width: 5, fit: BoxFit.scaleDown),
                            textEditingController: _controller.password,
                            obsecureText: !_controller.passwordLoginVisibility,
                            ontapSuffix: () {
                              _controller.showPassword();
                            },
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                            hintText: "Password",
                            color: const Color(0xff585A60)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Transform.translate(
                                  offset: const Offset(-5, 0),
                                  child: CupertinoCheckbox(
                                    // This bool value toggles the switch.
                                    value: controller.isRemember,

                                    onChanged: (value) {
                                      controller.isRememberUpdate();
                                    },
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      "Remember Me",
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ))
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.to(ForgetPassword());
                                },
                                child: Text(
                                  "Forget Password?",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: Color.fromRGBO(22, 126, 230, 1),
                                      fontWeight: FontWeight.w400),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Button(
                            title: "Sign in",
                            ontap: () {
                              if (loginformKey.currentState!.validate()) {
                                controller.submit();
                                //   Get.to(DashboardScreen());
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
