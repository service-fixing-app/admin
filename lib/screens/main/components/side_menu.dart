import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              MenuAppController.instance
                  .changeSelectedItem(MenuItems.dashboard);
            },
          ),
          // DrawerListTile(
          //   title: "ສະມາຊິກ",
          //   svgSrc: "assets/icons/menu_tran.svg",
          //   press: () {
          //     //
          //   },
          // ),
          ExpansionTile(
            title: DrawerListTile(
              title: "ສະມາຊິກ",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                // Handle ລາຍງານ menu item press
              },
            ),
            children: [
              ListTile(
                title: const Text(
                  "ຈັດການຜູ້ໃຊ້",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.customer);
                },
              ),
              ListTile(
                title: const Text(
                  "ຈັດການຮ້ານສ້ອມແປງລົດ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.repairshop);
                },
              ),
              ListTile(
                title: const Text(
                  "ຈັດການຮ້ານແກ່ລົດ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.towingshop);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: DrawerListTile(
              title: "ລາຍງານ",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                // Handle ລາຍງານ menu item press
              },
            ),
            children: [
              ListTile(
                title: const Text(
                  "ລາຍງານຈຳນວນຜູ້ໃຊ້",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.cusomterReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຈຳນວນຮ້ານສ້ອມແປງລົດ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.repairshopReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຈຳນວນຮ້ານແກ່ລົດ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.towingshopReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຈຳນວນຄະແນນຮ້ານສ້ອມແປງ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.repairshopScoreReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຈຳນວນຄະແນນຮ້ານແກ່ລົດ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.towingshopScoreReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຮ້ອງຂໍບໍລິການສ້ອມແປງ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.requestRepairReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຮ້ອງຂໍບໍລິການແກ່ລົດ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.requestTowingReport);
                },
              ),
              ListTile(
                title: const Text(
                  "ລາຍງານຮ້ານທີ່ຖືກການຍົກເລີກ",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.shopCannelRequest);
                },
              ),
            ],
          ),
          ExpansionTile(
            title: DrawerListTile(
              title: "ແຈ້ງເຕືອນ",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {
                // Handle ລາຍງານ menu item press
              },
            ),
            children: [
              ListTile(
                title: const Text(
                  "ແຈ້ງເຕືອນສະໜັກຮ້ານສ້ອມແປງລົດໃໝ່",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.repairshopNotification);
                },
              ),
              ListTile(
                title: const Text(
                  "ແຈ້ງເຕືອນສະໜັກຮ້ານແກ່ລົດລົດໃໝ່",
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  MenuAppController.instance
                      .changeSelectedItem(MenuItems.towingshopNotification);
                },
              ),
            ],
          ),
          DrawerListTile(
            title: "ການຕັ້ງຄ່າ",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "ອອກຈາກລະບົບ",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              Get.offAll(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(fontColorDefualt, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: fontColorDefualt, fontSize: 16),
      ),
    );
  }
}
