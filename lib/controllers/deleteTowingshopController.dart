import 'dart:convert';

import 'package:admin/controllers/member/towingshopController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteTowingshopController extends GetxController {
  Future<void> deleteTowingshop(towingshopId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5000/api/towingtruck/deleteTowingtruck/$towingshopId'),
      );
      if (response.statusCode == 200) {
        // print('Successfully deleted towingshop $towingshopId');
        await Get.find<TowingshopController>().fetchTowingshopData();
      } else {
        // print(
        //     "Failed to delete towingshop shop $towingshopId: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error fetching repair data: $e");
    }
  }

  Future<void> UpdatePermission(towingshopId) async {
    try {
      var response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/towingtruck/updateTowingtruck/$towingshopId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'permission_status': 'block'}),
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
                const Text('ສຳເລັດໃນການ blocked ຮ້ານແກ່ລົດນີ້ແລ້ວ, ຂໍຂອບໃຈ'),
          ),
        );
        await Get.find<TowingshopController>().fetchTowingshopData();
      } else {
        // print("Response body: ${response.body}");
      }
    } catch (error) {
      // print("Error: $error");
    }
  }
}
