import 'package:flutter/material.dart';
import 'product_item.dart';

/// Katalog produk terpusat — single source of truth.
/// Menghapus duplikasi data yang sebelumnya ada di home_page.dart
/// dan wishlist_page.dart.
class ProductCatalog {
  ProductCatalog._();

  static const List<ProductItem> products = [
    ProductItem(
      id: 'p1',
      brand: 'The North Face',
      name: 'D2 Utility Dryvent',
      price: '\$572',
      rating: 4.9,
      bgColor: Color(0xFFF5F5F0),
      imagePath: 'assets/images/the_north_face.png',
      type: 'clothing',
    ),
    ProductItem(
      id: 'p2',
      brand: 'Adidas',
      name: 'Originals Retro',
      price: '\$112',
      rating: 4.8,
      bgColor: Color(0xFFF0F0F5),
      imagePath: 'assets/images/adidas.jpeg',
      type: 'shoes',
    ),
    ProductItem(
      id: 'p3',
      brand: 'Nike',
      name: 'Air Max 270',
      price: '\$189',
      rating: 4.7,
      bgColor: Color(0xFFF5F0F0),
      imagePath: 'assets/images/nike.png',
      type: 'shoes',
    ),
    ProductItem(
      id: 'p4',
      brand: 'Adidas',
      name: 'Ultraboost 22',
      price: '\$220',
      rating: 4.6,
      bgColor: Color(0xFFF0F5F0),
      imagePath: 'assets/images/adidas_1.png',
      type: 'shoes',
    ),
    ProductItem(
      id: 'p5',
      brand: 'Carhartt',
      name: 'WIP Hoodie',
      price: '\$145',
      rating: 4.8,
      bgColor: Color(0xFFF5F5F5),
      imagePath: 'assets/images/carhartt.png',
      type: 'clothing',
    ),
    ProductItem(
      id: 'p6',
      brand: 'New Balance',
      name: '530 Silver',
      price: '\$130',
      rating: 4.9,
      bgColor: Color(0xFFF0F0F0),
      imagePath: 'assets/images/new_balance.png',
      type: 'shoes',
    ),
    ProductItem(
      id: 'p7',
      brand: 'The North Face',
      name: 'Retro Nuptse',
      price: '\$320',
      rating: 4.9,
      bgColor: Color(0xFFF5F5F0),
      imagePath: 'assets/images/the_north_face_1.png',
      type: 'clothing',
    ),
  ];
}
