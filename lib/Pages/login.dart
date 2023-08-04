import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lingoread/Controllers/Theme/profileController.dart';
import 'package:lingoread/Pages/introduction.dart';
import 'package:lingoread/Utils/Theme/decoration.dart';
import 'package:lingoread/Utils/app_funtions.dart';
import 'package:lingoread/Widgets/Buttons/authServices.dart';
import 'package:lingoread/Widgets/Buttons/buttongoogle.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:lingoread/Widgets/Main/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Routes/routes_names.dart';
import '../Services/postRequests.dart';
import '../Utils/app_constants.dart';
import '../Widgets/Buttons/button_main.dart';
import '../Widgets/Buttons/buttonfb.dart';
import '../Widgets/TextField/myTextFromField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController textEditingControllerEmail = TextEditingController();
  TextEditingController textEditingControllerPassword = TextEditingController();
  String verificationIdNew = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSendingMessage = false;
  bool isSendingMessageGuest = false;
  bool isLoadingFacebook = false;
  bool isLoadingGoogle = false;
  @override
  Widget build(BuildContext context) {
    return ThemeContainer(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ThemeFooter(),
          Padding(
            padding: EdgeInsets.fromLTRB(AppConst.padding * 2,
                AppConst.padding * 3, AppConst.padding * 2, 0),
            child: Column(
              children: [
                Center(
                  child: Text("LingoRead",
                      style: Theme.of(context).textTheme.headline1),
                ),
                SizedBox(height: AppConst.padding * 2),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text("Login",
                            style: Theme.of(context).textTheme.headline2),
                        const SizedBox(height: 2),
                        Text("To Continue",
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                        SizedBox(height: AppConst.padding * 2),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              MyTextFormField(
                                controller: textEditingControllerEmail,
                                labelText: "Email",
                                isShowHeader: false,
                                isEnabled: !isSendingMessage,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter name";
                                  } else if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return "Please enter valid email";
                                  }
                                  return null;
                                },
                                isNumberOnly: false,
                              ),
                              SizedBox(height: AppConst.padding * 0.5),
                              MyTextFormField(
                                controller: textEditingControllerPassword,
                                hintText: "",
                                labelText: "Password",
                                isEnabled: !isSendingMessage,
                                isShowHeader: false,
                                validator: (value) {
                                  if (value.length < 8) {
                                    return 'Please enter 8 digit password';
                                  }
                                  return null;
                                },
                                isNumberOnly: false,
                              ),
                              SizedBox(height: AppConst.padding * 0.5),
                              isSendingMessage
                                  ? loadingwidget()
                                  : SizedBox(
                                      width: double.infinity,
                                      child: CustomButton(
                                        text: "Login",
                                        onPressed: () async {
                                          login();
                                        },
                                      ),
                                    ),
                              SizedBox(height: AppConst.padding * 0.5),
                              isLoadingFacebook
                                  ? loadingwidget()
                                  : ButtonFB(
                                      onPressed: () {
                                        loginFacebook();
                                      },
                                    ),
                              SizedBox(height: AppConst.padding * 0.5),
                              isLoadingGoogle
                                  ? loadingwidget()
                                  : ButtonGoogle(
                                      onPressed: () {
                                        loginGoogle();
                                      },
                                    ),
                              SizedBox(height: AppConst.padding * 0.5),
                              isSendingMessageGuest
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConst.padding * 0.25),
                                          color: AppConst
                                              .colorPrimaryLightv3_1BA0C1),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary)),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: CustomButton(
                                        text: "Guest Login",
                                        onPressed: () async {
                                          guestlogin();
                                        },
                                      ),
                                    ),
                              SizedBox(height: AppConst.padding),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't Have An Account? ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.register);
                                    },
                                    child: Text("Sign Up",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppConst.padding),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Container loadingwidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConst.padding * 0.25),
          color: Theme.of(context).primaryColor),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary)),
        ],
      ),
    );
  }

  login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSendingMessage = true;
      });
      dynamic data = {
        "action": "login",
        "user_email": textEditingControllerEmail.text,
        "user_password": textEditingControllerPassword.text,
      };
      APIsCallPost.submitRequest("", data).then((value) async {
        print(value.statusCode);
        if (value.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          print(value.data);
          await prefs.setString('userDetails', jsonEncode(value.data));
          await prefs.setString('Authorization', value.data["token"] ?? "");

          await prefs.setString('UserId', value.data["email"].toString());
          APIsCallPost.submitRequestWithAuth("", {"action": "randomstories"})
              .then((value) => {
                    if (value.statusCode == 200)
                      {
                        prefs.setString("Banners", jsonEncode(value.data)),
                        Get.offAllNamed(Routes.levelsScreen)
                      }
                    else
                      {
                        Get.offAllNamed(Routes.login),
                      }
                  });
        } else if (value.statusCode == 404) {
          AppFunctions.showSnackBar("Error", "Incorrect Username or Password");
          setState(() {
            isSendingMessage = false;
          });
        } else {
          AppFunctions.showSnackBar("Error",
              "Something went wrong, Please check your internet conection and try again.");
          setState(() {
            isSendingMessage = false;
          });
        }
      }).catchError((error) => print(error));
    }
  }

  guestlogin() {
    setState(() {
      isSendingMessageGuest = true;
    });
    dynamic data = {
      "action": "login",
      "user_email": "guest@lingoread.com",
      "user_password": "Guest",
    };
    APIsCallPost.submitRequest("", data).then((value) async {
      print(value.statusCode);
      if (value.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        print(value.data);
        await prefs.setString('userDetails', jsonEncode(value.data));
        await prefs.setString('Authorization', value.data["token"] ?? "");
        await prefs.setBool('isGuestLogin', true);

        await prefs.setString('UserId', value.data["email"].toString());
        APIsCallPost.submitRequestWithAuth("", {"action": "randomstories"})
            .then((value) => {
                  if (value.statusCode == 200)
                    {
                      prefs.setString("Banners", jsonEncode(value.data)),
                      Get.offAllNamed(Routes.levelsScreen)
                    }
                  else
                    {
                      Get.offAllNamed(Routes.login),
                    }
                });
      } else if (value.statusCode == 404) {
        AppFunctions.showSnackBar("Error", "Incorrect Username or Password");
        setState(() {
          isSendingMessageGuest = false;
        });
      } else {
        AppFunctions.showSnackBar("Error",
            "Something went wrong, Please check your internet conection and try again.");
        setState(() {
          isSendingMessageGuest = false;
        });
      }
    }).catchError((error) => print(error));
  }

  loginFacebook() async {
    setState(() {
      isLoadingFacebook = true;
    });
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        dynamic data = {
          "action": "soicallogins",
          "user_name": "",
          "user_emai": "",
        };
        print(data);
        APIsCallPost.submitRequest("", data).then((value) async {
          print(value.statusCode);

          if (value.statusCode == 200) {
            final prefs = await SharedPreferences.getInstance();
            print(value.data);
            await prefs.setString('userDetails', jsonEncode(value.data));
            await prefs.setString('Authorization', value.data["token"] ?? "");

            await prefs.setString('UserId', value.data["email"].toString());
            APIsCallPost.submitRequestWithAuth("", {"action": "randomstories"})
                .then((value) => {
                      if (value.statusCode == 200)
                        {
                          prefs.setString("Banners", jsonEncode(value.data)),
                          Get.offAllNamed(Routes.levelsScreen)
                        }
                      else
                        {
                          Get.offAllNamed(Routes.login),
                        }
                    });
          } else {
            AppFunctions.showSnackBar("Error", "User Not Found");
            setState(() {
              isLoadingFacebook = false;
            });
          }
        }).catchError((error) => print(error));
      } else {
        setState(() {
          isLoadingFacebook = false;
        });
        AppFunctions.showSnackBar("Error", "Login failed");
      }
    } catch (e) {
      setState(() {
        isLoadingFacebook = false;
      });
    }
  }

  loginGoogle() async {
    setState(() {
      isLoadingGoogle = true;
    });
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      print(googleUser);
      if (googleUser != null) {
        dynamic data = {
          "action": "soicallogins",
          "user_name": googleUser.displayName ?? "",
          "user_email": googleUser.email,
        };
        print(data);
        APIsCallPost.submitRequest("", data).then((value) async {
          print(value.statusCode);

          if (value.statusCode == 200) {
            final prefs = await SharedPreferences.getInstance();
            print(value.data);
            await prefs.setString('userDetails', jsonEncode(value.data));
            await prefs.setString('Authorization', value.data["token"] ?? "");

            await prefs.setString('UserId', value.data["email"].toString());
            ProfileController.to.loadProfile();
            APIsCallPost.submitRequestWithAuth("", {"action": "randomstories"})
                .then((value) => {
                      if (value.statusCode == 200)
                        {
                          prefs.setString("Banners", jsonEncode(value.data)),
                          Get.offAllNamed(Routes.levelsScreen)
                        }
                      else
                        {
                          Get.offAllNamed(Routes.login),
                        }
                    });
          } else {
            AppFunctions.showSnackBar("Error", "User Not Found");
            setState(() {
              isLoadingGoogle = false;
            });
          }
        }).catchError((error) => print(error));
      } else {
        setState(() {
          isLoadingGoogle = false;
        });
        AppFunctions.showSnackBar("Error", "Login failed");
      }
    } catch (e) {
      setState(() {
        isLoadingGoogle = false;
      });
    }
  }
}
