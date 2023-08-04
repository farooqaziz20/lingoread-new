import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingoread/Controllers/Theme/profileController.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Pages/introduction.dart';
import 'package:lingoread/Services/postRequests.dart';
import 'package:lingoread/Utils/Theme/decoration.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Routes/routes_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () async {
        final prefs = await SharedPreferences.getInstance();
        bool? isNotFirstVisit = prefs.getBool('isNotFirstVisit');
        if (isNotFirstVisit == true) {
          String? userIdTemp = prefs.getString('UserId');
          ProfileController.to.loadProfile();
          // Get.offAllNamed(Routes.login);
          if (userIdTemp != null && userIdTemp != "") {
            String? autherization = prefs.getString('Authorization');
            APIsCallPost.submitRequestWithAuth("", {"action": "randomstories"}).then((value) {
              if (value.statusCode == 200) {
                String? level = prefs.getString("level");
                prefs.setString("Banners", jsonEncode(value.data));

                if (level != null && level != "") {
                  Get.offAllNamed(Routes.homeScreen);
                } else {
                  Get.offAllNamed(Routes.levelsScreen);
                }
              } else {
                Get.offAllNamed(Routes.login);
              }
            });
            // Get.offAllNamed(Routes.homeScreen);
          } else {
            Get.offAllNamed(Routes.login);
          }
        } else {
          Get.offAllNamed(Routes.introduction);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        revese: true,
        child: Scaffold(
          body: Center(
            child: Text("LingoRead",
                style: GoogleFonts.raleway(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: ThemeController.to.isDark.isTrue ? AppConst.colorWhite : Theme.of(context).primaryColorLight,
                )),
          ),
        ));
  }
}
