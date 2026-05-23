import 'package:flutter/material.dart';
import 'package:untitled6/core/component/conests.dart';
import 'package:untitled6/models/category_model.dart';

enum CategoryCardType {
  grid,
  compact,
}

class CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final CategoryCardType type;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.type = CategoryCardType.grid,
    this.isSelected = false,
    this.onTap,
  });

  const CategoryCard.grid({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  }) : type = CategoryCardType.grid;

  const CategoryCard.compact({
    super.key,
    required this.category,
    this.isSelected = false,
    this.onTap,
  }) : type = CategoryCardType.compact;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
            child: widget.type == CategoryCardType.grid
                ? _buildGridCard()
                : _buildCompactCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? widget.category.color.withValues(alpha: 0.05)
            : kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isSelected
              ? widget.category.color
              : _isHovered
                  ? widget.category.color.withValues(alpha: 0.5)
                  : kDividerColor,
          width: widget.isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isSelected
                ? widget.category.color.withValues(alpha: 0.1)
                : _isHovered
                    ? Colors.black.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.02),
            blurRadius: _isHovered ? 12 : 8,
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.category.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.category.icon,
                  color: widget.category.color,
                  size: 20,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: widget.isSelected ? widget.category.color : kGreyColor,
                size: 12,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category.name,
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
                '${widget.category.productCount} Products',
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

  Widget _buildCompactCard() {
    return Container(
      width: 85,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? widget.category.color.withValues(alpha: 0.08)
            : kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isSelected
              ? widget.category.color
              : _isHovered
                  ? widget.category.color.withValues(alpha: 0.4)
                  : kDividerColor,
          width: widget.isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (_isHovered || widget.isSelected)
            BoxShadow(
              color: widget.category.color.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.category.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.category.icon,
              color: widget.category.color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.category.shortName ?? widget.category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.isSelected ? widget.category.color : kDarkColor,
              fontSize: 11,
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
