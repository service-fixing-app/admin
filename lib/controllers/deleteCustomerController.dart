import 'package:admin/controllers/getCustomerController.dart';
import 'package:admin/controllers/member/customerController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteCustomerController extends GetxController {
  Future<void> deleteCustomer(customerId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5000/api/customer/deleteCustomer/$customerId'),
      );
      if (response.statusCode == 200) {
        print('Successfully deleted customer $customerId');
        try {
          await Get.find<GetCustomerController>().fetchCustomerData();
        } catch (e) {
          //print('Error fetching customer history messages: $e');
        }
        try {
          await Get.find<CustomerController>().fetchCustomer();
        } catch (e) {
          //print('Error fetching history messages: $e');
        }
      } else {
        print(
            "Failed to delete repair shop $customerId: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }
}
