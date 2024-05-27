import 'package:admin/controllers/member/repairshopController.dart';
import 'package:admin/controllers/member/towingshopController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteTowingshopController extends GetxController {
  Future<void> deleteTowingshop(towingshopId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://localhost:5000/api/towingtruck/deleteTowingtruck/$towingshopId'),
      );
      if (response.statusCode == 200) {
        print('Successfully deleted towingshop $towingshopId');
        await Get.find<TowingshopController>().fetchTowingshopData();
      } else {
        print(
            "Failed to delete towingshop shop $towingshopId: ${response.statusCode}");
      }
    } catch (e) {
      // Error handling
      print("Error fetching repair data: $e");
    }
  }
}
