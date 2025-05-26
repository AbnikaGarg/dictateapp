import 'dart:async';
import 'package:get/get.dart';
import 'package:speechtotext/view/auth/login.dart';

import '../services/shared_pref.dart';
import '../view/home/bottombar.dart';

class SplashController extends GetxController {
  SplashController();
  final image = "assets/images/Logo.jpg";

  @override
  void onReady() {
    super.onReady();

    Timer(const Duration(seconds: 2), () {
      if (PreferenceUtils.isLoggedIn()) {
        Get.offAll(DashboardScreen());
      } else {
        Get.offAll(LoginWidget());
      }
    });
    // }
  }
}
