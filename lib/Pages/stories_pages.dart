import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingoread/Controllers/Theme/learnedStories.dart';
import 'package:lingoread/Controllers/Theme/storyDetails_controller.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:lingoread/Widgets/Buttons/button_main.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:lingoread/Widgets/Main/footer.dart';
import 'package:lingoread/Widgets/StoryDetails/grammar.dart';
import 'package:lingoread/Widgets/StoryDetails/keywords.dart';
import 'package:lingoread/Widgets/StoryDetails/quiz.dart';
import 'package:lingoread/Widgets/StoryDetails/story.dart';
import 'package:translator_plus/translator_plus.dart';
import '../Utils/app_constants.dart';
import '../Widgets/Main/paid_star.dart';

class StoriesPage extends StatefulWidget {
  StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    storyDetailsControllers.setStory(Get.arguments);
    setState(() {
      isPaidStory = (((Get.arguments ?? {})["subscription_type"] ?? "") == "Paid") ? true : false;
      story = Get.arguments;
      textGerman = (Get.arguments ?? {})["description"] ?? "";
      storyId = (Get.arguments ?? {})["id"] ?? "";
      keywords = (((Get.arguments ?? {})["keywords"]) != false) ? (Get.arguments ?? {})["keywords"] ?? [] : [];
      grammer = (((Get.arguments ?? {})["grammer"]) != false) ? (Get.arguments ?? {})["grammer"] ?? [] : [];
      questions = (((Get.arguments ?? {})["questions"]) != false) ? (Get.arguments ?? {})["questions"] ?? [] : [];

      image = (Get.arguments ?? {})["image"] ?? "";
      checkBoxValue = (LearnedStories.to.checkIfAddedtoTraining((Get.arguments ?? {})["id"] ?? "") > -1) ? true : false;
    });
    print(Get.arguments);
  }

  StoryDetailsControllers storyDetailsControllers = Get.put(StoryDetailsControllers());
  List keywords = [];
  List grammer = [];
  List questions = [];
  String image = "";
  dynamic story = {};
  bool value = false;
  int screenNo = 0;
  bool checkBoxValue = false;
  String textGerman = "";

  String storyId = "-1";
  bool isPaidStory = false;
  String wordToTranslate = "";
  String translatedWord = "";
  final translator = GoogleTranslator();
  List listTextGerman = [];
  int selectedWordIndex = -1;
  FlutterTts flutterTts = FlutterTts();
  bool playingAudio = false;
  bool pauseAudio = false;
  bool is1x = true;
  String speed = "1";
  String readingword = "";

  playAudioOnSpeedChange() async {
    await flutterTts.setLanguage("de");
    await flutterTts.setQueueMode(1);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(storyDetailsControllers.getNewStringtoPlay());
    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      log("$startOffset $endOffset $word");
      storyDetailsControllers.setPlayingIndex(word);
    });

    flutterTts.setCancelHandler(() {
      // storyDetailsControllers
      //     .resetDataAfterRead();
    });
    flutterTts.setCompletionHandler(() {
      flutterTts.stop();
      storyDetailsControllers.resetDataAfterRead();
      setState(() {
        playingAudio = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
      child: Scaffold(
          body: Stack(
        children: [
          ///-----Background Footer Layers
          screenNo == 0
              ? ThemeFooter()
              : screenNo == 1
                  ? ThemeFooter()
                  : screenNo == 2
                      ? ThemeFooter()
                      : screenNo == 3
                          ? Container()
                          : Container(),
          // ThemeFooter(),
          Column(
            children: [
              SizedBox(height: AppConst.padding * 2),

              ///-------------App Bar
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: AppConst.padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ThemeController.to.isDark.isTrue
                              ? AppConst.colorWhite
                              : Theme.of(context).primaryColorLight,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      InkWell(
                        onTap: () {
                          if (checkBoxValue) {
                            LearnedStories.to.removeFromFLearned(storyId, isLearnedStoreisScreen: true);
                            setState(() {
                              checkBoxValue = !checkBoxValue;
                            });
                          } else {
                            LearnedStories.to.addtoLearned(storyId, isLearnedStoreisScreen: true);

                            setState(() {
                              checkBoxValue = !checkBoxValue;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'Mark As Read',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ThemeController.to.isDark.isTrue
                                    ? AppConst.light_textColor_gw
                                    : Theme.of(context).primaryColorDark,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 11,
                                backgroundColor: Theme.of(context).primaryColorLight,
                                child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: checkBoxValue
                                          ? Theme.of(context).colorScheme.onPrimary
                                          : Theme.of(context).colorScheme.secondary,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: AppConst.padding * 0.0001,
              ),

              ///-------Hero Image Box with Play/Pause & Speed Controllers
              Container(
                height: 210,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  image: (image == "" || image == null)
                      ? null
                      : DecorationImage(
                          image: NetworkImage(image.contains("http") ? image : (AppConst.imagebaseurl + image)),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (storyDetailsControllers.wordToTranslate.value != "")
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.5),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storyDetailsControllers.wordToTranslate.value,
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(storyDetailsControllers.translatedWord.value,
                                        style:
                                            TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    flutterTts.speak(storyDetailsControllers.wordToTranslate.value);
                                  },
                                  icon: Icon(
                                    Icons.volume_down_sharp,
                                    color: Theme.of(context).primaryColorDark,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          ///------Pause  / Play Button
                          //---- this will be shown when reading is continue
                          playingAudio
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    backgroundColor: ThemeController.to.isDark.isTrue
                                        ? AppConst.colorBlack
                                        : const Color(0xff00ACC4),
                                    radius: 20,
                                    child: IconButton(
                                      icon: Icon(pauseAudio ? Icons.pause : Icons.play_arrow, color: Colors.white),
                                      onPressed: (screenNo != 0)
                                          ? () {
                                              AppFunctions.showSnackBar("Info", "Open Story Tab to Play Story");
                                            }
                                          : () async {
                                              if (pauseAudio) {
                                                //   ///----if audio is playing then just stop it

                                                flutterTts.stop();
                                                setState(() {
                                                  pauseAudio = !pauseAudio;
                                                });
                                              } else {
                                                ///----- on resume functionality will be added here

                                                setState(() {
                                                  pauseAudio = !pauseAudio;
                                                });

                                                ///----- on resume functionality will be added here
                                                await flutterTts.setLanguage("de");
                                                await flutterTts.setQueueMode(1);
                                                await flutterTts.awaitSpeakCompletion(true);

                                                ///-----Replace the Previous Full Description to Latest Description read so far
                                                // await flutterTts
                                                //     .speak(textGerman);
                                                print(storyDetailsControllers.selectedWordIndex.value);

                                                await flutterTts.speak(storyDetailsControllers.getNewStringtoPlay());

                                                flutterTts.setProgressHandler(
                                                    (String text, int startOffset, int endOffset, String word) {
                                                  log("$startOffset $endOffset $word");
                                                  storyDetailsControllers.setPlayingIndex(word);
                                                });

                                                flutterTts.setCancelHandler(() {
                                                  // storyDetailsControllers
                                                  //     .resetDataAfterRead();
                                                });
                                                flutterTts.setCompletionHandler(() {
                                                  flutterTts.stop();
                                                  storyDetailsControllers.resetDataAfterRead();
                                                  setState(() {
                                                    playingAudio = false;
                                                  });
                                                });
                                              }
                                            },
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),

                          ///---------Play / Restart Button
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    ThemeController.to.isDark.isTrue ? AppConst.colorBlack : const Color(0xff00ACC4),
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(playingAudio ? Icons.stop : Icons.play_arrow, color: Colors.white),
                                  onPressed: (screenNo != 0)
                                      ? () {
                                          AppFunctions.showSnackBar("Info", "Open Story Tab to Play Story");
                                        }
                                      : () async {
                                          if (isPaidStory) {
                                            AppFunctions.subcribeplan(context);
                                          } else {
                                            if (playingAudio) {
                                              flutterTts.stop();
                                              storyDetailsControllers.resetDataAfterRead();
                                              setState(() {
                                                playingAudio = false;
                                                selectedWordIndex = 0;
                                              });
                                            } else {
                                              await flutterTts.setLanguage("de");
                                              await flutterTts.setQueueMode(1);
                                              await flutterTts.awaitSpeakCompletion(true);
                                              await flutterTts.speak(textGerman);
                                              flutterTts.setProgressHandler(
                                                  (String text, int startOffset, int endOffset, String word) {
                                                print("$startOffset $endOffset $word");
                                                storyDetailsControllers.setPlayingIndex(word);
                                              });

                                              setState(() {
                                                selectedWordIndex = 0;
                                                playingAudio = true;
                                                pauseAudio = true;
                                              });
                                              flutterTts.setCancelHandler(() {});
                                              flutterTts.setCompletionHandler(() {
                                                flutterTts.stop();
                                                storyDetailsControllers.resetDataAfterRead();
                                                setState(() {
                                                  playingAudio = false;
                                                });
                                              });
                                            }
                                          }
                                        },
                                ),
                              ),
                              if (isPaidStory)
                                const Positioned(
                                  child: PaidStar(),
                                  top: 0,
                                  right: 0,
                                )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          ///------Speed Button
                          Container(
                            decoration: BoxDecoration(
                                color: ThemeController.to.isDark.isTrue ? AppConst.colorBlack : Color(0xff58B9B3),
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                              icon: Text(
                                speed + "x".toUpperCase(),
                                style: TextStyle(
                                    color: ThemeController.to.isDark.isTrue
                                        ? AppConst.colorWhite
                                        : Theme.of(context).primaryColorLight,
                                    fontSize: 14,
                                    fontFamily: GoogleFonts.dmSans().fontFamily,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (speed == "0.5") {
                                  await flutterTts.stop();
                                  await flutterTts.setSpeechRate(0.35);
                                  setState(() {
                                    speed = "0.7";
                                  });
                                  playAudioOnSpeedChange();
                                } else if (speed == "0.7") {
                                  await flutterTts.stop();
                                  flutterTts.setSpeechRate(0.5);
                                  setState(() {
                                    speed = "1";
                                  });
                                  playAudioOnSpeedChange();
                                } else if (speed == "1") {
                                  await flutterTts.stop();

                                  flutterTts.setSpeechRate(0.7);
                                  setState(() {
                                    speed = "1.5";
                                  });
                                  playAudioOnSpeedChange();
                                } else if (speed == "1.5") {
                                  await flutterTts.stop();

                                  flutterTts.setSpeechRate(1.0);
                                  setState(() {
                                    speed = "2";
                                  });
                                  playAudioOnSpeedChange();
                                } else if (speed == "2") {
                                  await flutterTts.stop();

                                  flutterTts.setSpeechRate(0.25);
                                  setState(() {
                                    speed = "0.5";
                                  });
                                  playAudioOnSpeedChange();
                                } else {
                                  await flutterTts.stop();

                                  setState(() {
                                    flutterTts.setSpeechRate(0.5);
                                    speed = "1";
                                  });
                                  playAudioOnSpeedChange();
                                }
                                // flutterTts.setSpeechRate(!is1x ? 0.5 : 1.0);

                                // setState(() {
                                //   is1x = !is1x;
                                // });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ThemeController.to.isDark.isTrue ? AppConst.dark_colorPrimaryDark : Color(0xff58B9B3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            screenNo = 0;
                          });
                        },
                        child: Text(
                          "Story",
                          style: TextStyle(
                              color: (screenNo == 0)
                                  ? Color(0xFF162D3B)
                                  : ThemeController.to.isDark.isTrue
                                      ? AppConst.colorWhite
                                      : Theme.of(context).primaryColorLight,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(width: 2, height: 20, color: Colors.white),
                      InkWell(
                        onTap: () {
                          if (isPaidStory) {
                            AppFunctions.subcribeplan(context);
                          } else {
                            if (screenNo != 1) {
                              flutterTts.stop();
                              setState(() {
                                playingAudio = false;
                                selectedWordIndex = 0;
                              });
                            }
                            setState(() {
                              screenNo = 1;
                            });
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quiz",
                              style: TextStyle(
                                color: (screenNo == 1)
                                    ? Color(0xFF162D3B)
                                    : ThemeController.to.isDark.isTrue
                                        ? AppConst.colorWhite
                                        : Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isPaidStory) PaidStar()
                          ],
                        ),
                      ),
                      Container(width: 2, height: 20, color: Colors.white),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (isPaidStory) {
                                AppFunctions.subcribeplan(context);
                              } else {
                                if (screenNo != 2) {
                                  flutterTts.stop();
                                  setState(() {
                                    playingAudio = false;
                                    selectedWordIndex = 0;
                                  });
                                }
                                setState(() {
                                  screenNo = 2;
                                });
                              }
                            },
                            child: Text(
                              "Keywords",
                              style: TextStyle(
                                color: (screenNo == 2)
                                    ? Color(0xFF162D3B)
                                    : ThemeController.to.isDark.isTrue
                                        ? AppConst.colorWhite
                                        : Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isPaidStory) PaidStar()
                        ],
                      ),
                      Container(width: 2, height: 20, color: Colors.white),
                      InkWell(
                        onTap: () {
                          if (isPaidStory) {
                            AppFunctions.subcribeplan(context);
                          } else {
                            if (screenNo != 3) {
                              flutterTts.stop();
                              setState(() {
                                playingAudio = false;
                                selectedWordIndex = 0;
                              });
                            }
                            setState(() {
                              screenNo = 3;
                            });
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Grammer",
                              style: TextStyle(
                                color: (screenNo == 3)
                                    ? Color(0xFF162D3B)
                                    : ThemeController.to.isDark.isTrue
                                        ? AppConst.colorWhite
                                        : Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isPaidStory) PaidStar()
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              Expanded(
                  child: screenNo == 0
                      ? StoryDetails(story, isPaidStory)
                      : screenNo == 1
                          ? StoryQuiz(questions)
                          : screenNo == 2
                              ? KeyWords(keywords, flutterTts)
                              : screenNo == 3
                                  ? Grammer(grammer)
                                  : Container())
            ],
          ),
          if (isPaidStory)
            Positioned(
                bottom: Get.height * 0.23,
                left: 50,
                child: SizedBox(
                  width: Get.width - 100,
                  child: CustomButton(
                    text: "Read More",
                    onPressed: () async {
                      AppFunctions.subcribeplan(context);
                    },
                  ),
                ))
        ],
      )),
    );
  }
}
