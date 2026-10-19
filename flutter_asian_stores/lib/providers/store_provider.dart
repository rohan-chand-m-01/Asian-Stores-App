import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class StoreProvider extends ChangeNotifier {
  User? _user;
  List<Product> _products = List.from(mockProducts);
  final List<String> _wishlist = ['basmati', 'coconut-oil'];
  final List<String> _notifyIds = [];
  final List<CartLine> _cart = [];
  final List<Address> _addresses = List.from(mockAddresses);
  String _selectedAddressId = 'home';
  String _coupon = '';
  final List<Order> _orders = [
    Order(
      id: 'AS-10255',
      placedAt: '19 Oct 2026, 11:20 AM',
      status: 'Packed',
      items: [
        OrderItem(
          productId: 'basmati',
          name: 'Basmathi Rice',
          pack: '1 kg',
          qty: 2,
          price: 100,
          image: mockProducts.firstWhere((p) => p.id == 'basmati').image,
        ),
      ],
      subtotal: 200,
      delivery: 0,
      discount: 0,
      total: 200,
      payment: 'UPI',
      address: mockAddresses[0],
      eta: 'Tomorrow, 6–8 PM',
    ),
    Order(
      id: 'AS-10241',
      placedAt: '18 Oct 2026, 4:05 PM',
      status: 'Out for delivery',
      items: [
        OrderItem(
          productId: 'coconut-oil',
          name: 'Coconut Oil',
          pack: '500 ml',
          qty: 1,
          price: 288,
          image: mockProducts.firstWhere((p) => p.id == 'coconut-oil').image,
        ),
      ],
      subtotal: 288,
      delivery: 40,
      discount: 50,
      total: 278,
      payment: 'Cash on delivery',
      address: mockAddresses[1],
      eta: 'Today, 6–8 PM',
    ),
  ];

  // Getters
  User? get user => _user;
  List<Product> get products => _products;
  List<String> get wishlist => _wishlist;
  List<String> get notifyIds => _notifyIds;
  List<CartLine> get cart => _cart;
  List<Address> get addresses => _addresses;
  String get selectedAddressId => _selectedAddressId;
  String get coupon => _coupon;
  List<Order> get orders => _orders;

  Address get selectedAddress {
    return _addresses.firstWhere(
      (a) => a.id == _selectedAddressId,
      orElse: () => _addresses.first,
    );
  }

  int get cartCount => _cart.fold(0, (sum, line) => sum + line.qty);

  int get subtotal => _cart.fold(0, (sum, line) => sum + (line.pack.price * line.qty));

  int get deliveryFee {
    if (subtotal == 0) return 0;
    return subtotal >= 499 ? 0 : 40;
  }

  int get discount {
    if (_coupon.isEmpty || !mockCoupons.containsKey(_coupon)) return 0;
    final info = mockCoupons[_coupon]!;
    if (info.isPercent) {
      return (subtotal * info.off / 100).round();
    }
    return info.off;
  }

  int get total {
    final t = subtotal + deliveryFee - discount;
    return t > 0 ? t : 0;
  }

  // Auth
  String? login(String emailOrPhone, String password) {
    if (password != 'asian123') return 'Demo password is asian123';
    _user = User(
      name: 'Priya S.',
      email: emailOrPhone.contains('@') ? emailOrPhone : 'demo@asianstores.in',
      phone: emailOrPhone.contains('@') ? '8825604253' : emailOrPhone,
    );
    notifyListeners();
    return null;
  }

  String? register(String name, String email, String phone, String password) {
    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      return 'Please fill in all fields';
    }
    _user = User(name: name, email: email, phone: phone);
    notifyListeners();
    return null;
  }

  void continueGuest() {
    _user = User(
      name: 'Guest Shopper',
      email: 'guest@asianstores.in',
      phone: '8825604253',
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateProfile(String name, String email, String phone) {
    if (_user != null) {
      _user = _user!.copyWith(name: name, email: email, phone: phone);
      notifyListeners();
    }
  }

  // Wishlist
  void toggleWish(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  // Notify Me
  void notifyMe(String productId) {
    if (!_notifyIds.contains(productId)) {
      _notifyIds.add(productId);
      notifyListeners();
    }
  }

  // Cart
  void addToCart(Product product, Pack pack, {int qty = 1}) {
    final key = '${product.id}-${pack.id}';
    final index = _cart.indexWhere((l) => l.key == key);
    if (index >= 0) {
      _cart[index].qty += qty;
    } else {
      _cart.add(CartLine(key: key, product: product, pack: pack, qty: qty));
    }
    notifyListeners();
  }

  void setQty(String key, int qty) {
    final index = _cart.indexWhere((l) => l.key == key);
    if (index >= 0) {
      if (qty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].qty = qty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String key) {
    _cart.removeWhere((l) => l.key == key);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Coupon
  String applyCoupon(String code) {
    final c = code.trim().toUpperCase();
    if (!mockCoupons.containsKey(c)) {
      return 'Invalid coupon. Try WELCOME, ASIAN50, or CHARITY';
    }
    _coupon = c;
    notifyListeners();
    return 'Applied ${mockCoupons[c]!.label}';
  }

  void removeCoupon() {
    _coupon = '';
    notifyListeners();
  }

  // Addresses
  void setSelectedAddressId(String id) {
    _selectedAddressId = id;
    notifyListeners();
  }

  void addAddress(Address address) {
    _addresses.add(address);
    _selectedAddressId = address.id;
    notifyListeners();
  }

  // Orders
  Order placeOrder(String payment) {
    final orderItems = _cart
        .map((l) => OrderItem(
              productId: l.product.id,
              name: l.product.name,
              pack: l.pack.label,
              qty: l.qty,
              price: l.pack.price,
              image: l.product.image,
            ))
        .toList();

    final order = Order(
      id: 'AS-${10260 + _orders.length}',
      placedAt: 'Today, Just now',
      status: 'Placed',
      items: orderItems,
      subtotal: subtotal,
      delivery: deliveryFee,
      discount: discount,
      total: total,
      payment: payment,
      address: selectedAddress,
      eta: 'Tomorrow, 6–8 PM',
    );

    _orders.insert(0, order);
    _cart.clear();
    _coupon = '';
    notifyListeners();
    return order;
  }

  void cancelOrder(String id) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index >= 0) {
      _orders[index].status = 'Cancelled';
      notifyListeners();
    }
  }

  void reorder(String id) {
    final order = _orders.firstWhere((o) => o.id == id);
    for (var it in order.items) {
      final p = _products.firstWhere((x) => x.id == it.productId, orElse: () => _products.first);
      final pk = p.packs.firstWhere((x) => x.label == it.pack, orElse: () => p.packs.first);
      addToCart(p, pk, qty: it.qty);
    }
  }

  void advanceOrder(String id) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index >= 0) {
      final current = _orders[index].status;
      if (current == 'Placed') {
        _orders[index].status = 'Packed';
      } else if (current == 'Packed') {
        _orders[index].status = 'Out for delivery';
      } else if (current == 'Out for delivery') {
        _orders[index].status = 'Delivered';
      }
      notifyListeners();
    }
  }

  // Reviews
  void addReview(String productId, String name, double rating, String text) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      final p = _products[index];
      final newReview = Review(
        id: 'r-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        rating: rating,
        date: 'Today',
        text: text,
      );
      final updatedReviews = [newReview, ...p.reviews];
      final newCount = p.reviewCount + 1;
      final newRating = double.parse(((p.rating * p.reviewCount + rating) / newCount).toStringAsFixed(1));
      _products[index] = p.copyWith(
        reviews: updatedReviews,
        rating: newRating,
        reviewCount: newCount,
      );
      notifyListeners();
    }
  }
}
