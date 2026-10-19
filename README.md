<div align="center">

# 🌿 Asian Stores Mobile App

### *Premium Quality Groceries — From Rural Harvests to Your Doorstep*

[![React Native](https://img.shields.io/badge/React_Native-0.88-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://reactnative.dev/)
[![Expo](https://img.shields.io/badge/Expo_SDK-58-000020?style=for-the-badge&logo=expo&logoColor=white)](https://expo.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-6.0-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Android APK](https://img.shields.io/badge/Build-Android_.APK_Ready-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://expo.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

<br/>

A high-polish, full-stack demo mobile application conversion of [**Asian Stores (asianstores.in)**](https://asianstores.in/) (i2 Agro Products Private Limited, Chennai · Est. 2002).

**Every single button, interaction, state transition, and user flow is 100% functional, responsive, and ready for live client presentations.**

Available in **both React Native (Expo SDK 58)** and **Flutter** with standalone **Android `.apk` build configurations**.

---

[Explore Features](#-key-features) •
[Color Palette](#-white--green-color-palette) •
[Dual Architecture](#-dual-architecture-react-native--flutter) •
[Building the APK](#-how-to-generate-the-android-apk) •
[Demo Credentials](#-demo-credentials--walkthrough-cheat-sheet) •
[Contributors](#-contributors)

</div>

---

## 🌟 Highlights & Client Demo Interactivity

This mobile experience converts every facet of the [Asian Stores web platform](https://asianstores.in/) into an authentic mobile app:

- 🧺 **Pre-Opening Wicker Basket Animation**: Physics-based opening animation where the basket lid rotates open with cubic easing, elastic container scaling, and 4 farm groceries (`🌾` aged rice, `🫒` cold-pressed oil, `🌶️` dry red chilly, `🥥` fresh coconut) float out smoothly before landing on authentication. Includes a **Skip ›** button for instant presentation access.
- ⚡ **1-Tap Instant Demo Login**: Built-in 1-tap demo chip that auto-authenticates as **Priya S.** without typing. Also supports manual email/password, OTP (`4821`), Guest Checkout, and Google sign-in.
- 🏷️ **Dynamic Cash Price vs. MRP System**: Real-time savings calculation comparing standard MRP against the discounted Cash Settlement Price.
- ⚖️ **Interactive Pack Size Switcher**: Instant switching between pack variants (`100 gms`, `250 gms`, `500 gms`, `1 kg`, or `100 ml`, `500 ml`, `1 L`). Recalculates cash price, savings badge, and total bill in real time.
- 🛒 **Complete Basket & Cart Management**: Quantity steppers (`+`/`-`), instant item removal, clear basket safety dialog, and live subtotal breakdown.
- 📍 **Chennai Delivery Zone Validation**: Real-time validation restricted to supported delivery pincodes: **Perungudi (`600096`)**, **Thuraipakkam (`600097`)**, and **Karapakkam (`600097`)**.
- 🎟️ **1-Tap Clickable Promo Coupons**: Tap `WELCOME` (10% off), `ASIAN50` (Flat ₹50 off), or `CHARITY` (Extra ₹20 off) for instant auto-fill and real-time discount calculation.
- 💳 **Multiple Settlement Modes**: Supports Cash on Delivery (COD), UPI (with validation), and Debit/Credit Card.
- 🚚 **4-Stage Interactive Order Tracker**: Live visual tracker (`Placed` ➔ `Packed` ➔ `Out for delivery` ➔ `Delivered`) equipped with a **"Demo: Advance Tracking Status"** button that advances the status live during presentations.
- ⭐ **Customer Reviews & Live Rating Engine**: View customer feedback and submit new reviews with interactive 1–5 star ratings that instantly recalculate and live-update product rating averages and review counts.
- 🤝 **Social Impact Integration**: Automatically highlights the real Asian Stores pledge: **₹200 from every live order is donated to rural community welfare**.

---

## 🎨 White & Green Color Palette

Designed specifically for organic agro-products and groceries with a refreshing, high-contrast, clean modern look:

| Token | Hex Value | Role in Application |
| :--- | :--- | :--- |
| **Forest Green (Primary)** | `#1F7A3A` | Primary headers, action buttons, active tab indicators, badges |
| **Deep Forest Green** | `#145C2A` | Hero banner gradient, bold cash price highlights |
| **Soft Mint** | `#E8F5EC` | Selected chips, demo login pill, quantity stepper background |
| **Cream White** | `#F7FBF8` | Warm organic app background (eliminates harsh digital glare) |
| **Pure White** | `#FFFFFF` | Surface cards, modals, input containers, bottom navigation |
| **Charcoal Ink** | `#102018` | Primary high-legibility typography |
| **Border Line** | `#D7E5DB` | Refined card borders, dividers, chip outlines |
| **Harvest Amber** | `#C45C26` | Savings badge (*"You save ₹XX on cash settlement"*), alerts |
| **Star Gold** | `#E8B923` | Rating stars & review highlights |

---

## 📱 Dual Architecture: React Native & Flutter

To ensure maximum versatility, the complete application is provided in **both industry-standard mobile frameworks**:

```
Asian-Stores-App/
├── App.tsx                          # React Native Root Navigator & Tabs
├── app.json                         # Expo configuration (com.asianstores.app)
├── eas.json                         # EAS Build configuration (Direct APK profile)
├── package.json                     # React Native dependencies
├── src/
│   ├── theme.ts                     # White & Green design tokens & seed auth
│   ├── data.ts                      # 20+ grocery products, categories, zones, FAQs
│   ├── store.tsx                    # React Context global state store
│   ├── ui.tsx                       # Reusable ProductCard, PrimaryButton, Qty, Stars
│   ├── navigation.ts                # TypeScript Stack & Tab param lists
│   └── screens/
│       ├── SplashScreen.tsx         # Pre-opening basket physics animation
│       ├── AuthScreen.tsx           # 1-Tap demo login, email, phone OTP, guest
│       ├── HomeScreen.tsx           # Charity bar, search, hero, categories, featured
│       ├── ShopScreen.tsx           # Full catalog, category chips, sort, in-stock
│       ├── ProductScreen.tsx        # Dynamic pack size selector, cash price, reviews
│       ├── CartScreen.tsx           # Basket itemized lines, quantity, totals
│       ├── CheckoutScreen.tsx       # Saved addresses, Chennai zones, coupon chips
│       ├── OrdersScreen.tsx         # Orders list, 4-step tracking timeline
│       ├── AccountScreen.tsx        # Profile edit, FAQs accordion, policies, contact
│       └── ExtraScreens.tsx         # Search, filters, wishlist, chocolates aisle
│
└── flutter_asian_stores/            # Complete Flutter Implementation
    ├── pubspec.yaml                 # Flutter package manifest & dependencies
    └── lib/
        ├── main.dart                # MultiProvider & Material 3 entry point
        ├── theme/app_theme.dart     # AppTheme & light color scheme
        ├── models/models.dart       # Product, Pack, Review, Order, Address models
        ├── data/mock_data.dart      # Catalog, categories, coupons, delivery zones
        ├── providers/store_provider.dart # ChangeNotifier global state engine
        ├── widgets/product_card.dart# Reusable ProductCard with cash pricing
        └── screens/
            ├── splash_screen.dart   # Animated wicker basket with floating items
            ├── auth_screen.dart     # 1-Tap demo, OTP, registration, guest
            ├── home_screen.dart     # Charity bar, hero, category browser
            ├── shop_screen.dart     # Filter chips, in-stock toggle, sorting
            ├── product_screen.dart  # Pack switcher, quantity stepper, write review
            ├── cart_screen.dart     # Basket list, line items, order summary
            ├── checkout_screen.dart # Addresses, clickable coupons, payments
            ├── orders_screen.dart   # Order cards, 4-step status stepper, reorder
            └── account_screen.dart  # Profile, FAQ expansion tiles, studio contact
```

---

## ⚡ Quick Start Guide

### 1. React Native (Expo SDK 58)

#### Prerequisites
- Node.js 18+ & npm

#### Run locally:
```bash
# 1. Clone the repository
git clone https://github.com/rohan-chand-m-01/Asian-Stores-App.git
cd Asian-Stores-App

# 2. Install dependencies
npm install

# 3. Typecheck
npx tsc --noEmit

# 4. Start Expo Dev Server (Web Preview)
npm run web
# Opens at http://localhost:8081 or http://localhost:8082 in mobile frame preview

# 5. Run on Mobile Device
npx expo start
# Scan the displayed QR code with the Expo Go app on iOS / Android
```

---

### 2. Flutter Application

#### Prerequisites
- Flutter SDK 3.x & Dart 3.x

#### Run locally:
```bash
cd flutter_asian_stores

# Fetch dependencies
flutter pub get

# Run on Chrome / Emulator / Physical device
flutter run
```

---

## 📦 How to Generate the Android `.apk`

### Option 1: EAS Cloud Build (Zero Native Setup Required)
[`eas.json`](eas.json) is already pre-configured with `"buildType": "apk"` under the `preview` profile:

```bash
# 1. Log in to EAS (free Expo account)
npx eas-cli login

# 2. Trigger the APK cloud build
npx eas-cli build -p android --profile preview
```
*EAS compiles the app in the cloud and provides a direct, installable `.apk` download link.*

---

### Option 2: Local React Native APK Build (Android Studio / Gradle)
```bash
# Generate native Android wrapper
npx expo prebuild --platform android

# Compile release APK
cd android
./gradlew assembleRelease
# The standalone APK will be created at:
# android/app/build/outputs/apk/release/app-release.apk
```

---

### Option 3: Flutter Release APK Build
```bash
cd flutter_asian_stores
flutter pub get
flutter build apk --release
# The standalone APK will be created at:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔑 Demo Credentials & Walkthrough Cheat Sheet

| Field | Demo Value | Notes |
| :--- | :--- | :--- |
| **⚡ 1-Tap Login** | Button on Auth Screen | One click enters as **Priya S.** without typing |
| **Demo Email** | `demo@asianstores.in` | Standard email login |
| **Demo Mobile** | `8825604253` | Mobile number matching studio support |
| **Demo Password** | `asian123` | Password for all test accounts |
| **Demo OTP** | `4821` | Auto-filled 4-digit verification code |
| **Coupon 1** | `WELCOME` | **10% off** your order |
| **Coupon 2** | `ASIAN50` | **Flat ₹50 off** |
| **Coupon 3** | `CHARITY` | **Extra ₹20 discount** |
| **Chennai Zones** | `600096`, `600097` | Perungudi, Thuraipakkam, Karapakkam |
| **Order Advance** | *"Demo: Advance Tracking Status"* | Advances timeline (`Placed` ➔ `Packed` ➔ `Out for delivery` ➔ `Delivered`) |

---

## 👥 Contributors

This project was engineered and maintained by:

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/rohan-chand-m-01">
        <img src="https://github.com/rohan-chand-m-01.png" width="100px;" alt="Rohan Chand M"/><br />
        <sub><b>Rohan Chand M</b></sub>
      </a><br />
      <sub>Lead Developer & Mobile Architect</sub>
    </td>
    <td align="center">
      <a href="https://github.com/rohan-chand-m-01/Asian-Stores-App">
        <img src="https://ui-avatars.com/api/?name=Venkatesh+Reddy+K&background=1F7A3A&color=fff&size=100" width="100px;" alt="Venkatesh Reddy K"/><br />
        <sub><b>Venkatesh Reddy K</b></sub>
      </a><br />
      <sub>Core Contributor & Product Co-Lead</sub>
    </td>
  </tr>
</table>

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) — see the LICENSE file for details.

---

<div align="center">
  <sub>Built with ❤️ for <b>Asian Stores</b> (i2 Agro Products Private Limited, Chennai).</sub>
</div>
