import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/member/add_member/add_customer.dart';
import 'package:admin/screens/member/add_member/add_repairshop.dart';
import 'package:admin/screens/member/add_member/add_towingshop.dart';
import 'package:admin/screens/member/customer.dart';
import 'package:admin/screens/member/repairshop.dart';
import 'package:admin/screens/member/towingshop.dart';
import 'package:admin/screens/member/update_menber/update_customer.dart';
import 'package:admin/screens/notification/repairshop_notification.dart';
import 'package:admin/screens/notification/towingshop_notification.dart';
import 'package:admin/screens/report/customer_resport.dart';
import 'package:admin/screens/report/repairshopScore_report.dart';
import 'package:admin/screens/report/repairshop_report.dart';
import 'package:admin/screens/report/requestRepair_report.dart';
import 'package:admin/screens/report/requestTowing_report.dart';
import 'package:admin/screens/report/shopCannelRequest_report.dart';
import 'package:admin/screens/report/towingshopScore_report.dart';
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
                  case MenuItems.customer:
                    return const Customer();
                  case MenuItems.repairshop:
                    return const Repairshop();
                  case MenuItems.towingshop:
                    return const Towingshop();
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
                  case MenuItems.repairshopScoreReport:
                    return const RepairshopScoreReport();
                  case MenuItems.towingshopScoreReport:
                    return const TowingshopScoreReport();
                  case MenuItems.addCustomer:
                    return const AddCustomer();
                  case MenuItems.addRepairshop:
                    return const AddRepairshop();
                  case MenuItems.addTowingshop:
                    return const AddTowingshop();
                  case MenuItems.updateCustomer:
                    return UpdateCustomer();
                  case MenuItems.repairshopNotification:
                    return const RepairshopNotification();
                  case MenuItems.towingshopNotification:
                    return const TowingshopNotification();
                  case MenuItems.shopCannelRequest:
                    return const ShopCannelRequestReport();
                  // case MenuItems.updateRepairshop:
                  //   return UpdateCustomer();
                  // case MenuItems.updateTowingshop:
                  //   return UpdateCustomer();
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
