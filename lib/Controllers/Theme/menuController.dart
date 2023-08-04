import 'package:get/get.dart';

class MenuCustomeController extends GetxController {
  static MenuCustomeController get to => Get.find();

  var selected = "Home".obs;
  setSelected(String value) => selected.value = value;
}
