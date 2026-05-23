import 'package:flutter/material.dart';
import 'package:untitled6/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onBuyPressed;
  final VoidCallback onFavoritePressed;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onBuyPressed,
    required this.onFavoritePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  // تقدر تستخدم CachedNetworkImage بعدين
                ),
              ),
            ),
          ),

          // تفاصيل المنتج
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),

                // التقييم (النجوم)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < product.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.grey, // لون النجوم في الموقع رمادي
                    );
                  }),
                ),
                const SizedBox(height: 4),

                // السعر
                if (product.oldPrice != null)
                  Text(
                    '${product.oldPrice} EGP',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                Text(
                  '${product.price} EGP',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // الأزرار المتاحة (اشتري الآن ومفضلة)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.grey),
                  onPressed: onFavoritePressed,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBuyPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // لون الزرار في الموقع
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'اشتري الآن',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}