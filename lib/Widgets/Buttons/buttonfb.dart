import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Utils/app_constants.dart';

class ButtonFB extends StatelessWidget {
  ButtonFB({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  // final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        elevation: 4,
        padding: EdgeInsets.all(10),
        primary: Theme.of(context).primaryColorDark,
        backgroundColor: Color(0xFF549DF2),
      ),
      onPressed: onPressed as void Function()?,
   
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 22,
            child: Image.asset("assets/images/fb.png"),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Facebook",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

