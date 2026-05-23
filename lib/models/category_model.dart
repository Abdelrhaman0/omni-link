import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String? shortName;
  final int productCount;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    this.shortName,
    required this.productCount,
    required this.icon,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String?,
      productCount: json['productCount'] as int? ?? 0,
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      color: Color(json['colorHex'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'productCount': productCount,
      'iconCode': icon.codePoint,
      'colorHex': color.toARGB32(),
    };
  }

  // Pre-configured mock / sample categories for the application
  static List<CategoryModel> get mockCategories => [
        CategoryModel(
          id: 'routers_firewalls',
          name: 'Routers & Firewalls',
          shortName: 'Routers',
          productCount: 124,
          icon: Icons.router_rounded,
          color: Colors.blue,
        ),
        CategoryModel(
          id: 'switches',
          name: 'Network Switches',
          shortName: 'Switches',
          productCount: 256,
          icon: Icons.hub_rounded,
          color: Colors.indigo,
        ),
        CategoryModel(
          id: 'wireless',
          name: 'Wireless Access Points',
          shortName: 'Wireless AP',
          productCount: 84,
          icon: Icons.wifi_rounded,
          color: Colors.teal,
        ),
        CategoryModel(
          id: 'cabling',
          name: 'Fiber & Copper Cabling',
          shortName: 'Cabling',
          productCount: 312,
          icon: Icons.cable_rounded,
          color: Colors.purple,
        ),
        CategoryModel(
          id: 'cabinets',
          name: 'Server Cabinets & Racks',
          shortName: 'Cabinets',
          productCount: 48,
          icon: Icons.inventory_2_rounded,
          color: Colors.blueGrey,
        ),
        CategoryModel(
          id: 'sfp_optics',
          name: 'SFP & Optic Modules',
          shortName: 'SFP & Optics',
          productCount: 196,
          icon: Icons.developer_board_rounded,
          color: Colors.orange,
        ),
        CategoryModel(
          id: 'poe_power',
          name: 'PoE & Power Delivery',
          shortName: 'PoE & Power',
          productCount: 64,
          icon: Icons.power_rounded,
          color: Colors.red,
        ),

      ];
}
