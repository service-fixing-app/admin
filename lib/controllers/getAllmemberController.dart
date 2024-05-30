import 'package:admin/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllmemberController extends GetxController {
  var customerCount = 0.obs;
  var repairshopCount = 0.obs;
  var towingtruckCount = 0.obs;
  var totalCount = 0.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }

  void fetchCounts() async {
    try {
      isLoading(true);
      var customerResponse = await http
          .get(Uri.parse('http://localhost:5000/api/customer/allCustomers'));
      var repairshopResponse = await http
          .get(Uri.parse('http://localhost:5000/api/repairshop/allRepairshop'));
      var towingtruckResponse = await http.get(
          Uri.parse('http://localhost:5000/api/towingtruck/allTowingtruck'));

      if (customerResponse.statusCode == 200 &&
          repairshopResponse.statusCode == 200 &&
          towingtruckResponse.statusCode == 200) {
        var customerData = json.decode(customerResponse.body);
        var repairshopData = json.decode(repairshopResponse.body);
        var towingtruckData = json.decode(towingtruckResponse.body);

        // Assuming your API returns a list of items
        customerCount.value = customerData.length;
        repairshopCount.value = repairshopData.length;
        towingtruckCount.value = towingtruckData.length;

        totalCount.value = customerCount.value +
            repairshopCount.value +
            towingtruckCount.value;

        print(customerCount.value);
        print(repairshopCount.value);
        print(towingtruckCount.value);
        print(totalCount.value);
      } else {
        print('Error fetching data');
      }
    } catch (e) {
      print('Error $e');
    } finally {
      isLoading(false);
    }
  }

  List<PieChartSectionData> get pieChartData {
    return [
      PieChartSectionData(
        color: primaryColor,
        value: customerCount.value.toDouble(),
        showTitle: false,
        radius: 25,
      ),
      PieChartSectionData(
        color: const Color(0xFF26E5FF),
        value: repairshopCount.value.toDouble(),
        showTitle: false,
        radius: 22,
      ),
      PieChartSectionData(
        color: const Color(0xFFFFCF26),
        value: towingtruckCount.value.toDouble(),
        showTitle: false,
        radius: 19,
      ),
    ];
  }
}
