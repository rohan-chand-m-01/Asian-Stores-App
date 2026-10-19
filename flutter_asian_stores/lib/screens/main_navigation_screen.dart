import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'shop_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'account_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'all';

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategory = categoryId;
      _currentIndex = 1; // Switch to shop tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    final List<Widget> screens = [
      HomeScreen(
        onTabChange: _onTabTapped,
        onSelectCategory: _onCategorySelected,
      ),
      ShopScreen(
        initialCategory: _selectedCategory,
      ),
      CartScreen(
        onContinueShopping: () => _onTabTapped(1),
      ),
      const OrdersListScreen(),
      AccountScreen(
        onNavigateToOrders: () => _onTabTapped(3),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.green,
          unselectedItemColor: AppColors.muted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: store.cartCount > 0,
                label: Text('${store.cartCount}'),
                backgroundColor: AppColors.green,
                child: const Icon(Icons.shopping_basket_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: store.cartCount > 0,
                label: Text('${store.cartCount}'),
                backgroundColor: AppColors.green,
                child: const Icon(Icons.shopping_basket),
              ),
              label: 'Basket',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: store.orders.isNotEmpty,
                label: Text('${store.orders.length}'),
                backgroundColor: AppColors.greenDark,
                child: const Icon(Icons.receipt_long_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: store.orders.isNotEmpty,
                label: Text('${store.orders.length}'),
                backgroundColor: AppColors.greenDark,
                child: const Icon(Icons.receipt_long),
              ),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
