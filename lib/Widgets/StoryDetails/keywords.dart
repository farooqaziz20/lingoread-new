import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/keywordcontroller.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Controllers/Theme/traningKeywords.dart';

import '../../Utils/app_constants.dart';

class KeyWords extends StatelessWidget {
  const KeyWords(this.keywords, this.flutterTts, {Key? key}) : super(key: key);
  final List keywords;
  final FlutterTts flutterTts;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(AppConst.padding * 1,
                AppConst.padding * 1, AppConst.padding * 1, 0),
            child: ListView.builder(
                itemCount: keywords.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic keyword = keywords[index];

                  return Keyword(keyword, flutterTts);
                }),
          ),
        )
      ],
    );
  }
}

class Keyword extends StatelessWidget {
  Keyword(this.keyword, this.flutterTts, {Key? key}) : super(key: key);
  final dynamic keyword;
  KeywordController keywordController = Get.put(KeywordController());
  final FlutterTts flutterTts;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ThemeController.to.isDark.isTrue
                ? AppConst.dark_colorPrimaryDark
                : Color(0xff00767D)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (keyword ?? {})["title"] ?? "",
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (keyword ?? {})["subtitle"] ?? "",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: const Color(
                            0xffA7A7A7,
                          ),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      flutterTts.speak((keyword ?? {})["title"] ?? "");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.volume_up,
                        color: ThemeController.to.isDark.isTrue
                            ? AppConst.colorWhite
                            : Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (((TrainingKeyword.to.listTrainingKeyword.indexWhere(
                              (element) =>
                                  element["keyword"].toString() ==
                                  keyword["id"].toString())) >
                          -1)) {
                        TrainingKeyword.to.removeFromFav(keyword["id"],
                            isTrainingScreen: true);
                        // keywordController.setAddedStatus(false);
                      } else {
                        TrainingKeyword.to.addtoTraining(keyword["id"],
                            isTrainingScreen: true);
                        // keywordController.setAddedStatus(true);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ((TrainingKeyword.to.listTrainingKeyword
                                    .indexWhere((element) =>
                                        element["keyword"].toString() ==
                                        keyword["id"].toString())) >
                                -1)
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                      ),
                      child: const Image(
                        image: AssetImage(
                          'assets/images/icon_training.png',
                        ),
                        width: 25,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )));
  }
}
