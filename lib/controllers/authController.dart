import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speechtotext/components/loaders.dart';
import 'package:speechtotext/view/auth/login.dart';
import 'package:speechtotext/view/auth/otp_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../services/auth_repo.dart';
import '../services/shared_pref.dart';
import '../view/home/bottombar.dart';

class AuthController extends GetxController {
  final email = TextEditingController();
  final emailForgot = TextEditingController();
  final pinController = TextEditingController();

  final password = TextEditingController();
  final newpassword = TextEditingController();
  final cofirmpassword = TextEditingController();
  bool passwordLoginVisibility = false;
  bool passwordLoginVisibility1 = false;
  bool passwordLoginVisibility2 = false;
  void showPassword() {
    passwordLoginVisibility = !passwordLoginVisibility;
    update();
  }

  void showPassword1() {
    passwordLoginVisibility1 = !passwordLoginVisibility1;
    update();
  }

  void showPassword2() {
    passwordLoginVisibility2 = !passwordLoginVisibility2;
    update();
  }

  bool isRemember = false;
  isRememberUpdate() {
    isRemember = !isRemember;
    update();
  }

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!; // unique ID on iOS
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // unique ID on Android
    }
    return "";
  }

  void submit() async {
    String deveiceid = await getId();
    Loaders.showLoading('Loading...');
    AuthRepo()
        .apiLoginService(email.text, password.text, deveiceid)
        .then((value) {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);
          PreferenceUtils.saveUserToken(data2["access_token"]);
          PreferenceUtils.setString("name", data2["data"]["name"]);
          PreferenceUtils.setString("email", data2["data"]["username"]);
          PreferenceUtils.setString("userid", data2["data"]["id"].toString());
           PreferenceUtils.setString("deveiceid", data2["data"]["deviceid"].toString());
          Get.offAll(DashboardScreen());
          break;
        case 400:
          // if (value.data["detail"] == "User is not verified") {
          //   DialogHelper.showErroDialog(
          //       description: "your email not registered with us");
          //   // Get.toNamed(
          //   //   Routes.SIGNUP,
          //   // );
          // }
          Loaders.errorSnackBar(
              message: "Username and password is wrong",
              title: "Invalid Credentials");

          break;
        case 401:
          Loaders.errorSnackBar(
              message: "Username and password is wrong",
              title: "Invalid Credentials");
          break;

        case 1:
          break;
        default:
          Loaders.errorSnackBar(
              message: "Username and password is wrong",
              title: "Invalid Credentials");
          break;
      }
    });
  }

  void sentOtpSubmit() async {
    Loaders.showLoading('Loading...');
    AuthRepo().apiSentOtp(emailForgot.text).then((value) {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);
          // PreferenceUtils.saveUserToken(data2["access_token"]);
          // PreferenceUtils.setString("name", data2["data"]["name"]);
          // PreferenceUtils.setString("email", data2["data"]["username"]);
          // PreferenceUtils.setString("userid", data2["data"]["id"].toString());
          Get.to(otpScreen());
          break;
        case 400:
          // if (value.data["detail"] == "User is not verified") {
          //   DialogHelper.showErroDialog(
          //       description: "your email not registered with us");
          //   // Get.toNamed(
          //   //   Routes.SIGNUP,
          //   // );
          // }
          Loaders.errorSnackBar(
              message: "Username is wrong", title: "Invalid Credentials");

          break;
        case 401:
          Loaders.errorSnackBar(
              message: "Username is wrong", title: "Invalid Credentials");
          break;

        case 1:
          break;
        default:
          Loaders.errorSnackBar(
              message: "Username is wrong", title: "Invalid Credentials");
          break;
      }
    });
  }

  void verifyOtp() async {
    Loaders.showLoading('Loading...');
    AuthRepo()
        .apiVerifyOtp(pinController.text, cofirmpassword.text, emailForgot.text)
        .then((value) {
      print(value.statusCode);
      Loaders.hideLoading();
      switch (value.statusCode) {
        case 200:
          var data2 = jsonDecode(value.body);
          print(data2);

          Get.offAll(LoginWidget());
          break;
        case 400:
          // if (value.data["detail"] == "User is not verified") {
          //   DialogHelper.showErroDialog(
          //       description: "your email not registered with us");
          //   // Get.toNamed(
          //   //   Routes.SIGNUP,
          //   // );
          // }
          Loaders.errorSnackBar(message: "OTP is wrong", title: "Invalid OTP");

          break;
        case 401:
          Loaders.errorSnackBar(message: "OTP is wrong", title: "Invalid OTP");
          break;

        case 1:
          break;
        default:
          Loaders.errorSnackBar(message: "OTP is wrong", title: "Invalid OTP");
          break;
      }
    });
  }
}
