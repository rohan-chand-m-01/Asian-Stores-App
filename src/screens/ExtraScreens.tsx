import React, { useMemo, useState } from 'react';
import { Alert, Image, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { colors } from '../theme';
import { addresses as zoneHint, categories, deliveryZones } from '../data';
import { PrimaryButton, ProductCard, Stars } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';
import ShopScreen from './ShopScreen';

export function SearchScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const route = useRoute<any>();
  const { products, addToCart, toggleWish, wishlist } = useStore();
  const [q, setQ] = useState(route.params?.q ?? '');
  const list = products.filter((p) => p.name.toLowerCase().includes(q.toLowerCase()) || p.category.includes(q.toLowerCase()));
  return (
    <View style={{ flex: 1, backgroundColor: colors.cream }}>
      <View style={styles.searchBar}>
        <Ionicons name="search" size={18} color={colors.muted} />
        <TextInput value={q} onChangeText={setQ} autoFocus placeholder="Search groceries" style={{ flex: 1, marginLeft: 8, color: colors.ink }} />
      </View>
      <ScrollView contentContainerStyle={styles.grid}>
        {list.map((p) => (
          <ProductCard
            key={p.id}
            product={p}
            wished={wishlist.includes(p.id)}
            onWish={() => toggleWish(p.id)}
            onPress={() => nav.navigate('Product', { id: p.id })}
            onAdd={() => addToCart(p, p.packs[0], 1)}
          />
        ))}
        {!list.length ? <Text style={styles.meta}>No matches. Try rice, oil, dhal.</Text> : null}
      </ScrollView>
    </View>
  );
}

export function FiltersScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const [max, setMax] = useState(500);
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      <Text style={styles.h}>Cash price under</Text>
      {[50, 100, 250, 500].map((n) => (
        <Pressable key={n} onPress={() => setMax(n)} style={[styles.box, max === n && styles.boxOn]}>
          <Text style={styles.name}>₹{n}</Text>
        </Pressable>
      ))}
      <PrimaryButton
        label="Show results"
        onPress={() => {
          Alert.alert('Filters', `Showing items with cash price ≤ ₹${max} in Shop.`);
          nav.navigate('Main', { screen: 'Shop' });
        }}
      />
    </ScrollView>
  );
}

export function WishlistScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { products, wishlist, toggleWish, addToCart } = useStore();
  const list = products.filter((p) => wishlist.includes(p.id));
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={styles.grid}>
      {list.map((p) => (
        <ProductCard
          key={p.id}
          product={p}
          wished
          onWish={() => toggleWish(p.id)}
          onPress={() => nav.navigate('Product', { id: p.id })}
          onAdd={() => addToCart(p, p.packs[0], 1)}
        />
      ))}
      {!list.length ? <Text style={styles.meta}>Heart a product to save it here.</Text> : null}
    </ScrollView>
  );
}

export function NotificationsScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { notifyIds, products, orders } = useStore();
  const notes = [
    { t: 'Basmathi rice is back in stock', s: 'New lot for Chennai zones', go: () => nav.navigate('Product', { id: 'basmati' }) },
    { t: `${orders[0]?.id} update`, s: orders[0]?.status ?? 'Order activity', go: () => nav.navigate('Track', { orderId: orders[0].id }) },
    ...notifyIds.map((id) => {
      const p = products.find((x) => x.id === id);
      return { t: `Watching ${p?.name}`, s: 'We will ping you in this demo when it returns', go: () => nav.navigate('Product', { id }) };
    }),
  ];
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      {notes.map((n) => (
        <Pressable key={n.t} onPress={n.go} style={styles.box}>
          <Text style={styles.name}>{n.t}</Text>
          <Text style={styles.meta}>{n.s}</Text>
        </Pressable>
      ))}
    </ScrollView>
  );
}

export function ChocolatesScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { products, addToCart, toggleWish, wishlist } = useStore();
  const list = products.filter((p) => p.category === 'chocolate');
  return (
    <ScrollView style={{ flex: 1, backgroundColor: '#3A2414' }} contentContainerStyle={{ padding: 16 }}>
      <Text style={{ color: '#E8C9A0', fontWeight: '700', letterSpacing: 1 }}>CRAVING SWEETS?</Text>
      <Text style={{ color: '#fff', fontSize: 26, fontWeight: '800', marginVertical: 8 }}>British Chocolates</Text>
      <Pressable onPress={() => nav.navigate('Main', { screen: 'Shop' })}>
        <Text style={{ color: '#E8C9A0', marginBottom: 16 }}>Also shop groceries →</Text>
      </Pressable>
      <View style={styles.grid}>
        {list.map((p) => (
          <ProductCard
            key={p.id}
            product={p}
            wished={wishlist.includes(p.id)}
            onWish={() => toggleWish(p.id)}
            onPress={() => nav.navigate('Product', { id: p.id })}
            onAdd={() => addToCart(p, p.packs[0], 1)}
          />
        ))}
      </View>
    </ScrollView>
  );
}

