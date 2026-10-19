import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;

  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _bounceAnim;
  late Animation<double> _lidAnim;
  late Animation<double> _itemsAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _bounceAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.45, curve: Curves.elasticOut),
      ),
    );

    _lidAnim = Tween<double>(begin: 0.0, end: -0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    _itemsAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.90, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: GestureDetector(
        onTap: widget.onDone,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: widget.onDone,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Skip ›',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'PREMIUM QUALITY GROCERIES · SINCE 2002',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'ASIAN STORES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'CHENNAI · OKKIYAM THURAIPAKKAM',
                          style: TextStyle(
                            color: Color(0xFFD7F3E0),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Transform.scale(
                          scale: _bounceAnim.value,
                          child: SizedBox(
                            width: 170,
                            height: 150,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Floating Items
                                Positioned(
                                  top: 30 - (_itemsAnim.value * 40),
                                  left: 20,
                                  child: Opacity(
                                    opacity: _itemsAnim.value,
                                    child: const Text('🌾', style: TextStyle(fontSize: 26)),
                                  ),
                                ),
                                Positioned(
                                  top: 30 - (_itemsAnim.value * 50),
                                  right: 20,
                                  child: Opacity(
                                    opacity: _itemsAnim.value,
                                    child: const Text('🫒', style: TextStyle(fontSize: 26)),
                                  ),
                                ),
                                Positioned(
                                  top: 30 - (_itemsAnim.value * 60),
                                  left: 70,
                                  child: Opacity(
                                    opacity: _itemsAnim.value,
                                    child: const Text('🌶️', style: TextStyle(fontSize: 26)),
                                  ),
                                ),
                                Positioned(
                                  top: 30 - (_itemsAnim.value * 45),
                                  right: 55,
                                  child: Opacity(
                                    opacity: _itemsAnim.value,
                                    child: const Text('🥥', style: TextStyle(fontSize: 24)),
                                  ),
                                ),

                                // Basket Lid
                                Positioned(
                                  top: 25,
                                  child: Transform.rotate(
                                    angle: _lidAnim.value,
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      width: 140,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFC9842A),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Basket Body
                                Positioned(
                                  top: 38,
                                  child: Container(
                                    width: 146,
                                    height: 92,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE39B3A),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(22),
                                        bottomRight: Radius.circular(22),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Wicker weave lines
                                        Positioned(
                                          top: 10,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 8,
                                            color: const Color(0xFFF3C56A).withOpacity(0.55),
                                          ),
                                        ),
                                        Positioned(
                                          top: 24,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 8,
                                            color: const Color(0xFFF3C56A).withOpacity(0.55),
                                          ),
                                        ),
                                        Positioned(
                                          top: 38,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 8,
                                            color: const Color(0xFFF3C56A).withOpacity(0.55),
                                          ),
                                        ),
                                        Positioned(
                                          top: 52,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 8,
                                            color: const Color(0xFFF3C56A).withOpacity(0.55),
                                          ),
                                        ),
                                        // Handles
                                        Positioned(
                                          left: 18,
                                          top: -8,
                                          child: Container(
                                            width: 10,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF8D4F12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 18,
                                          top: -8,
                                          child: Container(
                                            width: 10,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF8D4F12),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Opening your grocery basket…',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tap anywhere to continue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
