import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';

class HealthShopScreen extends StatefulWidget {
  const HealthShopScreen({super.key});

  @override
  State<HealthShopScreen> createState() => _HealthShopScreenState();
}

class _HealthShopScreenState extends State<HealthShopScreen> {
  final List<String> _categories = ['الكل', 'مكملات', 'فيتامينات', 'أعشاب', 'زيوت'];
  String _cat = 'الكل';

  final List<Map<String, dynamic>> _products = [
    {'name': 'فيتامين سي', 'brand': 'Nature\'s', 'price': 45, 'rating': 4.8, 'img': 'https://images.unsplash.com/photo-1550572012-edd7b1a7b51c?w=200', 'cat': 'فيتامينات'},
    {'name': 'زيت السمك', 'brand': 'Omega 3', 'price': 89, 'rating': 4.7, 'img': 'https://images.unsplash.com/photo-1550572012-edd7b1a7b51c?w=200', 'cat': 'زيوت'},
    {'name': 'مكمل كالسيوم', 'brand': 'Calcium', 'price': 32, 'rating': 4.5, 'img': 'https://images.unsplash.com/photo-1550572012-edd7b1a7b51c?w=200', 'cat': 'مكملات'},
    {'name': 'شاي أخضر', 'brand': 'Green Tea', 'price': 15, 'rating': 4.9, 'img': 'https://images.unsplash.com/photo-1550572012-edd7b1a7b51c?w=200', 'cat': 'أعشاب'},
  ];

  List<Map<String, dynamic>> get _filtered => _cat == 'الكل' ? _products : _products.where((p) => p['cat'] == _cat).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتجر الصحي'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الفئات
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.asMap().entries.map((e) {
                final label = e.value;
                return ChoiceChip(
                  label: Text(label, style: const TextStyle(fontSize: 10)),
                  selected: _cat == label,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _cat == label ? Colors.white : null),
                  onSelected: (v) => setState(() => _cat = v ? label : 'الكل'),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // المنتجات
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
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
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 120,
                            color: AppColors.primary.withOpacity(0.08),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 120,
                            color: AppColors.primary.withOpacity(0.08),
                            child: const Center(
                              child: Icon(Icons.medical_services, size: 40, color: AppColors.primary),
                            ),
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
                            Text(
                              p['brand'],
                              style: const TextStyle(fontSize: 9, color: AppColors.grey),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.amber, size: 12),
                                Text(' ${p['rating']}', style: const TextStyle(fontSize: 10)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${p['price']} ر.ي',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 16,
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
