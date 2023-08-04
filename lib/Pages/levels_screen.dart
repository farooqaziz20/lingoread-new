import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingoread/Controllers/Theme/homecontroller.dart';
import 'package:lingoread/Controllers/Theme/levels_controllers.dart';
import 'package:lingoread/Controllers/Theme/stories_controllers.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Routes/routes_names.dart';
import 'package:lingoread/Services/postRequests.dart';
import 'package:lingoread/Utils/app_funtions.dart';

import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:lingoread/Widgets/Main/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/app_constants.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    APIsCallPost.submitRequestWithAuth("", {"action": "alllevels"})
        .then((value) {
      if (value.statusCode == 200) {
        setState(() {
          loadingLevels = true;
        });
        print(value.data);
        List list = value.data;
        levelsControllers.setList(list);
      } else if (value.statusCode == 401) {
        AppFunctions.showSnackBar("Authorization", "Authorization Denied");
      } else {
        AppFunctions.showSnackBar("Error", "Something went wrong");
      }
    });
    final prefs = await SharedPreferences.getInstance();

    String? value = prefs.getString("level");
    if (value != null) {
      setState(() {
        selectedLevel = value;
      });
    }
  }

  bool loadingLevels = false;

  final LevelsControllers levelsControllers = Get.put(LevelsControllers());
  final StoriesControllers storiesControllers = Get.put(StoriesControllers());
  final HomeController homeController = Get.put(HomeController());

  String selectedLevel = "";
  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ThemeFooter(),
          Padding(
            padding: EdgeInsets.fromLTRB(AppConst.padding * 2,
                AppConst.padding * 3, AppConst.padding * 2, 0),
            child: Column(
              children: [
                Center(
                  child: Text("LingoRead",
                      style: Theme.of(context).textTheme.headline1),
                ),
                SizedBox(height: AppConst.padding * 2),
                Center(
                  child: Text("Select Level",
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 22)),
                ),
                SizedBox(height: AppConst.padding * 2),
                Expanded(
                  child: loadingLevels
                      ? Obx(
                          () => ListView.builder(
                              itemCount: levelsControllers.listLevels.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: AppConst.padding * 0.3),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        selectedLevel = levelsControllers
                                            .listLevels[index]["title"]
                                            .toString();
                                      });
                                      print(levelsControllers.selectedLevel);
                                      levelsControllers.setSelectedLevel(
                                          levelsControllers.listLevels[index]
                                                  ["title"]
                                              .toString());
                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      await prefs.setString(
                                          "level", selectedLevel);
                                      Get.toNamed(Routes.homeScreen);
                                      // loadStories(selectedLevel);
                                    },
                                    child: Obx(
                                      () => Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  AppConst.padding * 0.5),
                                          decoration: BoxDecoration(
                                            color: levelsControllers
                                                            .listLevels[index]
                                                        ["title"] ==
                                                    selectedLevel
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(
                                                AppConst.padding * 0.5),
                                            border: Border.all(
                                              color: Color(0xff244D63),
                                              width: 2,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${levelsControllers.listLevels[index]["title"]}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2!
                                                    .copyWith(
                                                        fontSize: 24,
                                                        fontFamily: GoogleFonts
                                                                .poppins()
                                                            .fontFamily),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${levelsControllers.listLevels[index]["description"]}"
                                                      .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2!
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .poppins()
                                                                  .fontFamily,
                                                          color: (selectedLevel ==
                                                                  levelsControllers
                                                                              .listLevels[
                                                                          index]
                                                                      ["title"])
                                                              ? Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary
                                                              : ThemeController
                                                                      .to
                                                                      .isDark
                                                                      .isTrue
                                                                  ? Color(
                                                                      0xff35657E)
                                                                  : Color(
                                                                      0xff00C2D6)),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Obx(
                                                () => Radio(
                                                    activeColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                    fillColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            ThemeController
                                                                    .to
                                                                    .isDark
                                                                    .isTrue
                                                                ? Color(
                                                                    0xff254E64)
                                                                : Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary),
                                                    // overlayColor:   ,

                                                    value:
                                                        "${levelsControllers.listLevels[index]["title"]}",
                                                    groupValue: selectedLevel,
                                                    onChanged: (value) {
                                                      // print(value);
                                                      // levelsControllers.setSelectedLevel(
                                                      //     value.toString());
                                                    }),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              })),
                        )
                      : Column(
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
