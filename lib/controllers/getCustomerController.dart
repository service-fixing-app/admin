import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetCustomerController extends GetxController {
  var customerData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerData();
  }

  Future<void> fetchCustomerData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/customer/allCustomers'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        customerData.value = List<Map<String, dynamic>>.from(responseData);
        print('Successfully fetched repair data $customerData');
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
