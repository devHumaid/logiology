import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logiology/controllers/home_controller.dart';

class FilterScreen extends StatelessWidget {
  final HomeController productController = Get.find();

  // Controllers for filter inputs
  final categoryController = TextEditingController();
  final tagController = TextEditingController();
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filter Products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: tagController,
              decoration: InputDecoration(labelText: 'Tag'),
            ),
            TextField(
              controller: minPriceController,
              decoration: InputDecoration(labelText: 'Min Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: maxPriceController,
              decoration: InputDecoration(labelText: 'Max Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final category = categoryController.text.isNotEmpty ? categoryController.text : null;
                final tag = tagController.text.isNotEmpty ? tagController.text : null;
                final minPrice = minPriceController.text.isNotEmpty ? double.tryParse(minPriceController.text) : null;
                final maxPrice = maxPriceController.text.isNotEmpty ? double.tryParse(maxPriceController.text) : null;

                productController.filterProducts(
                  category: category,
                  tag: tag,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                );

                Get.back();
              },
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
