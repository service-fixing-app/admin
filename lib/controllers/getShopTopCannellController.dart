import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetTopShopCannelRequest extends GetxController {
  var shopcannelData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchshopData();
  }

  Future<void> fetchshopData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/request/getShopCannelRequest'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        Map<String, int> shopCancellationCounts = {};
        Map<String, String> shopNames = {};

        for (var request in responseData) {
          String shopId = request['shop_id'] ?? 'Unknown';
          String shopName = request['receiver_name'] ?? 'Unknown';

          if (request['status'] == 'cancelled') {
            shopCancellationCounts[shopId] =
                (shopCancellationCounts[shopId] ?? 0) + 1;
          }

          if (!shopNames.containsKey(shopId)) {
            shopNames[shopId] = shopName;
          }
        }

        shopcannelData.value = shopCancellationCounts.entries
            .map((entry) => {
                  'shop_id': entry.key,
                  'shop_name': shopNames[entry.key] ?? 'Unknown',
                  'cancelled_count': entry.value,
                })
            .toList();

        print('Data for table: $shopcannelData');
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
