import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/controllers/loginController.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MenuAppController menuController = Get.find();

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: menuController.controlMenu,
          ),
        if (!Responsive.isMobile(context))
          const Text(
            "Dashboard",
            style: TextStyle(color: fontColorDefualt),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find();
    final userData = loginController.userData;

    // Check if userData is not null and contains the 'user' property
    if (userData != null && userData.containsKey('user')) {
      final user = userData['user'];
      final userName = user['name'];

      return Container(
        margin: const EdgeInsets.only(left: defaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/admin.png",
              width: 40,
              height: 40,
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Text(
                  userName,
                  style: const TextStyle(color: fontColorDefualt),
                ),
              ),
            // const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      );
    } else {
      // Handle the case where userData is null or does not contain the 'user' property
      // For example, you can return a loading indicator or an empty container
      return Container();
    }
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "ຄົ້ນຫາ",
        hintStyle: const TextStyle(color: fontColorDefualt),
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
