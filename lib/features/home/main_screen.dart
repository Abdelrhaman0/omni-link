import 'package:flutter/material.dart';

import '../../core/component/conests.dart';
import '../../core/widgets/category_card.dart';
import '../../core/widgets/product_widget.dart';
import '../../core/widgets/brand_card.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/brand_model.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Welcome / Enterprise Account Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kPrimaryColor, kSecondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enterprise Client 👋',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Network Engineer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: const Icon(
                          Icons.dns_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickStat(Icons.settings_input_hdmi_rounded, 'Active Quotes', '3 Pending'),
                      _buildQuickStat(Icons.terminal_rounded, 'Tier Discount', '15% Off'),
                      _buildQuickStat(Icons.local_shipping_outlined, 'Next Delivery', 'Tomorrow'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Section Header: Network Categories
            const Text(
              'Network Categories',
              style: TextStyle(
                color: kDarkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Networking categories horizontal list
            SizedBox(
              height: 96,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: CategoryModel.mockCategories.length,
                itemBuilder: (context, index) {
                  final category = CategoryModel.mockCategories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CategoryCard.compact(
                      category: category,
                      onTap: () {
                        // Interactive tap handling can be wired up here if needed
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // New Section: Top Hardware Brands
            const Text(
              'Top Brands',
              style: TextStyle(
                color: kDarkColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal Brands list using our new BrandCard
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: BrandModel.mockBrands.length,
                itemBuilder: (context, index) {
                  final brand = BrandModel.mockBrands[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: BrandCard.compact(
                      brand: brand,
                      onTap: () {
                        // Interactive brand selection
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 3. Section Header: Featured Enterprise Hardware
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Enterprise Hardware',
                  style: TextStyle(
                    color: kDarkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Grid of products (focused on network equipment) using our beautiful ProductCard
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ProductModel.mockProducts.take(4).length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = ProductModel.mockProducts[index];
                return ProductCard.grid(
                  product: product,
                  actionLabel: 'Add to Quote',
                  onTap: () {
                    // Navigate to product details
                  },
                  onFavoritePressed: () {
                    // Toggle favorite in Bloc later
                  },
                  onActionPressed: () {
                    // Add to Quote in Bloc later
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
