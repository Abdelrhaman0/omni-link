import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/core/component/conests.dart';
import 'package:untitled6/models/product_model.dart';
import 'presentation/manager/products_cubit.dart';
import 'presentation/manager/products_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductModel _product;

  // UI state variables
  int _quantity = 1;
  int _activeImageIndex = 0;
  bool _isDescriptionExpanded = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProductsCubit.get(context).fetchProductDetails(widget.product.id);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Add to Cart API / Handler using ProductsCubit
  void _addToCart() {
    ProductsCubit.get(context).addToCart(_product.id, _quantity);
  }

  /// Toggle Favorite API / Handler using ProductsCubit
  void _toggleFavorite() {
    ProductsCubit.get(context).toggleFavorite(_product.id);
  }

  /// Opens a high-fidelity full screen modal with pinch-to-zoom interactive view
  void _openZoomModal(int initialIndex) {
    final images = _product.images ?? [_product.image];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        int localIndex = initialIndex;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Scaffold(
              backgroundColor: Colors.black.withValues(alpha: 0.95),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  '${localIndex + 1} / ${images.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        itemCount: images.length,
                        controller: PageController(initialPage: initialIndex),
                        onPageChanged: (idx) {
                          setModalState(() {
                            localIndex = idx;
                          });
                        },
                        itemBuilder: (context, index) {
                          return InteractiveViewer(
                            clipBehavior: Clip.none,
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Image.network(
                              images[index],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.developer_board_rounded, color: kGreyColor, size: 80);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Navigation hints
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        'Pinch to Zoom • Swipe to Browse',
                        style: TextStyle(color: kGreyColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {
        if (state is AddToCartSuccessState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Added ${state.quantity} x ${_product.name} to Cart!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is AddToCartErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add to cart: ${state.error}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is ToggleFavoriteSuccessState) {
          setState(() {
            _product = _product.copyWith(isFavorite: !_product.isFavorite);
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    _product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _product.isFavorite 
                          ? '${_product.name} added to favorites!' 
                          : '${_product.name} removed from favorites!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              backgroundColor: _product.isFavorite ? Colors.redAccent : kDarkColor,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ToggleFavoriteErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update favorites: ${state.error}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GetProductDetailsLoadingState) {
          return Scaffold(
            backgroundColor: kLightColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kDarkColor, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: _buildLoadingState(),
          );
        }

        if (state is GetProductDetailsErrorState) {
          return Scaffold(
            backgroundColor: kLightColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kDarkColor, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: _buildErrorState(state.error),
          );
        }

        if (state is GetProductDetailsSuccessState) {
          _product = state.product;
        }

        final images = _product.images ?? [_product.image];

        return Scaffold(
          backgroundColor: kLightColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              _product.brandName ?? 'Product Details',
              style: const TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kDarkColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _product.isFavorite ? Colors.red : kDarkColor,
                ),
                onPressed: _toggleFavorite,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _buildMainContent(images),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: kPrimaryColor),
          SizedBox(height: 16),
          Text(
            'Fetching hardware parameters...',
            style: TextStyle(color: kGreyColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState([String? message]) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message ?? 'Network discrepancy detected',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: kDarkColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ProductsCubit.get(context).fetchProductDetails(_product.id);
              },
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
              child: const Text('Re-initialize Link', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(List<String> images) {
    return Column(
      children: [
        // Main scrollable details body
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Premium Image Slider
                _buildImageSlider(images),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Product Name, Category & Rating Overview
                      _buildTitleSection(),
                      const SizedBox(height: 16),

                      // 3. Dynamic Price Layout
                      _buildPriceLayout(),
                      const SizedBox(height: 24),

                      // 4. Interactive Configuration Panel (Qty & Subtotal)
                      _buildConfigurationPanel(),
                      const SizedBox(height: 24),

                      // 5. Expandable Description
                      _buildDescriptionSection(),
                      const SizedBox(height: 24),

                      // 6. Network Specifications Grid
                      _buildSpecificationsSection(),
                      const SizedBox(height: 28),

                      // 7. Customer Reviews & Breakdown
                      _buildReviewsSection(),
                      const SizedBox(height: 28),

                      // 8. Related Hardware Carousel
                      _buildRelatedSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 9. Premium Floating Action Bottom Bar (Sticky Add to Cart)
        _buildBottomActionBar(),
      ],
    );
  }

  /// 1. Custom Image Slider using PageView & Animated indicator dots
  Widget _buildImageSlider(List<String> images) {
    return Container(
      color: Colors.white,
      height: 260,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Gradient Overlay for premium aesthetic
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    kLightColor.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Horizontal PageView for slider
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _activeImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _openZoomModal(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 48.0),
                  child: Hero(
                    tag: 'product_image_${_product.id}',
                    child: Image.network(
                      images[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.developer_board_rounded,
                          size: 72,
                          color: kGreyColor,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          // Slide indicator dots
          if (images.length > 1)
            Positioned(
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _activeImageIndex == index ? 20.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: _activeImageIndex == index ? kPrimaryColor : kGreyColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ),
            ),

          // Interactive Zoom overlay prompt
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kLightColor,
                shape: BoxShape.circle,
                border: Border.all(color: kDividerColor),
              ),
              child: const Icon(
                Icons.zoom_in_rounded,
                size: 18,
                color: kGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Product Title, Category, and Star Rating Row
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _product.category,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (_product.brandName != null)
              Text(
                'by ${_product.brandName}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _product.name,
          style: const TextStyle(
            color: kDarkColor,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Stars
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: index < _product.rating.floor() 
                      ? kAccentColor 
                      : kDividerColor,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${_product.rating}',
              style: const TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 12, color: kDividerColor),
            const SizedBox(width: 8),
            Text(
              '${_product.reviews?.length ?? 0} Reviews',
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 3. Price Display Layout showing discount percent and strike-through of old price
  Widget _buildPriceLayout() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDividerColor),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Unit Price',
                style: TextStyle(color: kGreyColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _product.price.toStringAsFixed(0),
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'EGP',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          if (_product.hasDiscount) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'SAVE ${_product.discountPercentage}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Was ${_product.oldPrice.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 4. Interactive Configuration Panel containing Qty controller and Checkout Subtotal preview
  Widget _buildConfigurationPanel() {
    final double subtotal = _product.price * _quantity;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kDividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Configure Quantity',
                style: TextStyle(
                  color: kDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: kLightColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kDividerColor),
                ),
                child: Row(
                  children: [
                    // Minus Button
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove_rounded, size: 16, color: kDarkColor),
                    ),
                    // Quantity Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                        child: Text(
                          '$_quantity',
                          key: ValueKey<int>(_quantity),
                          style: const TextStyle(
                            color: kDarkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    // Plus Button
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        if (_quantity < 99) {
                          setState(() {
                            _quantity++;
                          });
                        }
                      },
                      icon: const Icon(Icons.add_rounded, size: 16, color: kDarkColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: kDividerColor, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calculated Estimate',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${subtotal.toStringAsFixed(0)} EGP',
                style: const TextStyle(
                  color: kDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 5. Expandable Product Description Section
  Widget _buildDescriptionSection() {
    final String fullDesc = _product.description ?? 'No detailed description available.';
    final bool isLong = fullDesc.length > 150;
    final String displayedText = isLong && !_isDescriptionExpanded 
        ? '${fullDesc.substring(0, 150)}...' 
        : fullDesc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Description',
          style: TextStyle(
            color: kDarkColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          displayedText,
          style: const TextStyle(
            color: kGreyColor,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if (isLong)
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(
                    _isDescriptionExpanded ? 'Read Less' : 'Read Full Description',
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isDescriptionExpanded 
                        ? Icons.keyboard_arrow_up_rounded 
                        : Icons.keyboard_arrow_down_rounded,
                    color: kPrimaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// 6. Custom Specification Grid Layout
  Widget _buildSpecificationsSection() {
    final specs = _product.specifications;
    if (specs == null || specs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Parameters',
          style: TextStyle(
            color: kDarkColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDividerColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specs.length,
            separatorBuilder: (context, index) => const Divider(color: kDividerColor, height: 1),
            itemBuilder: (context, index) {
              final key = specs.keys.elementAt(index);
              final value = specs[key]!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        key,
                        style: const TextStyle(
                          color: kGreyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: kDarkColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 7. Detailed Review Section with visual aggregate metrics
  Widget _buildReviewsSection() {
    final reviews = _product.reviews;
    if (reviews == null || reviews.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews & Evaluations',
            style: TextStyle(color: kDarkColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kDividerColor),
            ),
            child: const Center(
              child: Text(
                'No reviews logged for this product yet.',
                style: TextStyle(color: kGreyColor, fontSize: 13),
              ),
            ),
          ),
        ],
      );
    }

    // Dynamic rating breakdowns (simulated math)
    final double averageRating = _product.rating;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews & Evaluations',
          style: TextStyle(
            color: kDarkColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // Score breakdown card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDividerColor),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: kDarkColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Out of 5.0',
                      style: TextStyle(color: kGreyColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: index < averageRating.round() ? kAccentColor : kDividerColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 70, color: kDividerColor),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.85),
                      const SizedBox(height: 3),
                      _buildRatingBar(4, 0.12),
                      const SizedBox(height: 3),
                      _buildRatingBar(3, 0.03),
                      const SizedBox(height: 3),
                      _buildRatingBar(2, 0.00),
                      const SizedBox(height: 3),
                      _buildRatingBar(1, 0.00),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Individual reviews
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final r = reviews[index];
            final initials = r.userName.split(' ').map((e) => e[0]).take(2).join('');
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kDividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Colorful dynamic placeholder avatar
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: kPrimaryColor.withValues(alpha: 0.08),
                        child: Text(
                          initials.toUpperCase(),
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.userName,
                              style: const TextStyle(
                                color: kDarkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              r.date,
                              style: const TextStyle(color: kGreyColor, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (idx) => Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: idx < r.rating ? kAccentColor : kDividerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    r.comment,
                    style: const TextStyle(
                      color: kGreyColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Row(
      children: [
        Text(
          '$stars',
          style: const TextStyle(color: kDarkColor, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star_rounded, size: 10, color: kAccentColor),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 5,
              backgroundColor: kDividerColor,
              valueColor: const AlwaysStoppedAnimation<Color>(kAccentColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(percentage * 100).toInt()}%',
          style: const TextStyle(color: kGreyColor, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// 8. Related Items Horizontal Grid View (filtering from same category)
  Widget _buildRelatedSection() {
    final List<ProductModel> related = ProductModel.mockProducts
        .where((p) => p.category == _product.category && p.id != _product.id)
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Related Network Hardware',
          style: TextStyle(
            color: kDarkColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 185,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: related.length,
            itemBuilder: (context, index) {
              final product = related[index];
              return Container(
                width: 145,
                margin: const EdgeInsets.only(right: 14),
                child: _buildCompactProductCard(product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompactProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.developer_board_rounded, color: kGreyColor, size: 28);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: kDarkColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
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
      ),
    );
  }

  /// 9. Premium Floating Bottom Action Bar with animation and loading states
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        border: const Border(
          top: BorderSide(color: kDividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Favorites toggler
            Container(
              decoration: BoxDecoration(
                color: kLightColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kDividerColor),
              ),
              child: IconButton(
                icon: Icon(
                  _product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _product.isFavorite ? Colors.red : kGreyColor,
                ),
                onPressed: _toggleFavorite,
              ),
            ),
            const SizedBox(width: 12),
            // Primary Call to Action Button
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _addToCart,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Add to Basket',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
