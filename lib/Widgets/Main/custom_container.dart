import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';

import '../../Utils/app_constants.dart';

class ThemeContainer extends StatelessWidget {
  ThemeContainer({Key? key, required this.child, this.revese = false})
      : super(key: key);

  final Widget child;
  final bool revese;
  // final ThemeController themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    // print(themeController.isDark.isTrue);
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ThemeController.to.isDark.isTrue
                    ? [
                        AppConst.dark_backgruondColor,
                        AppConst.dark_backgruondColor
                      ]
                    : (revese)
                        ? [
                            Color(0xFF00332A),
                            Color(0xFF00E0FF),
                          ]
                        : [Color(0xFF00E0FF), Color(0xFF00332A)])),
        child: child,
      ),
    );
  }
}
