import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:logiology/model/product_model.dart';

class ApiService {
  static Future<List<ProductModel>> fetchProducts() async {
    final url = Uri.parse('https://dummyjson.com/products');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data['products'] as List;
        return products.map((e) => ProductModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
