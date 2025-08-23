
import 'dart:convert';
import 'dart:developer';
import 'package:crpto_wallet/Import%20Wallet%20Screens/wallet%20import%20successfully.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImportSeedPhraseScreen extends StatefulWidget {
  const ImportSeedPhraseScreen({super.key});

  @override
  State<ImportSeedPhraseScreen> createState() => _ImportSeedPhraseScreen();
}

class _ImportSeedPhraseScreen extends State<ImportSeedPhraseScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _useFaceId = false;
  bool _isChecked = false;

  // Controllers
  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Focus Nodes
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
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIcon: addSuffix
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color:
              text.isNotEmpty ? const Color(0xFFBFFF08) : Colors.transparent,
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
    // Agar form valid nahi → kuchh bhi na kare
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and accept terms"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final url = Uri.parse("http://192.168.18.119/import_wallet");
     final body = {
     "mnemonic": _seedController.text.trim(),
      "password": _passwordController.text.trim(),
      "confirm_password": _confirmPasswordController.text.trim(),};

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(body),
      );

      log("Status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data["status"] ?? "unknown";

        if (status == "success") {
          // Import successful → dusri screen par bhejo
          // Navigator.pushReplacement(
          //   // context,
          //   // MaterialPageRoute(
          //   //   //builder: (context) => const Walletimportsuccessfully(),
          //   // ),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${data["message"] ?? "Unknown error"}"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Server error: ${response.statusCode}"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      log("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
    final buttonColor = _isFormValid
        ? const Color(0xFFBFFF08) // light when valid
        : const Color.fromARGB(255, 137, 158, 46); // dark when invalid

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
            const Text(
              "Import From Seed",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Import your wallet using the seed\n phrase, or face ID.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Seed Phrase
            TextField(
              controller: _seedController,
              maxLines: 3,
              decoration: _buildInputDecoration(
                "Enter Seed Phrase",
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
              decoration: _buildInputDecoration(
                "Confirm Password",
                _isConfirmPasswordVisible,
                () => setState(
                    () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
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
            const SizedBox(height: 10),

            // Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isChecked,
                  activeColor: const Color(0xFFBFFF08),
                  onChanged: (val) =>
                      setState(() => _isChecked = val ?? false),
                ),
                const Expanded(
                  child: Text(
                    "I understand that 'Crypto Wallet' cannot recover this password for me.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),

            // Continue Button (never disabled)
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
                onPressed: _importWallet,
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

