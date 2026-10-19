import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Orders')),
      body: store.orders.isEmpty
          ? const Center(child: Text('No orders yet', style: TextStyle(color: AppColors.muted)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: store.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final order = store.orders[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.ink),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.status == 'Cancelled'
                                    ? Colors.red[50]
                                    : order.status == 'Delivered'
                                        ? Colors.blue[50]
                                        : AppColors.greenSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: order.status == 'Cancelled'
                                      ? Colors.red
                                      : order.status == 'Delivered'
                                          ? Colors.blue[800]
                                          : AppColors.greenDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('${order.placedAt} · ${order.payment}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                        const SizedBox(height: 8),
                        Text(
                          '₹${order.total} · ${order.items.length} item(s)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Track order & items details →',
                          style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    // Get latest state
    final currentOrder = store.orders.firstWhere((o) => o.id == order.id, orElse: () => order);
    const steps = ['Placed', 'Packed', 'Out for delivery', 'Delivered'];
    final currentIdx = steps.indexOf(currentOrder.status);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: Text('Track ${currentOrder.id}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentOrder.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.ink)),
                      Text(
                        currentOrder.status,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Placed on: ${currentOrder.placedAt}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Text(
                    'Estimated Delivery: ${currentOrder.eta}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  // 4-Step Progress Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(steps.length, (index) {
                      final isPassed = currentIdx >= index && currentOrder.status != 'Cancelled';
                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (index > 0)
                                  Expanded(
                                    child: Container(
                                      height: 3,
                                      color: currentIdx >= index && currentOrder.status != 'Cancelled'
                                          ? AppColors.green
                                          : AppColors.line,
                                    ),
                                  ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: isPassed ? AppColors.green : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isPassed ? AppColors.green : AppColors.line, width: 2),
                                  ),
                                  child: isPassed
                                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                                      : null,
                                ),
                                if (index < steps.length - 1)
                                  Expanded(
                                    child: Container(
                                      height: 3,
                                      color: currentIdx > index && currentOrder.status != 'Cancelled'
                                          ? AppColors.green
                                          : AppColors.line,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              steps[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
                                color: isPassed ? AppColors.ink : AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                  if (currentOrder.status != 'Delivered' && currentOrder.status != 'Cancelled') ...[
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => store.advanceOrder(currentOrder.id),
                        icon: const Icon(Icons.fast_forward, size: 16, color: AppColors.green),
                        label: const Text('Demo: Advance Tracking Status', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Items List
            const Text('Ordered Items', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ink)),
            const SizedBox(height: 8),

            ...currentOrder.items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 50,
                          height: 50,
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
                          Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink)),
                          Text('${item.pack} × ${item.qty}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    Text(
                      '₹${item.price * item.qty}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Delivery Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
                  const SizedBox(height: 4),
                  Text('${currentOrder.address.label} · ${currentOrder.address.name}', style: const TextStyle(fontSize: 12, color: AppColors.ink)),
                  Text(currentOrder.address.line, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  Text('${currentOrder.address.area} — ${currentOrder.address.pincode}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                  const Divider(height: 20, color: AppColors.line),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Paid:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('₹${currentOrder.total} (${currentOrder.payment})', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.greenDark)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            if (currentOrder.status == 'Placed')
              ElevatedButton(
                onPressed: () {
                  store.cancelOrder(currentOrder.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order cancelled successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                child: const Text('Cancel Order'),
              ),

            const SizedBox(height: 8),

            OutlinedButton(
              onPressed: () {
                store.reorder(currentOrder.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Items added back to your basket!')),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.green),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Reorder These Items', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
