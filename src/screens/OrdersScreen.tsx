import React from 'react';
import { Image, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { colors } from '../theme';
import { formatInr, GhostButton, PrimaryButton } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';

const steps = ['Placed', 'Packed', 'Out for delivery', 'Delivered'] as const;

export function OrdersListScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { orders } = useStore();
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      {orders.map((o) => (
        <Pressable key={o.id} onPress={() => nav.navigate('Track', { orderId: o.id })} style={styles.card}>
          <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
            <Text style={styles.id}>{o.id}</Text>
            <Text style={styles.status}>{o.status}</Text>
          </View>
          <Text style={styles.meta}>{o.placedAt} · {o.payment}</Text>
          <Text style={styles.total}>{formatInr(o.total)} · {o.items.length} item(s)</Text>
          <Text style={styles.link}>Track order</Text>
        </Pressable>
      ))}
    </ScrollView>
  );
}

export function TrackScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { orderId } = useRoute<any>().params as { orderId: string };
  const { orders, cancelOrder, reorder, advanceOrder } = useStore();
  const order = orders.find((o) => o.id === orderId);
  if (!order) {
    return (
      <View style={styles.center}>
        <Text>Order not found</Text>
        <PrimaryButton label="My orders" onPress={() => nav.navigate('Main', { screen: 'Orders' })} />
      </View>
    );
  }
  const idx = steps.indexOf(order.status as any);
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16, paddingBottom: 40 }}>
      <Text style={styles.id}>{order.id}</Text>
      <Text style={styles.meta}>{order.placedAt}</Text>
      <Text style={styles.eta}>{order.eta}</Text>
      <View style={styles.track}>
        {steps.map((s, i) => (
          <View key={s} style={styles.step}>
            <View style={[styles.dot, (idx >= i || order.status === 'Delivered') && order.status !== 'Cancelled' ? styles.dotOn : null]} />
            {i < steps.length - 1 ? <View style={[styles.bar, idx > i ? styles.barOn : null]} /> : null}
            <Text style={styles.stepT}>{s}</Text>
          </View>
        ))}
      </View>
      {order.status === 'Cancelled' ? <Text style={{ color: colors.danger, fontWeight: '800', marginBottom: 12 }}>This order was cancelled</Text> : null}

      {order.items.map((it) => (
        <Pressable key={it.productId + it.pack} onPress={() => nav.navigate('Product', { id: it.productId })} style={styles.item}>
          <Image source={{ uri: it.image }} style={styles.img} />
          <View style={{ flex: 1 }}>
            <Text style={{ fontWeight: '800', color: colors.ink }}>{it.name}</Text>
            <Text style={styles.meta}>{it.pack} × {it.qty}</Text>
          </View>
          <Text style={{ fontWeight: '800' }}>{formatInr(it.price * it.qty)}</Text>
        </Pressable>
      ))}

      <View style={styles.bill}>
        <Text>Subtotal {formatInr(order.subtotal)}</Text>
        <Text>Delivery {order.delivery ? formatInr(order.delivery) : 'FREE'}</Text>
        <Text>Discount {order.discount ? formatInr(order.discount) : '—'}</Text>
        <Text style={{ fontWeight: '800', marginTop: 6 }}>Paid {formatInr(order.total)} · {order.payment}</Text>
        <Text style={styles.meta}>{order.address.label}: {order.address.area} {order.address.pincode}</Text>
      </View>

      {order.status === 'Placed' ? (
        <PrimaryButton label="Cancel order" onPress={() => cancelOrder(order.id)} />
      ) : null}
      <View style={{ height: 10 }} />
      <GhostButton
        label="Reorder these items"
        onPress={() => {
          reorder(order.id);
          nav.navigate('Cart');
        }}
      />
      {order.status !== 'Delivered' && order.status !== 'Cancelled' ? (
        <Pressable onPress={() => advanceOrder(order.id)} style={{ marginTop: 12, alignItems: 'center' }}>
          <Text style={styles.link}>Demo: advance tracking status</Text>
        </Pressable>
      ) : null}
    </ScrollView>
  );
}

export function SuccessScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { orderId } = useRoute<any>().params as { orderId: string };
  return (
    <View style={styles.center}>
      <Text style={{ fontSize: 42 }}>🧺</Text>
      <Text style={styles.ok}>Order placed</Text>
      <Text style={styles.meta}>{orderId} is packing at the Thuraipakkam studio.</Text>
      <PrimaryButton label="Track order" onPress={() => nav.replace('Track', { orderId })} />
      <View style={{ height: 10 }} />
      <GhostButton label="Back to home" onPress={() => nav.navigate('Main', { screen: 'Home' })} />
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: '#fff', borderRadius: 16, padding: 14, marginBottom: 10, borderWidth: 1, borderColor: colors.line },
  id: { fontWeight: '800', color: colors.ink, fontSize: 16 },
  status: { color: colors.green, fontWeight: '800' },
  meta: { color: colors.muted, marginTop: 4 },
  total: { fontWeight: '700', marginTop: 8, color: colors.ink },
  link: { color: colors.green, fontWeight: '700', marginTop: 8 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 8, padding: 24, backgroundColor: colors.cream },
  eta: { fontWeight: '700', color: colors.greenDark, marginVertical: 8 },
  track: { flexDirection: 'row', marginVertical: 16 },
  step: { flex: 1, alignItems: 'center' },
  dot: { width: 14, height: 14, borderRadius: 7, backgroundColor: colors.line, zIndex: 1 },
  dotOn: { backgroundColor: colors.green },
  bar: { position: 'absolute', top: 6, left: '50%', right: -20, height: 2, backgroundColor: colors.line },
  barOn: { backgroundColor: colors.green },
  stepT: { fontSize: 10, textAlign: 'center', marginTop: 8, color: colors.muted },
  item: { flexDirection: 'row', gap: 10, backgroundColor: '#fff', padding: 10, borderRadius: 12, marginBottom: 8, alignItems: 'center' },
  img: { width: 54, height: 54, borderRadius: 10 },
  bill: { backgroundColor: '#fff', padding: 14, borderRadius: 14, marginVertical: 12, gap: 4 },
  ok: { fontSize: 24, fontWeight: '800', color: colors.ink },
});
