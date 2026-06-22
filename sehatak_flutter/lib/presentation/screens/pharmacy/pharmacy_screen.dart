import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import 'pharmacies_list_screen.dart';
import 'pharmacy_products_screen.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final List<Map<String, dynamic>> _pharmacies = [
    {'id': '1', 'name': 'صيدلية النصر', 'address': 'صنعاء - شارع التعاون', 'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'rating': 4.8},
    {'id': '2', 'name': 'صيدلية الأمان', 'address': 'عدن - شارع المعلا', 'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'rating': 4.6},
    {'id': '3', 'name': 'صيدلية الصفا', 'address': 'تعز - شارع الجيش', 'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200', 'rating': 4.7},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'مسكنات', 'color': Colors.red},
    {'name': 'مضادات', 'color': Colors.blue},
    {'name': 'فيتامينات', 'color': Colors.green},
    {'name': 'قلب', 'color': Colors.pink},
    {'name': 'سكري', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصيدلية'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'أقرب الصيدليات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _pharmacies.length,
                itemBuilder: (context, index) {
                  final p = _pharmacies[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PharmacyProductsScreen(pharmacyId: p['id'])),
                    ),
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: CachedNetworkImage(
                              imageUrl: p['image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(height: 100, color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.local_pharmacy, color: Colors.grey),
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
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  p['address'],
                                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 14, color: Colors.amber),
                                    Text(
                                      p['rating'].toString(),
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'الأقسام',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                return FilterChip(
                  label: Text(cat['name']),
                  onSelected: (_) {},
                  backgroundColor: cat['color'].withOpacity(0.1),
                  selectedColor: cat['color'].withOpacity(0.2),
                  labelStyle: TextStyle(color: cat['color']),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PharmaciesListScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('عرض جميع الصيدليات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
