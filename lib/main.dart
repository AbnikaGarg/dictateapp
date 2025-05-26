import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speechtotext/services/shared_pref.dart';
import 'package:speechtotext/view/home/home.dart';
import 'package:speechtotext/view/home/play_audio.dart';
import 'package:speechtotext/view/home/test.dart';

import 'bindings/init_bindings.dart';
import 'splash.dart';
import 'theme/app_theme.dart';
import 'view/auth/login.dart';
import 'view/home/bottombar.dart';

void main() async {
  //calling DependencyInjection init method
  WidgetsFlutterBinding.ensureInitialized();

  DependencyInjection.init();
  await Future.delayed(const Duration(milliseconds: 400));
  _requestPermission();
  runApp(MyApp());
}

Future<bool> _requestPermission() async {
  // Check and request microphone permission
 
  PermissionStatus status = await Permission.microphone.request();
 // await Permission.phone.request();
  return status.isGranted;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Speech Text',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppTheme.whiteDullColor,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Colors.black),
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
            bottomNavigationBarTheme:
                BottomNavigationBarThemeData(backgroundColor: Colors.white)),

        // getPages:appRoutes(),
        //  initialRoute: Routes.addblog,
        //  unknownRoute: GetPage(name: "/page_not_found", page:()=> Scaffold(body: Center(child: Text("Page not found"),),)),
        home: SplashScreen());
  }
}
