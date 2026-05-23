import 'package:flutter/material.dart';

import '../../core/component/conests.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kDarkColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: kLightColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kDividerColor),
          ),
          child: const TextField(
            autofocus: true,
            style: TextStyle(fontSize: 14, color: kDarkColor),
            decoration: InputDecoration(
              hintText: 'Search routers, switches, optic modules...',
              hintStyle: TextStyle(color: kGreyColor, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: kGreyColor, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Popular Searches',
              style: TextStyle(
                color: kDarkColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSearchTag(context, 'UniFi AP'),
                _buildSearchTag(context, 'PoE Switch'),
                _buildSearchTag(context, 'Cat6 Cable'),
                _buildSearchTag(context, 'SFP+ Transceiver'),
                _buildSearchTag(context, 'Server Rack'),
                _buildSearchTag(context, 'MikroTik CCR'),
              ],
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 72,
                      color: kGreyColor.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Search Network Hardware Catalog',
                      style: TextStyle(
                        color: kDarkColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Search over 10,000 enterprise networking parts and accessories.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kGreyColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kDividerColor),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: kDarkColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
