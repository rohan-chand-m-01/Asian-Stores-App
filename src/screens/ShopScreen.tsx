import React, { useMemo, useState } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { categories } from '../data';
import { colors } from '../theme';
import { ProductCard } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';

export default function ShopScreen({ forcedCategory }: { forcedCategory?: string }) {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const route = useRoute<any>();
  const startCat = forcedCategory || route.params?.category || 'all';
  const { products, addToCart, toggleWish, wishlist } = useStore();
  const [cat, setCat] = useState(startCat);
  const [sort, setSort] = useState<'featured' | 'price' | 'rating'>('featured');
  const [stockOnly, setStockOnly] = useState(false);

  const list = useMemo(() => {
    let rows = products.filter((p) => (cat === 'all' ? true : p.category === cat));
    if (stockOnly) rows = rows.filter((p) => p.inStock);
    if (sort === 'price') rows = [...rows].sort((a, b) => a.cashPrice - b.cashPrice);
    if (sort === 'rating') rows = [...rows].sort((a, b) => b.rating - a.rating);
    return rows;
  }, [products, cat, sort, stockOnly]);

  return (
    <View style={{ flex: 1, backgroundColor: colors.cream }}>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.chips}>
        {categories.map((c) => (
          <Pressable key={c.id} onPress={() => setCat(c.id)} style={[styles.chip, cat === c.id && styles.chipOn]}>
            <Text style={[styles.chipText, cat === c.id && { color: '#fff' }]}>{c.name}</Text>
          </Pressable>
        ))}
      </ScrollView>
      <View style={styles.toolbar}>
        <Pressable onPress={() => setStockOnly((s) => !s)}>
          <Text style={styles.tool}>{stockOnly ? 'In stock only ✓' : 'In stock only'}</Text>
        </Pressable>
        <Pressable onPress={() => setSort(sort === 'featured' ? 'price' : sort === 'price' ? 'rating' : 'featured')}>
          <Text style={styles.tool}>Sort: {sort}</Text>
        </Pressable>
        <Pressable onPress={() => nav.navigate('Filters')}>
          <Text style={styles.tool}>More filters</Text>
        </Pressable>
      </View>
      <ScrollView contentContainerStyle={styles.grid}>
        {list.map((p) => (
          <ProductCard
            key={p.id}
            product={p}
            wished={wishlist.includes(p.id)}
            onWish={() => toggleWish(p.id)}
            onPress={() => nav.navigate('Product', { id: p.id })}
            onAdd={() => {
              addToCart(p, p.packs[0], 1);
              Alert.alert('Cart', `${p.name} added`);
            }}
          />
        ))}
        {list.length === 0 ? <Text style={{ color: colors.muted, padding: 24 }}>No products in this filter.</Text> : null}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  chips: { paddingHorizontal: 12, paddingVertical: 12, gap: 8, alignItems: 'center' },
  chip: { backgroundColor: '#fff', borderRadius: 18, paddingHorizontal: 12, height: 34, justifyContent: 'center', borderWidth: 1, borderColor: colors.line },
  chipOn: { backgroundColor: colors.green, borderColor: colors.green },
  chipText: { fontSize: 12, fontWeight: '700', color: colors.ink },
  toolbar: { flexDirection: 'row', justifyContent: 'space-between', paddingHorizontal: 16, marginBottom: 8 },
  tool: { color: colors.green, fontWeight: '700', fontSize: 12 },
  grid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between', paddingHorizontal: 16, paddingBottom: 24 },
});
