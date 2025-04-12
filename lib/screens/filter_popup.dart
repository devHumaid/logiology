import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logiology/controllers/home_controller.dart';

void showFilterDialog(BuildContext context) {
  final homeController = Get.find<HomeController>();

  String? selectedCategory;
  
  // Use RxDouble for selectedMaxPrice and initialize it with a value
  RxDouble selectedMaxPrice = 500.0.obs;  // Default value is 500

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Filter Products'),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category dropdown (non-reactive)
                Obx(() {
                  return DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    hint: Text('Select Category'),
                    items: homeController.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedCategory = value;
                    },
                  );
                }),

                SizedBox(height: 16),

                // TAG INPUT FIELD
                TextField(
                  controller: homeController.tagInputController,
                  decoration: InputDecoration(
                    labelText: 'Enter tag and press enter',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    homeController.addTag(value);
                  },
                ),

                SizedBox(height: 10),

                // ✅ Only this part is reactive
                Obx(() => Wrap(
                      spacing: 8,
                      children: homeController.enteredTags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () => homeController.removeTag(tag),
                        );
                      }).toList(),
                    )),

                SizedBox(height: 16),

                // Price Slider (reactive)
                Obx(() => Column(
                      children: [
                        Text(
                          "Max Price: ${selectedMaxPrice.value.toStringAsFixed(0)}",
                        ),
                        Slider(
                          value: selectedMaxPrice.value,
                          min: 0,
                          max: 500,
                          onChanged: (value) {
                            selectedMaxPrice.value = value;
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        actions: [
          // Clear Filters Button
          TextButton(
            onPressed: () {
              // Reset the filters to default values
              selectedCategory = null;
              selectedMaxPrice.value = 500; // Reset to default max price
              homeController.enteredTags.clear();

              // Apply the cleared filters
              homeController.applyFilters(
                category: selectedCategory,
                tag: null,  // No tag
                maxPrice: selectedMaxPrice.value,
              );

              Navigator.of(context).pop();  // Close the dialog
            },
            child: Text('Clear Filters'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              homeController.applyFilters(
                category: selectedCategory,
                tag: homeController.enteredTags.isNotEmpty
                    ? homeController.enteredTags.first
                    : null,
                maxPrice: selectedMaxPrice.value,
              );
              Navigator.of(context).pop();
            },
            child: Text('Apply'),
          ),
        ],
      );
    },
  );
}
