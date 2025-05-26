import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../components/app_urls.dart';
import '../../components/button.dart';
import '../../components/text_feilds.dart';
import '../../controllers/authController.dart';
import '../../theme/app_theme.dart';
import 'reset_screen.dart';

class otpScreen extends StatelessWidget {
  otpScreen({super.key});

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
                    "assets/images/otp.png",
                    height: 200,
                  ),
                  // SizedBox(
                  //   height: getProportionateScreenHeight(12),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Enter Otp",
                          style: GoogleFonts.inter(
                              fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "We’ve sent a verification code to your email",
                          style: GoogleFonts.inter(
                            color: AppTheme.lightText,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Pinput(
                            controller: _controller.pinController,
                            length: 6,
                            autofocus: true,
                            forceErrorState: true,
                            onCompleted: (pin) => print(pin),
                            defaultPinTheme: PinTheme(
                              width: 40,
                              height: 40,
                              textStyle: TextStyle(fontSize: 18),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff585A60).withOpacity(0.4)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            validator: (pin) {
                              if (pin!.length >= 6) return null;
                              return 'Enter Valid OTP';
                            },
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Button(
                            title: "Verify Code",
                            ontap: () {
                              if (formkey.currentState!.validate()) {
                                Get.to(ResetScreen());
                              }
                            },
                            textcolor: AppTheme.whiteColor,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Resend Otp",
                          style: GoogleFonts.inter(
                              fontSize: 14, fontWeight: FontWeight.w600),
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
