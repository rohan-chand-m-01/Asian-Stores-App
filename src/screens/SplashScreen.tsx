import React, { useEffect, useRef } from 'react';
import { Animated, Easing, Pressable, StyleSheet, Text, View } from 'react-native';
import { colors } from '../theme';

export default function SplashScreen({ onDone }: { onDone: () => void }) {
  const lid = useRef(new Animated.Value(0)).current;
  const bounce = useRef(new Animated.Value(0)).current;
  const items = useRef(new Animated.Value(0)).current;
  const fade = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    const anim = Animated.sequence([
      Animated.timing(fade, { toValue: 1, duration: 400, useNativeDriver: true }),
      Animated.spring(bounce, { toValue: 1, friction: 5, useNativeDriver: true }),
      Animated.timing(lid, {
        toValue: 1,
        duration: 700,
        easing: Easing.out(Easing.cubic),
        useNativeDriver: true,
      }),
      Animated.timing(items, { toValue: 1, duration: 600, useNativeDriver: true }),
      Animated.delay(800),
    ]);
    anim.start(() => onDone());
    return () => anim.stop();
  }, [bounce, fade, items, lid, onDone]);

  const lidRotate = lid.interpolate({ inputRange: [0, 1], outputRange: ['0deg', '-55deg'] });
  const bagScale = bounce.interpolate({ inputRange: [0, 1], outputRange: [0.7, 1] });

  return (
    <Pressable onPress={onDone} style={styles.wrap}>
      <Pressable onPress={onDone} style={styles.skipBtn}>
        <Text style={styles.skipText}>Skip ›</Text>
      </Pressable>
      <Animated.View style={{ opacity: fade, alignItems: 'center' }}>
        <Text style={styles.kicker}>PREMIUM QUALITY GROCERIES · SINCE 2002</Text>
        <Text style={styles.brand}>ASIAN STORES</Text>
        <Text style={styles.location}>CHENNAI · OKKIYAM THURAIPAKKAM</Text>
        <Animated.View style={{ transform: [{ scale: bagScale }], marginTop: 28 }}>
          <View style={styles.basket}>
            <Animated.View style={[styles.lid, { transform: [{ rotate: lidRotate }, { translateY: -2 }] }]} />
            <View style={styles.body}>
              <View style={styles.weave} />
              <View style={[styles.weave, { top: 18 }]} />
              <View style={[styles.weave, { top: 36 }]} />
              <View style={styles.handleL} />
              <View style={styles.handleR} />
            </View>
            <Animated.Text
              style={[
                styles.item,
                {
                  left: 14,
                  opacity: items,
                  transform: [
                    { translateY: items.interpolate({ inputRange: [0, 1], outputRange: [10, -32] }) },
                  ],
                },
              ]}
            >
              🌾
            </Animated.Text>
            <Animated.Text
              style={[
                styles.item,
                {
                  right: 14,
                  opacity: items,
                  transform: [
                    { translateY: items.interpolate({ inputRange: [0, 1], outputRange: [12, -36] }) },
                  ],
                },
              ]}
            >
              🫒
            </Animated.Text>
            <Animated.Text
              style={[
                styles.item,
                {
                  left: 54,
                  opacity: items,
                  transform: [
                    { translateY: items.interpolate({ inputRange: [0, 1], outputRange: [8, -48] }) },
                  ],
                },
              ]}
            >
              🌶️
            </Animated.Text>
            <Animated.Text
              style={[
                styles.item,
                {
                  right: 48,
                  opacity: items,
                  transform: [
                    { translateY: items.interpolate({ inputRange: [0, 1], outputRange: [14, -28] }) },
                  ],
                },
              ]}
            >
              🥥
            </Animated.Text>
          </View>
        </Animated.View>
        <Text style={styles.tag}>Opening your grocery basket…</Text>
        <Text style={styles.subtag}>Tap anywhere to continue</Text>
      </Animated.View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  wrap: { flex: 1, backgroundColor: colors.green, alignItems: 'center', justifyContent: 'center' },
  kicker: { color: '#FFFFFF', letterSpacing: 2, fontSize: 11, fontWeight: '700' },
  brand: { color: '#fff', fontSize: 28, fontWeight: '800', marginTop: 6, textShadowColor: 'rgba(0,0,0,0.2)', textShadowRadius: 4 },
  basket: { width: 160, height: 150, alignItems: 'center' },
  lid: {
    width: 132,
    height: 18,
    backgroundColor: '#C9842A',
    borderRadius: 8,
    zIndex: 2,
  },
  body: {
    width: 140,
    height: 88,
    backgroundColor: '#E39B3A',
    borderBottomLeftRadius: 18,
    borderBottomRightRadius: 18,
    overflow: 'hidden',
    marginTop: -4,
  },
  weave: {
    position: 'absolute',
    left: 0,
    right: 0,
    height: 8,
    backgroundColor: '#F3C56A',
    opacity: 0.55,
    top: 8,
  },
  handleL: {
    position: 'absolute',
    width: 10,
    height: 34,
    backgroundColor: '#8D4F12',
    left: 18,
    top: -8,
    borderRadius: 6,
  },
  handleR: {
    position: 'absolute',
    width: 10,
    height: 34,
    backgroundColor: '#8D4F12',
    right: 18,
    top: -8,
    borderRadius: 6,
  },
  item: { position: 'absolute', top: 20, fontSize: 22 },
  tag: { color: '#FFFFFF', marginTop: 24, fontWeight: '700', fontSize: 14 },
  subtag: { color: 'rgba(255,255,255,0.7)', marginTop: 6, fontSize: 12, fontWeight: '500' },
  location: { color: '#D7F3E0', fontSize: 11, fontWeight: '700', letterSpacing: 1.5, marginTop: 4 },
  skipBtn: {
    position: 'absolute',
    top: 50,
    right: 20,
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: 'rgba(255,255,255,0.2)',
    zIndex: 10,
  },
  skipText: { color: '#fff', fontWeight: '700', fontSize: 13 },
});
