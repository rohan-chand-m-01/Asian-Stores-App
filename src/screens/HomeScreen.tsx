import React, { useState } from 'react';
import { Alert, Image, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import { colors } from '../theme';
import { categories } from '../data';
import { ProductCard } from '../ui';
import { useStore } from '../store';

export default function HomeScreen() {
  const nav = useNavigation<any>();
  const { products, addToCart, toggleWish, wishlist, totals, user } = useStore();
  const [query, setQuery] = useState('');
  const featured = products.filter((p) => p.inStock).slice(0, 6);

  return (
    <View style={{ flex: 1, backgroundColor: colors.cream }}>
      <View style={styles.topBar}>
        <Text style={styles.charity}>Shop Groceries, Spread Kindness — ₹200 from every live purchase goes to charity.</Text>
      </View>
      <View style={styles.header}>
        <Pressable onPress={() => nav.navigate('Menu')}>
          <Ionicons name="menu" size={24} color={colors.ink} />
        </Pressable>
        <View style={{ flex: 1, marginLeft: 10 }}>
          <Text style={styles.brand}>ASIAN STORES</Text>
          <Text style={styles.tag}>PREMIUM QUALITY GROCERIES</Text>
        </View>
        <Pressable onPress={() => nav.navigate('Notifications')} style={styles.iconBtn}>
          <Ionicons name="notifications-outline" size={20} color={colors.ink} />
        </Pressable>
        <Pressable onPress={() => nav.navigate('Wishlist')} style={styles.iconBtn}>
          <Ionicons name="heart-outline" size={20} color={colors.ink} />
        </Pressable>
        <Pressable onPress={() => nav.navigate('Cart')} style={styles.iconBtn}>
          <Ionicons name="cart-outline" size={20} color={colors.ink} />
          {totals.count ? (
            <View style={styles.badge}>
              <Text style={styles.badgeText}>{totals.count}</Text>
            </View>
          ) : null}
        </Pressable>
      </View>

      <ScrollView contentContainerStyle={{ paddingBottom: 28 }}>
        <Pressable onPress={() => nav.navigate('Search')} style={styles.search}>
          <Ionicons name="search" size={18} color={colors.muted} />
          <TextInput
            placeholder="Search pulse, masala, oil..."
            placeholderTextColor={colors.muted}
            value={query}
            onChangeText={setQuery}
            onSubmitEditing={() => nav.navigate('Search', { q: query })}
            style={{ flex: 1, marginLeft: 8, color: colors.ink }}
          />
          <Pressable onPress={() => nav.navigate('Filters')}>
            <Ionicons name="options-outline" size={18} color={colors.green} />
          </Pressable>
        </Pressable>

        <View style={styles.pill}>
          <View style={styles.dot} />
          <Text style={styles.pillText}>New Stock: Premium Basmathi Rice</Text>
        </View>

        <View style={styles.hero}>
          <Text style={styles.i2}>i 2 AGRO PRODUCTS</Text>
          <Text style={styles.heroTitle}>Fresh.{'\n'}Quality.{'\n'}Grocery.</Text>
          <Text style={styles.hello}>Hi {user?.name?.split(' ')[0] ?? 'there'} — Chennai delivery zones are live.</Text>
          <View style={{ flexDirection: 'row', gap: 8, marginTop: 14 }}>
            <Pressable onPress={() => nav.navigate('Shop' as never)} style={styles.cta}>
              <Text style={styles.ctaText}>Start Exploring</Text>
            </Pressable>
            <Pressable onPress={() => nav.navigate('Contact')} style={styles.ctaAlt}>
              <Text style={styles.ctaAltText}>Contact Us</Text>
            </Pressable>
          </View>
          <Text style={styles.trust}>Trusted by 2,000+ Families</Text>
        </View>

        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ paddingHorizontal: 16, gap: 10 }}>
          {[
            { icon: 'leaf-outline', t: 'Premium Groceries', s: 'Quality since 2002' },
            { icon: 'logo-whatsapp', t: 'WhatsApp Support', s: 'Place orders on chat' },
            { icon: 'card-outline', t: 'Online Payment', s: 'Cards, UPI, COD' },
            { icon: 'bicycle-outline', t: 'Fast Delivery', s: 'Dispatched 24–48 hrs' },
          ].map((b) => (
            <Pressable key={b.t} onPress={() => nav.navigate('About')} style={styles.benefit}>
              <Ionicons name={b.icon as any} size={22} color="#fff" />
              <Text style={styles.benefitT}>{b.t}</Text>
              <Text style={styles.benefitS}>{b.s}</Text>
            </Pressable>
          ))}
        </ScrollView>

        <View style={styles.sectionHead}>
          <Text style={styles.h2}>Categories</Text>
          <Pressable onPress={() => nav.navigate('Shop' as never)}>
            <Text style={styles.see}>All Categories</Text>
          </Pressable>
        </View>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ paddingHorizontal: 16, gap: 10 }}>
          {categories.map((c) => (
            <Pressable key={c.id} onPress={() => nav.navigate('ShopCategory', { category: c.id })} style={styles.cat}>
              <Image source={{ uri: c.image }} style={styles.catImg} />
              <Text numberOfLines={2} style={styles.catName}>
                {c.name}
              </Text>
            </Pressable>
          ))}
        </ScrollView>

        <Pressable onPress={() => nav.navigate('Chocolates')} style={styles.choco}>
          <Text style={styles.chocoK}>CRAVING SWEETS?</Text>
          <Text style={styles.chocoT}>British Chocolates</Text>
        </Pressable>

        <View style={styles.sectionHead}>
          <Text style={styles.h2}>Premium Collections</Text>
          <Pressable onPress={() => nav.navigate('Filters')}>
            <Text style={styles.see}>Filters</Text>
          </Pressable>
        </View>
        <View style={styles.grid}>
          {featured.map((p) => (
            <ProductCard
              key={p.id}
              product={p}
              wished={wishlist.includes(p.id)}
              onWish={() => toggleWish(p.id)}
              onPress={() => nav.navigate('Product', { id: p.id })}
              onAdd={() => {
                addToCart(p, p.packs[0], 1);
                Alert.alert('Added', `${p.name} added at cash price ${p.cashPrice}`);
              }}
            />
          ))}
        </View>
        <Pressable onPress={() => nav.navigate('Shop' as never)} style={{ alignSelf: 'center', marginTop: 4 }}>
          <Text style={styles.see}>View full catalog</Text>
        </Pressable>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  topBar: { backgroundColor: colors.green, paddingTop: 8, paddingBottom: 8, paddingHorizontal: 12 },
  charity: { color: '#fff', fontSize: 11, textAlign: 'center' },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 14, paddingVertical: 10, backgroundColor: '#fff' },
  brand: { fontWeight: '800', color: colors.ink, letterSpacing: 0.6, fontSize: 14 },
  tag: { fontSize: 9, color: colors.muted, letterSpacing: 0.8 },
  iconBtn: { width: 34, height: 34, alignItems: 'center', justifyContent: 'center' },
  badge: {
    position: 'absolute',
    top: 2,
    right: 2,
    backgroundColor: colors.green,
    minWidth: 16,
    height: 16,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  badgeText: { color: '#fff', fontSize: 9, fontWeight: '800' },
  search: {
    margin: 16,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#fff',
    borderRadius: 14,
    paddingHorizontal: 12,
    height: 46,
    borderWidth: 1,
    borderColor: colors.line,
  },
  pill: {
    alignSelf: 'flex-start',
    marginLeft: 16,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    backgroundColor: '#fff',
    borderRadius: 20,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderWidth: 1,
    borderColor: colors.line,
  },
  dot: { width: 8, height: 8, borderRadius: 4, backgroundColor: colors.greenMid },
  pillText: { color: colors.greenDark, fontWeight: '600', fontSize: 12 },
  hero: { padding: 16 },
  i2: { color: colors.green, fontWeight: '800', letterSpacing: 1 },
  heroTitle: { fontSize: 36, fontWeight: '800', color: colors.ink, lineHeight: 40, marginTop: 6 },
  hello: { color: colors.muted, marginTop: 8 },
  cta: { backgroundColor: colors.green, borderRadius: 24, paddingHorizontal: 18, height: 44, justifyContent: 'center' },
  ctaText: { color: '#fff', fontWeight: '800' },
  ctaAlt: { backgroundColor: '#fff', borderRadius: 24, paddingHorizontal: 18, height: 44, justifyContent: 'center', borderWidth: 1, borderColor: colors.line },
  ctaAltText: { color: colors.ink, fontWeight: '800' },
  trust: { marginTop: 12, color: colors.muted },
  benefit: { width: 150, backgroundColor: colors.green, borderRadius: 16, padding: 14 },
  benefitT: { color: '#fff', fontWeight: '800', marginTop: 8 },
  benefitS: { color: '#D7F3E0', fontSize: 12, marginTop: 4 },
  sectionHead: { flexDirection: 'row', justifyContent: 'space-between', paddingHorizontal: 16, marginTop: 22, marginBottom: 10, alignItems: 'center' },
  h2: { fontSize: 18, fontWeight: '800', color: colors.ink },
  see: { color: colors.green, fontWeight: '700' },
  cat: { width: 88, alignItems: 'center' },
  catImg: { width: 72, height: 72, borderRadius: 36, backgroundColor: colors.greenSoft },
  catName: { fontSize: 11, textAlign: 'center', marginTop: 6, color: colors.ink, fontWeight: '600' },
  choco: { margin: 16, backgroundColor: '#4A2C14', borderRadius: 18, padding: 16 },
  chocoK: { color: '#E8C9A0', letterSpacing: 1, fontSize: 11, fontWeight: '700' },
  chocoT: { color: '#fff', fontSize: 20, fontWeight: '800', marginTop: 4 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between', paddingHorizontal: 16 },
});
