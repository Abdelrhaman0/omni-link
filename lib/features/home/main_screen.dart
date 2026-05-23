import 'package:flutter/material.dart';

import '../../core/component/conests.dart';
import '../../core/widgets/category_card.dart';
import '../../models/category_model.dart';

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
                    color: kPrimaryColor.withOpacity(0.3),
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
                        backgroundColor: Colors.white24,
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


            // 3. Section Header: Featured Networking Hardware
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

            // Grid of products (focused on network equipment)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
              children: [
                _buildProductCard(
                  'UniFi U6 Pro Access Point',
                  '\$149.00',
                  '4.9',
                  Icons.wifi_tethering_rounded,
                  Colors.blue,
                ),
                _buildProductCard(
                  'MikroTik CCR2004 Router',
                  '\$495.00',
                  '4.8',
                  Icons.router_rounded,
                  Colors.blueGrey,
                ),
                _buildProductCard(
                  'Cisco Catalyst 9300 Switch',
                  '\$2,499.00',
                  '5.0',
                  Icons.hub_rounded,
                  Colors.indigo,
                ),
                _buildProductCard(
                  '10G SFP+ SR Module',
                  '\$29.99',
                  '4.7',
                  Icons.developer_board_rounded,
                  Colors.orange,
                ),
              ],
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

  Widget _buildProductCard(
      String name, String price, String rating, IconData icon, Color bgIconColor) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kLightColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 48,
                  color: bgIconColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kDarkColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: kAccentColor, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            color: kGreyColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {},
              child: const Text(
                'Add to Quote',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
