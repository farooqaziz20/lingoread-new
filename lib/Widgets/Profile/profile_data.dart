import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/Theme/themecontroller.dart';
import '../../Utils/app_constants.dart';

class ProfileData extends StatelessWidget {
  const ProfileData(this.text, this.icon1, this.number,
      {Key? key, required this.color})
      : super(key: key);
  final String text;
  final IconData icon1;
  final int number;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: ThemeController.to.isDark.isTrue
                      ? AppConst.colorWhite
                      : Theme.of(context).primaryColor),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              icon1,
              color: color,
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          child: Text(number.toString(),
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: ThemeController.to.isDark.isTrue
                        ? AppConst.colorWhite
                        : Theme.of(context).primaryColorDark,
                  )),
        ),
      ],
    );
  }
}
