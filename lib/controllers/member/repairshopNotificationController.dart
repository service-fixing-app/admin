import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RepairshopNotificationController extends GetxController {
  var repairshopData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRepairshopData();
  }

  Future<void> fetchRepairshopData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/repairshop/allRepairshop'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        var allRepairshopData = List<Map<String, dynamic>>.from(responseData);
        repairshopData.value = allRepairshopData
            .where((shop) => shop['permission_status'] == "false")
            .toList();

        print('Successfully fetched and filtered repair data $repairshopData');

        print('Successfully fetched repair data $repairshopData');
      } else {
        // Error handling
        print("Failed to fetch repair data: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }

  Future<void> UpdatePermission(repairshop) async {
    try {
      var response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/repairshop/updateRepairshopById/$repairshop'),
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
                'ສຳເລັດໃນການອະນູມັດທີ່ຢູ່ຂອງຮ້ານສ້ອມແປງນີ້ແລ້ວ, ຂໍຂອບໃຈ'),
          ),
        );
        Get.find<RepairshopNotificationController>().fetchRepairshopData();
      } else {
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }
}