export function MenuScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const links: { label: string; to: () => void }[] = [
    { label: 'Home', to: () => nav.navigate('Main', { screen: 'Home' }) },
    { label: 'Categories', to: () => nav.navigate('Main', { screen: 'Shop' }) },
    { label: 'About us', to: () => nav.navigate('About') },
    { label: 'Contact', to: () => nav.navigate('Contact') },
    { label: 'My orders', to: () => nav.navigate('Main', { screen: 'Orders' }) },
    { label: 'British Chocolates', to: () => nav.navigate('Chocolates') },
    { label: 'Refund policy', to: () => nav.navigate('Policy', { type: 'refund' }) },
    { label: 'Shipping policy', to: () => nav.navigate('Policy', { type: 'shipping' }) },
  ];
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      {links.map((l) => (
        <Pressable key={l.label} onPress={l.to} style={styles.box}>
          <Text style={styles.name}>{l.label}</Text>
        </Pressable>
      ))}
    </ScrollView>
  );
}

export function ShopCategoryScreen() {
  const { category } = useRoute<any>().params as { category: string };
  return <ShopScreen forcedCategory={category} />;
}

export function AddressFormScreen() {
  const nav = useNavigation();
  const { addAddress, setSelectedAddressId } = useStore();
  const [label, setLabel] = useState('Parents');
  const [name, setName] = useState('K. Sharma');
  const [phone, setPhone] = useState('9876543210');
  const [line, setLine] = useState('12, 2nd street');
  const [area, setArea] = useState(deliveryZones[0].area);
  const [pincode, setPincode] = useState(deliveryZones[0].pincode);
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16, gap: 10 }}>
      <Text style={styles.meta}>Supported: {deliveryZones.map((z) => `${z.area} (${z.pincode})`).join(', ')}</Text>
      <TextInput value={label} onChangeText={setLabel} style={styles.input} placeholder="Label" />
      <TextInput value={name} onChangeText={setName} style={styles.input} placeholder="Name" />
      <TextInput value={phone} onChangeText={setPhone} style={styles.input} placeholder="Phone" />
      <TextInput value={line} onChangeText={setLine} style={styles.input} placeholder="Street" />
      {deliveryZones.map((z) => (
        <Pressable key={z.area} onPress={() => { setArea(z.area); setPincode(z.pincode); }} style={[styles.box, area === z.area && styles.boxOn]}>
          <Text style={styles.name}>{z.area} · {z.pincode}</Text>
        </Pressable>
      ))}
      <PrimaryButton
        label="Save address"
        onPress={() => {
          const id = `addr-${Date.now()}`;
          addAddress({ id, label, name, phone, line, area, pincode });
          setSelectedAddressId(id);
          Alert.alert('Saved', 'Address added to checkout.');
          nav.goBack();
        }}
      />
      <Text style={styles.meta}>Existing: {zoneHint.map((a) => a.label).join(', ')}</Text>
    </ScrollView>
  );
}

export function ReviewScreen() {
  const nav = useNavigation();
  const { id } = useRoute<any>().params as { id: string };
  const { products, addReview, user } = useStore();
  const product = products.find((p) => p.id === id);
  const [rating, setRating] = useState(5);
  const [text, setText] = useState('Fresh pack, cash price matched the label.');
  if (!product) return null;
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      <Text style={styles.h}>{product.name}</Text>
      <View style={{ flexDirection: 'row', gap: 6, marginVertical: 12 }}>
        {[1, 2, 3, 4, 5].map((n) => (
          <Pressable key={n} onPress={() => setRating(n)}>
            <Ionicons name={n <= rating ? 'star' : 'star-outline'} size={28} color={colors.gold} />
          </Pressable>
        ))}
      </View>
      <TextInput value={text} onChangeText={setText} multiline style={[styles.input, { height: 100, textAlignVertical: 'top' }]} />
      <PrimaryButton
        label="Submit review"
        onPress={() => {
          addReview(id, { name: user?.name ?? 'Guest', rating, date: '19 Oct 2026', text });
          Alert.alert('Thanks', 'Review posted on this demo product.');
          nav.goBack();
        }}
      />
      {product.reviews.map((r) => (
        <View key={r.id} style={styles.box}>
          <Stars rating={r.rating} />
          <Text style={styles.name}>{r.name}</Text>
          <Text style={styles.meta}>{r.text}</Text>
        </View>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  searchBar: { flexDirection: 'row', alignItems: 'center', margin: 16, backgroundColor: '#fff', borderRadius: 14, paddingHorizontal: 12, height: 46, borderWidth: 1, borderColor: colors.line },
  grid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between', paddingHorizontal: 16, paddingBottom: 24 },
  meta: { color: colors.muted, padding: 8 },
  h: { fontWeight: '800', fontSize: 18, color: colors.ink },
  box: { backgroundColor: '#fff', padding: 14, borderRadius: 14, marginBottom: 8, borderWidth: 1, borderColor: colors.line },
  boxOn: { borderColor: colors.green, backgroundColor: colors.greenSoft },
  name: { fontWeight: '800', color: colors.ink },
  input: { height: 46, borderWidth: 1, borderColor: colors.line, borderRadius: 12, paddingHorizontal: 12, backgroundColor: '#fff', color: colors.ink, marginBottom: 8 },
});
