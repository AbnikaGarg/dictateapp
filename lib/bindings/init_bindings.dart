import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:speechtotext/controllers/splashController.dart';

import '../services/shared_pref.dart';

class DependencyInjection {
  static void init() async {
    await PreferenceUtils.init();
  
     Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
