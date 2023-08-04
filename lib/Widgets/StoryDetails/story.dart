import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lingoread/Controllers/Theme/storyDetails_controller.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Utils/app_funtions.dart';

import '../../Controllers/Theme/favcontroller.dart';

class StoryDetails extends StatelessWidget {
  StoryDetails(this.story, this.isPaidStory, {Key? key}) : super(key: key);
  final dynamic story;

  final bool isPaidStory;

  FavController favController = Get.put(FavController());
  StoryDetailsControllers storyDetailsControllers =
      Get.put(StoryDetailsControllers());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              AppConst.padding * 1, AppConst.padding, AppConst.padding * 1, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (story ?? {})["title"] ?? "",
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: ThemeController.to.isDark.isTrue
                              ? AppConst.colorWhite
                              : AppConst.colorWhite,
                        ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        DateFormat('MMM dd, yyyy').format(DateTime.parse(
                            ((story ?? {})["created_on"] ??
                                DateTime.now().toString()))),
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ThemeController.to.isDark.isTrue
                                ? AppConst.dark_colorPrimaryDark
                                : Color(0xffffffff)),
                        child: Center(
                          child: Text((story ?? {})["level_id"] ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                      color: ThemeController.to.isDark.isTrue
                                          ? AppConst.colorWhite
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Obx(
                    () => InkWell(
                      onTap: () {
                        if (favController.checkIfAddedtoFav(
                                (story ?? {})["id"] ?? "0") ==
                            -1) {
                          favController.addtoFav((story ?? {})["id"] ?? "",
                              isFavScreen: true);
                        } else {
                          favController.removeFromFav((story ?? {})["id"] ?? "",
                              isFavScreen: true);
                        }
                      },
                      child: favController.checkIfAddedtoFav(
                                  (story ?? {})["id"] ?? "0") ==
                              -1
                          ? const Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ThemeController.to.isDark.isTrue
                            ? AppConst.dark_colorPrimaryDark
                            : Color(0xff1AB5CA)),
                    child: Center(
                      child: Text((story ?? {})["subscription_type"] ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: AppConst.padding * 1.3,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              // padding: EdgeInsets.fromLTRB(
              //     AppConst.padding, AppConst.padding, AppConst.padding, 0),
              child: Obx(
                () => Wrap(
                  spacing: -6.1,
                  runSpacing: -2.1,
                  children: storyDetailsControllers.listStoryDisWords
                      .asMap()
                      .entries
                      .map((e) => InkWell(
                            onTap: () async {
                              if (isPaidStory) {
                                AppFunctions.subcribeplan(context);
                              } else {
                                storyDetailsControllers.setWordForTranslation(
                                    e.key, e.value);
                              }

                              // setState(() {
                              //   selectedWordIndex = e.key;
                              //   readingword = e.value;
                              // });
                              // Translation translated =
                              //     await translator.translate(
                              //         e.value,
                              //         from: 'de',
                              //         to: 'en');
                              // setState(() {
                              //   wordToTranslate = e.value;
                              //   translatedWord = translated.text;
                              // });
                            },
                            child: ImageFiltered(
                              imageFilter: (e.key > 15 && isPaidStory)
                                  ? ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0)
                                  : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: storyDetailsControllers
                                                  .selectedWordIndex.value ==
                                              e.key
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  child: Text(
                                    e.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                            fontSize: 14),
                                  )),
                            ),
                          ))
                      .toList(),
                ),
              ),

              //  Text(
              //   (story ?? {})["description"] ?? "",
              //   textAlign: TextAlign.left,
              //   style: Theme.of(context).textTheme.headline5!.copyWith(
              //       fontFamily: GoogleFonts.poppins().fontFamily, fontSize: 14),
              // ),
            ),
          ),
        )
      ],
    );
  }
}
