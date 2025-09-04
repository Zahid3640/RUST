import 'dart:developer';
import 'package:crpto_wallet/Token/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:crpto_wallet/services/wallet_service.dart';

class UnlockWalletScreen extends StatefulWidget {
  const UnlockWalletScreen({super.key});
  @override
  State<UnlockWalletScreen> createState() => _UnlockWalletScreenState();
}

class _UnlockWalletScreenState extends State<UnlockWalletScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isChecked = false;

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
    String hint,
    bool isVisible,
    VoidCallback toggleVisibility,
    bool isFocused,
    String text,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1C1C1E),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: isVisible ? Colors.white : Colors.grey,
        ),
        onPressed: toggleVisibility,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: text.isNotEmpty ? const Color(0xFFBFFF08) : Colors.transparent,
          width: text.isNotEmpty ? 2 : 0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFBFFF08), width: 2),
      ),
    );
  }

  Future<void> _handleContinue() async {
  if (_passwordController.text.isEmpty || !_isChecked) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please enter password and accept terms."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final data = await WalletService.unlockWallet(
      password: _passwordController.text.trim(),
    );

    if (mounted) {
      context.read<WalletProvider>().setWalletData(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wallet unlocked successfully!"),
          backgroundColor: Color.fromARGB(255, 8, 9, 6),
        ),
      );

      // ✅ Navigate to CryptoWalletApp screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TokenHomeScreen()),
        (route) => false,
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("Unlock Wallet",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "To unlock your wallet, enter your \nCorrect password.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Password
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: !_isPasswordVisible,
              maxLength: 20,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              decoration: _buildInputDecoration(
                "Enter Password",
                _isPasswordVisible,
                () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                _passwordFocus.hasFocus,
                _passwordController.text,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  activeColor: const Color(0xFFBFFF08),
                  onChanged: (val) => setState(() => _isChecked = val ?? false),
                ),
                const Expanded(
                  child: Text(
                    "I understand that 'Crypto Wallet' cannot recover this password for me.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            // Continue Button with loader
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isChecked
                      ? const Color(0xFFBFFF08)
                      : const Color.fromARGB(255, 137, 158, 46),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed:  _handleContinue,
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black),
                          ),
                          SizedBox(width: 12),
                          Text("Processing...",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const Text("Continue",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
