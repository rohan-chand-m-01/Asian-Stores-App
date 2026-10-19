export type Pack = { id: string; label: string; grams: number; price: number };

export type Review = {
  id: string;
  name: string;
  rating: number;
  date: string;
  text: string;
};

export type Product = {
  id: string;
  name: string;
  category: string;
  image: string;
  mrp: number;
  cashPrice: number;
  packs: Pack[];
  inStock: boolean;
  rating: number;
  reviewCount: number;
  description: string;
  reviews: Review[];
};

export type Address = {
  id: string;
  label: string;
  name: string;
  phone: string;
  line: string;
  area: string;
  pincode: string;
};

export type OrderStatus = 'Placed' | 'Packed' | 'Out for delivery' | 'Delivered' | 'Cancelled';

export type OrderItem = {
  productId: string;
  name: string;
  pack: string;
  qty: number;
  price: number;
  image: string;
};

export type Order = {
  id: string;
  placedAt: string;
  status: OrderStatus;
  items: OrderItem[];
  subtotal: number;
  delivery: number;
  discount: number;
  total: number;
  payment: string;
  address: Address;
  eta: string;
};

const img = (id: string) =>
  `https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_600/${id}`;

const reviews = (name: string, extra?: Review[]): Review[] => [
  {
    id: `${name}-1`,
    name: 'Lakshmi R.',
    rating: 5,
    date: '12 Oct 2026',
    text: 'Fresh stock, same quality we buy from Asian Stores in Chennai.',
  },
  {
    id: `${name}-2`,
    name: 'Arun K.',
    rating: 4,
    date: '03 Oct 2026',
    text: 'Packing was neat. Cash price on the app matched the bill.',
  },
  ...(extra ?? []),
];

function packsFromBase(cash: number, unit: 'gms' | 'ml' | 'kg', baseQty: number): Pack[] {
  if (unit === 'kg') {
    return [
      { id: '1kg', label: '1 kg', grams: 1000, price: cash },
      { id: '5kg', label: '5 kg', grams: 5000, price: Math.round(cash * 4.8) },
      { id: '10kg', label: '10 kg', grams: 10000, price: Math.round(cash * 9.2) },
    ];
  }
  if (unit === 'ml') {
    const per = cash / baseQty;
    return [
      { id: '100ml', label: '100 ml', grams: 100, price: Math.round(per * 100) },
      { id: '500ml', label: '500 ml', grams: 500, price: Math.round(per * 480) },
      { id: '1L', label: '1 L', grams: 1000, price: Math.round(per * 920) },
    ];
  }
  const per = cash / baseQty;
  return [
    { id: '100g', label: '100 gms', grams: 100, price: Math.round(per * 100) },
    { id: '250g', label: '250 gms', grams: 250, price: Math.round(per * 240) },
    { id: '500g', label: '500 gms', grams: 500, price: Math.round(per * 460) },
    { id: '1kg', label: '1 kg', grams: 1000, price: Math.round(per * 880) },
  ];
}

