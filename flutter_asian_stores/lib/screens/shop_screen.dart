import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';

class ShopScreen extends StatefulWidget {
  final String initialCategory;

  const ShopScreen({super.key, this.initialCategory = 'all'});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late String _category;
  String _sort = 'featured'; // featured, price, rating
  bool _inStockOnly = false;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  void didUpdateWidget(covariant ShopScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      _category = widget.initialCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    List<Product> list = store.products;
    if (_category != 'all') {
      list = list.where((p) => p.category == _category).toList();
    }
    if (_inStockOnly) {
      list = list.where((p) => p.inStock).toList();
    }

    if (_sort == 'price') {
      list.sort((a, b) => a.cashPrice.compareTo(b.cashPrice));
    } else if (_sort == 'rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('All Groceries Catalog'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category chips
          Container(
            height: 48,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: mockCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = mockCategories[i];
                final isSelected = c.id == _category;
                return GestureDetector(
                  onTap: () => setState(() => _category = c.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.green : AppColors.cream,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? AppColors.green : AppColors.line),
                    ),
                    child: Text(
                      c.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.ink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Filters toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _inStockOnly = !_inStockOnly),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _inStockOnly ? AppColors.greenSoft : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _inStockOnly ? AppColors.green : AppColors.line),
                    ),
                    child: Text(
                      _inStockOnly ? 'In Stock Only ✓' : 'In Stock Only',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _inStockOnly ? AppColors.greenDark : AppColors.muted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (val) => setState(() => _sort = val),
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'featured', child: Text('Sort: Featured')),
                    const PopupMenuItem(value: 'price', child: Text('Sort: Price: Low to High')),
                    const PopupMenuItem(value: 'rating', child: Text('Sort: Top Rated')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: [
                        Text('Sort: $_sort', style: const TextStyle(fontSize: 11, color: AppColors.green, fontWeight: FontWeight.bold)),
                        const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.green),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${list.length} items',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text('No products match this filter.', style: TextStyle(color: AppColors.muted)),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final product = list[i];
                      final isWished = store.wishlist.contains(product.id);

                      return ProductCard(
                        product: product,
                        isWished: isWished,
                        onWish: () => store.toggleWish(product.id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductScreen(product: product),
                            ),
                          );
                        },
                        onAdd: () {
                          store.addToCart(product, product.packs.first);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product.name} added to cart')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
