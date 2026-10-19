import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onContinueShopping;

  const CartScreen({super.key, required this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    if (store.cart.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(title: const Text('My Basket')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: AppColors.greenSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_basket_outlined, size: 48, color: AppColors.green),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your basket is empty',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore our farm-fresh groceries and spices from rural harvests.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onContinueShopping,
                  child: const Text('Start Exploring Groceries'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('My Basket'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear basket?'),
                  content: const Text('Remove all items from your basket?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep')),
                    TextButton(
                      onPressed: () {
                        store.clearCart();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Clear', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: store.cart.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final line = store.cart[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          line.product.image,
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 65,
                            height: 65,
                            color: AppColors.greenSoft,
                            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${line.pack.label} · Cash ₹${line.pack.price}',
                              style: const TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.cream,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.line),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => store.setQty(line.key, line.qty - 1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Icon(Icons.remove, size: 14, color: AppColors.green),
                                        ),
                                      ),
                                      Text(
                                        '${line.qty}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      GestureDetector(
                                        onTap: () => store.setQty(line.key, line.qty + 1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Icon(Icons.add, size: 14, color: AppColors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '₹${line.pack.price * line.qty}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.greenDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                        onPressed: () => store.removeFromCart(line.key),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Checkout Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.line)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total (${store.cartCount} items):',
                        style: const TextStyle(fontSize: 14, color: AppColors.muted, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '₹${store.subtotal}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      );
                    },
                    child: const Text('Review & Checkout'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: onContinueShopping,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.line),
                      minimumSize: const Size.fromHeight(46),
                    ),
                    child: const Text('Continue Shopping', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
