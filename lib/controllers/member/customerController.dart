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
        for (var entry in responseData) {
          String birthdateString = entry['birthdate'];
          List<String> parts = birthdateString.split('/');
          String reformattedDateString =
              '${parts[2]}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}';
          entry['birthdate'] = DateTime.parse(reformattedDateString);
        }
        print('Successfully fetched repair data $customer');
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