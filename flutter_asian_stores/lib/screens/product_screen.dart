import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _packIndex = 0;
  int _qty = 1;

  void _showWriteReviewDialog(BuildContext context, StoreProvider store) {
    double selectedRating = 5;
    final textCtrl = TextEditingController(text: 'Fresh pack, cash price matched the label.');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Review ${widget.product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: AppColors.gold,
                      size: 28,
                    ),
                    onPressed: () => setDialogState(() => selectedRating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                store.addReview(
                  widget.product.id,
                  store.user?.name ?? 'Customer',
                  selectedRating,
                  textCtrl.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review posted successfully!')),
                );
                setState(() {});
              },
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    // Get fresh instance from provider if reviews updated
    final currentProduct = store.products.firstWhere(
      (p) => p.id == widget.product.id,
      orElse: () => widget.product,
    );
    final pack = currentProduct.packs[_packIndex];
    final mrp = (pack.price * 1.18).round();
    final savings = mrp - pack.price;
    final isWished = store.wishlist.contains(currentProduct.id);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(currentProduct.name),
        actions: [
          IconButton(
            icon: Icon(
              isWished ? Icons.favorite : Icons.favorite_border,
              color: isWished ? Colors.red : AppColors.ink,
            ),
            onPressed: () => store.toggleWish(currentProduct.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Hero Image
            Container(
              height: 250,
              width: double.infinity,
              color: AppColors.greenSoft,
              child: Image.network(
                currentProduct.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.green),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREMIUM PRODUCT · ${currentProduct.category.toUpperCase()}',
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentProduct.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ink),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(
                        '${currentProduct.rating} (${currentProduct.reviewCount} reviews)',
                        style: const TextStyle(color: AppColors.muted, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _showWriteReviewDialog(context, store),
                        icon: const Icon(Icons.rate_review_outlined, size: 16, color: AppColors.green),
                        label: const Text('Write Review', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Price Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MRP ₹$mrp',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cash Price ₹${pack.price}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.greenDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'You save ₹$savings on cash settlement',
                            style: const TextStyle(color: Color(0xFFC62828), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Pack Sizes
                  const Text('Select Pack Size', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(currentProduct.packs.length, (i) {
                      final pk = currentProduct.packs[i];
                      final isSelected = i == _packIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _packIndex = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.green : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSelected ? AppColors.green : AppColors.line),
                          ),
                          child: Column(
                            children: [
                              Text(
                                pk.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.ink,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '₹${pk.price}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? const Color(0xFFD7F3E0) : AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 18),

                  // Quantity
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18, color: AppColors.green),
                              onPressed: () {
                                if (_qty > 1) setState(() => _qty--);
                              },
                            ),
                            Text(
                              '$_qty',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18, color: AppColors.green),
                              onPressed: () => setState(() => _qty++),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Total: ₹${pack.price * _qty}',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.greenDark),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Description
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                  const SizedBox(height: 6),
                  Text(
                    currentProduct.description,
                    style: const TextStyle(color: AppColors.ink, height: 1.4, fontSize: 13),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  if (currentProduct.inStock) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        store.addToCart(currentProduct, pack, qty: _qty);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added $_qty × ${currentProduct.name} (${pack.label}) to cart')),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text('Add to Cart · ₹${pack.price * _qty}'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        store.addToCart(currentProduct, pack, qty: _qty);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.green, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Buy Now', style: TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () {
                        store.notifyMe(currentProduct.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Demo notification scheduled when back in stock!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: store.notifyIds.contains(currentProduct.id) ? Colors.grey : AppColors.green,
                      ),
                      child: Text(
                        store.notifyIds.contains(currentProduct.id) ? 'We’ll Notify You' : 'Notify Me When in Stock',
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Reviews List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink),
                      ),
                      TextButton(
                        onPressed: () => _showWriteReviewDialog(context, store),
                        child: const Text('Write a review', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...currentProduct.reviews.map((r) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                              Row(
                                children: List.generate(5, (starIdx) {
                                  return Icon(
                                    starIdx < r.rating ? Icons.star : Icons.star_border,
                                    size: 14,
                                    color: AppColors.gold,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(r.date, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                          const SizedBox(height: 6),
                          Text(r.text, style: const TextStyle(fontSize: 13, color: AppColors.ink)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
