import 'package:flutter/material.dart';
import '../../core/component/conests.dart';

class CartItem {
  final String id;
  final String name;
  final String category;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.image,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(
      id: 'dream_machine',
      name: 'Ubiquiti UniFi Dream Machine Pro SE',
      category: 'Routers',
      price: 19999.00,
      quantity: 1,
      image: 'https://cdn-icons-png.flaticon.com/512/3208/3208726.png',
    ),
    CartItem(
      id: 'cat6a_cable',
      name: 'Cat6a STP Shielded Copper Cable 305m',
      category: 'Fiber & Copper Cabling',
      price: 3499.00,
      quantity: 2,
      image: 'https://cdn-icons-png.flaticon.com/512/2888/2888691.png',
    ),
  ];

  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get _shippingFee {
    if (_subtotal == 0) return 0.0;
    // Free shipping on orders over 15,000 EGP
    return _subtotal > 15000.0 ? 0.0 : 150.0;
  }

  double get _total => _subtotal + _shippingFee;

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      setState(() {
        _cartItems[index].quantity--;
      });
    } else {
      _removeItem(index);
    }
  }

  void _removeItem(int index) {
    final item = _cartItems[index];
    setState(() {
      _cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from cart'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: kAccentColor,
          onPressed: () {
            setState(() {
              _cartItems.insert(index, item);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _checkout() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCheckoutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
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
      body: _cartItems.isEmpty ? _buildEmptyState() : _buildCartBody(),
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
                Icons.shopping_bag_outlined,
                size: 64,
                color: kGreyColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Cart is Empty',
              style: TextStyle(
                color: kDarkColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse our enterprise network catalog to add hardware.',
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
                child: const Text('Shop Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartBody() {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
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
                      // Image
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kLightColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.network(
                          item.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.developer_board_rounded, color: kGreyColor, size: 28);
                          },
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            const SizedBox(height: 4),
                            Text(
                              '${item.price.toStringAsFixed(0)} EGP',
                              style: const TextStyle(
                                color: kPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quantity Controller
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                            onPressed: () => _removeItem(index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: kLightColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kDividerColor),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _decreaseQuantity(index),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(Icons.remove, size: 14, color: kDarkColor),
                                  ),
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    color: kDarkColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _increaseQuantity(index),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Icon(Icons.add, size: 14, color: kDarkColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Checkout Summary section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: const Border(
              top: BorderSide(color: kDividerColor),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(color: kGreyColor, fontSize: 14)),
                    Text('${_subtotal.toStringAsFixed(2)} EGP', style: const TextStyle(color: kDarkColor, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),

                // Shipping
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shipping Fee', style: TextStyle(color: kGreyColor, fontSize: 14)),
                    Text(
                      _shippingFee == 0 ? 'Free Shipping' : '${_shippingFee.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                        color: _shippingFee == 0 ? Colors.green.shade600 : kDarkColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: kDividerColor, height: 1),
                const SizedBox(height: 12),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(color: kDarkColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${_total.toStringAsFixed(2)} EGP', style: const TextStyle(color: kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: kPrimaryColor.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Checkout Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kDividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.green,
            child: Icon(Icons.check_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
          const Text(
            'Order Placed Successfully!',
            style: TextStyle(
              color: kDarkColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your network hardware order has been registered and is being prepared for shipment.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kGreyColor, fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Divider(color: kDividerColor, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Charged', style: TextStyle(color: kGreyColor, fontSize: 14)),
              Text('${_total.toStringAsFixed(2)} EGP', style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _cartItems.clear();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
