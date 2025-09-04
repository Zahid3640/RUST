import 'dart:developer';
import 'package:crpto_wallet/Import%20Wallet%20Screens/import%20successfullywithprivatekey.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/wallet%20import%20successfully.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/wallet_service.dart';

class ImportPrivateKeyScreen extends StatefulWidget {
  const ImportPrivateKeyScreen({super.key});

  @override
  State<ImportPrivateKeyScreen> createState() => _ImportPrivateKeyScreen();
}

class _ImportPrivateKeyScreen extends State<ImportPrivateKeyScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _useFaceId = false;
  bool _isChecked = false;
  bool _isLoading = false;

  String? _errorMessage;

  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _seedController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
    String hint,
    bool isVisible,
    VoidCallback toggleVisibility,
    bool isFocused,
    String text, {
    bool addSuffix = true,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1C1C1E),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white),
      suffixIcon: addSuffix
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: isVisible ? Colors.white : Colors.grey,
              ),
              onPressed: toggleVisibility,
            )
          : null,
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

  Future<void> _importWallet() async {
    if (!_isFormValid) {
      setState(() {
        _errorMessage = "Please fill all fields and accept terms";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await WalletService.importWallet(
        privateKey: _seedController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );

      log("Wallet Imported: $data");

      // ✅ Provider update karo
      context.read<WalletProvider>().setWalletData(data);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Walletimportsuccessfullyyy()),
      );
    } catch (e) {
      log("Error: $e");
      _errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool get _isFormValid {
    return _seedController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isChecked;
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        _isFormValid ? const Color(0xFFBFFF08) : const Color.fromARGB(255, 137, 158, 46);

    return Scaffold(
      backgroundColor: Colors.black,
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
          children: [
            const SizedBox(height: 20),
            const Text("Import From Private Key",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Import your wallet using the \nprivate key.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Private Key
            TextField(
              controller: _seedController,
              maxLines: 2,
              decoration: _buildInputDecoration(
                "Enter Private Key",
                false,
                () {},
                false,
                _seedController.text,
                addSuffix: false,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Password
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: !_isPasswordVisible,
              maxLength: 20,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              decoration: _buildInputDecoration(
                "New Password",
                _isPasswordVisible,
                () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                _passwordFocus.hasFocus,
                _passwordController.text,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              obscureText: !_isConfirmPasswordVisible,
              maxLength: 20,
              buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
              decoration: _buildInputDecoration(
                "Confirm Password",
                _isConfirmPasswordVisible,
                () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                _confirmPasswordFocus.hasFocus,
                _confirmPasswordController.text,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // Face ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Log in with Face ID",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                Switch(
                  value: _useFaceId,
                  activeColor: const Color(0xFFBFFF08),
                  onChanged: (val) => setState(() => _useFaceId = val),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkbox
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
            const SizedBox(height: 30),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  if (!_isLoading) _importWallet();
                },
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("Processing...",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        ],
                      )
                    : const Text("Continue",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
