import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';

import '../../Utils/app_constants.dart';
import 'package:flutter_html/flutter_html.dart';

class Grammer extends StatelessWidget {
  Grammer(this.grammers, {Key? key}) : super(key: key);
  final List grammers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppConst.padding * 1, AppConst.padding * 1, AppConst.padding * 1, 0),
      child: ListView.builder(
        itemCount: grammers.length,
        itemBuilder: (context, index) {
          dynamic grammer = grammers[index];
          return GrammerWidget(grammer);
        },
      ),
    );
  }
}

class GrammerWidget extends StatelessWidget {
  GrammerWidget(this.data, {Key? key}) : super(key: key);
  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppConst.padding * 0.5),
      padding: EdgeInsets.fromLTRB(AppConst.padding * 1, AppConst.padding * 1,
          AppConst.padding * 1, AppConst.padding * 1),
      decoration: BoxDecoration(
        border: Border.all(
            color: ThemeController.to.isDark.isTrue
                ? AppConst.colorWhite
                : Theme.of(context).colorScheme.onBackground,
            width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: ThemeController.to.isDark.isTrue
            ? AppConst.color_343434.withOpacity(0.28)
            : Theme.of(context).primaryColorDark,
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (data ?? {})["name"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: AppConst.colorWhite),
            )
          ],
        ),
        SizedBox(
          height: AppConst.padding * 0.5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Example',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: ThemeController.to.isDark.isTrue
                      ? AppConst.colorWhite
                      : Color(0xff00E0FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
                child: Html(
              data: data['example'],
            )),
            SizedBox(
              height: 6,
            ),
            Text(
              'Description',
              style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: ThemeController.to.isDark.isTrue
                      ? AppConst.colorWhite
                      : Color(0xff00E0FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              child: Html(
                data: data["content"] ?? "",
              ),
            )
          ],
        )
      ]),
    );
  }
}
