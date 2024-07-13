import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/controllers/loginController.dart';
import 'package:admin/screens/login/login_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants.dart';

void main() {
  Get.put(MenuAppController());
  Get.put(LoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: bgColor,
        canvasColor: secondaryColor,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/mainScreen',
          page: () => MainScreen(),
        ),
      ],
      // initialRoute: '/',
    );
  }
}
