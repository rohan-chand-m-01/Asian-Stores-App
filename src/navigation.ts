export type RootStackParamList = {
  Splash: undefined;
  Auth: undefined;
  Main: { screen?: 'Home' | 'Shop' | 'Orders' | 'Account' } | undefined;
  Product: { id: string };
  Cart: undefined;
  Checkout: undefined;
  Success: { orderId: string };
  Track: { orderId: string };
  Search: { q?: string } | undefined;
  Filters: undefined;
  Wishlist: undefined;
  Notifications: undefined;
  About: undefined;
  Contact: undefined;
  Policy: { type: 'refund' | 'shipping' | 'privacy' | 'terms' };
  Chocolates: undefined;
  Menu: undefined;
  ShopCategory: { category: string };
  AddressForm: undefined;
  Review: { id: string };
  Faq: undefined;
  ProfileEdit: undefined;
};

export type TabParamList = {
  Home: undefined;
  Shop: undefined;
  Orders: undefined;
  Account: undefined;
};
