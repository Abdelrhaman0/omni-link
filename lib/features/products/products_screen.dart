import 'package:flutter/material.dart';

import '../../core/component/conests.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int activeChipIndex = 0;
  final List<String> categories = ['All', 'Routers', 'Switches', 'Wireless', 'Fiber & Cables'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // Horizontal Filter Chips
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final bool isActive = activeChipIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeChipIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive ? kPrimaryColor : kCardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? kPrimaryColor : kDividerColor,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isActive ? Colors.white : kGreyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Catalog Listing (Networking Hardware)
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildProductRow(
                  'UniFi Dream Machine Pro',
                  'Enterprise Gateway, Security & Controller',
                  '\$379.00',
                  '',
                  Icons.router_rounded,
                  Colors.blue,
                  false,
                ),
                _buildProductRow(
                  'Cisco CBS350-24P-4G Switch',
                  'Managed 24-Port Gigabit PoE+ (370W)',
                  '\$499.00',
                  '\$569.00',
                  Icons.hub_rounded,
                  Colors.indigo,
                  true,
                ),
                _buildProductRow(
                  'Omada EAP670 Access Point',
                  'AX5400 Ceiling Mount WiFi 6 AP',
                  '\$159.00',
                  '',
                  Icons.wifi_rounded,
                  Colors.teal,
                  false,
                ),
                _buildProductRow(
                  'Cat6 Solid UTP Spool (1000ft)',
                  'Bulk Solid Copper Ethernet Cabling',
                  '\$169.00',
                  '\$189.00',
                  Icons.cable_rounded,
                  Colors.purple,
                  true,
                ),
                _buildProductRow(
                  'Fiber Optic Patch Cord (2m)',
                  'LC-LC Duplex OM4 Multimode Fiber',
                  '\$14.99',
                  '',
                  Icons.developer_board_rounded,
                  Colors.orange,
                  false,
                ),
                _buildProductRow(
                  '9U Server Cabinet Rack',
                  'Wallmount Enclosed Steel Cabinet with Fan',
                  '\$129.00',
                  '\$149.00',
                  Icons.inventory_2_rounded,
                  Colors.blueGrey,
                  true,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(
    String title,
    String sub,
    String price,
    String oldPrice,
    IconData icon,
    Color accentColor,
    bool isSale,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Icon Container (Mock Image)
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: kLightColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(icon, size: 36, color: accentColor),
                ),
                if (isSale)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kAccentColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Center: Metadata Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: kDarkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (oldPrice.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        oldPrice,
                        style: const TextStyle(
                          color: kGreyColor,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Right: Action Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: kGreyColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 18,
                backgroundColor: kPrimaryColor,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
