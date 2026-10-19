import React, { useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { StatusBar } from 'expo-status-bar';
import { Ionicons } from '@expo/vector-icons';
import { StoreProvider, useStore } from './src/store';
import { colors } from './src/theme';
import { ScreenWrap } from './src/ui';
import { RootStackParamList, TabParamList } from './src/navigation';
import SplashScreen from './src/screens/SplashScreen';
import AuthScreen from './src/screens/AuthScreen';
import HomeScreen from './src/screens/HomeScreen';
import ShopScreen from './src/screens/ShopScreen';
import ProductScreen from './src/screens/ProductScreen';
import CartScreen from './src/screens/CartScreen';
import CheckoutScreen from './src/screens/CheckoutScreen';
import { OrdersListScreen, SuccessScreen, TrackScreen } from './src/screens/OrdersScreen';
import AccountScreen, {
  AboutScreen,
  ContactScreen,
  FaqScreen,
  PolicyScreen,
  ProfileEditScreen,
} from './src/screens/AccountScreen';
import {
  AddressFormScreen,
  ChocolatesScreen,
  FiltersScreen,
  MenuScreen,
  NotificationsScreen,
  ReviewScreen,
  SearchScreen,
  ShopCategoryScreen,
  WishlistScreen,
} from './src/screens/ExtraScreens';

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tabs = createBottomTabNavigator<TabParamList>();

function tabIcon(name: keyof typeof Ionicons.glyphMap) {
  return ({ color, size }: { color: string; size: number }) => <Ionicons name={name} size={size} color={color} />;
}

function MainTabs() {
  const { orders } = useStore();
  return (
    <Tabs.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.green,
        tabBarInactiveTintColor: colors.muted,
        tabBarStyle: { borderTopColor: colors.line, height: 58 },
        tabBarLabelStyle: { fontWeight: '700', fontSize: 11 },
      }}
    >
      <Tabs.Screen name="Home" component={HomeScreen} options={{ tabBarIcon: tabIcon('home') }} />
      <Tabs.Screen name="Shop" component={ShopScreen} options={{ tabBarIcon: tabIcon('grid') }} />
      <Tabs.Screen
        name="Orders"
        component={OrdersListScreen}
        options={{ tabBarIcon: tabIcon('receipt'), tabBarBadge: orders.length || undefined }}
      />
      <Tabs.Screen name="Account" component={AccountScreen} options={{ tabBarIcon: tabIcon('person') }} />
    </Tabs.Navigator>
  );
}

function Root() {
  const { user } = useStore();
  const [splash, setSplash] = useState(true);
  if (splash) return <SplashScreen onDone={() => setSplash(false)} />;
  if (!user) return <AuthScreen />;
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.white },
        headerTintColor: colors.greenDark,
        headerTitleStyle: { fontWeight: '800', color: colors.ink },
        contentStyle: { backgroundColor: colors.cream },
      }}
    >
      <Stack.Screen name="Main" component={MainTabs} options={{ headerShown: false }} />
      <Stack.Screen name="Product" component={ProductScreen} options={{ title: 'Product' }} />
      <Stack.Screen name="Cart" component={CartScreen} options={{ title: 'Basket' }} />
      <Stack.Screen name="Checkout" component={CheckoutScreen} options={{ title: 'Review order' }} />
      <Stack.Screen name="Success" component={SuccessScreen} options={{ headerShown: false }} />
      <Stack.Screen name="Track" component={TrackScreen} options={{ title: 'Track order' }} />
      <Stack.Screen name="Search" component={SearchScreen} options={{ title: 'Search' }} />
      <Stack.Screen name="Filters" component={FiltersScreen} options={{ title: 'Filters' }} />
      <Stack.Screen name="Wishlist" component={WishlistScreen} options={{ title: 'Wishlist' }} />
      <Stack.Screen name="Notifications" component={NotificationsScreen} options={{ title: 'Notifications' }} />
      <Stack.Screen name="About" component={AboutScreen} options={{ title: 'About us' }} />
      <Stack.Screen name="Contact" component={ContactScreen} options={{ title: 'Contact' }} />
      <Stack.Screen name="Policy" component={PolicyScreen} options={{ title: 'Policy' }} />
      <Stack.Screen name="Chocolates" component={ChocolatesScreen} options={{ title: 'British Chocolates' }} />
      <Stack.Screen name="Menu" component={MenuScreen} options={{ title: 'Menu' }} />
      <Stack.Screen name="ShopCategory" component={ShopCategoryScreen} options={{ title: 'Category' }} />
      <Stack.Screen name="AddressForm" component={AddressFormScreen} options={{ title: 'Address' }} />
      <Stack.Screen name="Review" component={ReviewScreen} options={{ title: 'Reviews' }} />
      <Stack.Screen name="Faq" component={FaqScreen} options={{ title: 'FAQs' }} />
      <Stack.Screen name="ProfileEdit" component={ProfileEditScreen} options={{ title: 'Edit profile' }} />
    </Stack.Navigator>
  );
}

export default function App() {
  return (
    <StoreProvider>
      <ScreenWrap>
        <NavigationContainer>
          <StatusBar style="dark" />
          <Root />
        </NavigationContainer>
      </ScreenWrap>
    </StoreProvider>
  );
}
