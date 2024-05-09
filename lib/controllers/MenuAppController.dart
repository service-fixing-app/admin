import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MenuItems {
  dashboard,
  cusomterReport,
  repairshopReport,
  towingshopReport,
  requestRepairReport,
  requestTowingReport,
}

class MenuAppController extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedMenuItem = MenuItems.dashboard.obs;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void changeSelectedItem(MenuItems item) {
    selectedMenuItem.value = item;
  }

  // Static instance getter
  static MenuAppController get instance => Get.find<MenuAppController>();
}
