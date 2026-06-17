import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/category_card.dart';
import '../widgets/animated_entrance.dart';
import 'product_catalog_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextileColors.background,
      appBar: AppBar(
        title: const Text(
          "Fabric Categories",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        elevation: 0,
        backgroundColor: TextileColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Explore Our Textile Lines",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TextileColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select a category to view high-quality fabrics, traditional garments, and premium home textiles.",
                style: TextStyle(
                  fontSize: 14,
                  color: TextileColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: TextileConstants.categories.length,
                  itemBuilder: (context, index) {
                    final category = TextileConstants.categories[index];
                    return AnimatedEntrance(
                      delay: Duration(milliseconds: index * 75),
                      child: CategoryCard(
                        category: category,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductScreen(initialCategory: category.name),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
