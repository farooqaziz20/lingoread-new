import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/traningKeywords.dart';
import 'package:lingoread/Routes/routes_names.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:lingoread/Widgets/training_screen_widget.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Widgets/Header/CustomerHeader.dart';
import 'package:lingoread/Widgets/Main/footer.dart';

import '../Controllers/Theme/themecontroller.dart';
import '../Widgets/Drawer/custome_drawer.dart';
import '../Widgets/Main/custom_container.dart';

class Training extends StatefulWidget {
  const Training({Key? key}) : super(key: key);

  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  @override
  void initState() {
    // TODO: implement initState
    TrainingKeyword.to.loadKeywords();

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();


  List keywordsShow = [];
  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        child: Scaffold(
      key: _scaffoldkey,
      drawer: CustomDrawer(context),
      body: Stack(children: [
        ThemeFooter(),
        Column(
          children: [
            SizedBox(height: AppConst.padding * 3),
            CustomerHeader(
              title: "Training",
              image: ThemeController.to.isDark.isTrue
                  ? "assets/images/icon_menu_white.png"
                  : 'assets/images/icon_menu.png',
              titleimage: ThemeController.to.isDark.isTrue
                  ? 'assets/images/training_icon_dark.png'
                  : 'assets/images/icon_training.png',
              onPressed: () {
                _scaffoldkey.currentState!.openDrawer();

                // Get.back();
              },
            ),
            SizedBox(height: AppConst.padding * 2),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: AppConst.padding * 1),
                    child: Row(
                      children: [
                        Text(
                          'Added Keywords',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: AppConst.colorWhite),
                        )
                      ],
                    ),
                  ),

                  Obx(
                    () => TrainingKeyword.to.listTrainingKeyword.length > 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return TrainingScreenWidget(TrainingKeyword
                                  .to.listTrainingKeyword[index]);
                            },
                            itemCount: (TrainingKeyword
                                        .to.listTrainingKeyword.length >
                                    4)
                                ? 2
                                : TrainingKeyword.to.listTrainingKeyword.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "No Keywords Added",
                              style: Get.textTheme.headline3,
                            ),
                          ),
                  ),

                  if ((TrainingKeyword.to.listTrainingKeyword.length > 4))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "and More ${TrainingKeyword.to.listTrainingKeyword.length - 4} Keywords",
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      ],
                    ),

                  // const TrainingScreenWidget(),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // TrainingScreenWidget(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TrainingScreenWidget(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // TrainingScreenWidget(),
                  SizedBox(
                    height: AppConst.padding * 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: AppConst.padding * 1),
                    child: Row(
                      children: [
                        Text(
                          'Assign Keywords',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: AppConst.colorWhite),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => TrainingReviewWidget(
                        ThemeController.to.isDark.isTrue
                            ? AppConst.dark_colorPrimaryDark
                            : Color(0xff0094FF),
                        TrainingKeyword.to.totalHardKeywords.value,
                        'Hard'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => TrainingReviewWidget(
                        ThemeController.to.isDark.isTrue
                            ? AppConst.dark_colorPrimaryDark
                            : Color(0xff22D269),
                        TrainingKeyword.to.totalOkKeywords.value,
                        'Okay'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => TrainingReviewWidget(
                        ThemeController.to.isDark.isTrue
                            ? AppConst.dark_colorPrimaryDark
                            : Color(0xffCA1A79),
                        TrainingKeyword.to.totalEasyKeywords.value,
                        'Easy'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => TrainingReviewWidget(
                        ThemeController.to.isDark.isTrue
                            ? AppConst.dark_colorPrimaryDark
                            : Color(0xffD4CC0C),
                        TrainingKeyword.to.totalCompletedKeywords.value,
                        'Done'),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ThemeController.to.isDark.isTrue
                              ? AppConst.colorPrimaryLightv3_1BA0C1
                              : Color(0xffffffff)),
                      child: InkWell(
                        onTap: () {
                          if (TrainingKeyword.to.listTrainingKeyword.length >
                              0) {
                            Get.toNamed(
                              Routes.total_words,
                            );
                          } else {
                            AppFunctions.showSnackBar(
                                "Message", "No Keywords Added to Play");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: ThemeController.to.isDark.isTrue
                                  ? Color(0xffffffff)
                                  : Color(0xff00767D),
                              child: ThemeController.to.isDark.isTrue
                                  ? Image(
                                      image: AssetImage(
                                          'assets/images/iconTrainingDark.png'))
                                  : Image(
                                      image: AssetImage(
                                          'assets/images/iconTraining.png')),
                            ),
                            // Icon(Icons.card_membership,
                            //     color: ThemeController.to.isDark.isTrue
                            //         ? AppConst.colorWhite
                            //         : AppConst.colorPrimaryDark),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Play in Card',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      color: ThemeController.to.isDark.isTrue
                                          ? AppConst.colorWhite
                                          : Color(0xff00ACC4),
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ))
          ],
        )
      ]),
    ));
    ;
  }
}
