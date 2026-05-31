import 'package:flutter/material.dart';
import 'package:untitled6/core/component/conests.dart';
import 'package:untitled6/models/product_model.dart';

enum ProductCardType {
  grid,
  list,
  compact,
}

class ProductCard extends StatefulWidget {
  final ProductModel? product; // Null when loading/shimmer
  final ProductCardType type;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onActionPressed;
  final String actionLabel;

  const ProductCard({
    super.key,
    required this.product,
    this.type = ProductCardType.grid,
    this.onTap,
    this.onFavoritePressed,
    this.onActionPressed,
    this.actionLabel = 'Add to Quote',
  });

  const ProductCard.grid({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.onActionPressed,
    this.actionLabel = 'Add to Quote',
  }) : type = ProductCardType.grid;

  const ProductCard.list({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.onActionPressed,
    this.actionLabel = 'Add to Quote',
  }) : type = ProductCardType.list;

  const ProductCard.compact({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoritePressed,
    this.onActionPressed,
    this.actionLabel = 'Add to Quote',
  }) : type = ProductCardType.compact;

  // Shimmer Named Constructor
  static Widget shimmer({
    Key? key,
    ProductCardType type = ProductCardType.grid,
  }) {
    return _ProductCardShimmer(type: type, key: key);
  }

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return ProductCard.shimmer(type: widget.type);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: widget.type == ProductCardType.grid
                ? _buildGridCard()
                : widget.type == ProductCardType.list
                    ? _buildListCard()
                    : _buildCompactCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard() {
    final product = widget.product!;
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isHovered ? kPrimaryColor.withValues(alpha: 0.4) : kDividerColor,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered
                ? kPrimaryColor.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: _isHovered ? 16 : 10,
            offset: _isHovered ? const Offset(0, 6) : const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image / Icon Container
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Hero(
                        tag: 'product_image_${product.id}',
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.developer_board_rounded,
                              size: 48,
                              color: kGreyColor,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Discount Badge
                if (product.hasDiscount)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.discountPercentage}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: Icon(
                        product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: product.isFavorite ? Colors.red : kGreyColor,
                        size: 18,
                      ),
                      onPressed: widget.onFavoritePressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & Brand row
                Row(
                  children: [
                    Text(
                      product.brandName ?? 'Generic',
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: kAccentColor, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            color: kDarkColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Name
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kDarkColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Prices
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)} EGP',
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${product.oldPrice.toStringAsFixed(0)} EGP',
                          style: const TextStyle(
                            color: kGreyColor,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Call to action button
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
              onPressed: widget.onActionPressed,
              child: Text(
                widget.actionLabel,
                style: const TextStyle(
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

  Widget _buildListCard() {
    final product = widget.product!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isHovered ? kPrimaryColor.withValues(alpha: 0.3) : kDividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered
                ? kPrimaryColor.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.01),
            blurRadius: _isHovered ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Image Container
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kLightColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.developer_board_rounded, color: kGreyColor, size: 32);
                  },
                ),
              ),
              if (product.hasDiscount)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${product.discountPercentage}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Center: Metadata Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (product.brandName != null) ...[
                      const SizedBox(width: 6),
                      Text(
                        product.brandName!,
                        style: const TextStyle(
                          color: kGreyColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
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
                      '${product.rating}',
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
                      '${product.price.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (product.hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${product.oldPrice.toStringAsFixed(0)} EGP',
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
          const SizedBox(width: 12),
          // Right: Action Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: product.isFavorite ? Colors.red : kGreyColor,
                  size: 22,
                ),
                onPressed: widget.onFavoritePressed,
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 18,
                backgroundColor: kPrimaryColor,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: widget.onActionPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard() {
    final product = widget.product!;
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isHovered ? kPrimaryColor.withValues(alpha: 0.3) : kDividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.developer_board_rounded, color: kGreyColor, size: 24);
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onFavoritePressed,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: product.isFavorite ? Colors.red : kGreyColor,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kDarkColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Private Shimmer Loading UI helper class for ProductCard
class _ProductCardShimmer extends StatefulWidget {
  final ProductCardType type;

  const _ProductCardShimmer({super.key, required this.type});

  @override
  State<_ProductCardShimmer> createState() => _ProductCardShimmerState();
}

class _ProductCardShimmerState extends State<_ProductCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return widget.type == ProductCardType.grid
            ? _buildGridShimmer()
            : widget.type == ProductCardType.list
                ? _buildListShimmer()
                : _buildCompactShimmer();
      },
    );
  }

  Widget _buildGridShimmer() {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kLightColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _shimmerCircle(48),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _shimmerBar(width: 40, height: 10),
                    const Spacer(),
                    _shimmerBar(width: 25, height: 10),
                  ],
                ),
                const SizedBox(height: 6),
                _shimmerBar(width: 100, height: 12),
                const SizedBox(height: 6),
                _shimmerBar(width: 60, height: 12),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: _shimmerGradient(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListShimmer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: kLightColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: _shimmerCircle(32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBar(width: 60, height: 10),
                const SizedBox(height: 8),
                _shimmerBar(width: 120, height: 12),
                const SizedBox(height: 6),
                _shimmerBar(width: 80, height: 12),
                const SizedBox(height: 8),
                _shimmerBar(width: 50, height: 14),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerCircle(20),
              const SizedBox(height: 24),
              _shimmerCircle(36),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactShimmer() {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kLightColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _shimmerCircle(24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBar(width: 85, height: 10),
                const SizedBox(height: 6),
                _shimmerBar(width: 45, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _shimmerGradient(),
      ),
    );
  }

  Widget _shimmerBar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: _shimmerGradient(),
      ),
    );
  }

  LinearGradient _shimmerGradient() {
    return LinearGradient(
      colors: const [
        Color(0xFFE2E8F0),
        Color(0xFFF1F5F9),
        Color(0xFFE2E8F0),
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment(-2.0 + _shimmerAnimation.value, -0.5),
      end: Alignment(0.0 + _shimmerAnimation.value, 0.5),
      tileMode: TileMode.clamp,
    );
  }
}