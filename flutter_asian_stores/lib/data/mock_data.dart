import '../models/models.dart';

String img(String id) => 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_600/$id';

List<Pack> packsFromBase(int cash, String unit, int baseQty) {
  if (unit == 'kg') {
    return [
      Pack(id: '1kg', label: '1 kg', grams: 1000, price: cash),
      Pack(id: '5kg', label: '5 kg', grams: 5000, price: (cash * 4.8).round()),
      Pack(id: '10kg', label: '10 kg', grams: 10000, price: (cash * 9.2).round()),
    ];
  }
  if (unit == 'ml') {
    double per = cash / baseQty;
    return [
      Pack(id: '100ml', label: '100 ml', grams: 100, price: (per * 100).round()),
      Pack(id: '500ml', label: '500 ml', grams: 500, price: (per * 480).round()),
      Pack(id: '1L', label: '1 L', grams: 1000, price: (per * 920).round()),
    ];
  }
  double per = cash / baseQty;
  return [
    Pack(id: '100g', label: '100 gms', grams: 100, price: (per * 100).round()),
    Pack(id: '250g', label: '250 gms', grams: 250, price: (per * 240).round()),
    Pack(id: '500g', label: '500 gms', grams: 500, price: (per * 460).round()),
    Pack(id: '1kg', label: '1 kg', grams: 1000, price: (per * 880).round()),
  ];
}

Product buildProduct({
  required String id,
  required String name,
  required String category,
  required String image,
  required int cash,
  required String unit,
  required int baseQty,
  required bool inStock,
  required double rating,
  required int reviewCount,
  required String description,
}) {
  final packs = packsFromBase(cash, unit, baseQty);
  final cashPrice = packs.first.price;
  final mrp = (cashPrice * 1.18).round();

  return Product(
    id: id,
    name: name,
    category: category,
    image: image,
    mrp: mrp,
    cashPrice: cashPrice,
    packs: packs,
    inStock: inStock,
    rating: rating,
    reviewCount: reviewCount,
    description: description,
    reviews: [
      Review(
        id: '$id-1',
        name: 'Lakshmi R.',
        rating: 5,
        date: '12 Oct 2026',
        text: 'Fresh stock, same authentic quality we buy from Asian Stores in Chennai.',
      ),
      Review(
        id: '$id-2',
        name: 'Arun K.',
        rating: 4,
        date: '03 Oct 2026',
        text: 'Packing was neat. Cash price on the app matched the final bill.',
      ),
    ],
  );
}

