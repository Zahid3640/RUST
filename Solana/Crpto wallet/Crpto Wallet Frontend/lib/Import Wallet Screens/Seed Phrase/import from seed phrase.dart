// import 'dart:developer';
// import 'package:crpto_wallet/Import%20Wallet%20Screens/Seed%20Phrase/wallet%20import%20successfully.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../services/wallet_service.dart';

// class ImportSeedPhraseScreen extends StatefulWidget {
//   const ImportSeedPhraseScreen({super.key});

//   @override
//   State<ImportSeedPhraseScreen> createState() => _ImportSeedPhraseScreen();
// }

// class _ImportSeedPhraseScreen extends State<ImportSeedPhraseScreen> {
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   bool _useFaceId = false;
//   bool _isChecked = false;
//   bool _isLoading = false;

//   String? _errorMessage;

//   final TextEditingController _seedController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   final FocusNode _passwordFocus = FocusNode();
//   final FocusNode _confirmPasswordFocus = FocusNode();

//   @override
//   void dispose() {
//     _seedController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _passwordFocus.dispose();
//     _confirmPasswordFocus.dispose();
//     super.dispose();
//   }

//   InputDecoration _buildInputDecoration(
//     String hint,
//     bool isVisible,
//     VoidCallback toggleVisibility,
//     bool isFocused,
//     String text, {
//     bool addSuffix = true,
//   }) {
//     return InputDecoration(
//       filled: true,
//       fillColor: const Color(0xFF1C1C1E),
//       hintText: hint,
//       hintStyle: const TextStyle(color: Colors.white),
//       suffixIcon: addSuffix
//           ? IconButton(
//               icon: Icon(
//                 isVisible ? Icons.visibility : Icons.visibility_off,
//                 color: isVisible ? Colors.white : Colors.grey,
//               ),
//               onPressed: toggleVisibility,
//             )
//           : null,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide(
//           color: text.isNotEmpty ? const Color(0xFFBFFF08) : Colors.transparent,
//           width: text.isNotEmpty ? 2 : 0,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: Color(0xFFBFFF08), width: 2),
//       ),
//     );
//   }

//   Future<void> _importWallet() async {
//     if (!_isFormValid) {
//       setState(() {
//         _errorMessage = "Please fill all fields and accept terms";
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
//       );
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final data = await WalletService.importWallet(
//         seedPhrase: _seedController.text.trim(),
//         password: _passwordController.text.trim(),
//         confirmPassword: _confirmPasswordController.text.trim(),
//       );

//       log("Wallet Imported: $data");

//       // ✅ Provider update karo
//       context.read<WalletProvider>().setWalletData(data);

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Walletimportsuccessfullyy()),
//       );
//     } catch (e) {
//       log("Error: $e");
//       _errorMessage = e.toString();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   bool get _isFormValid {
//     return _seedController.text.isNotEmpty &&
//         _passwordController.text.isNotEmpty &&
//         _confirmPasswordController.text.isNotEmpty &&
//         _isChecked;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final buttonColor =
//         _isFormValid ? const Color(0xFFBFFF08) : const Color.fromARGB(255, 137, 158, 46);

//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Text("Import From Seed",
//                 style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             const Text(
//               "Import your wallet using the seed\n phrase, or face ID.",
//               style: TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),

//             // Seed Phrase
//             TextField(
//               controller: _seedController,
//               maxLines: 3,
//               decoration: _buildInputDecoration(
//                 "Enter Seed Phrase",
//                 false,
//                 () {},
//                 false,
//                 _seedController.text,
//                 addSuffix: false,
//               ),
//               style: const TextStyle(color: Colors.white),
//               onChanged: (_) => setState(() {}),
//             ),
//             const SizedBox(height: 20),

//             // Password
//             TextField(
//               controller: _passwordController,
//               focusNode: _passwordFocus,
//               obscureText: !_isPasswordVisible,
//               maxLength: 20,
//               buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
//               decoration: _buildInputDecoration(
//                 "New Password",
//                 _isPasswordVisible,
//                 () => setState(() => _isPasswordVisible = !_isPasswordVisible),
//                 _passwordFocus.hasFocus,
//                 _passwordController.text,
//               ),
//               style: const TextStyle(color: Colors.white),
//               onChanged: (_) => setState(() {}),
//             ),
//             const SizedBox(height: 16),

