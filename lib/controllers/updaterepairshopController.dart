import 'package:admin/controllers/member/repairshopController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateRepairshopController extends GetxController {
  Future<void> updateRepairshop(Map<String, dynamic> repairshop) async {
    try {
      // Convert integer values to strings in the customer object
      Map<String, String> stringRepairshop = {};
      repairshop.forEach((key, value) {
        stringRepairshop[key] = value.toString();
      });

      final response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/repairshop/updateRepairshopById/${repairshop['id']}'),
        body: stringRepairshop,
      );
      if (response.statusCode == 200) {
        print('Successfully updated repairshop data ${repairshop['id']}');
        await Get.find<RepairshopController>().fetchRepairshopData();
      } else {
        print(
            "Failed to update repairshop ${repairshop['id']}: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error updating repairshop: $e");
    }
  }
}
