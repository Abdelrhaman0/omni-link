import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/component/conests.dart';

class ProductFilterState {
  final String searchQuery;
  final String selectedCategory;
  final Set<String> selectedBrands;
  final double? minPrice;
  final double? maxPrice;
  final Set<String> selectedAvailability;

  ProductFilterState({
    this.searchQuery = '',
    this.selectedCategory = 'All',
    Set<String>? selectedBrands,
    this.minPrice,
    this.maxPrice,
    Set<String>? selectedAvailability,
  })  : selectedBrands = selectedBrands ?? {},
        selectedAvailability = selectedAvailability ?? {};

  ProductFilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
    Set<String>? selectedBrands,
    double? minPrice,
    double? maxPrice,
    Set<String>? selectedAvailability,
  }) {
    return ProductFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedAvailability: selectedAvailability ?? this.selectedAvailability,
    );
  }

  ProductFilterState clear() {
    return ProductFilterState(
      searchQuery: '',
      selectedCategory: 'All',
      selectedBrands: {},
      minPrice: null,
      maxPrice: null,
      selectedAvailability: {},
    );
  }
}

class FilterSidebar extends StatefulWidget {
  final ProductFilterState filterState;
  final ValueChanged<ProductFilterState> onChanged;
  final Map<String, int> categoryCounts;
  final Map<String, int> brandCounts;
  final Map<String, int> availabilityCounts;
  final VoidCallback? onClearAll;

  const FilterSidebar({
    super.key,
    required this.filterState,
    required this.onChanged,
    required this.categoryCounts,
    required this.brandCounts,
    required this.availabilityCounts,
    this.onClearAll,
  });

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  late TextEditingController _searchController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

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

