import 'package:admin/controllers/member/customerController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateCustomerController extends GetxController {
  Future<void> updateCustomer(Map<String, dynamic> customer) async {
    try {
      // Convert integer values to strings in the customer object
      Map<String, String> stringCustomer = {};
      customer.forEach((key, value) {
        stringCustomer[key] = value.toString();
      });

      final response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/customer/updateCustomer/${customer['id']}'),
        body:
            stringCustomer, // Send the updated customer data in the request body
      );
      if (response.statusCode == 200) {
        print('Successfully updated customer ttt ${customer['id']}');
        await Get.find<CustomerController>().fetchCustomer();
      } else {
        print(
            "Failed to update customer ${customer['id']}: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error updating customer: $e");
    }
  }
}
