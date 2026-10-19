import React, { useState } from 'react';
import { Alert, Linking, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { colors } from '../theme';
import { faqs, policies } from '../data';
import { GhostButton, PrimaryButton } from '../ui';
import { useStore } from '../store';
import { RootStackParamList } from '../navigation';

export default function AccountScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  const { user, logout, wishlist, orders } = useStore();
  const rows: { icon: keyof typeof Ionicons.glyphMap; label: string; onPress: () => void }[] = [
    { icon: 'person-outline', label: 'Edit profile', onPress: () => nav.navigate('ProfileEdit') },
    { icon: 'heart-outline', label: `Wishlist (${wishlist.length})`, onPress: () => nav.navigate('Wishlist') },
    { icon: 'receipt-outline', label: `My orders (${orders.length})`, onPress: () => nav.navigate('Main', { screen: 'Orders' }) },
    { icon: 'location-outline', label: 'Saved addresses', onPress: () => nav.navigate('AddressForm') },
    { icon: 'notifications-outline', label: 'Notifications', onPress: () => nav.navigate('Notifications') },
    { icon: 'chatbubbles-outline', label: 'FAQs', onPress: () => nav.navigate('Faq') },
    { icon: 'information-circle-outline', label: 'About us', onPress: () => nav.navigate('About') },
    { icon: 'call-outline', label: 'Contact', onPress: () => nav.navigate('Contact') },
    { icon: 'refresh-outline', label: 'Refund policy', onPress: () => nav.navigate('Policy', { type: 'refund' }) },
    { icon: 'bicycle-outline', label: 'Shipping policy', onPress: () => nav.navigate('Policy', { type: 'shipping' }) },
    { icon: 'shield-outline', label: 'Privacy policy', onPress: () => nav.navigate('Policy', { type: 'privacy' }) },
    { icon: 'document-text-outline', label: 'Terms & conditions', onPress: () => nav.navigate('Policy', { type: 'terms' }) },
  ];
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16, paddingBottom: 36 }}>
      <View style={styles.hero}>
        <View style={styles.avatar}>
          <Text style={{ color: '#fff', fontWeight: '800', fontSize: 22 }}>{(user?.name ?? 'G')[0]}</Text>
        </View>
        <Text style={styles.name}>{user?.name}</Text>
        <Text style={styles.meta}>{user?.email}</Text>
        <Text style={styles.meta}>{user?.phone}</Text>
      </View>
      {rows.map((r) => (
        <Pressable key={r.label} onPress={r.onPress} style={styles.row}>
          <Ionicons name={r.icon} size={18} color={colors.green} />
          <Text style={styles.rowT}>{r.label}</Text>
          <Ionicons name="chevron-forward" size={16} color={colors.muted} />
        </Pressable>
      ))}
      <View style={{ height: 12 }} />
      <GhostButton label="Log out" onPress={logout} />
      <Text style={styles.foot}>© 2026 Asian Stores · Demo by conversion of asianstores.in</Text>
    </ScrollView>
  );
}

export function ProfileEditScreen() {
  const nav = useNavigation();
  const { user, updateProfile } = useStore();
  const [name, setName] = useState(user?.name ?? '');
  const [email, setEmail] = useState(user?.email ?? '');
  const [phone, setPhone] = useState(user?.phone ?? '');
  return (
    <View style={{ flex: 1, backgroundColor: colors.cream, padding: 16, gap: 10 }}>
      <TextInput value={name} onChangeText={setName} style={styles.input} placeholder="Name" />
      <TextInput value={email} onChangeText={setEmail} style={styles.input} placeholder="Email" />
      <TextInput value={phone} onChangeText={setPhone} style={styles.input} placeholder="Phone" />
      <PrimaryButton
        label="Save profile"
        onPress={() => {
          updateProfile({ name, email, phone });
          Alert.alert('Saved', 'Demo profile updated in memory.');
          nav.goBack();
        }}
      />
    </View>
  );
}

export function FaqScreen() {
  const [open, setOpen] = useState<string | null>(faqs[0].q);
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      {faqs.map((f) => (
        <Pressable key={f.q} onPress={() => setOpen(open === f.q ? null : f.q)} style={styles.faq}>
          <Text style={styles.name}>{f.q}</Text>
          {open === f.q ? <Text style={styles.meta}>{f.a}</Text> : null}
        </Pressable>
      ))}
    </ScrollView>
  );
}

