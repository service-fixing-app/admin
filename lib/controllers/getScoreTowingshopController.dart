import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetScoreTowingshopController extends GetxController {
  var towingScoreData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchScoreTowingshopData();
  }

  Future<void> fetchScoreTowingshopData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/reviews/getTowingshopScoreReport'),
      );
      if (response.statusCode == 200) {
        print('get from fetch: ${response.statusCode}');
        final responseData = json.decode(response.body);
        print('Successfully fetched repair data $responseData');

        // Calculate average rating for each shop ID
        Map<String, List<int>> shopRatings = {};
        responseData.forEach((review) {
          var towingtruck = review['towingtruck'];
          if (towingtruck != null && towingtruck['id'] != null) {
            String shopId = towingtruck['id'];
            String shopName = towingtruck['shop_name'];
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

        // Set shop_id, shop_name, and average to towingScoreData
        shopAverages.forEach((shopId, averageRating) {
          var shopName = responseData.firstWhere((review) =>
              review['towingtruck']['id'] == shopId)['towingtruck']['shop_name'];

          // Check if shop_id already exists in towingScoreData
          if (!towingScoreData.any((entry) => entry['shop_id'] == shopId)) {
            towingScoreData.add({
              'shop_id': shopId,
              'shop_name': shopName,
              'average': averageRating,
            });
          }
        });

        print('Data for table: $towingScoreData');
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