//             // Confirm Password
//             TextField(
//               controller: _confirmPasswordController,
//               focusNode: _confirmPasswordFocus,
//               obscureText: !_isConfirmPasswordVisible,
//               maxLength: 20,
//               buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
//               decoration: _buildInputDecoration(
//                 "Confirm Password",
//                 _isConfirmPasswordVisible,
//                 () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
//                 _confirmPasswordFocus.hasFocus,
//                 _confirmPasswordController.text,
//               ),
//               style: const TextStyle(color: Colors.white),
//               onChanged: (_) => setState(() {}),
//             ),
//             const SizedBox(height: 20),

//             // Face ID
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Log in with Face ID",
//                     style: TextStyle(color: Colors.white, fontSize: 14)),
//                 Switch(
//                   value: _useFaceId,
//                   activeColor: const Color(0xFFBFFF08),
//                   onChanged: (val) => setState(() => _useFaceId = val),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Checkbox
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Checkbox(
//                   value: _isChecked,
//                   activeColor: const Color(0xFFBFFF08),
//                   onChanged: (val) => setState(() => _isChecked = val ?? false),
//                 ),
//                 const Expanded(
//                   child: Text(
//                     "I understand that 'Crypto Wallet' cannot recover this password for me.",
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),

//             // Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: buttonColor,
//                   foregroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                 ),
//                 onPressed: () {
//                   if (!_isLoading) _importWallet();
//                 },
//                 child: _isLoading
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.black,
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Text("Processing...",
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
//                         ],
//                       )
//                     : const Text("Continue",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     ));
//   }
// }
import 'dart:async';
import 'dart:developer';
import 'package:crpto_wallet/Import%20Wallet%20Screens/Seed%20Phrase/wallet%20import%20successfully.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/wallet_service.dart';

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
  bool _isLoading = false;

  bool _showPasswordStrength = false; // ✅ new flag for hide after 5 sec
  Timer? _hideTimer;

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
    _hideTimer?.cancel();
    super.dispose();
  }

  // ✅ Strong password check
  bool _isPasswordStrong(String password) {
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  // ✅ Confirm password error message
  String? get _confirmPasswordError {
    if (_confirmPasswordController.text.isEmpty) return null;
    if (_passwordController.text != _confirmPasswordController.text) {
      return "❌ Passwords do not match";
    }
    return null;
  }

  // ✅ "I understand" box enable hone ka condition
  bool get _canCheckTerms {
    return _isPasswordStrong(_passwordController.text) &&
        _passwordController.text == _confirmPasswordController.text &&
        _seedController.text.isNotEmpty;
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

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await WalletService.importWallet(
        seedPhrase: _seedController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );

      log("Wallet Imported: $data");

      // ✅ Provider update karo
      context.read<WalletProvider>().setWalletData(data);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Walletimportsuccessfullyy()),
      );
    } catch (e) {
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

  void _handlePasswordChanged(String value) {
    setState(() {
      // Jab strong hoga tab message show karna h
      if (_isPasswordStrong(value)) {
        _showPasswordStrength = true;

        // Purana timer cancel karo
        _hideTimer?.cancel();

        // 5 sec baad hide karna h
        _hideTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() => _showPasswordStrength = false);
          }
        });
      } else {
        _showPasswordStrength = true; // weak hone pe bhi dikhana h
        _hideTimer?.cancel(); // disable auto-hide
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        _isFormValid ? const Color(0xFFBFFF08) : const Color.fromARGB(255, 137, 158, 46);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: _isLoading ? null: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text("Import From Seed",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
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
                enabled: !_isLoading,
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
                enabled: !_isLoading,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                decoration: _buildInputDecoration(
                  "New Password",
                  _isPasswordVisible,
                  () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  _passwordFocus.hasFocus,
                  _passwordController.text,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _handlePasswordChanged, // ✅ new handler
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordFocus,
                obscureText: !_isConfirmPasswordVisible,
                enabled: !_isLoading,
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

              // ✅ error show niche confirm password k
              if (_confirmPasswordError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _confirmPasswordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 10),

              // ✅ Password strength indicator (5 sec hide strong case me)
              if (_showPasswordStrength)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _isPasswordStrong(_passwordController.text)
                        ? "✅ Your password is strong"
                        : "⚠ Must be 8+ chars, include upper, lower, number & special char",
                    style: TextStyle(
                        color: _isPasswordStrong(_passwordController.text)
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12),
                  ),
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

              // ✅ Checkbox (enabled only if strong password + match)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IgnorePointer(
                    ignoring: !_canCheckTerms,
                    child: Checkbox(
                      value: _isChecked,
                      activeColor: const Color(0xFFBFFF08),
                      onChanged: (val) => setState(() => _isChecked = val ?? false),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "I understand that 'Crypto Wallet' cannot recover this password for me.",
                      style: TextStyle(
                        color:  Colors.grey ,
                        fontSize: 12,
                      ),
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
      ),
    );
  }
}
