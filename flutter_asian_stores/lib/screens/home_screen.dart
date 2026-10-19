import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onTabChange;
  final Function(String) onSelectCategory;

  const HomeScreen({
    super.key,
    required this.onTabChange,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final featuredProducts = store.products.where((p) => p.inStock).take(6).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Charity Top Bar
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Shop Groceries, Spread Kindness'),
                    content: const Text(
                      '₹200 from every live purchase on Asian Stores is pledged to rural charity initiatives. Thank you for supporting our farming communities!',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                    ],
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                color: AppColors.green,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: const Text(
                  'Shop Groceries, Spread Kindness — ₹200 from every live purchase goes to charity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ASIAN STORES',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.greenDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'PREMIUM QUALITY GROCERIES',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.muted.withOpacity(0.8),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.ink),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Wishlist has ${store.wishlist.length} saved products')),
                      );
                    },
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_basket_outlined, color: AppColors.ink),
                        onPressed: () => onTabChange(2), // Cart tab
                      ),
                      if (store.cartCount > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${store.cartCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Scrollable Area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.line),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.muted, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Search pulse, masala, oil...',
                                hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (query) {
                                onSelectCategory('all');
                                onTabChange(1); // Go to shop
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune, color: AppColors.green, size: 20),
                            onPressed: () => onTabChange(1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Announcement Pill
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: AppColors.green, size: 10),
                          SizedBox(width: 8),
                          Text(
                            'New Stock: Premium Basmathi Rice & Cold-Pressed Oils',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hero Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF145C2A), Color(0xFF1F7A3A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'i 2 AGRO PRODUCTS',
                          style: TextStyle(color: Color(0xFFD7F3E0), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Fresh.\nQuality.\nGrocery.',
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1.15),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hi ${store.user?.name.split(' ').first ?? 'there'} — Chennai delivery zones are live.',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => onTabChange(1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.greenDark,
                                minimumSize: const Size(120, 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Start Exploring', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () => onTabChange(3), // Account tab
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white70),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(100, 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Contact Us'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '✓ Trusted by 2,000+ Chennai Families',
                          style: TextStyle(color: Color(0xFFD7F3E0), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Value props
                  SizedBox(
                    height: 85,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildBenefitCard(Icons.eco_outlined, 'Premium Groceries', 'Quality since 2002'),
                        _buildBenefitCard(Icons.chat_bubble_outline, 'WhatsApp Support', 'Place orders on chat'),
                        _buildBenefitCard(Icons.credit_card, 'Online Payment', 'Cards, UPI, COD'),
                        _buildBenefitCard(Icons.delivery_dining, 'Fast Delivery', 'Dispatched 24–48 hrs'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Categories Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                        ),
                        TextButton(
                          onPressed: () => onTabChange(1),
                          child: const Text('All Categories', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 105,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: mockCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final cat = mockCategories[i];
                        return GestureDetector(
                          onTap: () {
                            onSelectCategory(cat.id);
                            onTabChange(1);
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  cat.image,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 65,
                                    height: 65,
                                    color: AppColors.greenSoft,
                                    child: const Icon(Icons.category, color: AppColors.green),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 75,
                                child: Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.ink),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // British Chocolates Banner
                  GestureDetector(
                    onTap: () {
                      onSelectCategory('chocolate');
                      onTabChange(1);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3E2723), Color(0xFF5D4037)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CRAVING SWEETS?',
                                  style: TextStyle(color: Color(0xFFFFCC80), fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'British Chocolates & Treats',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Imported Dairy Milk, Digestives & more →',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text('🍫', style: TextStyle(fontSize: 36)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Featured Products Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Premium Collections',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
                        ),
                        TextButton(
                          onPressed: () => onTabChange(1),
                          child: const Text('View All', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: featuredProducts.length,
                      itemBuilder: (context, i) {
                        final product = featuredProducts[i];
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard(IconData icon, String title, String subtitle) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFFD7F3E0), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
