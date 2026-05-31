import 'package:flutter/material.dart';

import '../../core/component/conests.dart';
import '../../core/widgets/product_widget.dart';
import '../../models/product_model.dart';
import 'presentation/widgets/filter_sidebar.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductFilterState _filterState = ProductFilterState();

  final List<String> _allCategories = [
    'All',
    'Access Point',
    'Routers',
    'CCTV Cameras',
    'POE',
    'Accessories',
    'antenna',
    'USB MODEM',
    'smart system',
    'Switch',
  ];

  final List<String> _allBrands = [
    'MikroTik',
    'Mimosa',
    'Ubiquiti',
    'cisco',
    'Mixed Products',
  ];

  int get _activeFiltersCount {
    int count = 0;
    if (_filterState.searchQuery.isNotEmpty) count++;
    if (_filterState.selectedCategory != 'All') count++;
    if (_filterState.selectedBrands.isNotEmpty) count += _filterState.selectedBrands.length;
    if (_filterState.minPrice != null || _filterState.maxPrice != null) count++;
    if (_filterState.selectedAvailability.isNotEmpty) count += _filterState.selectedAvailability.length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = ProductModel.mockProducts;

    // 1. Filtered products list
    final List<ProductModel> filteredProducts = allProducts.where((product) {
      // A. Search Query (filters products by name/description)
      if (_filterState.searchQuery.isNotEmpty) {
        final query = _filterState.searchQuery.toLowerCase();
        final nameMatches = product.name.toLowerCase().contains(query);
        final descMatches = (product.description ?? '').toLowerCase().contains(query);
        if (!nameMatches && !descMatches) return false;
      }

      // B. Category Selection
      if (_filterState.selectedCategory != 'All') {
        if (product.category.toLowerCase() != _filterState.selectedCategory.toLowerCase()) {
          return false;
        }
      }

      // C. Brand Selection (OR logic within brand filter)
      if (_filterState.selectedBrands.isNotEmpty) {
        final brand = product.brandName ?? '';
        if (!_filterState.selectedBrands.any((b) => b.toLowerCase() == brand.toLowerCase())) {
          return false;
        }
      }

      // D. Price Range (manual inputs)
      if (_filterState.minPrice != null && product.price < _filterState.minPrice!) {
        return false;
      }
      if (_filterState.maxPrice != null && product.price > _filterState.maxPrice!) {
        return false;
      }

      // E. Availability Selection (OR logic within availability filter)
      if (_filterState.selectedAvailability.isNotEmpty) {
        final inStock = product.inStock;
        final matchInStock = _filterState.selectedAvailability.contains('In Stock') && inStock;
        final matchOutOfStock = _filterState.selectedAvailability.contains('Out of Stock') && !inStock;
        if (!matchInStock && !matchOutOfStock) return false;
      }

      return true;
    }).toList();

    // 2. Faceted counts for Categories
    final Map<String, int> categoryCounts = {};
    for (final category in _allCategories) {
      categoryCounts[category] = allProducts.where((product) {
        if (category != 'All' && product.category.toLowerCase() != category.toLowerCase()) {
          return false;
        }
        // Search Query
        if (_filterState.searchQuery.isNotEmpty) {
          final query = _filterState.searchQuery.toLowerCase();
          final nameMatches = product.name.toLowerCase().contains(query);
          final descMatches = (product.description ?? '').toLowerCase().contains(query);
          if (!nameMatches && !descMatches) return false;
        }
        // Brand
        if (_filterState.selectedBrands.isNotEmpty) {
          final brand = product.brandName ?? '';
          if (!_filterState.selectedBrands.any((b) => b.toLowerCase() == brand.toLowerCase())) return false;
        }
        // Price
        if (_filterState.minPrice != null && product.price < _filterState.minPrice!) return false;
        if (_filterState.maxPrice != null && product.price > _filterState.maxPrice!) return false;
        // Availability
        if (_filterState.selectedAvailability.isNotEmpty) {
          final inStock = product.inStock;
          final matchInStock = _filterState.selectedAvailability.contains('In Stock') && inStock;
          final matchOutOfStock = _filterState.selectedAvailability.contains('Out of Stock') && !inStock;
          if (!matchInStock && !matchOutOfStock) return false;
        }
        return true;
      }).length;
    }

    // 3. Faceted counts for Brands
    final Map<String, int> brandCounts = {};
    for (final brand in _allBrands) {
      brandCounts[brand] = allProducts.where((product) {
        final productBrand = product.brandName ?? '';
        if (productBrand.toLowerCase() != brand.toLowerCase()) {
          return false;
        }
        // Search Query
        if (_filterState.searchQuery.isNotEmpty) {
          final query = _filterState.searchQuery.toLowerCase();
          final nameMatches = product.name.toLowerCase().contains(query);
          final descMatches = (product.description ?? '').toLowerCase().contains(query);
          if (!nameMatches && !descMatches) return false;
        }
        // Category
        if (_filterState.selectedCategory != 'All') {
          if (product.category.toLowerCase() != _filterState.selectedCategory.toLowerCase()) return false;
        }
        // Price
        if (_filterState.minPrice != null && product.price < _filterState.minPrice!) return false;
        if (_filterState.maxPrice != null && product.price > _filterState.maxPrice!) return false;
        // Availability
        if (_filterState.selectedAvailability.isNotEmpty) {
          final inStock = product.inStock;
          final matchInStock = _filterState.selectedAvailability.contains('In Stock') && inStock;
          final matchOutOfStock = _filterState.selectedAvailability.contains('Out of Stock') && !inStock;
          if (!matchInStock && !matchOutOfStock) return false;
        }
        return true;
      }).length;
    }

    // 4. Faceted counts for Availability
    final Map<String, int> availabilityCounts = {};
    for (final status in ['In Stock', 'Out of Stock']) {
      final bool targetInStock = status == 'In Stock';
      availabilityCounts[status] = allProducts.where((product) {
        if (product.inStock != targetInStock) {
          return false;
        }
        // Search Query
        if (_filterState.searchQuery.isNotEmpty) {
          final query = _filterState.searchQuery.toLowerCase();
          final nameMatches = product.name.toLowerCase().contains(query);
          final descMatches = (product.description ?? '').toLowerCase().contains(query);
          if (!nameMatches && !descMatches) return false;
        }
        // Category
        if (_filterState.selectedCategory != 'All') {
          if (product.category.toLowerCase() != _filterState.selectedCategory.toLowerCase()) return false;
        }
        // Brand
        if (_filterState.selectedBrands.isNotEmpty) {
          final brand = product.brandName ?? '';
          if (!_filterState.selectedBrands.any((b) => b.toLowerCase() == brand.toLowerCase())) return false;
        }
        // Price
        if (_filterState.minPrice != null && product.price < _filterState.minPrice!) return false;
        if (_filterState.maxPrice != null && product.price > _filterState.maxPrice!) return false;
        return true;
      }).length;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1024;

    Widget mainContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          if (!isDesktop) ...[
            _buildMobileFilterBar(context),
            const SizedBox(height: 16),
          ],
          
          // Catalog Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${filteredProducts.length} Product${filteredProducts.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_activeFiltersCount > 0)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _filterState = _filterState.clear();
                    });
                  },
                  icon: const Icon(Icons.clear_all_rounded, size: 16),
                  label: const Text('Reset Filters', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: kGreyColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Catalog Listing (Networking Hardware) using our ProductCard.list
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ProductCard.list(
                          product: product,
                          actionLabel: product.inStock ? 'Add to Cart' : 'Out of Stock',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                          onFavoritePressed: () {
                            // Can add local state toggle or Bloc favorite toggle
                          },
                          onActionPressed: product.inStock
                              ? () {
                                  // Cart Bloc Add
                                }
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      endDrawer: isDesktop
          ? null
          : Drawer(
              width: 310,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: FilterSidebar(
                  filterState: _filterState,
                  onChanged: (newState) {
                    setState(() {
                      _filterState = newState;
                    });
                  },
                  categoryCounts: categoryCounts,
                  brandCounts: brandCounts,
                  availabilityCounts: availabilityCounts,
                  onClearAll: () {
                    setState(() {
                      _filterState = _filterState.clear();
                    });
                  },
                ),
              ),
            ),
      body: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Desktop Sidebar
                Container(
                  width: 300,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      right: BorderSide(color: kDividerColor, width: 1.0),
                    ),
                  ),
                  child: FilterSidebar(
                    filterState: _filterState,
                    onChanged: (newState) {
                      setState(() {
                        _filterState = newState;
                      });
                    },
                    categoryCounts: categoryCounts,
                    brandCounts: brandCounts,
                    availabilityCounts: availabilityCounts,
                    onClearAll: () {
                      setState(() {
                        _filterState = _filterState.clear();
                      });
                    },
                  ),
                ),
                // Main Content Catalog
                Expanded(child: mainContent),
              ],
            )
          : mainContent,
    );
  }

  Widget _buildMobileFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _filterState.selectedCategory == 'All'
                  ? 'All Categories'
                  : _filterState.selectedCategory,
              style: const TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list_rounded, color: kPrimaryColor, size: 18),
                  const SizedBox(width: 6),
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (_activeFiltersCount > 0) ...[
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: kPrimaryColor,
                      child: Text(
                        '$_activeFiltersCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kLightColor,
              shape: BoxShape.circle,
              border: Border.all(color: kDividerColor),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: kGreyColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Products Found',
            style: TextStyle(
              color: kDarkColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try checking another network hardware filter.',
            style: TextStyle(color: kGreyColor, fontSize: 12),
          ),
          const SizedBox(height: 16),
          if (_activeFiltersCount > 0)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterState = _filterState.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Clear All Filters',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
