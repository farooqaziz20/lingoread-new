import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lingoread/Controllers/Theme/favcontroller.dart';
import 'package:lingoread/Controllers/Theme/homecontroller.dart';
import 'package:lingoread/Controllers/Theme/learnedStories.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Services/postRequests.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Routes/routes_names.dart';

class Story extends StatefulWidget {
  Story(this.story, this.context, this.favController,
      {Key? key, this.isFavScreen = false})
      : super(key: key);
  final dynamic story;
  final BuildContext context;
  final FavController favController;
  final bool isFavScreen;

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  void initState() {
    super.initState();

    getUserId();
    setData();
    setState(() {
      if (widget.isFavScreen) {
        isFav = true;
      } else {
        if (FavController.to.checkIfAddedtoFav(widget.story["id"]) > -1) {
          isFav = true;
        } else {
          isFav = false;
        }
      }
      // isFav = (widget.favController.listFavIDs
      //         .contains(widget.story["id"].toString()))
      //     ? true
      //     : false;
    });
  }

  setData() {
    try {
      setState(() {
        date = DateFormat("MMM dd, yyyy")
            .format(DateTime.parse(widget.story["created_on"].toString()));
      });
    } catch (e) {
      setState(() {
        date = DateFormat("MMM dd, yyyy").format(DateTime.now());
      });
    }
  }

  String date = "";
  FavController favController = Get.put(FavController());

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userIdTemp = prefs.getString('UserId');
    setState(() {
      userId = userIdTemp.toString();
    });
  }

  String userId = "";

  List list = [];
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(
            vertical: AppConst.padding * 0.25,
            horizontal: AppConst.padding * 0.5),
        padding: EdgeInsets.all(AppConst.padding * 0.5),
        decoration: BoxDecoration(
            color: ThemeController.to.isDark.isTrue
                ? Theme.of(context).colorScheme.primary
                : AppConst.light_textColor_gw,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Theme.of(context).primaryColorLight,
              width: 1.5,
            )),
        child: InkWell(
          onTap: () {
            HomeController.to.setFilter(false);

            Get.toNamed(Routes.stories_page, arguments: widget.story);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.story["title"].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 14,
                            color: ThemeController.to.isDark.isTrue
                                ? AppConst.light_textColor_gw
                                : Color(0xff07595F)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      color: ThemeController.to.isDark.isTrue
                                          ? Color(0xffA7A7A7)
                                          : AppConst.colorPrimaryLight,
                                      fontSize: 10,
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily),
                            ),
                            // SizedBox(width: AppConst.padding * 0.2),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConst.padding * 0.5,
                                  vertical: 3),
                              decoration: BoxDecoration(
                                color: ThemeController.to.isDark.isTrue
                                    ? AppConst.dark_backgruondColor
                                    : AppConst.colorPrimaryDark,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.story["level_id"].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeController.to.isDark.isTrue
                                            ? Color(0xffA7A7A7)
                                            : AppConst.light_textColor_gw,
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: AppConst.padding * 0.9),
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppConst.padding * 0.5,
                                  vertical: AppConst.padding * 0.2),
                              decoration: BoxDecoration(
                                color: widget.story["subscription_type"]
                                            .toString()
                                            .toUpperCase() ==
                                        'PAID'
                                    ? Color(0xffC99D3E)
                                    : ThemeController.to.isDark.isTrue
                                        ? AppConst.dark_backgruondColor
                                        : Color.fromARGB(255, 164, 162, 162),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.story["subscription_type"]
                                    .toString()
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeController.to.isDark.isTrue
                                            ? AppConst.colorWhite
                                            : Theme.of(context)
                                                .primaryColorLight,
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily),
                              ),
                            )
                          ],
                        ),
                      ),
                      Text(
                        widget.story["description"].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                            fontSize: 12,
                            color: ThemeController.to.isDark.isTrue
                                ? AppConst.colorWhite
                                : AppConst.colorBlack,
                            fontFamily: GoogleFonts.roboto().fontFamily),
                      ),
                    ],
                  ),
                ),
                // Stack(
                //   children: [
                //     SizedBox(
                //       width: 120,
                //       // // width: _screen.width * 0.40,
                //       // height: 100,
                //       child: Image(
                //         image: NetworkImage(widget.story["image"].toString()),
                //         fit: BoxFit.fill,
                //       ),
                //     ),
                //     Positioned(
                //       bottom: 2,
                //       right: 2,
                //       child: Row(
                //         children: [
                //           Container(
                //             width: 60,
                //             color: ThemeController.to.isDark.isTrue
                //                 ? AppConst.colorBlack
                //                 : Theme.of(context)
                //                     .colorScheme
                //                     .secondary
                //                     .withOpacity(0.5),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Obx(
                //                   () => InkWell(
                //                     onTap: () {
                //                       print("clicked");
                //                       if (!isFav) {
                //                         setState(() {
                //                           isFav = true;
                //                         });

                //                         favController.addtoFav(
                //                             widget.story["id"].toString(),
                //                             isFavScreen: true);
                //                         // widget.favController
                //                         //     .removeFav(widget.story["id"].toString());
                //                       } else {
                //                         favController.removeFromFav(
                //                             widget.story["id"].toString(),
                //                             isFavScreen: true);
                //                         setState(() {
                //                           isFav = false;
                //                         });
                //                       }
                //                     },
                //                     child: Icon(
                //                       (favController.checkIfAddedtoFav(
                //                                   widget.story["id"]) >
                //                               -1)
                //                           ? Icons.favorite
                //                           : Icons.favorite_border,
                //                       color: ThemeController.to.isDark.isTrue
                //                           ? Colors.white
                //                           : Color(0xff004C3F),
                //                       size: 25,
                //                     ),
                //                   ),
                //                 ),
                //                 InkWell(
                //                   onTap: () {
                //                     if (LearnedStories.to
                //                             .checkIfAddedtoTraining(
                //                                 widget.story["id"]) >
                //                         -1) {
                //                       LearnedStories.to.removeFromFLearned(
                //                           widget.story["id"].toString(),
                //                           isLearnedStoreisScreen: true);
                //                     } else {
                //                       LearnedStories.to.addtoLearned(
                //                           widget.story["id"].toString(),
                //                           isLearnedStoreisScreen: true);
                //                     }
                //                   },
                //                   child: Obx(
                //                     () => Icon(
                //                       (LearnedStories.to.checkIfAddedtoTraining(
                //                                   widget.story["id"]) >
                //                               -1)
                //                           ? Icons.check
                //                           : Icons.add,
                //                       color: Colors.white,
                //                       size: 25,
                //                     ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     )
                //   ],
                // ),
              ]),
        ),
      ),
    );
    ;
  }
}
