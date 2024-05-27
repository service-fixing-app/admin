import 'package:admin/controllers/member/towingshopController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateTowingshopController extends GetxController {
  Future<void> updateTowingshop(Map<String, dynamic> towingshop) async {
    try {
      // Convert integer values to strings in the customer object
      Map<String, String> stringRepairshop = {};
      towingshop.forEach((key, value) {
        stringRepairshop[key] = value.toString();
      });

      final response = await http.put(
        Uri.parse(
            'http://localhost:5000/api/towingtruck/updateTowingtruck/${towingshop['id']}'),
        body: stringRepairshop,
      );
      if (response.statusCode == 200) {
        print('Successfully updated repairshop data ${towingshop['id']}');
        await Get.find<TowingshopController>().fetchTowingshopData();
      } else {
        print(
            "Failed to update repairshop ${towingshop['id']}: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error updating repairshop: $e");
    }
  }
}
