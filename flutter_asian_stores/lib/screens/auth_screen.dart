import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _mode = 'login'; // login, register, otp, forgot
  final _emailCtrl = TextEditingController(text: 'demo@asianstores.in');
  final _phoneCtrl = TextEditingController(text: '8825604253');
  final _passCtrl = TextEditingController(text: 'asian123');
  final _nameCtrl = TextEditingController(text: 'Priya S.');
  final _otpCtrl = TextEditingController(text: '4821');
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Hero
            Container(
              width: double.infinity,
              color: AppColors.green,
              padding: const EdgeInsets.only(top: 60, bottom: 36),
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'i2',
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ASIAN STORES',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Premium Quality Groceries',
                    style: TextStyle(color: Color(0xFFD7F3E0), fontSize: 13),
                  ),
                ],
              ),
            ),

            // Card
            Transform.translate(
              offset: const Offset(0, -18),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.greenSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _mode = 'login'),
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _mode == 'login' ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _mode == 'login' ? AppColors.greenDark : AppColors.muted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _mode = 'register'),
                              child: Container(
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _mode == 'register' ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _mode == 'register' ? AppColors.greenDark : AppColors.muted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quick 1-Tap Demo Login
                    GestureDetector(
                      onTap: () {
                        final err = store.login('demo@asianstores.in', 'asian123');
                        if (err != null) _showMsg(err);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.greenSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBBE2C6)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.flash_on, size: 16, color: AppColors.greenDark),
                            SizedBox(width: 6),
                            Text(
                              '1-Tap Demo Login (Priya S.)',
                              style: TextStyle(
                                color: AppColors.greenDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (_mode == 'register') ...[
                      _buildTextField('Full name', _nameCtrl),
                      const SizedBox(height: 12),
                    ],

                    _buildTextField(
                      _mode == 'otp' ? 'Mobile number' : 'Email or mobile',
                      _mode == 'otp' ? _phoneCtrl : _emailCtrl,
                    ),
                    const SizedBox(height: 12),

                    if (_mode == 'register') ...[
                      _buildTextField('Mobile', _phoneCtrl, keyboardType: TextInputType.phone),
                      const SizedBox(height: 12),
                    ],

                    if (_mode == 'otp') ...[
                      _buildTextField('OTP (Demo: 4821)', _otpCtrl, keyboardType: TextInputType.number),
                      const SizedBox(height: 12),
                    ] else if (_mode == 'forgot') ...[
                      const Text(
                        'Demo reset link will be sent. Demo password remains asian123.',
                        style: TextStyle(color: AppColors.muted, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      _buildPasswordField(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => _mode = 'forgot'),
                          child: const Text('Forgot password?', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Primary Action Button
                    ElevatedButton(
                      onPressed: () {
                        if (_mode == 'login') {
                          final err = store.login(_emailCtrl.text, _passCtrl.text);
                          if (err != null) _showMsg(err);
                        } else if (_mode == 'register') {
                          final err = store.register(_nameCtrl.text, _emailCtrl.text, _phoneCtrl.text, _passCtrl.text);
                          if (err != null) _showMsg(err);
                        } else if (_mode == 'otp') {
                          if (_otpCtrl.text.length < 4) {
                            _showMsg('Enter demo OTP 4821');
                            return;
                          }
                          final err = store.login(_phoneCtrl.text, 'asian123');
                          if (err != null) _showMsg(err);
                        } else {
                          _showMsg('Reset simulated! Logging you in with demo password.');
                          setState(() => _mode = 'login');
                        }
                      },
                      child: Text(
                        _mode == 'login'
                            ? 'Login'
                            : _mode == 'register'
                                ? 'Create Account'
                                : _mode == 'otp'
                                    ? 'Verify OTP'
                                    : 'Send Reset Link',
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Continue as Guest
                    OutlinedButton(
                      onPressed: store.continueGuest,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.line),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Continue as guest', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.line)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('or', style: TextStyle(color: AppColors.muted)),
                        ),
                        Expanded(child: Divider(color: AppColors.line)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Google Login Demo
                    OutlinedButton.icon(
                      onPressed: () {
                        _showMsg('Signed in with Google (Demo)');
                        store.continueGuest();
                      },
                      icon: const Icon(Icons.g_mobiledata, size: 24, color: AppColors.green),
                      label: const Text('Continue with Google', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.line),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // OTP Option
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _mode = 'otp'),
                      icon: const Icon(Icons.phone_iphone, size: 18, color: AppColors.green),
                      label: const Text('Login with OTP', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.line),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),

                    const SizedBox(height: 14),
                    const Center(
                      child: Text(
                        'Demo: demo@asianstores.in / asian123',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cream,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.muted)),
        const SizedBox(height: 6),
        TextField(
          controller: _passCtrl,
          obscureText: _obscurePass,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.cream,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.line)),
            suffixIcon: IconButton(
              icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: AppColors.muted, size: 20),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
          ),
        ),
      ],
    );
  }
}
