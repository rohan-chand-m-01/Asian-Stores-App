# Asian Stores Mobile App — Complete Demo Implementation

A mobile app conversion of [Asian Stores (asianstores.in)](https://asianstores.in/) built with a **White and Green color palette**, complete hardcoded demo interactivity where **every single button works**, provided in **both React Native (Expo SDK 58) and Flutter**, with APK generation support.

---

## 🎨 Color Palette & Visual Identity

The design replicates the Asian Stores branding with a clean, high-contrast, organic grocery aesthetic:

| Token | Hex Code | Preview | Purpose |
| :--- | :--- | :--- | :--- |
| **Forest Green (Primary)** | `#1F7A3A` | Green | Primary brand color, headers, CTAs, badges |
| **Deep Forest Green** | `#145C2A` | Dark Green | Cash price highlight, card titles, hero gradient |
| **Soft Mint** | `#E8F5EC` | Mint | Selected tabs, pill badges, subtle active backgrounds |
| **Cream White Background**| `#F7FBF8` | Warm White | Main screen background for warmth and soft contrast |
| **Pure White** | `#FFFFFF` | White | Product cards, dialogs, inputs, checkout summary |
| **Charcoal Ink** | `#102018` | Dark Slate | High legibility typography |
| **Border Line** | `#D7E5DB` | Sage Border | Card borders, dividers, inputs |
| **Harvest Amber / Danger**| `#C45C26` | Amber/Red | Savings badge ("You save ₹XX"), warnings |
| **Star Gold** | `#E8B923` | Gold | Rating stars |

---

## 🛒 Key User Flows & Complete Button Interactivity

### 1. Pre-Opening Basket Animation (`SplashScreen`)
- **Physics & Motion**: Animated wicker lid rotates open with cubic easing (`-55deg`), container bounces with elastic scale, and 4 farm-fresh grocery items (`🌾` rice, `🫒` cold-pressed oil, `🌶️` dry red chilly, `🥥` fresh coconut) float out smoothly.
- **Demo-Friendly Controls**: Includes a **Skip ›** button in the header and tap-to-skip so presenters never get delayed during pitches.

### 2. Authentication Screen (`AuthScreen`)
- **1-Tap Quick Demo Login**: Single click on **"⚡ 1-Tap Demo Login (Priya S.)"** logs in instantly with pre-configured demo credentials without requiring any keyboard typing.
- **Multiple Login Modes**:
  - Email/Password login (`demo@asianstores.in` / `asian123`)
  - Registration tab
  - OTP phone login (auto-filled demo code `4821`)
  - Continue as Guest
  - Continue with Google
  - Forgot password dialog

### 3. Home Screen (`HomeScreen`)
- **Charity Banner**: *"Shop Groceries, Spread Kindness — ₹200 from every live purchase goes to charity"* (tappable for full pledge details).
- **Navigation Header**: Menu, Notification bell, Wishlist heart counter, and Basket counter with active badges.
- **Search Bar**: Real-time filtering with instant result navigation.
- **Categories Carousel**: 10+ categories with actual CDN image assets matching the website (Rice, Spices, Oil, Dhal, Flours, Pickle, Fryums, Paste, Chocolates).
- **British Chocolates Promo**: Dedicated *"Craving Sweets? British Chocolates"* banner leading directly to the imported treats section.
- **Featured Collection**: 2-column product grid with instant **Add to Cart** and heart toggles.

### 4. Product Details & Dynamic Pricing (`ProductScreen`)
- **Cash Price vs MRP**: Displays struck-through MRP alongside bold green Cash Settlement Price and a computed savings badge.
- **Dynamic Pack Size Selector**: Chips for `100 gms`, `250 gms`, `500 gms`, `1 kg` (or `ml`/`kg`). Tapping any pack dynamically recalculates the cash price, MRP, savings, and button total in real time.
- **Quantity Stepper**: `+` and `-` controls with quantity validation.
- **Add to Cart & Buy Now**:
  - *"Add to Cart · ₹XXX"* adds the exact pack and quantity to store with feedback toast.
  - *"Buy Now"* adds the product and navigates straight into checkout.
- **Stock Notification**: Out-of-stock items (e.g. Cardamom, Maida) display *"Notify Me When in Stock"* which triggers in-app stock alerts.
- **Reviews & Ratings**: Real customer reviews list + interactive **Write Review** dialog (1–5 star rating and comment text) that instantly recalculates and updates the product's overall rating and review count.

### 5. Basket / Cart (`CartScreen`)
- Full itemized list showing product thumbnail, name, selected pack size, cash price per unit, stepper to increment/decrement, and trash button.
- Live bill summary: Items Subtotal, Delivery Fee (FREE above ₹499 or ₹40), Applied Coupon discount, Charity pledge note, and Total.
- Clear basket with confirmation safeguard.

### 6. Checkout & Order Placement (`CheckoutScreen`)
- **Delivery Addresses**: Pre-configured Chennai addresses (`Home`, `Office`) plus a working **"+ Add New Address"** form.
- **Delivery Zone Validation**: Perungudi (`600096`), Thuraipakkam (`600097`), and Karapakkam (`600097`) matching the real notice on asianstores.in.
- **1-Tap Promo Coupon Chips**:
  - `WELCOME` (10% off)
  - `ASIAN50` (Flat ₹50 off)
  - `CHARITY` (Extra ₹20 discount)
  - Clicking any chip automatically fills and applies the coupon with instant bill recalculation.
- **Payment Method Selector**: Cash on delivery, UPI (with demo UPI ID), and Card (with demo card number).
- **Order Placement**: Deducts and creates an official order `AS-XXXXX`, clears cart, and navigates to the tracking flow.

### 7. Interactive Order Tracking (`OrdersScreen`)
- **4-Stage Visual Status Timeline**: `Placed` ➔ `Packed` ➔ `Out for delivery` ➔ `Delivered`.
- **"Demo: Advance Tracking Status" Button**: Tapping this button during a presentation instantly moves the simulated order to the next step, letting you demonstrate real-time tracking progression live!
- **Reorder & Cancel**: Cancel active orders when placed, or 1-tap **"Reorder these items"** to re-add everything to the basket.

### 8. Account & Store Policies (`AccountScreen`)
- Profile editor (Name, Email, Phone).
- FAQs accordion matching website answers.
- About Us (i2 Agro Products Private Limited since 2002, Thuraipakkam studio).
- Contact options: Direct phone call (+91 8825604253), sales@asianstores.in email, WhatsApp link.
- Refund, Shipping, Privacy, and Terms policies.

---

## 🛠️ Codebase Structure

### 1. React Native (Expo SDK 58)
Located in root `c:\Users\ADMIN\Asian-Stores-App\`:
```
Asian-Stores-App/
├── App.tsx                     # Main navigation container & tab navigator
├── app.json                    # Expo config (package: com.asianstores.app)
├── eas.json                    # EAS Build config (APK preview profile)
├── package.json                # Dependencies & scripts
├── src/
│   ├── theme.ts                # White & Green palette, demoAuth
│   ├── data.ts                 # Product catalog, categories, seed data
│   ├── store.tsx               # StoreProvider state management
│   ├── ui.tsx                  # Buttons, ProductCard, Stars, Qty
│   ├── navigation.ts           # Navigation param lists
│   └── screens/
│       ├── SplashScreen.tsx    # Pre-opening basket animation
│       ├── AuthScreen.tsx      # Login, Register, 1-Tap Demo Login
│       ├── HomeScreen.tsx      # Home catalog, charity bar, categories
│       ├── ShopScreen.tsx      # Full catalog, category filter, sort
│       ├── ProductScreen.tsx   # Product details, packs, reviews
│       ├── CartScreen.tsx      # Basket, totals, checkout
│       ├── CheckoutScreen.tsx  # Addresses, coupons, payments
│       ├── OrdersScreen.tsx    # Order list & tracking timeline
│       ├── AccountScreen.tsx   # Profile, FAQs, policies, contact
│       └── ExtraScreens.tsx    # Search, filters, wishlist, chocolates
```

### 2. Flutter Codebase
Located in `c:\Users\ADMIN\Asian-Stores-App\flutter_asian_stores\`:
```
flutter_asian_stores/
├── pubspec.yaml                # Flutter project definition
└── lib/
    ├── main.dart               # Entry point with MultiProvider
    ├── theme/
    │   └── app_theme.dart      # Material 3 White & Green palette
    ├── models/
    │   └── models.dart         # Product, Pack, Review, Order, Address
    ├── data/
    │   └── mock_data.dart      # 20+ products, categories, coupons, FAQs
    ├── providers/
    │   └── store_provider.dart # ChangeNotifier state management
    ├── widgets/
    │   └── product_card.dart   # ProductCard widget with MRP/Cash price
    └── screens/
        ├── splash_screen.dart  # Opening basket animation
        ├── auth_screen.dart    # Login, register, 1-tap demo
        ├── home_screen.dart    # Hero, categories, charity ticker
        ├── shop_screen.dart    # Catalog, filters, sorting
        ├── product_screen.dart # Pack selector, quantity, reviews
        ├── cart_screen.dart    # Cart & bill summary
        ├── checkout_screen.dart# Address, coupons, payments
        ├── orders_screen.dart  # Orders list & 4-step tracking
        └── account_screen.dart # Profile, FAQs, contact, policies
```

---

## 📦 How to Build the `.apk` File

### Method A: EAS Build (Recommended for React Native / Expo)
EAS builds the standalone installable `.apk` in the cloud without requiring local Android SDK or Mac/Linux toolchains:

1. **Install EAS CLI**:
   ```bash
   npm install -g eas-cli
   ```
2. **Log In to your Expo account**:
   ```bash
   eas login
   ```
3. **Build the Standalone APK**:
   ```bash
   npx eas-cli build -p android --profile preview
   ```
   *Note: Because `eas.json` is configured with `"buildType": "apk"`, EAS generates a direct `.apk` download link instead of an `.aab` bundle.*

### Method B: Local Android APK Build (React Native)
If you prefer building locally using Android Studio / Gradle:
```bash
# Generate native Android project
npx expo prebuild --platform android

# Build release APK
cd android
./gradlew assembleRelease
# The APK is generated at: android/app/build/outputs/apk/release/app-release.apk
```

### Method C: Flutter APK Build
Inside the `flutter_asian_stores` directory:
```bash
cd flutter_asian_stores
flutter pub get
flutter build apk --release
# The APK is generated at: build/app/outputs/flutter-apk/app-release.apk
```