export const categories = [
  { id: 'all', name: 'All Categories', image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80' },
  { id: 'pickle', name: 'Pickle/Condiments', image: img('v1771220480/bquwepi3lolo9ijwngty.jpg') },
  { id: 'fryums', name: 'Fryums', image: img('v1771219196/ggsxvgyxiatcfmueg39w.jpg') },
  { id: 'rice', name: 'Rice', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/rice.jpg' },
  { id: 'others', name: 'Others', image: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80' },
  { id: 'spices', name: 'Spices', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/spices.webp' },
  { id: 'oil', name: 'Oil', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/oil.webp' },
  { id: 'premix', name: 'Instant Premix', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/premix.jpg' },
  { id: 'dhal', name: 'Dhal', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/dhal.webp' },
  { id: 'flours', name: 'Flours', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_800/allinoinegenie/stores/atta.jpg' },
  { id: 'paste', name: 'Ginger Garlic Paste', image: 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/paste.jpg' },
  { id: 'chocolate', name: 'British Chocolates', image: 'https://images.unsplash.com/photo-1548907040-4d9d1d5d2d3c?w=400&q=80' },
];

function p(
  id: string,
  name: string,
  category: string,
  image: string,
  cash: number,
  unit: 'gms' | 'ml' | 'kg',
  baseQty: number,
  inStock: boolean,
  rating: number,
  reviewCount: number,
  description: string,
): Product {
  const packList = packsFromBase(cash, unit, baseQty);
  const cashPrice = packList[0].price;
  return {
    id,
    name,
    category,
    image,
    mrp: Math.round(cashPrice * 1.18),
    cashPrice,
    packs: packList,
    inStock,
    rating,
    reviewCount,
    description,
    reviews: reviews(id),
  };
}

export const products: Product[] = [
  p('kundu', 'Kundu Dry Chilly', 'spices', img('v1771222679/iozpuzytnkx6a1osr9ol.jpg'), 45, 'gms', 100, true, 4.8, 5, 'Sun-dried kundu chilly with deep colour for everyday sambar and kuzhambu.'),
  p('long-chilly', 'Long Dry Chilly', 'spices', img('v1771222577/kqmgax6e8lcevp7oppqk.jpg'), 50, 'gms', 100, true, 4.6, 8, 'Long red chilly, mild heat, ideal for tempering and podis.'),
  p('cardamom', 'Cardamom', 'spices', img('v1771222453/bnj2aqpza5ybhsb48dmo.jpg'), 400, 'gms', 100, false, 4.9, 12, 'Green cardamom pods with strong aroma. Currently restocking from the farm lot.'),
  p('cinnamon', 'Cinnamon', 'spices', img('v1771222293/jdpqvhtsw5gacnjfk60l.jpg'), 70, 'gms', 100, true, 4.5, 6, 'True cinnamon quills for payasam, biryani and masala tea.'),
  p('cloves', 'Cloves', 'spices', img('v1771222101/qnwqtrbprtsirch1t4qm.jpg'), 120, 'gms', 100, true, 4.7, 4, 'Whole cloves, pungent and clean. Use sparingly in garam masala.'),
  p('idli-chilly', 'Idli Chilly Powder', 'spices', img('v1771221709/kkgfvu3nfuqxoml1z9dp.jpg'), 40, 'gms', 100, true, 4.8, 21, 'Gunpowder-style idli chilly with sesame. Mix with gingelly oil.'),
  p('chicken65', 'Chicken 65 Powder', 'premix', img('v1771221056/j8efmjzjydrf4qutgmr5.jpg'), 40, 'gms', 100, true, 4.4, 9, 'Ready masala for Chicken 65. Coat, rest 20 minutes, then fry.'),
  p('gg-paste', 'Ginger Garlic Paste', 'paste', img('v1771220719/tyqs0qn8qpmgpc75b9py.jpg'), 20, 'gms', 100, true, 4.6, 14, 'Fresh ground paste without extra starch. Refrigerate after opening.'),
  p('mango-pickle', 'Cut Mango Pickle', 'pickle', img('v1771220480/bquwepi3lolo9ijwngty.jpg'), 30, 'gms', 100, true, 4.9, 18, 'Traditional cut mango pickle in gingelly oil. Tangy and spicy.'),
  p('samba', 'Samba Wheat Brokens', 'flours', img('v1771220106/r8euxwlpt71kv618qqrr.jpg'), 25, 'gms', 250, true, 4.3, 3, 'Broken samba wheat for kanji and upma. High fibre breakfast grain.'),
  p('groundnut-oil', 'Groundnut Oil', 'oil', img('v1770872317/brw8oaoanlgqqiof76pc.jpg'), 22, 'ml', 100, true, 4.7, 11, 'Cold-pressed groundnut oil for frying and everyday cooking.'),
  p('coconut-oil', 'Coconut Oil', 'oil', img('v1770872169/hzpdyyagrgkcurd5ebbw.jpg'), 60, 'ml', 100, true, 5, 5, 'Pure coconut oil. Use for tadka, hair, and Kerala-style curries.'),
  p('atta', 'Wheat Atta Flour', 'flours', 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_800/allinoinegenie/stores/atta.jpg', 28, 'gms', 100, true, 4.5, 7, 'Chakki atta for soft rotis. Mill-fresh i2 Agro lot.'),
  p('chilly-pwd', 'Chilly Powder', 'spices', img('v1771218782/n3ttrbdoecc1j74pbmzy.jpg'), 20, 'gms', 100, true, 4.6, 16, 'Bright red chilly powder, medium heat, no added colour.'),
  p('cumin-pwd', 'Cumin Powder', 'spices', img('v1771319514/kzxetowwzlgqigk2yvsi.jpg'), 40, 'gms', 100, true, 4.4, 5, 'Roasted jeera powder, stone ground.'),
  p('turmeric', 'Turmeric Powder', 'spices', img('v1771218848/cys6swuj6lbjqbx4fcfb.jpg'), 25, 'gms', 100, true, 4.8, 22, 'High-curcumin turmeric from selected rhizomes.'),
  p('coriander', 'Coriander Powder', 'spices', img('v1771218864/pyscp1ymw7az8bznkicx.jpg'), 30, 'gms', 100, true, 4.5, 8, 'Fragrant dhania powder for gravies and marinades.'),
  p('pappad', 'Pappad / Appalam', 'fryums', img('v1771219196/ggsxvgyxiatcfmueg39w.jpg'), 50, 'gms', 100, true, 4.7, 13, 'Urad appalam. Fry or roast. Crisp in 8 seconds.'),
  p('ural', 'Ural Dhal', 'dhal', img('v1771564395/fyq8dtpif5vgcn72pvob.jpg'), 40, 'gms', 250, true, 4.6, 10, 'Split urad dhal for idli, dosa and vadai batter.'),
  p('idli-rice', 'Idli Rice', 'rice', img('v1771219731/chrgydkcruitugxduicf.jpg'), 55, 'kg', 1000, true, 4.8, 19, 'Parboiled idli rice. Soak 4 hours for fluffy idlis.'),
  p('toor', 'Toor Dhal', 'dhal', img('v1771218965/ovyw0mdkqpxshlkhqvbu.jpg'), 40, 'gms', 250, true, 4.7, 15, 'Fat toor dhal, cooks soft for sambar.'),
  p('pepper', 'Pepper Powder', 'spices', img('v1771218864/pyscp1ymw7az8bznkicx.jpg'), 40, 'gms', 100, true, 4.6, 6, 'Coarse black pepper powder from Tellicherry-grade pepper.'),
  p('rava', 'Rava', 'flours', img('v1771220106/r8euxwlpt71kv618qqrr.jpg'), 25, 'gms', 100, true, 4.4, 4, 'Bombay rava for upma, kesari and tiffin.'),
  p('moong', 'Moong Dhal', 'dhal', img('v1771564395/fyq8dtpif5vgcn72pvob.jpg'), 40, 'gms', 250, true, 4.5, 9, 'Split yellow moong, quick-cook for pongal and kootu.'),
  p('ponni-boiled', 'Boiled Ponni Rice', 'rice', img('v1771219731/chrgydkcruitugxduicf.jpg'), 70, 'kg', 1000, true, 5, 5, 'Boiled ponni, the everyday Chennai table rice.'),
  p('ponni-raw', 'Raw Ponni Rice', 'rice', img('v1771219731/chrgydkcruitugxduicf.jpg'), 80, 'kg', 1000, true, 4.6, 7, 'Raw ponni rice with separate grains for lunch meals.'),
  p('bengal', 'Bengal Gram Dhal', 'dhal', img('v1771218965/ovyw0mdkqpxshlkhqvbu.jpg'), 35, 'gms', 250, true, 4.5, 6, 'Chana dhal for sundal, chutney and sweets.'),
  p('basmati', 'Basmathi Rice', 'rice', 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_400/allinoinegenie/stores/rice.jpg', 100, 'kg', 1000, true, 4.9, 24, 'Premium aged basmati. New stock just landed.'),
  p('maida', 'Maida', 'flours', 'https://res.cloudinary.com/dqo1r1ftb/image/upload/f_auto,q_auto,w_800/allinoinegenie/stores/atta.jpg', 25, 'gms', 500, false, 4.2, 2, 'Refined wheat flour. Restocking this week.'),
  p('gingelly', 'Gingelly Oil', 'oil', img('v1770872169/hzpdyyagrgkcurd5ebbw.jpg'), 70, 'ml', 100, true, 4.8, 17, 'Cold-pressed sesame oil for Tamil cooking and oil baths.'),
  p('dairy-milk', 'British Dairy Milk Bar', 'chocolate', 'https://images.unsplash.com/photo-1511381939415-e44015466831?w=600&q=80', 180, 'gms', 100, true, 4.9, 31, 'Imported British chocolate bar. Promo aisle — Craving Sweets.'),
  p('digestive', 'McVitie Digestive', 'chocolate', 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=600&q=80', 220, 'gms', 250, true, 4.6, 12, 'British digestive biscuits. Pair with evening filter coffee.'),
];

export const deliveryZones = [
  { area: 'Perungudi', pincode: '600096' },
  { area: 'Thuraipakkam', pincode: '600097' },
  { area: 'Karapakkam', pincode: '600097' },
];

export const addresses: Address[] = [
  {
    id: 'home',
    label: 'Home',
    name: 'Priya S.',
    phone: '8825604253',
    line: 'G-2, Saravana Flat, 259/54, Plot 74, Chandrasekaran Nagar',
    area: 'Okkiyam Thuraipakkam',
    pincode: '600097',
  },
  {
    id: 'work',
    label: 'Office',
    name: 'Priya S.',
    phone: '8825604253',
    line: '2nd Floor, OMR, near Toll',
    area: 'Perungudi',
    pincode: '600096',
  },
];

export const coupons: Record<string, { label: string; off: number; type: 'flat' | 'percent' }> = {
  WELCOME: { label: 'Welcome 10% off', off: 10, type: 'percent' },
  ASIAN50: { label: 'Flat ₹50 off', off: 50, type: 'flat' },
  CHARITY: { label: 'Charity extra ₹20', off: 20, type: 'flat' },
};

export const faqs = [
  { q: 'Is this the live Asian Stores app?', a: 'This is a complete demo conversion of asianstores.in. Prices and stock are hardcoded so every button works in a client walkthrough.' },
  { q: 'Where do you deliver?', a: 'Demo delivery is limited to Perungudi (600096), Thuraipakkam (600097) and Karapakkam (600097), matching the website notice.' },
  { q: 'What is Cash Price?', a: 'Cash Price is the amount billed for prepaid / cash settlement. MRP is shown struck through. Pack size changes the cash price.' },
  { q: 'How long is delivery?', a: 'Orders are dispatched in 24–48 hours. Tracking updates are simulated in this demo.' },
];

export const policies = {
  refund:
    'Demo refund policy: unused packed groceries can be returned within 48 hours of delivery. Opened spices and oils are not returnable. Refunds credit to the original payment method in 3–5 working days.',
  shipping:
    'Demo shipping: free delivery above ₹499 within supported Chennai zones. Below that, a ₹40 delivery fee applies. Dispatch window is 24–48 hours.',
  privacy:
    'Demo privacy: no data leaves this device. Login, cart and orders live only in app memory for the walkthrough.',
  terms:
    'Demo terms: this build is for demonstration of a mobile conversion of Asian Stores. It does not place real orders or charge cards.',
};

export const aboutText = `Asian Stores — i2 Agro Products Private Limited — supplies premium groceries from rural harvests to Chennai homes. Quality since 2002. Trusted by 2,000+ families.

Address: G-2 G-Floor, Saravana Flat, 259/54, Plot no: 74, Chandrasekaran Nagar, Okkiyam Thuraipakkam, Chennai-600097.

₹200 from every live purchase on the website is pledged to charity. This app demo keeps that banner so the story matches asianstores.in.`;
