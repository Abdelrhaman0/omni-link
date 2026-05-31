import 'package:flutter/material.dart';

import '../../core/component/conests.dart';
import '../../core/widgets/product_widget.dart';
import '../../models/product_model.dart';
import '../products/product_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Grab the favorite items from mockProducts to act as the initial wishlist database
  late final List<ProductModel> _wishlistProducts;

  @override
  void initState() {
    super.initState();
    _wishlistProducts = ProductModel.mockProducts.where((p) => p.isFavorite).toList();
  }

  void _removeItem(int index) {
    final item = _wishlistProducts[index];
    setState(() {
      _wishlistProducts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from wishlist'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: kAccentColor,
          onPressed: () {
            setState(() {
              _wishlistProducts.insert(index, item);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _addToCart(ProductModel item) {
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
      body: _wishlistProducts.isEmpty ? _buildEmptyState() : _buildWishlistList(),
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
      itemCount: _wishlistProducts.length,
      itemBuilder: (context, index) {
        final product = _wishlistProducts[index];
        // Ensure favorite visual representation remains true on WishlistScreen
        final displayProduct = product.copyWith(isFavorite: true);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ProductCard.list(
            product: displayProduct,
            actionLabel: 'Add to Cart',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsScreen(product: displayProduct),
                ),
              );
            },
            onFavoritePressed: () => _removeItem(index),
            onActionPressed: () => _addToCart(product),
          ),
        );
      },
    );
  }
}
