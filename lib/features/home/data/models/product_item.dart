import 'package:flutter/material.dart';

/// Model data untuk satu item produk.
/// Dipindahkan dari home_page.dart ke layer data/models agar
/// dapat diakses oleh BLoC, Pages, dan Widgets tanpa circular dependency.
class ProductItem {
  final String id;
  final String brand;
  final String name;
  final String price;
  final double rating;
  final Color bgColor;
  final String imagePath;
  final String type;

  const ProductItem({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.rating,
    required this.bgColor,
    required this.imagePath,
    required this.type,
  });
}
