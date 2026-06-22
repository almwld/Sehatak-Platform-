import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';

class PharmacyProductsScreen extends StatefulWidget {
  final String pharmacyId;
  const PharmacyProductsScreen({super.key, required this.pharmacyId});

  @override
  State<PharmacyProductsScreen> createState() => _PharmacyProductsScreenState();
}

class _PharmacyProductsScreenState extends State<PharmacyProductsScreen> {
  final List<String> _categories = ['جميع', 'مسكنات', 'مضادات', 'فيتامينات', 'أعشاب', 'أطفال'];
  String _category = 'جميع';
  final List<Map<String, dynamic>> _cart = [];

  final List<Map<String, dynamic>> _products = [
    {'name': 'باراسيتامول 500mg', 'price': 500, 'cat': 'مسكنات', 'type': 'أقراص', 'img': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'inStock': true},
    {'name': 'أموكسيسيلين 500mg', 'price': 750, 'cat': 'مضادات', 'type': 'كبسولات', 'img': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'inStock': true},
    {'name': 'فيتامين د 1000IU', 'price': 1200, 'cat': 'فيتامينات', 'type': 'قطرات', 'img': 'https://images.unsplash.com/photo-1550572012-edd7b1a7b51c?w=200', 'inStock': true},
    {'name': 'زنجبيل 500mg', 'price': 300, 'cat': 'أعشاب', 'type': 'كبسولات', 'img': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'inStock': false},
    {'name': 'شراب أطفال للسعال', 'price': 450, 'cat': 'أطفال', 'type': 'شراب', 'img': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'inStock': true},
  ];

  List<Map<String, dynamic>> get _filtered => _category == 'جميع' ? _products : _products.where((p) => p['cat'] == _category).toList();

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existing = _cart.firstWhere((e) => e['name'] == product['name'], orElse: () => {});
      if (existing.isNotEmpty) {
        existing['qty'] = (existing['qty'] ?? 0) + 1;
      } else {
        _cart.add({...product, 'qty': 1});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجات الصيدلية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (_cart.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cart.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // الفئات
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final sel = cat == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: sel ? Colors.white : AppColors.darkGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // المنتجات
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final p = _filtered[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: p['img'],
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(height: 100, color: Colors.white),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 100,
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.medication, color: AppColors.primary, size: 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  p['type'],
                                  style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  p['cat'],
                                  style: const TextStyle(color: AppColors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${p['price']} ر.ي',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                                ),
                                GestureDetector(
                                  onTap: p['inStock'] ? () => _addToCart(p) : null,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: p['inStock'] ? AppColors.primary : AppColors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      p['inStock'] ? Icons.add_shopping_cart : Icons.block,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
