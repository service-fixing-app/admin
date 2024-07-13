import 'dart:convert';

import 'package:admin/controllers/member/repairshopController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteRepairshopController extends GetxController {
  Future<void> deleteRepairshop(repairshopId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5000/api/repairshop/deleteRepairshop/$repairshopId'),
      );
      if (response.statusCode == 200) {
        print('Successfully deleted customer $repairshopId');
        await Get.find<RepairshopController>().fetchRepairshopData();
      } else {
        print(
            "Failed to delete repair shop $repairshopId: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }

  Future<void> UpdatePermission(String repairshopId) async {
    try {
      var response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/repairshop/updateRepairshopById/$repairshopId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'permission_status': 'blocked'}),
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
            content:
                const Text('ສຳເລັດໃນການ blocked ຮ້ານສ້ອມແປງນີ້ແລ້ວ, ຂໍຂອບໃຈ'),
          ),
        );
        await Get.find<RepairshopController>().fetchRepairshopData();
      } else {
        // print("Response body: ${response.body}");
      }
    } catch (error) {
      // print("Error: $error");
    }
  }
}
