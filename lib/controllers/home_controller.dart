import 'dart:ui';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logiology/model/product_model.dart';
import 'package:logiology/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var filteredProducts = <ProductModel>[].obs;
  final RxInt selectedCategory = 0.obs;
  final RxInt selectedColor = 0.obs;
  final RxBool isFavorite = false.obs;

  final List<String> categories = ['Chairs', 'Tables', 'Sofas', 'Beds'];
  final List<Color> colorOptions = [
    Color(0xFFD9A8A8), // Light pink
    Color(0xFF89A98C), // Sage green
    Color(0xFFA86464), // Dark pink/burgundy
  ];

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void setCategory(int index) {
    selectedCategory.value = index;
  }

  void setColor(int index) {
    selectedColor.value = index;
  }
  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadUserProfile();
  }
  
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      var fetchedProducts = await ApiService.fetchProducts();
      products.assignAll(fetchedProducts);
      filteredProducts.assignAll(fetchedProducts);
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts(
      {String? category, String? tag, double? minPrice, double? maxPrice}) {
    var tempProducts = products.where((product) {
      final matchesCategory = category == null || product.category == category;
      final matchesTag = tag == null || product.tags.contains(tag);
      final matchesMinPrice = minPrice == null || product.price >= minPrice;
      final matchesMaxPrice = maxPrice == null || product.price <= maxPrice;
      return matchesCategory &&
          matchesTag &&
          matchesMinPrice &&
          matchesMaxPrice;
    }).toList();
    filteredProducts.assignAll(tempProducts);
  }

  // PROFILE
  var username = ''.obs;
  var profileImagePath = ''.obs;
  var password = ''.obs;

  void loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'User';
    password.value = prefs.getString('password') ?? 'PASSWORD';
    profileImagePath.value = prefs.getString('profileImagePath') ?? '';
  }

  void updateUsername(String newUsername) async {
    username.value = newUsername;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
  }

  void updatePassword(String newPassword) async {
    password.value = newPassword;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', newPassword);
  }

  void updateProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
    }
  }
}
