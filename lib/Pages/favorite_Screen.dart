import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:lingoread/Controllers/Theme/favcontroller.dart';
import 'package:lingoread/Services/postRequests.dart';
import 'package:lingoread/Utils/app_constants.dart';
import 'package:lingoread/Widgets/Header/CustomerHeader.dart';
import 'package:lingoread/Widgets/Main/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controllers/Theme/themecontroller.dart';
import '../Widgets/Drawer/custome_drawer.dart';
import '../Widgets/Home/story.dart';
import '../Widgets/Main/custom_container.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => favController.loadFav());
  }

  FavController favController = Get.put(FavController());

  List listFav = [];
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
              title: "Favourites",
              titleicon: Icons.favorite,
              // titleimage: 'assets/images/setting_first_vector.png',
              onPressed: () {
                _scaffoldkey.currentState!.openDrawer();
              },
            ),
            SizedBox(height: AppConst.padding * 2),
            Expanded(
              child: Obx(() => favController.listFavStories.length > 0
                  ? CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              dynamic story = favController.listFavStories.value[index];
                              return Story(
                                story,
                                context,
                                favController,
                                isFavScreen: true,
                              );
                            },
                            childCount: favController.listFavStories.value.length,
                          ),
                        )
                      ],
                    )
                  : Text("No Stories Found")),
            )
          ],
        )
      ]),
    ));
    ;
  }
}
