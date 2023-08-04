import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';

import '../Utils/app_constants.dart';

class TrainingScreenWidget extends StatelessWidget {
  const TrainingScreenWidget(this.obj, {Key? key}) : super(key: key);

  final dynamic obj;

  @override
  Widget build(BuildContext context) {
    print(obj);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConst.padding,
        vertical: AppConst.padding * 0.2,
      ),
      child: Container(
          padding: EdgeInsets.all(AppConst.padding * 0.25),
          decoration: BoxDecoration(
              border: Border.all(
                  color: ThemeController.to.isDark.isTrue
                      ? AppConst.colorWhite
                      : Colors.black),
              borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    obj["title"] ?? "",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                InkWell(
                  onTap: () {
                    FlutterTts().speak(obj["title"] ?? "");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.volume_up,
                      color: ThemeController.to.isDark.isTrue
                          ? AppConst.colorWhite
                          : Colors.black,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class TrainingReviewWidget extends StatelessWidget {
  const TrainingReviewWidget(this.color, this.number, this.text, {Key? key})
      : super(key: key);
  final String text;
  final int number;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: 25,
      width: 250,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          number.toString(),
          style: Theme.of(context).textTheme.headline3!.copyWith(
              color: ThemeController.to.isDark.isTrue
                  ? AppConst.colorWhite
                  : Color(0xff000000),
              fontWeight: FontWeight.bold),
        )
      ]),
    );
  }
}
