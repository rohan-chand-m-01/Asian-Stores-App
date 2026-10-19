class Pack {
  final String id;
  final String label;
  final int grams;
  final int price;

  Pack({
    required this.id,
    required this.label,
    required this.grams,
    required this.price,
  });
}

class Review {
  final String id;
  final String name;
  final double rating;
  final String date;
  final String text;

  Review({
    required this.id,
    required this.name,
    required this.rating,
    required this.date,
    required this.text,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final String image;
  final int mrp;
  final int cashPrice;
  final List<Pack> packs;
  final bool inStock;
  final double rating;
  final int reviewCount;
  final String description;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.mrp,
    required this.cashPrice,
    required this.packs,
    required this.inStock,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.reviews,
  });

  Product copyWith({
    List<Review>? reviews,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id,
      name: name,
      category: category,
      image: image,
      mrp: mrp,
      cashPrice: cashPrice,
      packs: packs,
      inStock: inStock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description,
      reviews: reviews ?? this.reviews,
    );
  }
}

class Address {
  final String id;
  final String label;
  final String name;
  final String phone;
  final String line;
  final String area;
  final String pincode;

  Address({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.line,
    required this.area,
    required this.pincode,
  });
}

class OrderItem {
  final String productId;
  final String name;
  final String pack;
  final int qty;
  final int price;
  final String image;

  OrderItem({
    required this.productId,
    required this.name,
    required this.pack,
    required this.qty,
    required this.price,
    required this.image,
  });
}

class Order {
  final String id;
  final String placedAt;
  String status;
  final List<OrderItem> items;
  final int subtotal;
  final int delivery;
  final int discount;
  final int total;
  final String payment;
  final Address address;
  final String eta;

  Order({
    required this.id,
    required this.placedAt,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.delivery,
    required this.discount,
    required this.total,
    required this.payment,
    required this.address,
    required this.eta,
  });
}

class User {
  final String name;
  final String email;
  final String phone;

  User({
    required this.name,
    required this.email,
    required this.phone,
  });

  User copyWith({String? name, String? email, String? phone}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

class CartLine {
  final String key;
  final Product product;
  final Pack pack;
  int qty;

  CartLine({
    required this.key,
    required this.product,
    required this.pack,
    required this.qty,
  });
}

class CategoryItem {
  final String id;
  final String name;
  final String image;

  CategoryItem({
    required this.id,
    required this.name,
    required this.image,
  });
}