  bool _isPriceInvalid = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filterState.searchQuery);
    _minPriceController = TextEditingController(
      text: widget.filterState.minPrice != null ? widget.filterState.minPrice!.toStringAsFixed(0) : '',
    );
    _maxPriceController = TextEditingController(
      text: widget.filterState.maxPrice != null ? widget.filterState.maxPrice!.toStringAsFixed(0) : '',
    );
    _validatePriceRange();
  }

  @override
  void didUpdateWidget(covariant FilterSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the filters are cleared or changed externally, update the controllers
    if (oldWidget.filterState.searchQuery != widget.filterState.searchQuery &&
        _searchController.text != widget.filterState.searchQuery) {
      _searchController.text = widget.filterState.searchQuery;
    }
    
    final currentMinText = widget.filterState.minPrice != null ? widget.filterState.minPrice!.toStringAsFixed(0) : '';
    if (oldWidget.filterState.minPrice != widget.filterState.minPrice &&
        _minPriceController.text != currentMinText) {
      _minPriceController.text = currentMinText;
    }

    final currentMaxText = widget.filterState.maxPrice != null ? widget.filterState.maxPrice!.toStringAsFixed(0) : '';
    if (oldWidget.filterState.maxPrice != widget.filterState.maxPrice &&
        _maxPriceController.text != currentMaxText) {
      _maxPriceController.text = currentMaxText;
    }
    
    _validatePriceRange();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _validatePriceRange() {
    final min = double.tryParse(_minPriceController.text);
    final max = double.tryParse(_maxPriceController.text);
    if (min != null && max != null && min > max) {
      _isPriceInvalid = true;
    } else {
      _isPriceInvalid = false;
    }
  }

  void _onPriceChanged() {
    setState(() {
      _validatePriceRange();
    });

    if (!_isPriceInvalid) {
      final min = double.tryParse(_minPriceController.text);
      final max = double.tryParse(_maxPriceController.text);
      widget.onChanged(widget.filterState.copyWith(
        minPrice: min,
        maxPrice: max,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter categories based on search input as user types
    final searchQuery = _searchController.text.trim().toLowerCase();
    final displayedCategories = _allCategories.where((category) {
      if (category == 'All') return true; // Always display "All"
      return category.toLowerCase().contains(searchQuery);
    }).toList();

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and Clear All button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    color: kDarkColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    _minPriceController.clear();
                    _maxPriceController.clear();
                    setState(() {
                      _isPriceInvalid = false;
                    });
                    if (widget.onClearAll != null) {
                      widget.onClearAll!();
                    } else {
                      widget.onChanged(widget.filterState.clear());
                    }
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: kDividerColor, thickness: 1),
            const SizedBox(height: 12),

            // 1. Search Section
            const Text(
              'Search',
              style: TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Search catalog',
              textField: true,
              child: Container(
                decoration: BoxDecoration(
                  color: kLightColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kDividerColor),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: kGreyColor, size: 20),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: kGreyColor, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: const TextStyle(color: kDarkColor, fontSize: 14),
                  onChanged: (val) {
                    setState(() {}); // update category filtering in UI
                    widget.onChanged(widget.filterState.copyWith(searchQuery: val));
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Categories Section
            const Text(
              'Categories',
              style: TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayedCategories.length,
              itemBuilder: (context, index) {
                final category = displayedCategories[index];
                final isSelected = widget.filterState.selectedCategory.toLowerCase() == category.toLowerCase();
                final count = widget.categoryCounts[category] ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      widget.onChanged(widget.filterState.copyWith(selectedCategory: category));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                      child: Row(
                        children: [
                          // Circular radio-like button
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? kPrimaryColor : kGreyColor.withValues(alpha: 0.5),
                                width: isSelected ? 5.5 : 1.5,
                              ),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? kDarkColor : kGreyColor,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          // Count badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: kLightColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kDividerColor),
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: kGreyColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 3. Brand Section
            const Text(
              'Brand',
              style: TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allBrands.length,
              itemBuilder: (context, index) {
                final brand = _allBrands[index];
                final isSelected = widget.filterState.selectedBrands.contains(brand);
                final count = widget.brandCounts[brand] ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: InkWell(
                    onTap: () {
                      final updatedBrands = Set<String>.from(widget.filterState.selectedBrands);
                      if (isSelected) {
                        updatedBrands.remove(brand);
                      } else {
                        updatedBrands.add(brand);
                      }
                      widget.onChanged(widget.filterState.copyWith(selectedBrands: updatedBrands));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                      child: Row(
                        children: [
                          // Standard Checkbox
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: isSelected,
                              activeColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: kGreyColor.withValues(alpha: 0.6),
                                width: 1.5,
                              ),
                              onChanged: (bool? val) {
                                final updatedBrands = Set<String>.from(widget.filterState.selectedBrands);
                                if (val == true) {
                                  updatedBrands.add(brand);
                                } else {
                                  updatedBrands.remove(brand);
                                }
                                widget.onChanged(widget.filterState.copyWith(selectedBrands: updatedBrands));
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              brand,
                              style: TextStyle(
                                color: isSelected ? kDarkColor : kGreyColor,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                          // Count badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: kLightColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kDividerColor),
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: kGreyColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // 4. Price Section
            const Text(
              'Price',
              style: TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    label: 'Minimum Price in EGP',
                    textField: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Minimum Price',
                          style: TextStyle(color: kGreyColor, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: kLightColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isPriceInvalid ? Colors.red : kDividerColor,
                              width: _isPriceInvalid ? 1.5 : 1.0,
                            ),
                          ),
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Min',
                              hintStyle: TextStyle(color: kGreyColor, fontSize: 12),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            style: const TextStyle(color: kDarkColor, fontSize: 13, fontWeight: FontWeight.bold),
                            onChanged: (_) => _onPriceChanged(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    label: 'Maximum Price in EGP',
                    textField: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Maximum Price',
                          style: TextStyle(color: kGreyColor, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: kLightColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isPriceInvalid ? Colors.red : kDividerColor,
                              width: _isPriceInvalid ? 1.5 : 1.0,
                            ),
                          ),
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Max',
                              hintStyle: TextStyle(color: kGreyColor, fontSize: 12),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            style: const TextStyle(color: kDarkColor, fontSize: 13, fontWeight: FontWeight.bold),
                            onChanged: (_) => _onPriceChanged(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isPriceInvalid) ...[
              const SizedBox(height: 6),
              const Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.red, size: 14),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Min price cannot exceed max price',
                      style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),

            // 5. Availability Section
            const Text(
              'Availability',
              style: TextStyle(
                color: kDarkColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            _buildAvailabilityTile(
              label: 'In Stock',
              count: widget.availabilityCounts['In Stock'] ?? 0,
            ),
            _buildAvailabilityTile(
              label: 'Out of Stock',
              count: widget.availabilityCounts['Out of Stock'] ?? 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityTile({required String label, required int count}) {
    final isSelected = widget.filterState.selectedAvailability.contains(label);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: () {
          final updatedAvailability = Set<String>.from(widget.filterState.selectedAvailability);
          if (isSelected) {
            updatedAvailability.remove(label);
          } else {
            updatedAvailability.add(label);
          }
          widget.onChanged(widget.filterState.copyWith(selectedAvailability: updatedAvailability));
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,
                  activeColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: kGreyColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  onChanged: (bool? val) {
                    final updatedAvailability = Set<String>.from(widget.filterState.selectedAvailability);
                    if (val == true) {
                      updatedAvailability.add(label);
                    } else {
                      updatedAvailability.remove(label);
                    }
                    widget.onChanged(widget.filterState.copyWith(selectedAvailability: updatedAvailability));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? kDarkColor : kGreyColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13.5,
                  ),
                ),
              ),
              // Count badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kLightColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kDividerColor),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
