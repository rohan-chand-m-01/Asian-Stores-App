import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'orders_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _couponCtrl = TextEditingController();
  final _upiCtrl = TextEditingController(text: 'priya@oksbi');
  final _cardCtrl = TextEditingController(text: '4111 1111 1111 1111');
  String _paymentMethod = 'Cash on delivery'; // Cash on delivery, UPI, Card

  @override
  void dispose() {
    _couponCtrl.dispose();
    _upiCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  void _showAddAddressDialog(BuildContext context, StoreProvider store) {
    final labelCtrl = TextEditingController(text: 'Parents');
    final nameCtrl = TextEditingController(text: 'K. Sharma');
    final phoneCtrl = TextEditingController(text: '9876543210');
    final lineCtrl = TextEditingController(text: '12, 2nd Cross Street');
    String selectedArea = 'Perungudi';
    String selectedPin = '600096';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Delivery Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: labelCtrl, decoration: const InputDecoration(labelText: 'Label (Home/Work/Parents)')),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Recipient Name')),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
                TextField(controller: lineCtrl, decoration: const InputDecoration(labelText: 'Street Address')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedArea,
                  items: const [
                    DropdownMenuItem(value: 'Perungudi', child: Text('Perungudi (600096)')),
                    DropdownMenuItem(value: 'Thuraipakkam', child: Text('Thuraipakkam (600097)')),
                    DropdownMenuItem(value: 'Karapakkam', child: Text('Karapakkam (600097)')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        selectedArea = val;
                        selectedPin = val == 'Perungudi' ? '600096' : '600097';
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Delivery Area (Chennai)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final addr = Address(
                  id: 'addr-${DateTime.now().millisecondsSinceEpoch}',
                  label: labelCtrl.text,
                  name: nameCtrl.text,
                  phone: phoneCtrl.text,
                  line: lineCtrl.text,
                  area: selectedArea,
                  pincode: selectedPin,
                );
                store.addAddress(addr);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('New address saved and selected!')),
                );
              },
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Review Order & Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                TextButton(
                  onPressed: () => _showAddAddressDialog(context, store),
                  child: const Text('+ Add New', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Addresses
            ...store.addresses.map((addr) {
              final isSelected = addr.id == store.selectedAddressId;
              return GestureDetector(
                onTap: () => store.setSelectedAddressId(addr.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.greenSoft : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? AppColors.green : AppColors.line),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.green : AppColors.muted,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${addr.label} · ${addr.name}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink)),
                            const SizedBox(height: 2),
                            Text(addr.line, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                            Text('${addr.area} — ${addr.pincode}', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Coupon Section
            const Text('Apply Coupon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),

            // Suggestion chips
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildCouponChip('WELCOME', 'WELCOME (10% off)', store),
                _buildCouponChip('ASIAN50', 'ASIAN50 (Flat ₹50)', store),
                _buildCouponChip('CHARITY', 'CHARITY (₹20 extra)', store),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final res = store.applyCoupon(_couponCtrl.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),

            if (store.coupon.isNotEmpty) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: store.removeCoupon,
                child: Text(
                  'Remove applied coupon (${store.coupon})',
                  style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Payment Options
            const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),

            ...['Cash on delivery', 'UPI', 'Card'].map((method) {
              final isSelected = _paymentMethod == method;
              return GestureDetector(
                onTap: () => setState(() => _paymentMethod = method),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.greenSoft : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? AppColors.green : AppColors.line),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.green : AppColors.muted,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(method, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                    ],
                  ),
                ),
              );
            }),

            if (_paymentMethod == 'UPI')
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: _upiCtrl,
                  decoration: InputDecoration(
                    labelText: 'UPI ID (Demo auto-filled)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

            if (_paymentMethod == 'Card')
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: _cardCtrl,
                  decoration: InputDecoration(
                    labelText: 'Card Number (Demo auto-filled)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Bill Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  _buildBillRow('Items Subtotal', '₹${store.subtotal}'),
                  const SizedBox(height: 8),
                  _buildBillRow('Delivery Fee', store.deliveryFee == 0 ? 'FREE' : '₹${store.deliveryFee}'),
                  const SizedBox(height: 8),
                  _buildBillRow(
                    'Coupon Discount',
                    store.discount > 0 ? '- ₹${store.discount}' : '—',
                    color: store.discount > 0 ? Colors.green : AppColors.muted,
                  ),
                  const SizedBox(height: 8),
                  _buildBillRow('Rural Charity Pledge', '₹20 (Included)', color: AppColors.muted),
                  const Divider(height: 20, color: AppColors.line),
                  _buildBillRow('To Pay', '₹${store.total}', isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Place Order Button
            ElevatedButton(
              onPressed: () {
                if (store.cart.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your basket is empty! Add products first.')),
                  );
                  return;
                }
                final order = store.placeOrder(_paymentMethod);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => AlertDialog(
                    title: const Row(
                      children: [
                        Text('🧺 '),
                        Text('Order Placed!'),
                      ],
                    ),
                    content: Text(
                      'Order ${order.id} is packing at the Thuraipakkam studio!\n\nDelivery scheduled: ${order.eta}',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx); // Close dialog
                          Navigator.pop(context); // Back from checkout
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        child: const Text('Track Order'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Place Order · ₹${store.total}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponChip(String code, String label, StoreProvider store) {
    final isActive = store.coupon == code;
    return GestureDetector(
      onTap: () {
        _couponCtrl.text = code;
        final res = store.applyCoupon(code);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.greenSoft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? AppColors.green : AppColors.line),
        ),
        child: Text(
          isActive ? '✓ $code' : '+ $label',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.greenDark : AppColors.muted,
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: color ?? AppColors.ink,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 13,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isBold ? AppColors.greenDark : (color ?? AppColors.ink),
          ),
        ),
      ],
    );
  }
}
