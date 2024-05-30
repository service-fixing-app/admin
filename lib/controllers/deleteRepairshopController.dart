import 'package:admin/controllers/member/repairshopController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteRepairshopController extends GetxController {
  Future<void> deleteRepairshop(repairshopId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5000/api/repairshop/deleteRepairshop/$repairshopId'),
      );
      if (response.statusCode == 200) {
        print('Successfully deleted customer $repairshopId');
        await Get.find<RepairshopController>().fetchRepairshopData();
      } else {
        print(
            "Failed to delete repair shop $repairshopId: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }
}
