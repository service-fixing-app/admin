import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MenuItems {
  dashboard,
  customer,
  repairshop,
  towingshop,
  cusomterReport,
  repairshopReport,
  towingshopReport,
  requestRepairReport,
  requestTowingReport,
  repairshopScoreReport,
  towingshopScoreReport,
  addCustomer,
  addRepairshop,
  addTowingshop,
  updateCustomer,
  updateRepairshop,
  updateTowingshop,
  towingshopNotification,
  repairshopNotification,
  shopCannelRequest
}

class MenuAppController extends GetxController {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final selectedMenuItem = MenuItems.dashboard.obs;
  final selectedCustomerData = Rx<Map<String, dynamic>?>(null);

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  // void changeSelectedItem(MenuItems item) {
  //   selectedMenuItem.value = item;
  // }

  void changeSelectedItem(MenuItems item,
      {Map<String, dynamic>? customerData}) {
    selectedMenuItem.value = item;
    if (customerData != null) {
      selectedCustomerData.value = customerData;
    }
  }

  // Static instance getter
  static MenuAppController get instance => Get.find<MenuAppController>();
}
