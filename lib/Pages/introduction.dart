import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lingoread/Utils/Theme/decoration.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Routes/routes_names.dart';
import '../Widgets/Buttons/buttonIntro.dart';

class Introduction extends StatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        child: SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: AppConst.padding * 2),
          child: Column(
            children: [
              Container(
                height: 130,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/header_intro_light.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppConst.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dignissim, elit vel viverra ornare, lacus ipsum aliquet massa, nec lacinia nunc diam vel velit. Mauris nec rutrum mi. In viverra libero non enim ultrices eleifend.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppConst.padding),
                        child: SizedBox(
                          width: double.infinity,
                          child: ButtonIntro(
                            text: "Let's Start",
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              String? userIdTemp = prefs.getString('UserId');
                              await prefs.setBool('isNotFirstVisit', true);
                              print(userIdTemp);
                              // Get.offAllNamed(Routes.login);
                              Get.offAllNamed(Routes.login);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
