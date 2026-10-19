import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class AccountScreen extends StatelessWidget {
  final VoidCallback onNavigateToOrders;

  const AccountScreen({super.key, required this.onNavigateToOrders});

  void _showEditProfile(BuildContext context, StoreProvider store) {
    final nameCtrl = TextEditingController(text: store.user?.name ?? '');
    final emailCtrl = TextEditingController(text: store.user?.email ?? '');
    final phoneCtrl = TextEditingController(text: store.user?.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              store.updateProfile(nameCtrl.text, emailCtrl.text, phoneCtrl.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showFaqs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
            const SizedBox(height: 14),
            ...mockFaqs.map((faq) => ExpansionTile(
                  title: Text(faq['q']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                      child: Text(faq['a']!, style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Asian Stores · Since 2002"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Asian Stores — i2 Agro Products Private Limited — supplies farm-fresh groceries and natural ingredients directly from rural harvests to Chennai homes.",
                style: TextStyle(height: 1.4, fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                "Studio Address:\nG-2 G-Floor, Saravana Flat, 259/54, Plot no: 74, Chandrasekaran Nagar, Okkiyam Thuraipakkam, Chennai-600097.",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              SizedBox(height: 12),
              Text(
                "Charity Pledge:\n₹200 from every live order is pledged to community development.",
                style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showPolicy(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body, style: const TextStyle(fontSize: 13, height: 1.4)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.green,
                  child: Text(
                    (store.user?.name.isNotEmpty == true ? store.user!.name[0] : 'G').toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.user?.name ?? 'Guest Shopper',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(store.user?.email ?? 'demo@asianstores.in', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      Text(store.user?.phone ?? '+91 8825604253', style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.green),
                  onPressed: () => _showEditProfile(context, store),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Menu Options
          _buildMenuTile(
            Icons.receipt_long_outlined,
            'My Orders (${store.orders.length})',
            onTap: onNavigateToOrders,
          ),
          _buildMenuTile(
            Icons.favorite_outline,
            'Wishlist (${store.wishlist.length})',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Wishlist has ${store.wishlist.length} saved products')),
              );
            },
          ),
          _buildMenuTile(
            Icons.location_on_outlined,
            'Saved Delivery Addresses (${store.addresses.length})',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Active delivery to: ${store.selectedAddress.area}')),
              );
            },
          ),
          _buildMenuTile(
            Icons.help_outline,
            'Frequently Asked Questions (FAQs)',
            onTap: () => _showFaqs(context),
          ),
          _buildMenuTile(
            Icons.info_outline,
            'About Asian Stores (i2 Agro Products)',
            onTap: () => _showAbout(context),
          ),
          _buildMenuTile(
            Icons.phone_in_talk_outlined,
            'Contact & Studio (+91 8825604253)',
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Contact Asian Stores'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📞 Phone: +91 8825604253'),
                      SizedBox(height: 8),
                      Text('✉️ Email: sales@asianstores.in'),
                      SizedBox(height: 8),
                      Text('💬 WhatsApp: +91 8825604253'),
                      SizedBox(height: 8),
                      Text('📍 Studio: Okkiyam Thuraipakkam, Chennai-600097'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                  ],
                ),
              );
            },
          ),
          _buildMenuTile(
            Icons.restore_page_outlined,
            'Refund Policy',
            onTap: () => _showPolicy(
              context,
              'Refund Policy',
              'Unopened grocery packets can be returned within 48 hours of doorstep delivery. Spices and cold-pressed oils are non-returnable once opened.',
            ),
          ),
          _buildMenuTile(
            Icons.local_shipping_outlined,
            'Shipping & Delivery Policy',
            onTap: () => _showPolicy(
              context,
              'Shipping Policy',
              'Free delivery on orders above ₹499 in Perungudi, Thuraipakkam and Karapakkam. ₹40 delivery fee for smaller orders. Standard dispatch is 24–48 hours.',
            ),
          ),
          _buildMenuTile(
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            onTap: () => _showPolicy(
              context,
              'Privacy Policy',
              'Demo privacy: no customer data leaves this demo app. Login credentials and demo purchases exist solely in client memory for presentation.',
            ),
          ),

          const SizedBox(height: 20),

          // Logout Button
          OutlinedButton.icon(
            onPressed: () {
              store.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out of demo session')),
              );
            },
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: const Text('Log Out', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.line),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              minimumSize: const Size.fromHeight(48),
            ),
          ),

          const SizedBox(height: 20),
          const Center(
            child: Text(
              '© 2026 Asian Stores · Mobile App Conversion Demo',
              style: TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.green, size: 22),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.ink)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.muted, size: 20),
        onTap: onTap,
      ),
    );
  }
}
