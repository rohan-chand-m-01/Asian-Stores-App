import React, { createContext, useContext, useMemo, useState } from 'react';
import {
  Address,
  Order,
  OrderItem,
  Pack,
  Product,
  Review,
  addresses as seedAddresses,
  coupons,
  products as catalog,
} from './data';

export type CartLine = {
  key: string;
  product: Product;
  pack: Pack;
  qty: number;
};

type User = { name: string; email: string; phone: string };

type Store = {
  user: User | null;
  login: (emailOrPhone: string, password: string) => string | null;
  register: (name: string, email: string, phone: string, password: string) => string | null;
  logout: () => void;
  continueGuest: () => void;
  updateProfile: (patch: Partial<User>) => void;
  products: Product[];
  addReview: (productId: string, review: Omit<Review, 'id'>) => void;
  notifyIds: string[];
  notifyMe: (productId: string) => void;
  wishlist: string[];
  toggleWish: (productId: string) => void;
  cart: CartLine[];
  addToCart: (product: Product, pack: Pack, qty?: number) => void;
  setQty: (key: string, qty: number) => void;
  removeFromCart: (key: string) => void;
  clearCart: () => void;
  coupon: string;
  applyCoupon: (code: string) => string;
  removeCoupon: () => void;
  totals: { subtotal: number; delivery: number; discount: number; charity: number; total: number; count: number };
  addresses: Address[];
  selectedAddressId: string;
  setSelectedAddressId: (id: string) => void;
  addAddress: (a: Address) => void;
  orders: Order[];
  placeOrder: (payment: string) => Order;
  cancelOrder: (id: string) => void;
  reorder: (id: string) => void;
  advanceOrder: (id: string) => void;
};

const Ctx = createContext<Store | null>(null);

const seedOrders: Order[] = [
  {
    id: 'AS-10255',
    placedAt: '19 Oct 2026, 11:20 AM',
    status: 'Packed',
    items: [
      {
        productId: 'basmati',
        name: 'Basmathi Rice',
        pack: '1 kg',
        qty: 2,
        price: 100,
        image: catalog.find((p) => p.id === 'basmati')!.image,
      },
    ],
    subtotal: 200,
    delivery: 0,
    discount: 0,
    total: 200,
    payment: 'UPI',
    address: seedAddresses[0],
    eta: 'Tomorrow, 6–8 PM',
  },
  {
    id: 'AS-10241',
    placedAt: '18 Oct 2026, 4:05 PM',
    status: 'Out for delivery',
    items: [
      {
        productId: 'coconut-oil',
        name: 'Coconut Oil',
        pack: '500 ml',
        qty: 1,
        price: 288,
        image: catalog.find((p) => p.id === 'coconut-oil')!.image,
      },
      {
        productId: 'mango-pickle',
        name: 'Cut Mango Pickle',
        pack: '250 gms',
        qty: 1,
        price: 72,
        image: catalog.find((p) => p.id === 'mango-pickle')!.image,
      },
    ],
    subtotal: 360,
    delivery: 40,
    discount: 50,
    total: 350,
    payment: 'Cash on delivery',
    address: seedAddresses[1],
    eta: 'Today, 6–8 PM',
  },
  {
    id: 'AS-10218',
    placedAt: '12 Oct 2026, 9:40 AM',
    status: 'Delivered',
    items: [
      {
        productId: 'ponni-boiled',
        name: 'Boiled Ponni Rice',
        pack: '5 kg',
        qty: 1,
        price: 336,
        image: catalog.find((p) => p.id === 'ponni-boiled')!.image,
      },
    ],
    subtotal: 336,
    delivery: 0,
    discount: 0,
    total: 336,
    payment: 'Card',
    address: seedAddresses[0],
    eta: 'Delivered 13 Oct',
  },
];

