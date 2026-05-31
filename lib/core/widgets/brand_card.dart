import 'package:flutter/material.dart';
import 'package:untitled6/core/component/conests.dart';
import 'package:untitled6/models/brand_model.dart';

enum BrandCardType {
  grid,
  compact,
}

class BrandCard extends StatefulWidget {
  final BrandModel? brand; // Null when loading/shimmer
  final BrandCardType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const BrandCard({
    super.key,
    required this.brand,
    this.type = BrandCardType.grid,
    this.isSelected = false,
    this.onTap,
  });

  const BrandCard.grid({
    super.key,
    required this.brand,
    this.isSelected = false,
    this.onTap,
  }) : type = BrandCardType.grid;

  const BrandCard.compact({
    super.key,
    required this.brand,
    this.isSelected = false,
    this.onTap,
  }) : type = BrandCardType.compact;

  // Shimmer Named Constructors
  static Widget shimmer({
    Key? key,
    BrandCardType type = BrandCardType.grid,
  }) {
    return _BrandCardShimmer(type: type, key: key);
  }

  @override
  State<BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<BrandCard> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
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
    if (widget.brand == null) {
      return BrandCard.shimmer(type: widget.type);
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
            child: widget.type == BrandCardType.grid
                ? _buildGridCard()
                : _buildCompactCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard() {
    final brand = widget.brand!;
    final Color brandColor = brand.color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? brandColor.withValues(alpha: 0.04)
            : kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isSelected
              ? brandColor
              : _isHovered
                  ? brandColor.withValues(alpha: 0.5)
                  : kDividerColor,
          width: widget.isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isSelected
                ? brandColor.withValues(alpha: 0.08)
                : _isHovered
                    ? Colors.black.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.02),
            blurRadius: _isHovered ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              brand.icon ?? Icons.business_rounded,
              color: brandColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            brand.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kDarkColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${brand.productCount} Products',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard() {
    final brand = widget.brand!;
    final Color brandColor = brand.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? brandColor.withValues(alpha: 0.08)
            : kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isSelected
              ? brandColor
              : _isHovered
                  ? brandColor.withValues(alpha: 0.5)
                  : kDividerColor,
          width: widget.isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (_isHovered || widget.isSelected)
            BoxShadow(
              color: brandColor.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              brand.icon ?? Icons.business_rounded,
              color: brandColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            brand.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: widget.isSelected ? brandColor : kDarkColor,
              fontSize: 12,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Private Shimmer Loading UI helper class
class _BrandCardShimmer extends StatefulWidget {
  final BrandCardType type;

  const _BrandCardShimmer({super.key, required this.type});

  @override
  State<_BrandCardShimmer> createState() => _BrandCardShimmerState();
}

class _BrandCardShimmerState extends State<_BrandCardShimmer>
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
        return widget.type == BrandCardType.grid
            ? _buildGridShimmer()
            : _buildCompactShimmer();
      },
    );
  }

  Widget _buildGridShimmer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _shimmerCircle(48),
          const SizedBox(height: 12),
          _shimmerBar(width: 80, height: 12),
          const SizedBox(height: 6),
          _shimmerBar(width: 50, height: 8),
        ],
      ),
    );
  }

  Widget _buildCompactShimmer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _shimmerCircle(24),
          const SizedBox(width: 8),
          _shimmerBar(width: 60, height: 10),
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
