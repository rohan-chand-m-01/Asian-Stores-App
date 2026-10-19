import React, { useState } from 'react';
import { Alert, KeyboardAvoidingView, Platform, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { colors, demoAuth } from '../theme';
import { GhostButton, PrimaryButton } from '../ui';
import { useStore } from '../store';

export default function AuthScreen() {
  const { login, register, continueGuest } = useStore();
  const [mode, setMode] = useState<'login' | 'register' | 'otp' | 'forgot'>('login');
  const [email, setEmail] = useState(demoAuth.email);
  const [phone, setPhone] = useState(demoAuth.phone);
  const [password, setPassword] = useState(demoAuth.password);
  const [name, setName] = useState('Priya S.');
  const [otp, setOtp] = useState('4821');
  const [show, setShow] = useState(false);

  const onLogin = () => {
    const err = login(email || phone, password);
    if (err) Alert.alert('Login', err);
  };

  const onRegister = () => {
    const err = register(name, email, phone, password);
    if (err) Alert.alert('Create account', err);
  };

  return (
    <KeyboardAvoidingView style={{ flex: 1, backgroundColor: colors.cream }} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <View style={styles.hero}>
          <Text style={styles.logoMark}>i2</Text>
          <Text style={styles.brand}>ASIAN STORES</Text>
          <Text style={styles.sub}>Premium Quality Groceries</Text>
        </View>

        <View style={styles.card}>
          <View style={styles.tabs}>
            {(['login', 'register'] as const).map((m) => (
              <Pressable key={m} onPress={() => setMode(m)} style={[styles.tab, mode === m && styles.tabOn]}>
                <Text style={[styles.tabText, mode === m && styles.tabTextOn]}>{m === 'login' ? 'Login' : 'Register'}</Text>
              </Pressable>
            ))}
          </View>

          <Pressable
            onPress={() => {
              const err = login(demoAuth.email, demoAuth.password);
              if (err) Alert.alert('Demo Login', err);
            }}
            style={styles.quickLogin}
          >
            <Ionicons name="flash" size={16} color={colors.greenDark} />
            <Text style={styles.quickLoginText}>1-Tap Demo Login (Priya S.)</Text>
          </Pressable>

          {mode === 'register' ? (
            <Field label="Full name" value={name} onChangeText={setName} />
          ) : null}
          <Field
            label={mode === 'otp' ? 'Mobile number' : 'Email or mobile'}
            value={mode === 'otp' ? phone : email}
            onChangeText={mode === 'otp' ? setPhone : setEmail}
            keyboardType="email-address"
          />
          {mode === 'register' ? <Field label="Mobile" value={phone} onChangeText={setPhone} keyboardType="phone-pad" /> : null}

          {mode === 'otp' ? (
            <Field label="OTP (demo auto-filled)" value={otp} onChangeText={setOtp} keyboardType="number-pad" />
          ) : mode === 'forgot' ? (
            <Text style={styles.hint}>We’ll send a reset link to {email}. Demo password stays asian123.</Text>
          ) : (
            <View>
              <Text style={styles.label}>Password</Text>
              <View style={styles.passRow}>
                <TextInput
                  value={password}
                  onChangeText={setPassword}
                  secureTextEntry={!show}
                  style={[styles.input, { flex: 1, marginBottom: 0, borderWidth: 0 }]}
                />
                <Pressable onPress={() => setShow((s) => !s)} style={{ padding: 8 }}>
                  <Ionicons name={show ? 'eye-off' : 'eye'} size={18} color={colors.muted} />
                </Pressable>
              </View>
            </View>
          )}

          {mode === 'login' ? (
            <Pressable onPress={() => setMode('forgot')} style={{ alignSelf: 'flex-end', marginBottom: 12 }}>
              <Text style={styles.link}>Forgot password?</Text>
            </Pressable>
          ) : null}

          {mode === 'login' ? (
            <PrimaryButton label="Login" onPress={onLogin} />
          ) : mode === 'register' ? (
            <PrimaryButton label="Create account" onPress={onRegister} />
          ) : mode === 'otp' ? (
            <PrimaryButton
              label="Verify OTP"
              onPress={() => {
                if (otp.length < 4) return Alert.alert('OTP', 'Enter the 4-digit demo OTP 4821');
                const err = login(phone, 'asian123');
                if (err) Alert.alert('OTP', err);
              }}
            />
          ) : (
            <PrimaryButton
              label="Send reset link"
              onPress={() => {
                Alert.alert('Reset sent', 'Demo only — password is asian123. You can login now.');
                setMode('login');
                setPassword('asian123');
              }}
            />
          )}

          <View style={{ height: 10 }} />
          <GhostButton label="Continue as guest" onPress={continueGuest} />

          <View style={styles.orRow}>
            <View style={styles.line} />
            <Text style={styles.or}>or</Text>
            <View style={styles.line} />
          </View>
          <Pressable
            onPress={() => {
              Alert.alert('Google (demo)', 'Signed in with the demo Asian Stores account.');
              continueGuest();
            }}
            style={styles.social}
          >
            <Ionicons name="logo-google" size={18} color={colors.green} />
            <Text style={styles.socialText}>Continue with Google</Text>
          </Pressable>
          <Pressable onPress={() => setMode('otp')} style={styles.social}>
            <Ionicons name="call-outline" size={18} color={colors.green} />
            <Text style={styles.socialText}>Login with OTP</Text>
          </Pressable>
          <Text style={styles.demo}>Demo login: demo@asianstores.in / asian123</Text>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

function Field(props: {
  label: string;
  value: string;
  onChangeText: (t: string) => void;
  keyboardType?: 'email-address' | 'phone-pad' | 'number-pad' | 'default';
}) {
  return (
    <View style={{ marginBottom: 12 }}>
      <Text style={styles.label}>{props.label}</Text>
      <TextInput
        value={props.value}
        onChangeText={props.onChangeText}
        keyboardType={props.keyboardType}
        autoCapitalize="none"
        style={styles.input}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: { paddingBottom: 40 },
  hero: { backgroundColor: colors.green, paddingTop: 56, paddingBottom: 36, alignItems: 'center' },
  logoMark: {
    width: 54,
    height: 54,
    borderRadius: 16,
    backgroundColor: '#fff',
    color: colors.green,
    textAlign: 'center',
    textAlignVertical: 'center',
    fontWeight: '800',
    fontSize: 20,
    overflow: 'hidden',
    lineHeight: 54,
  },
  brand: { color: '#fff', fontSize: 22, fontWeight: '800', marginTop: 10 },
  sub: { color: '#D7F3E0', marginTop: 4 },
  card: { marginTop: -18, backgroundColor: '#fff', marginHorizontal: 16, borderRadius: 20, padding: 18, elevation: 3 },
  tabs: { flexDirection: 'row', backgroundColor: colors.greenSoft, borderRadius: 12, padding: 4, marginBottom: 16 },
  tab: { flex: 1, height: 36, alignItems: 'center', justifyContent: 'center', borderRadius: 10 },
  tabOn: { backgroundColor: '#fff' },
  tabText: { color: colors.muted, fontWeight: '700' },
  tabTextOn: { color: colors.greenDark },
  quickLogin: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
    backgroundColor: '#E8F5EC',
    borderWidth: 1,
    borderColor: '#BBE2C6',
    borderRadius: 12,
    paddingVertical: 10,
    marginBottom: 16,
  },
  quickLoginText: {
    color: colors.greenDark,
    fontWeight: '800',
    fontSize: 13,
  },
  label: { fontSize: 12, color: colors.muted, marginBottom: 6, fontWeight: '600' },
  input: {
    borderWidth: 1,
    borderColor: colors.line,
    borderRadius: 12,
    height: 46,
    paddingHorizontal: 12,
    color: colors.ink,
    marginBottom: 4,
    backgroundColor: colors.cream,
  },
  passRow: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.line,
    borderRadius: 12,
    backgroundColor: colors.cream,
    marginBottom: 8,
  },
  link: { color: colors.green, fontWeight: '700' },
  hint: { color: colors.muted, marginBottom: 12, lineHeight: 20 },
  orRow: { flexDirection: 'row', alignItems: 'center', gap: 8, marginVertical: 14 },
  line: { flex: 1, height: 1, backgroundColor: colors.line },
  or: { color: colors.muted },
  social: {
    flexDirection: 'row',
    gap: 8,
    height: 46,
    borderWidth: 1,
    borderColor: colors.line,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 8,
  },
  socialText: { fontWeight: '700', color: colors.ink },
  demo: { textAlign: 'center', color: colors.muted, fontSize: 12, marginTop: 8 },
});
