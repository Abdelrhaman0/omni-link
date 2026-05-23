import 'package:flutter/material.dart';
import '../../core/component/conests.dart';
import '../../core/widgets/category_card.dart';
import '../../models/category_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? selectedCategoryId;
  final List<CategoryModel> categories = CategoryModel.mockCategories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brief Introduction Header
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Enterprise Catalog',
                style: TextStyle(
                  color: kDarkColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Select a category to browse network equipment',
            style: TextStyle(color: kGreyColor, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Categories Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard.grid(
                  category: category,
                  isSelected: selectedCategoryId == category.id,
                  onTap: () {
                    setState(() {
                      if (selectedCategoryId == category.id) {
                        selectedCategoryId = null; // deselect if clicked again
                      } else {
                        selectedCategoryId = category.id;
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

