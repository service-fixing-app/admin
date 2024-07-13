import 'dart:convert';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var isAuthenticated = false.obs;
  var token = ''.obs;
  var isLoading = false.obs;
  var userData = {}.obs;

  String urlLogin = "http://localhost:5000/api/user/sigin";

  Future<void> login(String name, String password) async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 2));
      final response = await http.post(
        Uri.parse(urlLogin),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'name': name, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        token.value = responseData['token'];
        print("data: ${responseData}");
        final userData = responseData['user'];
        final userId = userData['id'];
        // final userRole = customerData['role'];
        print("userId: ${userId}");
        isAuthenticated.value = true;
        await fetchUserData(); // Pass userRole here
      } else {
        isAuthenticated.value = false;
        print('user error ${response.statusCode}');
        Get.dialog(
          AlertDialog(
            icon: Image.asset(
              'assets/images/error.png',
              width: 50,
              height: 50,
            ),
            title: const Text(
              'ຂໍ້ຄວາມຜິດພາດ',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            content: const Text(
                'ການເຂົ້າສູ່ລະບົບຜິດພາດ, ກະລຸນາສອບຊື່ຜູ້ໃຊ້ຫູືລະຫັດຜ່ານຄືນໃໝ່'),
          ),
        );
        // Error handling
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:5000/api/user/getUserByToken/${token.value}'),
        // Send token in the URL as a parameter
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        showCustomerData(responseData);
        print('successfully logined');
        Get.to(() => MainScreen());
      } else {
        // Error handling
        print("Failed to fetch user data: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching user data: $e");
    }
  }

  void showCustomerData(Map<String, dynamic> data) {
    print('Received user data: $data');
    userData.value = data;
    print('Updated user data: $userData');
  }
}
