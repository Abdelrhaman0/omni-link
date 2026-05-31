import 'package:flutter/material.dart';

class BrandModel {
  final String id;
  final String name;
  final IconData? icon;
  final String? imageUrl;
  final int productCount;
  final bool isPopular;
  final Color color;
  final String? description;

  BrandModel({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
    required this.productCount,
    this.isPopular = false,
    this.color = Colors.blue,
    this.description,
  });

  BrandModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? imageUrl,
    int? productCount,
    bool? isPopular,
    Color? color,
    String? description,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      productCount: productCount ?? this.productCount,
      isPopular: isPopular ?? this.isPopular,
      color: color ?? this.color,
      description: description ?? this.description,
    );
  }

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      icon: json['iconCode'] != null
          ? IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons')
          : null,
      productCount: json['productCount'] as int? ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      color: json['colorHex'] != null
          ? Color(json['colorHex'] as int)
          : Colors.blue,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'iconCode': icon?.codePoint,
      'productCount': productCount,
      'isPopular': isPopular,
      'colorHex': color.toARGB32(),
      'description': description,
    };
  }

  // Pre-configured mock brands
  static List<BrandModel> get mockBrands => [
        BrandModel(
          id: 'cisco',
          name: 'Cisco Systems',
          icon: Icons.hub_rounded,
          productCount: 156,
          isPopular: true,
          color: const Color(0xFF049FD9),
          description: 'Global leader in networking, security, and collaboration solutions.',
        ),
        BrandModel(
          id: 'ubiquiti',
          name: 'Ubiquiti UniFi',
          icon: Icons.wifi_tethering_rounded,
          productCount: 98,
          isPopular: true,
          color: const Color(0xFF005FFF),
          description: 'High-performance wireless networking and security cameras.',
        ),
        BrandModel(
          id: 'mikrotik',
          name: 'MikroTik',
          icon: Icons.router_rounded,
          productCount: 112,
          isPopular: true,
          color: const Color(0xFFE30613),
          description: 'Latvian manufacturer of network routers and wireless systems.',
        ),
        BrandModel(
          id: 'tplink',
          name: 'TP-Link Omada',
          icon: Icons.settings_input_antenna_rounded,
          productCount: 84,
          isPopular: false,
          color: const Color(0xFF00A2E8),
          description: 'Reliable smart home and enterprise networking devices.',
        ),
        BrandModel(
          id: 'hpe',
          name: 'HPE Aruba',
          icon: Icons.dns_rounded,
          productCount: 65,
          isPopular: true,
          color: const Color(0xFF00B074),
          description: 'Secure, intelligent edge-to-cloud networking solutions.',
        ),
      ];
}
