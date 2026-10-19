import React, { useState } from 'react';
import { Alert, Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { colors } from '../theme';
import { formatInr, PrimaryButton, Qty, Stars } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';

export default function ProductScreen() {
  const { id } = useRoute<any>().params as { id: string };
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { products, addToCart, toggleWish, wishlist, notifyMe, notifyIds } = useStore();
  const product = products.find((p) => p.id === id);
  const [packIndex, setPackIndex] = useState(0);
  const [qty, setQty] = useState(1);

  if (!product) {
    return (
      <View style={styles.center}>
        <Text>Product not found</Text>
        <PrimaryButton label="Back to shop" onPress={() => nav.goBack()} />
      </View>
    );
  }

  const pack = product.packs[packIndex];
  const mrp = Math.round(pack.price * 1.18);

  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ paddingBottom: 28 }}>
      <Image source={{ uri: product.image }} style={styles.hero} />
      <View style={styles.body}>
        <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
          <Text style={styles.name}>{product.name}</Text>
          <Pressable onPress={() => toggleWish(product.id)}>
            <Ionicons name={wishlist.includes(product.id) ? 'heart' : 'heart-outline'} size={24} color="#C62828" />
          </Pressable>
        </View>
        <Text style={styles.premium}>PREMIUM PRODUCT · {product.category.toUpperCase()}</Text>
        <Pressable onPress={() => nav.navigate('Review', { id: product.id })} style={{ flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 6 }}>
          <Stars rating={product.rating} size={14} />
          <Text style={styles.muted}>
            {product.rating} ({product.reviewCount} reviews)
          </Text>
        </Pressable>

        <View style={styles.priceBox}>
          <Text style={styles.mrp}>MRP {formatInr(mrp)}</Text>
          <Text style={styles.cash}>Cash price {formatInr(pack.price)}</Text>
          <Text style={styles.save}>You save {formatInr(mrp - pack.price)} on cash settlement</Text>
        </View>

        <Text style={styles.label}>Pack size</Text>
        <View style={styles.packs}>
          {product.packs.map((pk, i) => (
            <Pressable key={pk.id} onPress={() => setPackIndex(i)} style={[styles.pack, i === packIndex && styles.packOn]}>
              <Text style={[styles.packT, i === packIndex && { color: '#fff' }]}>{pk.label}</Text>
              <Text style={[styles.packP, i === packIndex && { color: '#D7F3E0' }]}>{formatInr(pk.price)}</Text>
            </Pressable>
          ))}
        </View>

        <Text style={styles.label}>Quantity</Text>
        <Qty qty={qty} onChange={(n) => setQty(Math.max(1, n))} />

        <Text style={styles.desc}>{product.description}</Text>

        {product.inStock ? (
          <View style={{ gap: 10, marginTop: 16 }}>
            <PrimaryButton
              label={`Add to cart · ${formatInr(pack.price * qty)}`}
              icon="cart"
              onPress={() => {
                addToCart(product, pack, qty);
                Alert.alert('Added to cart', `${qty} × ${product.name} (${pack.label})`);
              }}
            />
            <Pressable
              onPress={() => {
                addToCart(product, pack, qty);
                nav.navigate('Checkout');
              }}
              style={styles.buy}
            >
              <Text style={styles.buyT}>Buy now</Text>
            </Pressable>
          </View>
        ) : (
          <PrimaryButton
            label={notifyIds.includes(product.id) ? 'We’ll notify you' : 'Notify me when in stock'}
            onPress={() => {
              notifyMe(product.id);
              Alert.alert('Watchlist', 'Demo alert set. You’ll see this product under Notifications.');
            }}
          />
        )}

        <Pressable onPress={() => Alert.alert('Share (demo)', `asianstores://product/${product.id}`)} style={styles.share}>
          <Ionicons name="share-social-outline" size={16} color={colors.green} />
          <Text style={{ color: colors.green, fontWeight: '700' }}>Share product</Text>
        </Pressable>

        <View style={styles.revHead}>
          <Text style={styles.h3}>Reviews</Text>
          <Pressable onPress={() => nav.navigate('Review', { id: product.id })}>
            <Text style={{ color: colors.green, fontWeight: '700' }}>Write a review</Text>
          </Pressable>
        </View>
        {product.reviews.map((r) => (
          <View key={r.id} style={styles.rev}>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
              <Text style={{ fontWeight: '800', color: colors.ink }}>{r.name}</Text>
              <Stars rating={r.rating} />
            </View>
            <Text style={styles.muted}>{r.date}</Text>
            <Text style={{ marginTop: 6, color: colors.ink }}>{r.text}</Text>
          </View>
        ))}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 12 },
  hero: { width: '100%', height: 240, backgroundColor: colors.greenSoft },
  body: { padding: 16 },
  name: { fontSize: 22, fontWeight: '800', color: colors.ink, flex: 1, paddingRight: 12 },
  premium: { color: colors.green, fontWeight: '700', marginTop: 4, fontSize: 11, letterSpacing: 0.5 },
  muted: { color: colors.muted, fontSize: 12 },
  priceBox: { backgroundColor: '#fff', borderRadius: 16, padding: 14, marginTop: 14, borderWidth: 1, borderColor: colors.line },
  mrp: { textDecorationLine: 'line-through', color: colors.muted },
  cash: { fontSize: 22, fontWeight: '800', color: colors.greenDark, marginTop: 2 },
  save: { color: colors.danger, marginTop: 4, fontWeight: '600' },
  label: { marginTop: 16, marginBottom: 8, fontWeight: '800', color: colors.ink },
  packs: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  pack: { borderWidth: 1, borderColor: colors.line, backgroundColor: '#fff', borderRadius: 12, paddingHorizontal: 12, paddingVertical: 8 },
  packOn: { backgroundColor: colors.green, borderColor: colors.green },
  packT: { fontWeight: '700', color: colors.ink },
  packP: { fontSize: 12, color: colors.muted },
  desc: { marginTop: 16, color: colors.ink, lineHeight: 22 },
  buy: { height: 52, borderRadius: 28, borderWidth: 1.5, borderColor: colors.green, alignItems: 'center', justifyContent: 'center' },
  buyT: { color: colors.greenDark, fontWeight: '800', fontSize: 16 },
  share: { flexDirection: 'row', gap: 6, marginTop: 14, alignItems: 'center' },
  h3: { fontWeight: '800', fontSize: 16, color: colors.ink },
  revHead: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 22, marginBottom: 8 },
  rev: { backgroundColor: '#fff', padding: 12, borderRadius: 12, marginBottom: 8, borderWidth: 1, borderColor: colors.line },
});
