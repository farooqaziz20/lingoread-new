import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lingoread/Widgets/Drawer/custome_drawer.dart';
import 'package:lingoread/Widgets/shop_wigdet.dart';
import 'package:lingoread/Widgets/Header/CustomerHeader.dart';
import 'package:lingoread/Widgets/Main/custom_container.dart';
import 'package:lingoread/Widgets/Main/footer.dart';

import '../Controllers/Theme/themecontroller.dart';
import '../Utils/app_constants.dart';

class Shop extends StatelessWidget {
  Shop({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

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
                image: ThemeController.to.isDark.isTrue
                    ? "assets/images/icon_menu_white.png"
                    : "assets/images/icon_menu.png",
                titleicon: Icons.shopping_cart,
                title: "Shop",
                onPressed: () {
                  _scaffoldkey.currentState!.openDrawer();
                },
              ),
              SizedBox(height: AppConst.padding * 1),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      AppConst.padding, AppConst.padding, AppConst.padding, 0),
                  child: Column(
                    children: [
                      Text('Subscribe',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                  color: ThemeController.to.isDark.isTrue
                                      ? AppConst.colorWhite
                                      : Color(0xff004C51),
                                  fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dignissim, elit vel viverra ornare, lacus ipsum aliquet massa, nec lacinia nunc diam vel velit. Mauris nec rutrum mi. ',
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ShopWidget(
                          'Monthly Plan',
                          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
                          Color(0xffE17614)),
                      SizedBox(
                        height: 20,
                      ),
                      ShopWidget(
                          'Monthly Plan',
                          'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
                          Color(0xff4A00C4)),
                      SizedBox(
                        height: AppConst.padding * 2,
                      ),
                      Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xff00ACC4)),
                          child: InkWell(
                            onTap: () {},
                            child: Center(
                                child: Text(
                              'Subscribe',
                              style: Theme.of(context).textTheme.headline4,
                            )),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
