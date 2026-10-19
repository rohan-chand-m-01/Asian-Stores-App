import React, { useState } from 'react';
import { Alert, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { colors } from '../theme';
import { deliveryZones } from '../data';
import { formatInr, PrimaryButton } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';

const pays = ['Cash on delivery', 'UPI', 'Card'] as const;

export default function CheckoutScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { cart, totals, addresses, selectedAddressId, setSelectedAddressId, coupon, applyCoupon, removeCoupon, placeOrder } =
    useStore();
  const [code, setCode] = useState(coupon);
  const [pay, setPay] = useState<(typeof pays)[number]>('Cash on delivery');
  const [upi, setUpi] = useState('priya@oksbi');
  const [card, setCard] = useState('4111 1111 1111 1111');

  const address = addresses.find((a) => a.id === selectedAddressId)!;
  const zoneOk = deliveryZones.some((z) => address.pincode === z.pincode);

  const payNow = () => {
    if (!cart.length) return Alert.alert('Basket', 'Add products first');
    if (!zoneOk) return Alert.alert('Delivery area', 'This pincode is outside Perungudi, Thuraipakkam and Karapakkam.');
    if (pay === 'UPI' && !upi.includes('@')) return Alert.alert('UPI', 'Enter a demo UPI id like priya@oksbi');
    if (pay === 'Card' && card.replace(/\s/g, '').length < 16) return Alert.alert('Card', 'Enter the demo card 4111 1111 1111 1111');
    const order = placeOrder(pay);
    nav.replace('Success', { orderId: order.id });
  };

  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16, paddingBottom: 40 }}>
      <Text style={styles.h}>Delivery address</Text>
      {addresses.map((a) => (
        <Pressable key={a.id} onPress={() => setSelectedAddressId(a.id)} style={[styles.box, selectedAddressId === a.id && styles.boxOn]}>
          <Text style={styles.name}>{a.label} · {a.name}</Text>
          <Text style={styles.meta}>{a.line}</Text>
          <Text style={styles.meta}>{a.area} — {a.pincode}</Text>
        </Pressable>
      ))}
      <Pressable onPress={() => nav.navigate('AddressForm')} style={{ marginBottom: 16 }}>
        <Text style={styles.link}>+ Add new address</Text>
      </Pressable>
      {!zoneOk ? (
        <View style={styles.warn}>
          <Text style={styles.warnT}>Orders outside supported Chennai zones are flagged at checkout, same as the website.</Text>
        </View>
      ) : null}

      <Text style={styles.h}>Coupon</Text>
      <View style={styles.couponChips}>
        {[
          { c: 'WELCOME', l: 'WELCOME (10% off)' },
          { c: 'ASIAN50', l: 'ASIAN50 (Flat ₹50)' },
          { c: 'CHARITY', l: 'CHARITY (₹20 extra)' },
        ].map((cp) => (
          <Pressable
            key={cp.c}
            onPress={() => {
              setCode(cp.c);
              const msg = applyCoupon(cp.c);
              Alert.alert('Coupon Applied', msg);
            }}
            style={[styles.chip, coupon === cp.c && styles.chipActive]}
          >
            <Text style={[styles.chipText, coupon === cp.c && styles.chipTextActive]}>
              {coupon === cp.c ? `✓ ${cp.c}` : `+ ${cp.l}`}
            </Text>
          </Pressable>
        ))}
      </View>
      <View style={styles.couponRow}>
        <TextInput
          value={code}
          onChangeText={setCode}
          autoCapitalize="characters"
          placeholder="Enter coupon code"
          style={styles.input}
        />
        <Pressable
          onPress={() => Alert.alert('Coupon', applyCoupon(code))}
          style={styles.apply}
        >
          <Text style={{ color: '#fff', fontWeight: '800' }}>Apply</Text>
        </Pressable>
      </View>
      {coupon ? (
        <Pressable onPress={removeCoupon} style={{ marginBottom: 12 }}>
          <Text style={styles.removeLink}>Remove applied coupon ({coupon})</Text>
        </Pressable>
      ) : null}

      <Text style={styles.h}>Payment</Text>
      {pays.map((p) => (
        <Pressable key={p} onPress={() => setPay(p)} style={[styles.box, pay === p && styles.boxOn]}>
          <Text style={styles.name}>{p}</Text>
        </Pressable>
      ))}
      {pay === 'UPI' ? <TextInput value={upi} onChangeText={setUpi} style={styles.input} placeholder="UPI ID" /> : null}
      {pay === 'Card' ? <TextInput value={card} onChangeText={setCard} style={styles.input} placeholder="Card number" /> : null}

      <View style={styles.bill}>
        <Row k="Items" v={formatInr(totals.subtotal)} />
        <Row k="Delivery" v={totals.delivery === 0 ? 'FREE' : formatInr(totals.delivery)} />
        <Row k="Discount" v={totals.discount ? `- ${formatInr(totals.discount)}` : '—'} />
        <Row k="Charity note" v={`₹${totals.charity} demo pledge`} />
        <View style={styles.hr} />
        <Row k="To pay" v={formatInr(totals.total)} bold />
      </View>
      <PrimaryButton label={`Place order · ${formatInr(totals.total)}`} onPress={payNow} />
    </ScrollView>
  );
}

function Row({ k, v, bold }: { k: string; v: string; bold?: boolean }) {
  return (
    <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginBottom: 8 }}>
      <Text style={{ color: colors.muted, fontWeight: bold ? '800' : '500' }}>{k}</Text>
      <Text style={{ color: colors.ink, fontWeight: bold ? '800' : '600' }}>{v}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  h: { fontWeight: '800', fontSize: 16, color: colors.ink, marginBottom: 8, marginTop: 8 },
  box: { backgroundColor: '#fff', borderRadius: 14, padding: 12, marginBottom: 8, borderWidth: 1, borderColor: colors.line },
  boxOn: { borderColor: colors.green, backgroundColor: colors.greenSoft },
  name: { fontWeight: '800', color: colors.ink },
  meta: { color: colors.muted, marginTop: 4, fontSize: 12 },
  link: { color: colors.green, fontWeight: '700' },
  warn: { backgroundColor: colors.amberBg, padding: 12, borderRadius: 12, marginBottom: 12 },
  warnT: { color: colors.danger, fontWeight: '600' },
  couponChips: { flexDirection: 'row', flexWrap: 'wrap', gap: 6, marginBottom: 10 },
  chip: {
    backgroundColor: '#fff',
    borderWidth: 1,
    borderColor: colors.line,
    borderRadius: 14,
    paddingHorizontal: 10,
    paddingVertical: 6,
  },
  chipActive: {
    backgroundColor: colors.greenSoft,
    borderColor: colors.green,
  },
  chipText: {
    fontSize: 11,
    fontWeight: '700',
    color: colors.muted,
  },
  chipTextActive: {
    color: colors.greenDark,
  },
  removeLink: { color: colors.danger, fontWeight: '700', fontSize: 13 },
  couponRow: { flexDirection: 'row', gap: 8, marginBottom: 8 },
  input: { flex: 1, height: 46, borderWidth: 1, borderColor: colors.line, borderRadius: 12, paddingHorizontal: 12, backgroundColor: '#fff', color: colors.ink, marginBottom: 8 },
  apply: { backgroundColor: colors.green, borderRadius: 12, paddingHorizontal: 16, justifyContent: 'center' },
  bill: { backgroundColor: '#fff', borderRadius: 16, padding: 14, marginVertical: 16, borderWidth: 1, borderColor: colors.line },
  hr: { height: 1, backgroundColor: colors.line, marginVertical: 8 },
});
