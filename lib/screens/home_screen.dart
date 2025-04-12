import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logiology/routes/app_routes.dart';
import 'package:logiology/screens/filter_popup.dart';

import '../controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() {
          if (homeController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.grey[400]),
                                    SizedBox(width: 10),
                                    Text(
                                      'Search...',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                        onTap: () {
                                          showFilterDialog(context);
                                        },
                                        child: Icon(Icons.tune,
                                            color: Colors.grey[400])),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes
                                  .profile); // Navigate to the profile page
                            },
                            child: Obx(() {
                              final imagePath =
                                  homeController.profileImagePath.value;

                              return CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: imagePath.isNotEmpty
                                    ? FileImage(File(imagePath))
                                    : null, // If imagePath is empty, don't show a background image
                                child: imagePath.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Colors.grey[700],
                                      )
                                    : null, // If there's no image, show the default icon
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Titles
                      Text(
                        'Hello,',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        'Welcome to logiology store',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: homeController.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Obx(() => GestureDetector(
                              onTap: () => homeController.setCategory(index),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  color:
                                      homeController.selectedCategory.value ==
                                              index
                                          ? Color(0xFF2A2A2A)
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Text(
                                    homeController.categories[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: homeController
                                                  .selectedCategory.value ==
                                              index
                                          ? Colors.white
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: CarouselSlider.builder(
                  itemCount: homeController.products.length > 5
                      ? 5
                      : homeController.products.length,
                  itemBuilder: (context, index, realIndex) {
                    final product = homeController.products[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Image.network(
                                      product.thumbnail ??
                                          'https://i.imgur.com/zQYRvSJ.png',
                                      fit: BoxFit.contain,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 60),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Obx(() => GestureDetector(
                                  onTap: () => homeController.toggleFavorite(),
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        homeController.isFavorite.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 20,
                                        color: homeController.isFavorite.value
                                            ? Colors.red
                                            : Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 270,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    viewportFraction: 0.7,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              // Product Grid
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: Obx(() {
                  if (homeController.isLoading.value) {
                    return SliverToBoxAdapter(
                      child: Center(
                          child:
                              CircularProgressIndicator()), // Show loading indicator
                    );
                  }

                  // If products are filtered, show filtered list, else show all products
                  final productsToShow =
                      homeController.filteredProducts.isNotEmpty
                          ? homeController.filteredProducts
                          : homeController.products;

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = productsToShow[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  product.thumbnail,
                                  height: 110,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "\$${product.price}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          product.rating.toString(),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: productsToShow.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width < 600 ? 2 : 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
