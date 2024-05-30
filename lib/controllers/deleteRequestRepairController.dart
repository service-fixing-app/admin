import 'package:admin/controllers/getRequestRepairController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteRequestRepairController extends GetxController {
  Future<void> deleteCustomer(List<String> selectedRowKeys) async {
    try {
      for (var id in selectedRowKeys) {
        final response = await http.delete(
          Uri.parse('http://localhost:5000/api/request/deleteRquestById/$id'),
        );
        if (response.statusCode == 200) {
          print('Successfully deleted repair shop $id');
          Get.find<GetRequestRepairController>().fetchRequestRepairData();
        } else {
          print("Failed to delete repair shop $id: ${response.statusCode}");
        }
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }
}
