import React from 'react';
import {
  Image,
  Platform,
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors } from './theme';
import { Product } from './data';

export function formatInr(n: number) {
  return `₹${n.toFixed(0)}`;
}

export function Stars({ rating, size = 12 }: { rating: number; size?: number }) {
  const full = Math.round(rating);
  return (
    <View style={{ flexDirection: 'row', gap: 2 }}>
      {[1, 2, 3, 4, 5].map((i) => (
        <Ionicons key={i} name={i <= full ? 'star' : 'star-outline'} size={size} color={colors.gold} />
      ))}
    </View>
  );
}

export function PrimaryButton({
  label,
  onPress,
  disabled,
  icon,
}: {
  label: string;
  onPress: () => void;
  disabled?: boolean;
  icon?: keyof typeof Ionicons.glyphMap;
}) {
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      style={({ pressed }) => [styles.primary, disabled && { opacity: 0.45 }, pressed && { opacity: 0.85 }]}
    >
      {icon ? <Ionicons name={icon} size={18} color="#fff" /> : null}
      <Text style={styles.primaryText}>{label}</Text>
    </Pressable>
  );
}

export function GhostButton({ label, onPress }: { label: string; onPress: () => void }) {
  return (
    <Pressable onPress={onPress} style={({ pressed }) => [styles.ghost, pressed && { backgroundColor: colors.greenSoft }]}>
      <Text style={styles.ghostText}>{label}</Text>
    </Pressable>
  );
}

export function Qty({ qty, onChange }: { qty: number; onChange: (n: number) => void }) {
  return (
    <View style={styles.qty}>
      <Pressable onPress={() => onChange(qty - 1)} style={styles.qtyBtn}>
        <Ionicons name="remove" size={16} color={colors.green} />
      </Pressable>
      <Text style={styles.qtyNum}>{qty}</Text>
      <Pressable onPress={() => onChange(qty + 1)} style={styles.qtyBtn}>
        <Ionicons name="add" size={16} color={colors.green} />
      </Pressable>
    </View>
  );
}

export function ProductCard({
  product,
  onPress,
  onAdd,
  wished,
  onWish,
}: {
  product: Product;
  onPress: () => void;
  onAdd: () => void;
  wished: boolean;
  onWish: () => void;
}) {
  return (
    <Pressable onPress={onPress} style={styles.card}>
      <View>
        <Image source={{ uri: product.image }} style={styles.cardImg} />
        {!product.inStock ? (
          <View style={styles.oos}>
            <Text style={styles.oosText}>OUT OF STOCK</Text>
          </View>
        ) : null}
        <Pressable onPress={onWish} style={styles.wish}>
          <Ionicons name={wished ? 'heart' : 'heart-outline'} size={16} color={wished ? '#C62828' : colors.green} />
        </Pressable>
      </View>
      <Text numberOfLines={2} style={styles.cardName}>
        {product.name}
      </Text>
      <Text style={styles.premium}>PREMIUM PRODUCT</Text>
      <Stars rating={product.rating} />
      <View style={styles.priceRow}>
        <Text style={styles.mrp}>{formatInr(product.mrp)}</Text>
        <Text style={styles.cash}>{formatInr(product.cashPrice)}</Text>
      </View>
      <Text style={styles.cashHint}>Cash price · {product.packs[0].label}</Text>
      <Pressable
        onPress={product.inStock ? onAdd : onPress}
        style={[styles.addBtn, !product.inStock && { backgroundColor: '#EEE' }]}
      >
        <Text style={[styles.addText, !product.inStock && { color: colors.muted }]}>
          {product.inStock ? 'Add to Cart' : 'Notify Me'}
        </Text>
      </Pressable>
    </Pressable>
  );
}

export function ScreenWrap({ children }: { children: React.ReactNode }) {
  if (Platform.OS !== 'web') return <View style={{ flex: 1, backgroundColor: colors.cream }}>{children}</View>;
  return (
    <View style={styles.webPage}>
      <View style={styles.phone}>{children}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  primary: {
    backgroundColor: colors.green,
    borderRadius: 28,
    height: 52,
    alignItems: 'center',
    justifyContent: 'center',
    flexDirection: 'row',
    gap: 8,
  },
  primaryText: { color: '#fff', fontWeight: '700', fontSize: 16 },
  ghost: {
    borderRadius: 28,
    height: 52,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: colors.line,
    backgroundColor: '#fff',
  },
  ghostText: { color: colors.ink, fontWeight: '700', fontSize: 16 },
  qty: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.line,
    borderRadius: 12,
    overflow: 'hidden',
  },
  qtyBtn: { width: 36, height: 36, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.greenSoft },
  qtyNum: { minWidth: 28, textAlign: 'center', fontWeight: '700', color: colors.ink },
  card: {
    width: '48%',
    backgroundColor: '#fff',
    borderRadius: 16,
    padding: 10,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: colors.line,
  },
  cardImg: { width: '100%', height: 110, borderRadius: 12, backgroundColor: colors.greenSoft },
  oos: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: '#333',
    borderRadius: 6,
    paddingHorizontal: 6,
    paddingVertical: 2,
  },
  oosText: { color: '#fff', fontSize: 9, fontWeight: '800' },
  wish: {
    position: 'absolute',
    top: 8,
    right: 8,
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  cardName: { marginTop: 8, fontWeight: '700', color: colors.ink, fontSize: 13, minHeight: 34 },
  premium: { fontSize: 10, color: colors.green, fontWeight: '700', letterSpacing: 0.4, marginBottom: 4 },
  priceRow: { flexDirection: 'row', alignItems: 'baseline', gap: 8, marginTop: 6 },
  mrp: { color: colors.muted, textDecorationLine: 'line-through', fontSize: 12 },
  cash: { color: colors.greenDark, fontWeight: '800', fontSize: 16 },
  cashHint: { color: colors.muted, fontSize: 10, marginBottom: 8 },
  addBtn: { backgroundColor: colors.green, borderRadius: 10, height: 36, alignItems: 'center', justifyContent: 'center' },
  addText: { color: '#fff', fontWeight: '700', fontSize: 12 },
  webPage: {
    flex: 1,
    backgroundColor: '#0B1A12',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
  },
  phone: {
    width: 390,
    maxWidth: '100%',
    height: 844,
    maxHeight: '100%',
    backgroundColor: colors.cream,
    borderRadius: 36,
    overflow: 'hidden',
    borderWidth: 8,
    borderColor: '#14261C',
  },
});
