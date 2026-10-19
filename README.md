<div align="center">

# Asian Stores Mobile Application

### Enterprise-Grade Mobile Client for Asian Stores (asianstores.in)

[![React Native](https://img.shields.io/badge/React_Native-0.88.0-20232A?style=flat-square&logo=react&logoColor=61DAFB)](https://reactnative.dev/)
[![Expo](https://img.shields.io/badge/Expo_SDK-58.0-000020?style=flat-square&logo=expo&logoColor=white)](https://expo.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-6.0-3178C6?style=flat-square&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Android APK](https://img.shields.io/badge/Artifact-Android_.APK_Ready-1F7A3A?style=flat-square&logo=android&logoColor=white)](https://expo.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-gray?style=flat-square)](LICENSE)

<br />

An enterprise-ready, cross-platform mobile client engineered to replicate and elevate the e-commerce infrastructure of [**Asian Stores**](https://asianstores.in/) (i2 Agro Products Private Limited, Chennai, Est. 2002).

Every button, navigation pathway, state machine transition, and transaction calculation is fully functional, deterministic, and optimized for high-fidelity client evaluations.

**Delivered simultaneously in React Native (Expo SDK 58) and Flutter (Material 3).**

---

[System Capabilities](#system-capabilities) &bull;
[Design System & Tokens](#design-system--color-tokens) &bull;
[Technical Architecture](#technical-architecture) &bull;
[Build & Deployment](#build--deployment-procedures) &bull;
[Demo Credentials](#demo-credentials--evaluation-reference) &bull;
[Contributors](#contributors)

</div>

---

## Executive Overview

Asian Stores serves thousands of households across Chennai with farm-fresh grains, cold-pressed oils, handpicked spices, and traditional provisions. This project provides a full-featured native mobile client that mirrors the live web store's operations while introducing mobile-native patterns:

- **Physics-Driven Basket Opening Simulation**: Multi-stage opening lid animation with cubic easing, container scaling, and floating provisions before transitioning to session initialization. Includes an instant bypass control for rapid testing.
- **One-Tap Automated Authentication**: Instant evaluation authentication as Priya S. without manual input, alongside standard credential verification, SMS/OTP simulation (Code: `4821`), Guest Checkout, and Google Identity simulation.
- **Dynamic Settlement Pricing Engine**: Real-time cash settlement pricing contrasted against struck-through MRP, displaying absolute rupee savings across variable package dimensions.
- **Unit and Pack Dimension Selector**: Live pack-size scaling (`100 gms`, `250 gms`, `500 gms`, `1 kg`, `100 ml`, `500 ml`, `1 L`) with instantaneous unit-cost recalculation and subtotal scaling.
- **Cart State Machine**: Complete cart synchronization supporting quantity stepping, individual item clearance, batch cart purge, and live threshold-based delivery fee computation.
- **Geographic Zone Verification**: Strict postal code verification reflecting Asian Stores' active logistics routing in Chennai: Perungudi (`600096`), Thuraipakkam (`600097`), and Karapakkam (`600097`).
- **Interactive Discount Vouchers**: One-tap discount voucher chips (`WELCOME` for 10% percentage discount, `ASIAN50` for flat ₹50 rebate, `CHARITY` for ₹20 concession) with instant mathematical deduction.
- **Multi-Rail Payment Gateway Simulation**: Functional payment options for Cash on Delivery (COD), UPI validation, and 16-digit card tokenization.
- **Deterministic 4-Phase Logistics Tracking**: Complete fulfillment progression (`Placed` to `Packed` to `Out for Delivery` to `Delivered`) featuring a dedicated **Advance Tracking Status** controller for live demonstration of state transitions.
- **Review & Rating Aggregator**: Customer feedback module with interactive 5-star scoring and text submissions that recalculate aggregate star ratings and review counts dynamically.
- **Social Impact Accounting**: Direct integration of the store's charitable pledge, noting ₹200 allocated toward rural development initiatives for every order placed.

---

## Design System & Color Tokens

The visual identity is anchored on an organic, high-contrast palette calibrated specifically for agro-products, delivering clear typographic hierarchy and optimal readability.

| Token Identifier | Hex Value | Primary Application |
| :--- | :--- | :--- |
| `AppColors.green` | `#1F7A3A` | Primary brand identifier, primary action buttons, active tab indicators, headers |
| `AppColors.greenDark` | `#145C2A` | Hero banner gradient, bold settlement price emphasis, high-contrast text |
| `AppColors.greenSoft` | `#E8F5EC` | Selected chips, demo login pill, quantity stepper surfaces, card accents |
| `AppColors.cream` | `#F7FBF8` | Primary scaffold background, preventing harsh digital glare |
| `AppColors.white` | `#FFFFFF` | Surface elevation cards, dialogs, form input fields, bottom navigation |
| `AppColors.ink` | `#102018` | Primary high-density typographic elements |
| `AppColors.muted` | `#5B6B62` | Secondary labels, struck-through MRP references, metadata timestamps |
| `AppColors.line` | `#D7E5DB` | Subtle structural borders, input outlines, list dividers |
| `AppColors.danger` | `#C45C26` | Savings highlight badges (*"You save ₹XX on cash settlement"*), alert notices |
| `AppColors.gold` | `#E8B923` | Star ratings and review scoring |

---

## Technical Architecture

The application is structured into two autonomous, production-grade implementations sharing identical business logic, data models, and user experience flows.

### 1. React Native Specification
- **Runtime Environment**: React Native 0.88.0 on Expo SDK 58.0
- **Type Safety**: TypeScript 6.0 with strict compile-time checks (`noEmit` verification: 0 errors)
- **Navigation System**: React Navigation 7.x (Native Stack Navigator combined with Bottom Tab Navigator)
- **State Management**: Centralized React Context Provider with custom hooks (`StoreProvider`, `useStore`)
- **Responsive Layout**: Platform-aware container (`ScreenWrap`) supporting native Android/iOS viewports and constrained web preview framing
- **Packaging Target**: Standalone Android `.apk` supported natively via EAS Build and local Gradle assemble

```
Asian-Stores-App/
├── App.tsx                          # Root Stack & Tab Navigation Orchestrator
├── app.json                         # Native Configuration (Package: com.asianstores.app)
├── eas.json                         # Cloud Build Profile (buildType: apk)
├── package.json                     # Node Modules & Dependency Declarations
├── src/
│   ├── theme.ts                     # Design Tokens & Demo Authentication Seed
│   ├── data.ts                      # 20+ Product Catalog, Delivery Zones, Policies
│   ├── store.tsx                    # Store Context, Reducers & Global State Actions
│   ├── ui.tsx                       # Atoms & Molecules (ProductCard, Buttons, Qty)
│   ├── navigation.ts                # Strict Navigation Route Param Definitions
│   └── screens/
│       ├── SplashScreen.tsx         # Physics-Based Basket Lid & Provisions Animation
│       ├── AuthScreen.tsx           # Automated Demo Login, Password, OTP, Guest
│       ├── HomeScreen.tsx           # Charity Bar, Search, Hero, Categories, Featured
│       ├── ShopScreen.tsx           # Filter Chips, In-Stock Filters, Sorting Engine
│       ├── ProductScreen.tsx        # Unit Dimension Selector, Pricing, Review Engine
│       ├── CartScreen.tsx           # Line Items, Quantity Controls, Subtotal Engine
│       ├── CheckoutScreen.tsx       # Address Engine, Coupon Verification, Payments
│       ├── OrdersScreen.tsx         # 4-Stage Status Tracker, Simulated Progression
│       ├── AccountScreen.tsx        # Profile Editor, FAQ Accordion, Store Policies
│       └── ExtraScreens.tsx         # Search, Filters, Wishlist, British Chocolates
```

### 2. Flutter Specification
- **Runtime Environment**: Flutter 3.x / Dart 3.x
- **UI Framework**: Material Design 3 (`AppTheme.lightTheme`)
- **State Management**: Provider Architecture (`ChangeNotifierProvider`, `StoreProvider`)
- **Architecture Pattern**: Clean Architecture with dedicated separation of Models, Data Providers, Widgets, and Screens
- **Packaging Target**: Standalone Android Release APK (`flutter build apk --release`)

```
flutter_asian_stores/
├── pubspec.yaml                     # Flutter Package Manifest & Asset Registry
└── lib/
    ├── main.dart                    # Application Root with MultiProvider
    ├── theme/
    │   └── app_theme.dart           # Design Tokens, Color Scheme & Widget Themes
    ├── models/
    │   └── models.dart              # Product, Pack, Review, Order, Address Models
    ├── data/
    │   └── mock_data.dart           # Deterministic Product & Store Datasets
    ├── providers/
    │   └── store_provider.dart      # Business Logic & Global State Machine
    ├── widgets/
    │   └── product_card.dart        # Reusable Product Card with Settlement Pricing
    └── screens/
        ├── splash_screen.dart       # AnimationController Basket Lid Rotation & Float
        ├── auth_screen.dart         # Authentication Modes with One-Tap Demo Access
        ├── home_screen.dart         # Home View with Category Scroller & Collections
        ├── shop_screen.dart         # Catalog with Category Chips & Sorting Logic
        ├── product_screen.dart      # Dimension Switching & Review Modal Workflow
        ├── cart_screen.dart         # Basket Management with Subtotal Computations
        ├── checkout_screen.dart     # Address Selection, Voucher Deduction, Checkout
        ├── orders_screen.dart       # Order History & Interactive 4-Phase Stepper
        └── account_screen.dart      # Profile Management, Studio Contact, Policies
```

---

## Functional Capabilities Matrix

```
[Opening Animation] ──> [Authentication] ──> [Home / Catalog] ──> [Product View]
        │                      │                     │                    │
   Skip Control          1-Tap Demo / OTP     Category Browser     Pack Dimension
                               │                     │             Live Savings
                         Guest Access         Search Engine               │
                                                     │                    │
                                                     ▼                    ▼
[Order Tracking] <── [Order Confirmation] <── [Checkout & Pay] <── [Cart / Basket]
        │                      │                     │                    │
  4-Stage Stepper        Order Generation     Chennai Zone Check    Quantity Stepper
  Simulated Advance      Invoice Summary      Coupon Deduction      Fee Computation
```

1. **Pre-Opening Animation**: Built using spring physics (`friction: 5`) and cubic easing to lift the woven basket lid by `-55deg` while floating harvest staples upward. Equipped with a header bypass control (`Skip ›`) and root gesture detection.
2. **One-Tap Evaluation Login**: Bypasses authentication input barriers during stakeholder reviews by pre-filling and authorizing session state for Priya S. (`demo@asianstores.in`).
3. **Dynamic Unit Scaling**: Automatically converts base kilogram, gram, and milliliter configurations into proportional wholesale and retail units.
4. **Interactive Status Advance**: The order tracking screen includes a live debugging controller (`Demo: Advance Tracking Status`) that advances orders sequentially through `Placed`, `Packed`, `Out for Delivery`, and `Delivered`.
5. **Dynamic Review Ingestion**: User reviews submitted via the modal dialog compute new weighted mathematical averages for the target product and persist within memory across views.

---

## Build & Deployment Procedures

### 1. React Native (Expo) Setup

#### Local Execution
```bash
# Clone the repository
git clone https://github.com/rohan-chand-m-01/Asian-Stores-App.git
cd Asian-Stores-App

# Install project dependencies
npm install

# Verify TypeScript compilation integrity
npx tsc --noEmit

# Launch web development server (mobile preview container)
npm run web

# Launch native development server (Expo Go QR)
npx expo start
```

#### Android Standalone APK Build (EAS Cloud)
The project's `eas.json` is configured specifically for internal distribution `.apk` generation:
```bash
# Authenticate with Expo Application Services
npx eas-cli login

# Initiate the cloud build pipeline
npx eas-cli build -p android --profile preview
```
*Upon completion, EAS generates a direct downloadable `.apk` link compatible with standard Android hardware.*

#### Local Android APK Build (Gradle)
```bash
# Generate native Android project via Continuous Native Generation
npx expo prebuild --platform android

# Compile release APK
cd android
./gradlew assembleRelease
# Output artifact: android/app/build/outputs/apk/release/app-release.apk
```

---

### 2. Flutter Setup

#### Local Execution
```bash
cd flutter_asian_stores

# Retrieve dependencies
flutter pub get

# Run on connected device or simulator
flutter run
```

#### Android Standalone APK Build
```bash
cd flutter_asian_stores
flutter pub get
flutter build apk --release
# Output artifact: build/app/outputs/flutter-apk/app-release.apk
```

---

## Demo Credentials & Evaluation Reference

| Parameter | Value | Functional Role |
| :--- | :--- | :--- |
| **Instant Access** | `1-Tap Demo Login (Priya S.)` | Single-click authentication bypass |
| **Test Email** | `demo@asianstores.in` | Standard authentication identifier |
| **Test Mobile** | `8825604253` | Mobile identifier matching Asian Stores studio line |
| **Master Password** | `asian123` | Global testing password for all profiles |
| **Verification OTP** | `4821` | Simulated four-digit SMS code |
| **Voucher Code 1** | `WELCOME` | Applies 10% percentage discount to line items |
| **Voucher Code 2** | `ASIAN50` | Applies flat ₹50 deduction to line items |
| **Voucher Code 3** | `CHARITY` | Applies ₹20 supplemental community discount |
| **Valid Postal Zones** | `600096`, `600097` | Supported delivery sectors (Perungudi, Thuraipakkam, Karapakkam) |
| **State Controller** | `Advance Tracking Status` | Sequentially transitions fulfillment status on tracking view |

---

## Contributors

<table>
  <tr>
    <td align="center" width="50%">
      <a href="https://github.com/rohan-chand-m-01">
        <img src="https://github.com/rohan-chand-m-01.png" width="100px;" alt="Rohan Chand M"/><br />
        <sub><b>Rohan Chand M</b></sub>
      </a><br />
      <sub>Lead Developer & Mobile Systems Architect</sub><br />
      <a href="https://github.com/rohan-chand-m-01">github.com/rohan-chand-m-01</a>
    </td>
    <td align="center" width="50%">
      <a href="https://github.com/VenkateshReddy007">
        <img src="https://github.com/VenkateshReddy007.png" width="100px;" alt="Venkatesh Reddy K"/><br />
        <sub><b>Venkatesh Reddy K</b></sub>
      </a><br />
      <sub>Core Contributor & Product Co-Lead</sub><br />
      <a href="https://github.com/VenkateshReddy007">github.com/VenkateshReddy007</a>
    </td>
  </tr>
</table>

---

## License

This software is distributed under the terms of the [MIT License](LICENSE).

```
MIT License

Copyright (c) 2026 Rohan Chand M, Venkatesh Reddy K

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

<div align="center">
  <sub>Engineered for <b>Asian Stores</b> &bull; i2 Agro Products Private Limited, Okkiyam Thuraipakkam, Chennai-600097</sub>
</div>
