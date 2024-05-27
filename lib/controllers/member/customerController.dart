import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CustomerController extends GetxController {
  var customer = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomer();
  }

  Future<void> fetchCustomer() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/customer/allCustomers'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        customer.value = List<Map<String, dynamic>>.from(responseData);
        print('Successfully fetched  customer data $customer');
      } else {
        // Error handling
        print("Failed to fetch customer data: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching customer data: $e");
    }
  }
}
