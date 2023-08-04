import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lingoread/Controllers/Theme/profileController.dart';
import 'package:lingoread/Controllers/Theme/themecontroller.dart';
import 'package:lingoread/Pages/introduction.dart';
import 'package:lingoread/Services/postRequests.dart';
import 'package:lingoread/Utils/Theme/decoration.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:lingoread/Widgets/Buttons/buttongoogle.dart';
import 'package:lingoread/Widgets/Drawer/custome_drawer.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:lingoread/Widgets/Main/footer.dart';
import 'package:lingoread/Widgets/Profile/profile_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Routes/routes_names.dart';
import '../Utils/app_constants.dart';
import '../Widgets/Buttons/button_main.dart';
import '../Widgets/Buttons/buttonfb.dart';
import '../Widgets/Header/CustomerHeader.dart';
import '../Widgets/TextField/myTextFromField.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadProfile());
  }

  loadProfile() async {
    Loader.show(context, progressIndicator: CircularProgressIndicator());
    final prefs = await SharedPreferences.getInstance();
    String? userIdTemp = prefs.getString('UserId');
    APIsCallPost.submitRequestWithAuth("", {"action": "userprofile", "user_id": userIdTemp}).then((value) {
      if (value.statusCode == 200) {
        List list = value.data;
        dynamic data = list[0];

        setState(() {
          userData = list[0];
          favStories = int.parse((data['totalfavonstories'] ?? "0").toString());
          learnedWords = int.parse((data['totallearnedwords'] ?? "0").toString());
          learnedStoreis = int.parse((data['totallearnedstories'] ?? "0").toString());
        });
        // ProfileController.to.updateName((userData["name"] ?? "").toString());
        ProfileController.to.updateName((userData["name"] ?? "").toString());
      }
      Loader.hide();
    });
  }

  dynamic userData = {};
  int favStories = 0;
  int learnedWords = 0;
  int learnedStoreis = 0;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        child: Scaffold(
      key: _scaffoldkey,
      drawer: CustomDrawer(context),
      body: Stack(
        children: [
          ThemeFooter(),
          Column(
            children: [
              SizedBox(height: AppConst.padding * 3),
              CustomerHeader(
                image: ThemeController.to.isDark.isTrue
                    ? "assets/images/icon_menu_white.png"
                    : "assets/images/icon_menu.png",
                title: "Profile",
                onPressed: () {
                  _scaffoldkey.currentState!.openDrawer();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(AppConst.padding, AppConst.padding, AppConst.padding, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ThemeController.to.isDark.isTrue
                                ? AppConst.dark_colorPrimaryDark
                                : Theme.of(context).primaryColorDark,
                          ),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                      width: 100,
                                      height: 100,
                                      child: CircleAvatar(
                                          backgroundColor: Theme.of(context).colorScheme.secondary,
                                          // backgroundImage: NetworkImage(
                                          //     'https://www.thenews.com.pk/assets/uploads/updates/2022-01-18/926258_8142200_Hira-Mani_updates.jpg'),

                                          child: Icon(Icons.person,
                                              color: Theme.of(context).colorScheme.onPrimary, size: 60))),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => Text(
                                          ProfileController.to.userName.toString(),
                                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                              fontSize: 18,
                                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'AC Type: ',
                                            style: Theme.of(context).textTheme.headline3!.copyWith(
                                                fontSize: 14,
                                                color: ThemeController.to.isDark.isTrue
                                                    ? AppConst.colorWhite
                                                    : Theme.of(context).colorScheme.onPrimary.withOpacity(0.8)),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(18),
                                              color: ThemeController.to.isDark.isTrue
                                                  ? Color(0xffffffff)
                                                  : Color(0xff43C3BB),
                                            ),
                                            child: Text(
                                              (userData["user_status"] ?? "") + ' Plan',
                                              style: Theme.of(context).textTheme.headline3!.copyWith(
                                                  color: ThemeController.to.isDark.isTrue
                                                      ? Color(0xff000000)
                                                      : Color(0xffffffff),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ))
                                ],
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: PopupMenuButton<int>(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: AppConst.colorWhite,
                                  ),
                                  itemBuilder: (context) => [
                                    // PopupMenuItem 1
                                    PopupMenuItem(
                                      value: 1,
                                      // row with 2 children
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_note_outlined,
                                              color: ThemeController.to.isDark.isTrue
                                                  ? AppConst.colorBlack
                                                  : Color(0xff00565B)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Edit",
                                              style: TextStyle(color: Color(0xffA7A7A7), fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                    // PopupMenuItem 2
                                    PopupMenuItem(
                                      value: 2,
                                      // row with two children
                                      child: Row(
                                        children: [
                                          Icon(Icons.lock,
                                              color: ThemeController.to.isDark.isTrue
                                                  ? AppConst.colorBlack
                                                  : Color(0xff00565B)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Password",
                                              style: TextStyle(color: Color(0xffA7A7A7), fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      // row with two children
                                      child: Row(
                                        children: [
                                          Icon(Icons.settings,
                                              color: ThemeController.to.isDark.isTrue
                                                  ? AppConst.colorBlack
                                                  : Color(0xff00565B)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Settings",
                                            style: TextStyle(color: Color(0xffA7A7A7), fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                  offset: Offset(0, 40),
                                  color: Colors.white,
                                  elevation: 2,
                                  // on selected we show the dialog box
                                  onSelected: (value) async {
                                    final prefs = await SharedPreferences.getInstance();
                                    bool isGuest = prefs.getBool(
                                          'isGuestLogin',
                                        ) ??
                                        false;
                                    // if value 1 show dialog
                                    if (value == 1) {
                                      if (isGuest) {
                                        AppFunctions.showSnackBar('Info', 'Guest does not have Edit permission.');
                                      } else {
                                        Get.toNamed(Routes.edit_profile);
                                      }
                                    } else if (value == 2) {
                                      if (isGuest) {
                                        AppFunctions.showSnackBar('Info', 'Guest can not change password');
                                      } else {
                                        Get.toNamed(Routes.change_password);
                                      }
                                    } else if (value == 3) {
                                      Get.toNamed(Routes.setting);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: AppConst.padding, vertical: AppConst.padding),
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          child: Column(
                            children: [
                              ProfileData(
                                'Total Number of Fav Stories',
                                Icons.favorite,
                                favStories,
                                color:
                                    ThemeController.to.isDark.isTrue ? AppConst.colorPrimaryLightv3_1BA0C1 : Colors.red,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ProfileData('Total Number of Learned Words', Icons.menu_book_rounded, learnedWords,
                                  color: ThemeController.to.isDark.isTrue
                                      ? AppConst.colorWhite
                                      : Theme.of(context).primaryColorLight),
                              const SizedBox(
                                height: 20,
                              ),
                              ProfileData('Total Number of Learned Stories', Icons.menu_book_rounded, learnedStoreis,
                                  color: ThemeController.to.isDark.isTrue
                                      ? AppConst.colorWhite
                                      : Theme.of(context).primaryColorLight),
                              SizedBox(
                                height: AppConst.padding,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        AppFunctions.logout(context);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(17), color: Colors.white),
                                            child: Icon(
                                              Icons.logout,
                                              color: ThemeController.to.isDark.isTrue
                                                  ? AppConst.colorBlack
                                                  : AppConst.colorPrimaryLight,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Logout',
                                            style: Theme.of(context).textTheme.headline4!.copyWith(
                                                color: ThemeController.to.isDark.isTrue
                                                    ? AppConst.colorWhite
                                                    : AppConst.colorPrimaryLight),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
