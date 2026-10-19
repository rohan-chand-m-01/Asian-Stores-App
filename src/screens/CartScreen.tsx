import React from 'react';
import { Alert, Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { colors } from '../theme';
import { formatInr, GhostButton, PrimaryButton, Qty } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';

export default function CartScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { cart, setQty, removeFromCart, clearCart, totals } = useStore();

  if (!cart.length) {
    return (
      <View style={styles.empty}>
        <Ionicons name="basket-outline" size={64} color={colors.green} />
        <Text style={styles.emptyT}>Your basket is empty</Text>
        <PrimaryButton label="Start exploring" onPress={() => nav.navigate('Main', { screen: 'Shop' })} />
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: colors.cream }}>
      <ScrollView contentContainerStyle={{ padding: 16, paddingBottom: 140 }}>
        {cart.map((line) => (
          <View key={line.key} style={styles.row}>
            <Pressable onPress={() => nav.navigate('Product', { id: line.product.id })}>
              <Image source={{ uri: line.product.image }} style={styles.img} />
            </Pressable>
            <View style={{ flex: 1 }}>
              <Text style={styles.name}>{line.product.name}</Text>
              <Text style={styles.meta}>{line.pack.label} · Cash {formatInr(line.pack.price)}</Text>
              <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginTop: 8 }}>
                <Qty qty={line.qty} onChange={(n) => setQty(line.key, n)} />
                <Text style={styles.sum}>{formatInr(line.pack.price * line.qty)}</Text>
              </View>
            </View>
            <Pressable onPress={() => removeFromCart(line.key)} style={{ padding: 6 }}>
              <Ionicons name="trash-outline" size={18} color={colors.danger} />
            </Pressable>
          </View>
        ))}
        <Pressable onPress={() => Alert.alert('Clear cart', 'Remove all items?', [{ text: 'Keep' }, { text: 'Clear', onPress: clearCart }])}>
          <Text style={styles.clear}>Clear basket</Text>
        </Pressable>
      </ScrollView>
      <View style={styles.footer}>
        <View style={styles.tot}>
          <Text style={styles.muted}>{totals.count} items</Text>
          <Text style={styles.total}>{formatInr(totals.subtotal)}</Text>
        </View>
        <PrimaryButton label="Review & checkout" onPress={() => nav.navigate('Checkout')} />
        <View style={{ height: 8 }} />
        <GhostButton label="Continue shopping" onPress={() => nav.navigate('Main', { screen: 'Shop' })} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  empty: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 12, padding: 24, backgroundColor: colors.cream },
  emptyT: { fontSize: 18, fontWeight: '800', color: colors.ink, marginBottom: 8 },
  row: { flexDirection: 'row', gap: 10, backgroundColor: '#fff', padding: 12, borderRadius: 16, marginBottom: 10, borderWidth: 1, borderColor: colors.line },
  img: { width: 72, height: 72, borderRadius: 12, backgroundColor: colors.greenSoft },
  name: { fontWeight: '800', color: colors.ink },
  meta: { color: colors.muted, marginTop: 4, fontSize: 12 },
  sum: { fontWeight: '800', color: colors.greenDark },
  clear: { textAlign: 'center', color: colors.danger, fontWeight: '700', marginTop: 8 },
  footer: { position: 'absolute', left: 0, right: 0, bottom: 0, backgroundColor: '#fff', padding: 16, borderTopWidth: 1, borderColor: colors.line },
  tot: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 10 },
  muted: { color: colors.muted },
  total: { fontWeight: '800', fontSize: 18, color: colors.ink },
});