final List<CategoryItem> mockCategories = [
  CategoryItem(id: 'all', name: 'All Categories', image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80'),
  CategoryItem(id: 'pickle', name: 'Pickle/Condiments', image: img('v1771220480/bquwepi3lolo9ijwngty.jpg')),
  CategoryItem(id: 'fryums', name: 'Fryums', image: img('v1771219196/ggsxvgyxiatcfmueg39w.jpg')),
  CategoryItem(id: 'rice', name: 'Rice', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/rice.jpg'),
  CategoryItem(id: 'spices', name: 'Spices', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/spices.webp'),
  CategoryItem(id: 'oil', name: 'Oil', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/oil.webp'),
  CategoryItem(id: 'premix', name: 'Instant Premix', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/premix.jpg'),
  CategoryItem(id: 'dhal', name: 'Dhal', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/dhal.webp'),
  CategoryItem(id: 'flours', name: 'Flours', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_800/allinoinegenie/stores/atta.jpg'),
  CategoryItem(id: 'paste', name: 'Ginger Garlic Paste', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/paste.jpg'),
  CategoryItem(id: 'chocolate', name: 'British Chocolates', image: 'https://images.unsplash.com/photo-1548907040-4d9d1d5d2d3c?w=400&q=80'),
];

final List<Product> mockProducts = [
  buildProduct(
    id: 'kundu',
    name: 'Kundu Dry Chilly',
    category: 'spices',
    image: img('v1771222679/iozpuzytnkx6a1osr9ol.jpg'),
    cash: 45,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.8,
    reviewCount: 5,
    description: 'Sun-dried kundu chilly with deep colour for everyday sambar and kuzhambu.',
  ),
  buildProduct(
    id: 'long-chilly',
    name: 'Long Dry Chilly',
    category: 'spices',
    image: img('v1771222577/kqmgax6e8lcevp7oppqk.jpg'),
    cash: 50,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.6,
    reviewCount: 8,
    description: 'Long red chilly, mild heat, ideal for tempering and podis.',
  ),
  buildProduct(
    id: 'cardamom',
    name: 'Cardamom',
    category: 'spices',
    image: img('v1771222453/bnj2aqpza5ybhsb48dmo.jpg'),
    cash: 400,
    unit: 'gms',
    baseQty: 100,
    inStock: false,
    rating: 4.9,
    reviewCount: 12,
    description: 'Green cardamom pods with strong aroma. Currently restocking from the farm lot.',
  ),
  buildProduct(
    id: 'cinnamon',
    name: 'Cinnamon',
    category: 'spices',
    image: img('v1771222293/jdpqvhtsw5gacnjfk60l.jpg'),
    cash: 70,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.5,
    reviewCount: 6,
    description: 'True cinnamon quills for payasam, biryani and masala tea.',
  ),
  buildProduct(
    id: 'cloves',
    name: 'Cloves',
    category: 'spices',
    image: img('v1771222101/qnwqtrbprtsirch1t4qm.jpg'),
    cash: 120,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.7,
    reviewCount: 4,
    description: 'Whole cloves, pungent and clean. Use sparingly in garam masala.',
  ),
  buildProduct(
    id: 'idli-chilly',
    name: 'Idli Chilly Powder',
    category: 'spices',
    image: img('v1771221709/kkgfvu3nfuqxoml1z9dp.jpg'),
    cash: 40,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.8,
    reviewCount: 21,
    description: 'Gunpowder-style idli chilly with sesame. Mix with gingelly oil.',
  ),
  buildProduct(
    id: 'chicken65',
    name: 'Chicken 65 Powder',
    category: 'premix',
    image: img('v1771221056/j8efmjzjydrf4qutgmr5.jpg'),
    cash: 40,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.4,
    reviewCount: 9,
    description: 'Ready masala for Chicken 65. Coat, rest 20 minutes, then fry.',
  ),
  buildProduct(
    id: 'gg-paste',
    name: 'Ginger Garlic Paste',
    category: 'paste',
    image: img('v1771220719/tyqs0qn8qpmgpc75b9py.jpg'),
    cash: 20,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.6,
    reviewCount: 14,
    description: 'Fresh ground paste without extra starch. Refrigerate after opening.',
  ),
  buildProduct(
    id: 'mango-pickle',
    name: 'Cut Mango Pickle',
    category: 'pickle',
    image: img('v1771220480/bquwepi3lolo9ijwngty.jpg'),
    cash: 30,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.9,
    reviewCount: 18,
    description: 'Traditional cut mango pickle in gingelly oil. Tangy and spicy.',
  ),
  buildProduct(
    id: 'groundnut-oil',
    name: 'Groundnut Oil',
    category: 'oil',
    image: img('v1770872317/brw8oaoanlgqqiof76pc.jpg'),
    cash: 22,
    unit: 'ml',
    baseQty: 100,
    inStock: true,
    rating: 4.7,
    reviewCount: 11,
    description: 'Cold-pressed groundnut oil for frying and everyday cooking.',
  ),
  buildProduct(
    id: 'coconut-oil',
    name: 'Coconut Oil',
    category: 'oil',
    image: img('v1770872169/hzpdyyagrgkcurd5ebbw.jpg'),
    cash: 60,
    unit: 'ml',
    baseQty: 100,
    inStock: true,
    rating: 5.0,
    reviewCount: 5,
    description: 'Pure coconut oil. Use for tadka, hair, and Kerala-style curries.',
  ),
  buildProduct(
    id: 'atta',
    name: 'Wheat Atta Flour',
    category: 'flours',
    image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_800/allinoinegenie/stores/atta.jpg',
    cash: 28,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.5,
    reviewCount: 7,
    description: 'Chakki atta for soft rotis. Mill-fresh i2 Agro lot.',
  ),
  buildProduct(
    id: 'basmati',
    name: 'Basmathi Rice',
    category: 'rice',
    image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/rice.jpg',
    cash: 100,
    unit: 'kg',
    baseQty: 1000,
    inStock: true,
    rating: 4.9,
    reviewCount: 24,
    description: 'Premium aged basmati. New stock just landed.',
  ),
  buildProduct(
    id: 'dairy-milk',
    name: 'British Dairy Milk Bar',
    category: 'chocolate',
    image: 'https://images.unsplash.com/photo-1511381939415-e44015466831?w=600&q=80',
    cash: 180,
    unit: 'gms',
    baseQty: 100,
    inStock: true,
    rating: 4.9,
    reviewCount: 31,
    description: 'Imported British chocolate bar. Promo aisle — Craving Sweets.',
  ),
];

final List<Address> mockAddresses = [
  Address(
    id: 'home',
    label: 'Home',
    name: 'Priya S.',
    phone: '8825604253',
    line: 'G-2, Saravana Flat, 259/54, Plot 74, Chandrasekaran Nagar',
    area: 'Okkiyam Thuraipakkam',
    pincode: '600097',
  ),
  Address(
    id: 'work',
    label: 'Office',
    name: 'Priya S.',
    phone: '8825604253',
    line: '2nd Floor, OMR, near Toll',
    area: 'Perungudi',
    pincode: '600096',
  ),
];

class CouponInfo {
  final String label;
  final int off;
  final bool isPercent;

  CouponInfo({required this.label, required this.off, required this.isPercent});
}

final Map<String, CouponInfo> mockCoupons = {
  'WELCOME': CouponInfo(label: 'Welcome 10% off', off: 10, isPercent: true),
  'ASIAN50': CouponInfo(label: 'Flat ₹50 off', off: 50, isPercent: false),
  'CHARITY': CouponInfo(label: 'Charity extra ₹20 off', off: 20, isPercent: false),
};

final List<Map<String, String>> mockFaqs = [
  {
    'q': 'Is this the live Asian Stores app?',
    'a': 'This is a complete demo conversion of asianstores.in. Prices and stock are hardcoded so every button works cleanly in client walkthroughs.'
  },
  {
    'q': 'Where do you deliver?',
    'a': 'Demo delivery is available to Perungudi (600096), Thuraipakkam (600097) and Karapakkam (600097), matching the website notice.'
  },
  {
    'q': 'What is Cash Price?',
    'a': 'Cash Price is the discounted amount billed for direct prepaid/cash settlement. MRP is shown struck through.'
  },
  {
    'q': 'How long does delivery take?',
    'a': 'Orders are dispatched in 24–48 hours from the Thuraipakkam grocery studio.'
  },
];
