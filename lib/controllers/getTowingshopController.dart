import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetTowingshopController extends GetxController {
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
        final responseData = json.decode(response.body);
        towingshopData.value = List<Map<String, dynamic>>.from(responseData);
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
}
