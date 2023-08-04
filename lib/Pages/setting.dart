import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Utils/Theme/theme.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:lingoread/Widgets/Drawer/custome_drawer.dart';
import 'package:lingoread/Widgets/Header/CustomerHeader.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:lingoread/Widgets/Main/footer.dart';
import 'package:lingoread/Widgets/Setting/setting_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Routes/routes_names.dart';
import '../Utils/app_constants.dart';
import '../Widgets/Buttons/button_main.dart';
import '../Widgets/Buttons/buttonfb.dart';
import '../Widgets/TextField/myTextFromField.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final ThemeController themeControllers = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        child: Scaffold(
      key: _scaffoldkey,
      drawer: CustomDrawer(context),
      body: Stack(
        children: [
          ThemeFooter(),
          Column(
            children: [
              SizedBox(height: AppConst.padding * 3),
              Obx((() => CustomerHeader(
                    image: ThemeController.to.isDark.isTrue
                        ? "assets/images/icon_menu_white.png"
                        : "assets/images/icon_menu.png",
                    title: "Setting",
                    titleicon: Icons.settings,
                    onPressed: () {
                      _scaffoldkey.currentState!.openDrawer();
                    },
                  ))),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => Padding(
                          padding: EdgeInsets.fromLTRB(AppConst.padding * 2,
                              AppConst.padding * 3, AppConst.padding * 2, 0),
                          child: SettingWidget(
                              'assets/images/setting_first_vector.png',
                              ThemeController.to.isDark.isTrue
                                  ? AppConst.dark_colorPrimaryDark
                                  : Color(0xffffffff),
                              'Education Voucher',
                              ThemeController.to.isDark.isTrue
                                  ? AppConst.colorWhite
                                  : Color(0xff017476),
                              ThemeController.to.isDark.isTrue
                                  ? AppConst.colorWhite
                                  : Color(0xff016064), () {
                            Get.toNamed(Routes.setting_voucher);
                          })),
                    ),
                    Obx(
                      () => Padding(
                          padding: EdgeInsets.fromLTRB(AppConst.padding * 2, 18,
                              AppConst.padding * 2, 0),
                          child: SettingWidget(
                              'assets/images/setting_second_vector.png',
                              Color(0xff4DD0E4),
                              ThemeController.to.isDark.value
                                  ? 'Light Mode'
                                  : "Dark Mode",
                              Color(0xffffffff),
                              ThemeController.to.isDark.isTrue
                                  ? AppConst.colorWhite
                                  : Color(0xff000000), () async {
                            if (ThemeController.to.isDark.value) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('isDark', false);
                              Get.changeTheme(CustomThemeData.themeLight());

                              Get.changeThemeMode(ThemeMode.light);
                              ThemeController.to.setThemeIsDark(false);
                            } else {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('isDark', true);
                              Get.changeTheme(CustomThemeData.themeDark());
                              Get.changeThemeMode(ThemeMode.dark);
                              ThemeController.to.setThemeIsDark(true);
                            }
                          })),
                    ),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    ));
  }
}