export function StoreProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [products, setProducts] = useState(catalog);
  const [notifyIds, setNotifyIds] = useState<string[]>([]);
  const [wishlist, setWishlist] = useState<string[]>(['basmati', 'gingelly']);
  const [cart, setCart] = useState<CartLine[]>([]);
  const [coupon, setCoupon] = useState('');
  const [addresses, setAddresses] = useState(seedAddresses);
  const [selectedAddressId, setSelectedAddressId] = useState(seedAddresses[0].id);
  const [orders, setOrders] = useState<Order[]>(seedOrders);

  const login = (emailOrPhone: string, password: string) => {
    const id = emailOrPhone.trim().toLowerCase();
    if (password !== 'asian123') return 'Demo password is asian123';
    if (id !== 'demo@asianstores.in' && id !== '8825604253' && !id.includes('@') && id.length < 10) {
      return 'Use demo@asianstores.in or 8825604253';
    }
    setUser({
      name: 'Priya S.',
      email: id.includes('@') ? emailOrPhone.trim() : 'demo@asianstores.in',
      phone: id.includes('@') ? '8825604253' : emailOrPhone.trim(),
    });
    return null;
  };

  const register = (name: string, email: string, phone: string, password: string) => {
    if (!name.trim() || !email.trim() || phone.trim().length < 10 || password.length < 4) {
      return 'Fill name, email, 10-digit phone and a password';
    }
    setUser({ name: name.trim(), email: email.trim(), phone: phone.trim() });
    return null;
  };

  const logout = () => setUser(null);
  const continueGuest = () =>
    setUser({ name: 'Guest Shopper', email: 'guest@asianstores.in', phone: '8825604253' });
  const updateProfile = (patch: Partial<User>) => setUser((u) => (u ? { ...u, ...patch } : u));

  const addReview = (productId: string, review: Omit<Review, 'id'>) => {
    setProducts((list) =>
      list.map((p) =>
        p.id === productId
          ? {
              ...p,
              reviews: [{ ...review, id: `r-${Date.now()}` }, ...p.reviews],
              reviewCount: p.reviewCount + 1,
              rating: Number(((p.rating * p.reviewCount + review.rating) / (p.reviewCount + 1)).toFixed(1)),
            }
          : p,
      ),
    );
  };

  const notifyMe = (productId: string) =>
    setNotifyIds((ids) => (ids.includes(productId) ? ids : [...ids, productId]));

  const toggleWish = (productId: string) =>
    setWishlist((ids) => (ids.includes(productId) ? ids.filter((i) => i !== productId) : [...ids, productId]));

  const addToCart = (product: Product, pack: Pack, qty = 1) => {
    if (!product.inStock) return;
    const key = `${product.id}-${pack.id}`;
    setCart((lines) => {
      const found = lines.find((l) => l.key === key);
      if (found) return lines.map((l) => (l.key === key ? { ...l, qty: l.qty + qty } : l));
      return [...lines, { key, product, pack, qty }];
    });
  };

  const setQty = (key: string, qty: number) => {
    setCart((lines) => (qty <= 0 ? lines.filter((l) => l.key !== key) : lines.map((l) => (l.key === key ? { ...l, qty } : l))));
  };
  const removeFromCart = (key: string) => setCart((lines) => lines.filter((l) => l.key !== key));
  const clearCart = () => setCart([]);

  const applyCoupon = (code: string) => {
    const c = code.trim().toUpperCase();
    if (!coupons[c]) return 'Try WELCOME, ASIAN50 or CHARITY';
    setCoupon(c);
    return `Applied ${coupons[c].label}`;
  };
  const removeCoupon = () => setCoupon('');

  const totals = useMemo(() => {
    const subtotal = cart.reduce((s, l) => s + l.pack.price * l.qty, 0);
    const count = cart.reduce((s, l) => s + l.qty, 0);
    const delivery = subtotal === 0 || subtotal >= 499 ? 0 : 40;
    let discount = 0;
    if (coupon && coupons[coupon]) {
      const c = coupons[coupon];
      discount = c.type === 'percent' ? Math.round((subtotal * c.off) / 100) : c.off;
    }
    const charity = subtotal > 0 ? 20 : 0;
    const total = Math.max(0, subtotal + delivery - discount);
    return { subtotal, delivery, discount, charity, total, count };
  }, [cart, coupon]);

  const addAddress = (a: Address) => setAddresses((list) => [...list, a]);

  const placeOrder = (payment: string) => {
    const address = addresses.find((a) => a.id === selectedAddressId) ?? addresses[0];
    const items: OrderItem[] = cart.map((l) => ({
      productId: l.product.id,
      name: l.product.name,
      pack: l.pack.label,
      qty: l.qty,
      price: l.pack.price,
      image: l.product.image,
    }));
    const order: Order = {
      id: `AS-${10260 + orders.length}`,
      placedAt: new Date().toLocaleString('en-IN', { day: '2-digit', month: 'short', year: 'numeric', hour: 'numeric', minute: '2-digit' }),
      status: 'Placed',
      items,
      subtotal: totals.subtotal,
      delivery: totals.delivery,
      discount: totals.discount,
      total: totals.total,
      payment,
      address,
      eta: 'Tomorrow, 6–8 PM',
    };
    setOrders((list) => [order, ...list]);
    setCart([]);
    setCoupon('');
    return order;
  };

  const cancelOrder = (id: string) =>
    setOrders((list) => list.map((o) => (o.id === id && o.status === 'Placed' ? { ...o, status: 'Cancelled' } : o)));

  const reorder = (id: string) => {
    const order = orders.find((o) => o.id === id);
    if (!order) return;
    order.items.forEach((item) => {
      const product = products.find((p) => p.id === item.productId);
      const pack = product?.packs.find((pk) => pk.label === item.pack) ?? product?.packs[0];
      if (product && pack) addToCart(product, pack, item.qty);
    });
  };

  const advanceOrder = (id: string) => {
    const flow: Order['status'][] = ['Placed', 'Packed', 'Out for delivery', 'Delivered'];
    setOrders((list) =>
      list.map((o) => {
        if (o.id !== id) return o;
        const i = flow.indexOf(o.status);
        if (i < 0 || i >= flow.length - 1) return o;
        return { ...o, status: flow[i + 1], eta: flow[i + 1] === 'Delivered' ? 'Delivered just now' : o.eta };
      }),
    );
  };

  const value: Store = {
    user,
    login,
    register,
    logout,
    continueGuest,
    updateProfile,
    products,
    addReview,
    notifyIds,
    notifyMe,
    wishlist,
    toggleWish,
    cart,
    addToCart,
    setQty,
    removeFromCart,
    clearCart,
    coupon,
    applyCoupon,
    removeCoupon,
    totals,
    addresses,
    selectedAddressId,
    setSelectedAddressId,
    addAddress,
    orders,
    placeOrder,
    cancelOrder,
    reorder,
    advanceOrder,
  };

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useStore() {
  const ctx = useContext(Ctx);
  if (!ctx) throw new Error('Store missing');
  return ctx;
}
