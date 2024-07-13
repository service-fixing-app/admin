import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetRequestTowingshopController extends GetxController {
  var requestRepairData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequestRepairData();
  }

  Future<void> fetchRequestRepairData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/request/getTowingshopRequestion'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        requestRepairData.value = List<Map<String, dynamic>>.from(responseData);
        print('Successfully fetched repair data $requestRepairData');
      } else {
        // Error handling
        print("Failed to fetch repair data: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }
}
