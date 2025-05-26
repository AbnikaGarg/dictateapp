import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/splashController.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(controller.image, height: 200,)),
    );
  }
}
