import 'package:flutter/material.dart';
import '../../core/component/conests.dart';

class WishlistItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final String image;
  final double rating;

  WishlistItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.rating,
  });
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final List<WishlistItem> _wishlistItems = [
    WishlistItem(
      id: 'cisco_switch',
      name: 'Cisco Catalyst 9300 24-Port Switch',
      category: 'Switches',
      price: 15999.00,
      oldPrice: 18500.00,
      image: 'https://cdn-icons-png.flaticon.com/512/3208/3208726.png',
      rating: 4.8,
    ),
    WishlistItem(
      id: 'mikrotik_router',
      name: 'MikroTik CCR2004-16G-2S+ Cloud Router',
      category: 'Routers',
      price: 8499.00,
      oldPrice: 9200.00,
      image: 'https://cdn-icons-png.flaticon.com/512/1000/1000854.png',
      rating: 4.6,
    ),
    WishlistItem(
      id: 'ubiquiti_ap',
      name: 'Ubiquiti UniFi AC Pro Access Point',
      category: 'Wireless AP',
      price: 4199.00,
      oldPrice: 4800.00,
      image: 'https://cdn-icons-png.flaticon.com/512/2888/2888691.png',
      rating: 4.9,
    ),
  ];

  void _removeItem(int index) {
    final item = _wishlistItems[index];
    setState(() {
      _wishlistItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from wishlist'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: kAccentColor,
          onPressed: () {
            setState(() {
              _wishlistItems.insert(index, item);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _addToCart(WishlistItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('${item.name} added to cart!')),
          ],
        ),
        backgroundColor: kPrimaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(color: kDarkColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kDarkColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _wishlistItems.isEmpty ? _buildEmptyState() : _buildWishlistList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: kDividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.favorite_outline_rounded,
                size: 64,
                color: kGreyColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                color: kDarkColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the heart icon on any product to save it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kGreyColor, fontSize: 14),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Explore Hardware', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _wishlistItems.length,
      itemBuilder: (context, index) {
        final item = _wishlistItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: kDividerColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 90,
                  height: 90,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.developer_board_rounded, color: kGreyColor, size: 32);
                    },
                  ),
                ),
                const SizedBox(width: 14),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kDarkColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: kAccentColor, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${item.rating}',
                            style: const TextStyle(
                              color: kDarkColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            '${item.price.toStringAsFixed(0)} EGP',
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.oldPrice.toStringAsFixed(0)} EGP',
                            style: const TextStyle(
                              color: kGreyColor,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions (Add to Cart / Delete)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                      onPressed: () => _removeItem(index),
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                      onPressed: () => _addToCart(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