export function AboutScreen() {
  const nav = useNavigation<NativeStackNavigationProp<RootStackParamList>>();
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      <Text style={styles.name}>Nature's Promise Delivered</Text>
      <Text style={[styles.meta, { lineHeight: 22, marginTop: 10 }]}>
        Experience the purity of farm-fresh ingredients. We bridge the gap between rural goodness and your modern lifestyle.
        Asian Stores is i2 Agro Products Private Limited — quality since 2002.
      </Text>
      {[
        { t: 'Premium Quality', s: 'Handpicked groceries ensuring 100% purity.' },
        { t: 'Swift Delivery', s: 'Doorstep dispatch in 24–48 hours.' },
        { t: 'Best Price', s: 'Cash price on every pack, direct to you.' },
      ].map((b) => (
        <Pressable key={b.t} onPress={() => nav.navigate('Main', { screen: 'Shop' })} style={styles.faq}>
          <Text style={styles.name}>{b.t}</Text>
          <Text style={styles.meta}>{b.s}</Text>
          <Text style={{ color: colors.green, fontWeight: '700', marginTop: 6 }}>Shop now</Text>
        </Pressable>
      ))}
      <PrimaryButton label="Contact studio" onPress={() => nav.navigate('Contact')} />
    </ScrollView>
  );
}

export function ContactScreen() {
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16, gap: 10 }}>
      <Text style={styles.name}>Get in touch</Text>
      <Pressable onPress={() => Linking.openURL('tel:+918825604253')} style={styles.faq}>
        <Text style={styles.name}>+91 8825604253</Text>
        <Text style={styles.meta}>Tap to call (device)</Text>
      </Pressable>
      <Pressable onPress={() => Linking.openURL('mailto:sales@asianstores.in')} style={styles.faq}>
        <Text style={styles.name}>sales@asianstores.in</Text>
        <Text style={styles.meta}>Tap to email</Text>
      </Pressable>
      <Pressable onPress={() => Linking.openURL('https://wa.me/918825604253')} style={styles.faq}>
        <Text style={styles.name}>WhatsApp support</Text>
        <Text style={styles.meta}>Place demo enquiry on WhatsApp</Text>
      </Pressable>
      <View style={styles.faq}>
        <Text style={styles.name}>Studio address</Text>
        <Text style={styles.meta}>
          Asian Stores, i2Agro Products Private Limited, G-2, Saravana Flat, 259/54, Plot no: 74, Chandrasekaran Nagar,
          Okkiyam Thuraipakkam, Chennai-600097.
        </Text>
      </View>
    </ScrollView>
  );
}

export function PolicyScreen() {
  const { type } = useRoute<any>().params as { type: keyof typeof policies };
  const title = { refund: 'Refund policy', shipping: 'Shipping policy', privacy: 'Privacy policy', terms: 'Terms & conditions' }[type];
  return (
    <ScrollView style={{ flex: 1, backgroundColor: colors.cream }} contentContainerStyle={{ padding: 16 }}>
      <Text style={styles.name}>{title}</Text>
      <Text style={[styles.meta, { lineHeight: 22, marginTop: 12 }]}>{policies[type]}</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  hero: { backgroundColor: colors.green, borderRadius: 20, padding: 18, alignItems: 'center', marginBottom: 12 },
  avatar: { width: 64, height: 64, borderRadius: 32, backgroundColor: colors.greenDark, alignItems: 'center', justifyContent: 'center' },
  name: { fontWeight: '800', color: colors.ink, fontSize: 16, marginTop: 8 },
  meta: { color: colors.muted, marginTop: 4 },
  row: { flexDirection: 'row', alignItems: 'center', gap: 10, backgroundColor: '#fff', padding: 14, borderRadius: 14, marginBottom: 8, borderWidth: 1, borderColor: colors.line },
  rowT: { flex: 1, fontWeight: '700', color: colors.ink },
  foot: { textAlign: 'center', color: colors.muted, marginTop: 16, fontSize: 12 },
  input: { height: 46, borderWidth: 1, borderColor: colors.line, borderRadius: 12, paddingHorizontal: 12, backgroundColor: '#fff', color: colors.ink },
  faq: { backgroundColor: '#fff', padding: 14, borderRadius: 14, marginBottom: 10, borderWidth: 1, borderColor: colors.line },
});
