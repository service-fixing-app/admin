import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TowingshopNotificationController extends GetxController {
  var towingshopData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTowingshopData();
  }

  Future<void> fetchTowingshopData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/towingtruck/allTowingtruck'),
      );
      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        // repairshopData.value = List<Map<String, dynamic>>.from(responseData);
        final responseData = json.decode(response.body);
        var allRepairshopData = List<Map<String, dynamic>>.from(responseData);

        // Filter data to only include towingshops with permission_status set to "false"
        towingshopData.value = allRepairshopData
            .where((shop) => shop['permission_status'] == "false")
            .toList();

        print('Successfully fetched and filtered repair data $towingshopData');

        print('Successfully fetched repair data $towingshopData');
      } else {
        // Error handling
        print("Failed to fetch repair data: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }

  Future<void> UpdatePermission(towingshop) async {
    try {
      var response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/towingtruck/updateTowingtruck/$towingshop'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'permission_status': 'true'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.dialog(
          AlertDialog(
            icon: Image.asset(
              'assets/images/success.png',
              width: 50,
              height: 50,
            ),
            title: const Text(
              'Success',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            content: const Text(
                'ສຳເລັດໃນການອະນູມັດທີ່ຢູ່ຂອງຮ້ານແກ່ລົດນີ້ແລ້ວ, ຂໍຂອບໃຈ'),
          ),
        );
        Get.find<TowingshopNotificationController>().fetchTowingshopData();
      } else {
        // print("Response body: ${response.body}");
      }
    } catch (error) {
      // print("Error: $error");
    }
  }
}
