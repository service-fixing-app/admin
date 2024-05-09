import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/report/customer_resport.dart';
import 'package:admin/screens/report/repairshop_report.dart';
import 'package:admin/screens/report/requestRepair_report.dart';
import 'package:admin/screens/report/requestTowing_report.dart';
import 'package:admin/screens/report/towingshop_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  final MenuAppController menuController = Get.find();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: menuController.scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Obx(() {
                // Listen to the selected menu item in the controller
                final selectedItem = menuController.selectedMenuItem.value;
                // Based on the selected item, display the corresponding page
                switch (selectedItem) {
                  case MenuItems.dashboard:
                    return const DashboardScreen();
                  case MenuItems.cusomterReport:
                    return const CustomerReport();
                  case MenuItems.repairshopReport:
                    return const RepairshopReport();
                  case MenuItems.towingshopReport:
                    return const TowingshopReport();
                  case MenuItems.requestRepairReport:
                    return const RequestRepariReport();
                  case MenuItems.requestTowingReport:
                    return const RequestTowingReport();
                  default:
                    return Container();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
