import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RepairshopController extends GetxController {
  var repairshopData = <Map<String, dynamic>>[].obs;
  var filteredRepairshopData = <Map<String, dynamic>>[].obs; // Add this line

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
        repairshopData.value = List<Map<String, dynamic>>.from(responseData);
        // filteredRepairshopData
        //     .assignAll(repairshopData); // Initialize filtered data
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

  void filterDataByDateRange(DateTime startDate, DateTime endDate) {
    var filteredData = repairshopData.where((repairshop) {
      var createdAt = DateTime.parse(repairshop['createdAt']);
      return createdAt.isAfter(startDate) && createdAt.isBefore(endDate);
    }).toList();
    filteredRepairshopData.assignAll(filteredData);
  }
}
