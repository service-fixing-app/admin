import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetScoreRepairshopController extends GetxController {
  var repairScoreData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchScoreRepairshopData();
  }

  Future<void> fetchScoreRepairshopData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/reviews/getRepairshopScoreReport'),
      );
      if (response.statusCode == 200) {
        print('get from fetch: ${response.statusCode}');
        final responseData = json.decode(response.body);
        print('Successfully fetched repair data $responseData');

        // Calculate average rating for each shop ID
        Map<String, List<int>> shopRatings = {};
        responseData.forEach((review) {
          var repairshop = review['repairshop'];
          if (repairshop != null &&
              repairshop['id'] != null &&
              repairshop['shop_name'] != null) {
            String shopId = repairshop['id'];
            int rating = review['rating'];

            if (!shopRatings.containsKey(shopId)) {
              shopRatings[shopId] = [];
            }

            shopRatings[shopId]?.add(rating);
          }
        });

        // Calculate average rating for each shop ID
        Map<String, double> shopAverages = {};
        shopRatings.forEach((shopId, ratings) {
          double averageRating = ratings.isNotEmpty
              ? ratings.reduce((a, b) => a + b) / ratings.length
              : 0.0;
          averageRating = double.parse(averageRating.toStringAsFixed(2));
          shopAverages[shopId] = averageRating;
        });

        // Set shop_id, shop_name, and average to repairScoreData
        shopAverages.forEach((shopId, averageRating) {
          var shop = responseData.firstWhere(
            (review) =>
                review['repairshop'] != null &&
                review['repairshop']['id'] == shopId &&
                review['repairshop']['shop_name'] != null,
            orElse: () => null,
          );
          var shopName =
              shop != null ? shop['repairshop']['shop_name'] : 'Unknown';

          // Check if shop_id already exists in repairScoreData
          if (!repairScoreData.any((entry) => entry['shop_id'] == shopId)) {
            repairScoreData.add({
              'shop_id': shopId,
              'shop_name': shopName,
              'average': averageRating,
            });
          }
        });

        print('Data for table: $repairScoreData');
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
