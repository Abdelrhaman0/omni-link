import 'package:flutter/material.dart';
import '../component/conests.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCategoryCard(
                  'Routers & Firewalls',
                  '124 Products',
                  Icons.router_rounded,
                  Colors.blue,
                ),
                _buildCategoryCard(
                  'Network Switches',
                  '256 Products',
                  Icons.hub_rounded,
                  Colors.indigo,
                ),
                _buildCategoryCard(
                  'Wireless Access Points',
                  '84 Products',
                  Icons.wifi_rounded,
                  Colors.teal,
                ),
                _buildCategoryCard(
                  'Fiber & Copper Cabling',
                  '312 Products',
                  Icons.cable_rounded,
                  Colors.purple,
                ),
                _buildCategoryCard(
                  'Server Cabinets & Racks',
                  '48 Products',
                  Icons.inventory_2_rounded,
                  Colors.blueGrey,
                ),
                _buildCategoryCard(
                  'SFP & Optic Modules',
                  '196 Products',
                  Icons.developer_board_rounded,
                  Colors.orange,
                ),
                _buildCategoryCard(
                  'PoE & Power Delivery',
                  '64 Products',
                  Icons.power_rounded,
                  Colors.red,
                ),
                _buildCategoryCard(
                  'Tools & Cable Testers',
                  '42 Products',
                  Icons.handyman_rounded,
                  Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, String itemCount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color, size: 20),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: kGreyColor,
                size: 12,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: kDarkColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                itemCount,
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
