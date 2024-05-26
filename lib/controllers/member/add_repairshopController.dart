import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class Repairshop {
  final String shopName;
  final String shopownerName;
  final String tel;
  final String password;
  final String age;
  final String gender;
  final String birthdate;
  final String village;
  final String district;
  final String province;
  final String typeService;
  final File? profileImage;
  final File? documentImage;
  final String? latitude;
  final String? longitude;
  final String? status;
  Repairshop({
    required this.shopName,
    required this.shopownerName,
    required this.tel,
    required this.password,
    required this.age,
    required this.gender,
    required this.birthdate,
    required this.village,
    required this.district,
    required this.province,
    required this.typeService,
    this.profileImage,
    this.documentImage,
    this.latitude,
    this.longitude,
    this.status,
  });

  Future<String?> uploadProfileImageToFirebaseStorage() async {
    try {
      if (profileImage == null) return null;

      // Get image name
      String imageName = profileImage!.path.split('/').last;

      // Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child('Images/$imageName');
      await ref.putFile(File(profileImage!.path));

      // Get download URL of the uploaded image
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<String?> uploadDocumentImageToFirebaseStorage() async {
    try {
      if (documentImage == null) return null;

      // Get image name
      String imageName = documentImage!.path.split('/').last;

      // Upload image to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('Documents/$imageName');
      await ref.putFile(File(documentImage!.path));

      // Get download URL of the uploaded image
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading document image to Firebase Storage: $e');
      return null;
    }
  }
}

class RepairshopRegisterController extends GetxController {
  var isLoading = false.obs;
  var isSuccess = false.obs;

  Future<void> repairshopRegistrationData(Repairshop shop) async {
    try {
      isLoading.value = true;

      // Upload profile image to Firebase Storage and get image URL
      String? imageUrl = await shop.uploadProfileImageToFirebaseStorage();

      // Upload document image to Firebase Storage and get image URL
      String? documentImageUrl =
          await shop.uploadDocumentImageToFirebaseStorage();

      // Send shop data along with image URL to database
      if (imageUrl == null) {
        var response = await http.post(
          Uri.parse('http://localhost:5000/api/repairshop/addRepairshop'),
          body: {
            'shop_name': shop.shopName,
            'manager_name': shop.shopownerName,
            'tel': shop.tel,
            'password': shop.password,
            'age': shop.age,
            'gender': shop.gender,
            'birthdate': shop.birthdate,
            'village': shop.village,
            'district': shop.district,
            'province': shop.province,
            'type_service': shop.typeService,
            'profile_image': 'imageUrl',
            'document_verify': 'documentImageUrl',
            'role': 'repairshop',
            'latitude': shop.latitude,
            'longitude': shop.longitude,
            'status': shop.status,
          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registration successful
          isSuccess.value = true;
          print('sucessfully');
          // Navigate to success page or perform other actions
        } else {
          // Registration failed
          isSuccess.value = false;
          print("Error: ${response.statusCode}");
          if (response.statusCode == 400) {
            // Handle validation errors
            print('Validation error: ${response.body}');
            // Display validation errors to the user or perform other actions
          } else {
            // Handle other errors (e.g., server errors)
            print('Server error');
            // Display a generic error message to the user or perform other actions
          }
        }
      } else {
        print('Error: Image upload failed');
        isSuccess.value = false;
      }
    } catch (error) {
      // Handle network errors or exceptions
      isSuccess.value = false;
      print("Error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    isLoading.close();
    isSuccess.close();
    super.onClose();
  }
}
