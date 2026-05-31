import 'review_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double oldPrice;
  final String category;
  final double rating;
  final bool isFavorite;
  final String? brandName;
  final String? description;
  final List<String>? images;
  final Map<String, String>? specifications;
  final List<ProductReview>? reviews;
  final bool inStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.rating,
    this.isFavorite = false,
    this.brandName,
    this.description,
    this.images,
    this.specifications,
    this.reviews,
    this.inStock = true,
  });

  bool get hasDiscount => oldPrice > price;

  int get discountPercentage {
    if (!hasDiscount || oldPrice == 0) return 0;
    return (((oldPrice - price) / oldPrice) * 100).round();
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? image,
    double? price,
    double? oldPrice,
    String? category,
    double? rating,
    bool? isFavorite,
    String? brandName,
    String? description,
    List<String>? images,
    Map<String, String>? specifications,
    List<ProductReview>? reviews,
    bool? inStock,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      brandName: brandName ?? this.brandName,
      description: description ?? this.description,
      images: images ?? this.images,
      specifications: specifications ?? this.specifications,
      reviews: reviews ?? this.reviews,
      inStock: inStock ?? this.inStock,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var rawImages = json['images'] as List<dynamic>?;
    List<String>? imageList = rawImages?.map((e) => e as String).toList();

    var rawSpecs = json['specifications'] as Map<String, dynamic>?;
    Map<String, String>? specMap = rawSpecs?.map((k, v) => MapEntry(k, v.toString()));

    var rawReviews = json['reviews'] as List<dynamic>?;
    List<ProductReview>? reviewList = rawReviews
        ?.map((e) => ProductReview.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['oldPrice'] ?? json['old_price'] ?? 0.0 as num).toDouble(),
      category: json['category'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      brandName: json['brandName'] as String?,
      description: json['description'] as String?,
      images: imageList,
      specifications: specMap,
      reviews: reviewList,
      inStock: json['inStock'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'oldPrice': oldPrice,
      'category': category,
      'rating': rating,
      'isFavorite': isFavorite,
      'brandName': brandName,
      'description': description,
      'images': images,
      'specifications': specifications,
      'reviews': reviews?.map((r) => r.toJson()).toList(),
      'inStock': inStock,
    };
  }

  // Pre-configured mock products for the application
  static List<ProductModel> get mockProducts => [
        ProductModel(
          id: 1,
          name: 'UniFi U6 Pro Access Point',
          description: 'High-performance, ceiling-mounted WiFi 6 access point designed for large offices and enterprise environments.',
          image: 'https://cdn-icons-png.flaticon.com/512/2888/2888691.png',
          price: 4199.00,
          oldPrice: 4800.00,
          category: 'Access Point',
          rating: 4.9,
          brandName: 'Ubiquiti',
          isFavorite: true,
          inStock: true,
          images: const [
            'https://cdn-icons-png.flaticon.com/512/2888/2888691.png',
          ],
          specifications: const {
            'Standard': 'WiFi 6 (802.11ax)',
            'MIMO': '4x4 MU-MIMO',
            'Speed': 'Up to 5.3 Gbps aggregate rate',
          },
          reviews: const [
            ProductReview(
              id: 'r1_1',
              userName: 'Amr K.',
              rating: 5.0,
              date: 'May 12, 2026',
              comment: 'Incredibly easy to mount and set up.',
            ),
          ],
        ),
        ProductModel(
          id: 2,
          name: 'MikroTik CCR2004 Router',
          description: 'Powerful cloud core router equipped with a state-of-the-art quad-core CPU and 4GB DDR4 RAM.',
          image: 'https://cdn-icons-png.flaticon.com/512/1000/1000854.png',
          price: 8499.00,
          oldPrice: 9200.00,
          category: 'Routers',
          rating: 4.8,
          brandName: 'MikroTik',
          isFavorite: true,
          inStock: true,
          images: const [
            'https://cdn-icons-png.flaticon.com/512/1000/1000854.png',
          ],
          specifications: const {
            'CPU': 'AL32400 Quad-core 1.7 GHz',
            'RAM': '4 GB DDR4',
          },
          reviews: const [
            ProductReview(
              id: 'r2_1',
              userName: 'Sherif H.',
              rating: 5.0,
              date: 'May 18, 2026',
              comment: 'Outstanding routing engine.',
            ),
          ],
        ),
        ProductModel(
          id: 3,
          name: 'Cisco Catalyst 9300 Switch',
          description: 'Enterprise-grade stackable access-layer switch. Built for security, IoT, and cloud.',
          image: 'https://cdn-icons-png.flaticon.com/512/3208/3208726.png',
          price: 15999.00,
          oldPrice: 18500.00,
          category: 'Switch',
          rating: 5.0,
          brandName: 'cisco',
          isFavorite: false,
          inStock: true,
          images: const [
            'https://cdn-icons-png.flaticon.com/512/3208/3208726.png',
          ],
          specifications: const {
            'Total Ports': '24x 10/100/1000 PoE+ Ports',
          },
        ),
        ProductModel(
          id: 4,
          name: 'Mimosa C5c Client Device',
          description: 'High-performance, connectorized client device for long-range backhaul and PTP/PTMP links.',
          image: 'https://cdn-icons-png.flaticon.com/512/2888/2888691.png',
          price: 2499.00,
          oldPrice: 2800.00,
          category: 'Access Point',
          rating: 4.7,
          brandName: 'Mimosa',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 5,
          name: 'Cisco ISR 4331 Router',
          description: 'Integrated Services Router designed to deliver high-quality services to enterprise branches.',
          image: 'https://cdn-icons-png.flaticon.com/512/1000/1000854.png',
          price: 18999.00,
          oldPrice: 21000.00,
          category: 'Routers',
          rating: 4.6,
          brandName: 'cisco',
          isFavorite: false,
          inStock: false,
        ),
        ProductModel(
          id: 6,
          name: 'Hikvision IP Bullet Camera 4MP',
          description: 'High-definition outdoor bullet network camera with advanced night vision and motion detection.',
          image: 'https://cdn-icons-png.flaticon.com/512/2883/2883907.png',
          price: 1599.00,
          oldPrice: 1800.00,
          category: 'CCTV Cameras',
          rating: 4.5,
          brandName: 'Mixed Products',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 7,
          name: 'Dahua Dome PTZ Camera',
          description: 'Pan-Tilt-Zoom security camera with 25x optical zoom and robust weather protection.',
          image: 'https://cdn-icons-png.flaticon.com/512/2883/2883907.png',
          price: 2200.00,
          oldPrice: 2500.00,
          category: 'CCTV Cameras',
          rating: 4.4,
          brandName: 'Mixed Products',
          isFavorite: false,
          inStock: false,
        ),
        ProductModel(
          id: 8,
          name: 'Ubiquiti PoE Injector 24V',
          description: 'Reliable power delivery adapter for powering various Ubiquiti PoE devices.',
          image: 'https://cdn-icons-png.flaticon.com/512/815/815488.png',
          price: 499.00,
          oldPrice: 600.00,
          category: 'POE',
          rating: 4.8,
          brandName: 'Ubiquiti',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 9,
          name: 'MikroTik GPeR Gigabit PoE Repeater',
          description: 'Allows extending Ethernet cable by additional link (< 100 - 150 m to regular network devices).',
          image: 'https://cdn-icons-png.flaticon.com/512/815/815488.png',
          price: 749.00,
          oldPrice: 900.00,
          category: 'POE',
          rating: 4.5,
          brandName: 'MikroTik',
          isFavorite: false,
          inStock: false,
        ),
        ProductModel(
          id: 10,
          name: 'Cat6 Solid UTP Spool (1000ft)',
          description: 'High-quality bulk Ethernet cabling spool with copper-clad conductors.',
          image: 'https://cdn-icons-png.flaticon.com/512/10707/10707572.png',
          price: 4999.00,
          oldPrice: 5500.00,
          category: 'Accessories',
          rating: 4.6,
          brandName: 'Mixed Products',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 11,
          name: '9U Server Cabinet Rack',
          description: 'Enclosed wall-mount server cabinet constructed from SPCC cold-rolled steel.',
          image: 'https://cdn-icons-png.flaticon.com/512/2883/2883907.png',
          price: 3699.00,
          oldPrice: 4200.00,
          category: 'Accessories',
          rating: 4.5,
          brandName: 'Mixed Products',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 12,
          name: 'Mimosa N5-45x2 Sector Antenna',
          description: 'Industry-leading 45-degree sector antenna designed for long-range outdoor wireless systems.',
          image: 'https://cdn-icons-png.flaticon.com/512/2888/2888691.png',
          price: 3499.00,
          oldPrice: 4000.00,
          category: 'antenna',
          rating: 4.7,
          brandName: 'Mimosa',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 13,
          name: 'Huawei 4G LTE USB Modem',
          description: 'Compact USB modem providing high-speed mobile internet connection on the go.',
          image: 'https://cdn-icons-png.flaticon.com/512/815/815488.png',
          price: 899.00,
          oldPrice: 1100.00,
          category: 'USB MODEM',
          rating: 4.2,
          brandName: 'Mixed Products',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 14,
          name: 'Smart WiFi Motion Sensor',
          description: 'Battery-powered smart motion sensor for automation and alarm security alerts.',
          image: 'https://cdn-icons-png.flaticon.com/512/2883/2883907.png',
          price: 350.00,
          oldPrice: 450.00,
          category: 'smart system',
          rating: 4.3,
          brandName: 'Mixed Products',
          isFavorite: false,
          inStock: true,
        ),
        ProductModel(
          id: 15,
          name: 'MikroTik CRS326 24-Port Switch',
          description: 'Gigabit Ethernet switch powered by RouterOS/SwOS with dual boot capabilities.',
          image: 'https://cdn-icons-png.flaticon.com/512/3208/3208726.png',
          price: 5200.00,
          oldPrice: 6000.00,
          category: 'Switch',
          rating: 4.7,
          brandName: 'MikroTik',
          isFavorite: false,
          inStock: false,
        ),
      ];
}