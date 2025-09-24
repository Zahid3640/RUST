import 'dart:async';
import 'dart:ui';
import 'package:crpto_wallet/services/wallet_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/Create Wallet Screens/SaveSeedPhrase.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:crpto_wallet/services/wallet_service.dart';


class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});
  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _useFaceId = false;
  bool _isChecked = false;
  bool _isLoading = false; // ✅ loader state for main screen
  bool _firstBottomLoading = false;
  bool _secondBottomLoading = false;
  bool _showPasswordStrength = false; // ✅ Strength message flag
  Timer? _hideTimer; // ✅ loader state for bottom sheets

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
     _hideTimer?.cancel();
    super.dispose();
  }
  bool _isPasswordStrong(String password) {
  final regex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
  return regex.hasMatch(password);
}

bool get _canCheckTerms {
  return _isPasswordStrong(_passwordController.text) &&
      _passwordController.text == _confirmPasswordController.text;
}
  void _handlePasswordChanged(String value) {
    setState(() {
      if (_isPasswordStrong(value)) {
        _showPasswordStrength = true;

        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() => _showPasswordStrength = false);
          }
        });
      } else {
        _showPasswordStrength = true; 
        _hideTimer?.cancel(); 
      }
    });
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
        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
            color: isVisible ? Colors.white : Colors.grey),
        onPressed: toggleVisibility,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: text.isNotEmpty
              ? const Color(0xFFBFFF08)
              : Colors.transparent,
          width: text.isNotEmpty ? 2 : 0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFBFFF08), width: 2),
      ),
    );
  }
// Future<void> _handleContinue() async {
//   if (_isLoading) return;

//   if (!_isChecked) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Please accept terms first"),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   FocusScope.of(context).unfocus();
//   setState(() => _isLoading = true);

//   try {
//     final data = await WalletService.createWallet(
//       password: _passwordController.text.trim(),
//       confirmPassword: _confirmPasswordController.text.trim(),
//     );

//    if ((data['status']?.toString().toLowerCase() ?? '') == 'success') {
//   context.read<WalletProvider>().setWalletDataa(data);
 
//   if (!mounted) return;
//   _showFirstBottomSheet(context); // ✅ show seed phrase
// } else {
//   final msg = data['message']?.toString() ?? 'Something went wrong';
//   if (mounted) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: Colors.red),
//     );
//   }
// }

//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
//       );
//     }
//     debugPrint("❌ Error in wallet creation: $e");
//   } finally {
//     if (mounted) setState(() => _isLoading = false);
//   }
// }


  Future<void> _handleContinue() async {
    if (_isLoading) return;

    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please accept terms first"),
            backgroundColor: Colors.red),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final data = await WalletService.createWallet(
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );

      if ((data['status']?.toString().toLowerCase() ?? '') == 'success') {
        context.read<WalletProvider>().setWalletData(data);

        if (!mounted) return;
        _showFirstBottomSheet(context); // ✅ open bottom sheet
      } else {
        final msg = data['message']?.toString() ?? 'Something went wrong';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
      print(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  String? get _confirmPasswordError {
  if (_confirmPasswordController.text.isEmpty) return null;
  if (_passwordController.text != _confirmPasswordController.text) {
    return "❌ Passwords do not match";
  }
  return null;
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
       child:Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: _isLoading ? null : () => Navigator.pop(context),
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text("Create Password",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            "This password will unlock your wallet\non this device only.",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Password
          TextField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            obscureText: !_isPasswordVisible,
            enabled: !_isLoading,
            maxLength: 16,
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
            decoration: _buildInputDecoration(
                "New Password",
                _isPasswordVisible,
                () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                _passwordFocus.hasFocus,
                _passwordController.text),
            style: const TextStyle(color: Colors.white),
            onChanged: _handlePasswordChanged,
          ),
          const SizedBox(height: 16),

          // Confirm Password
                           TextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    obscureText: !_isConfirmPasswordVisible,
                    enabled: !_isLoading,
                    maxLength: 16,
                    buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                    decoration: _buildInputDecoration(
                        "Confirm Password",
                        _isConfirmPasswordVisible,
                        () => setState(
                            () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        _confirmPasswordFocus.hasFocus,
                        _confirmPasswordController.text),
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

             // ✅ Password strength indicator (conditionally shown)
if (_showPasswordStrength)
  Align(
    alignment: Alignment.centerLeft,
    child: Text(
      _isPasswordStrong(_passwordController.text)
          ? "Now Your Password is Strong"
          : "⚠ Must be 8+ chars, include upper, lower, number & special char",
      style: TextStyle(
        color: _isPasswordStrong(_passwordController.text)
            ? const Color(0xFFBFFF08)
            : Colors.red,
        fontSize: 12,
      ),
    ),
  ),
          const SizedBox(height: 20),

          // Face ID toggle
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

          // ✅ Checkbox (enabled only if strong password + match)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IgnorePointer(
                ignoring: !_canCheckTerms,
                child: Checkbox(
                  value: _isChecked,
                  activeColor: const Color(0xFFBFFF08),
                  onChanged: (val) =>
                      setState(() => _isChecked = val ?? false),
                ),
              ),
              Expanded(
                child: Text(
                  "I understand that 'Crypto Wallet' cannot recover this password for me.",
                  style: TextStyle(
                    color: Colors.grey ,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 100),

          // Continue button
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
              onPressed: _handleContinue,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black),
                    )
                  : const Text("Continue",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 12),
          const Text("Step 1/2",
              style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 20),
        ],
      ),
    ),
  )
    );
  }

// 🔹 First Bottom Sheet
void _showFirstBottomSheet(BuildContext context) {
  bool _isFirstSheetLoading = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return _blurBackground(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(
                    top: BorderSide(color: Color(0xFFBFFF08), width: 3),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Protect Your Wallet",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    Image.asset("assets/images/protect.png", height: 100),
                    const SizedBox(height: 20),

                    const Text(
                      "Don’t risk losing your funds. Protect your wallet by saving your seed phrase...",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: 281,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBFFF08),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                        ),
                        onPressed: () {
                          setModalState(() => _isFirstSheetLoading = true);    // simulate process
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    setModalState(
                                        () => _isFirstSheetLoading = false);
                                    Navigator.pop(context); // close first
                                    _showSecondBottomSheet(context); // open second
                                  }
                                });
                              },
                        child: _isFirstSheetLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black),
                              )
                            : const Text("Continue"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      // onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Remind Me Later.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// 🔹 Second Bottom Sheet
void _showSecondBottomSheet(BuildContext context) {
  bool _isSecondSheetLoading = false; // 🔹 default false

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return _blurBackground(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(
                    top: BorderSide(color: Color(0xFFBFFF08), width: 3),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "What is a Seed Phrase?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "A seed phrase is a set of 12 words that contains all the information about your wallet, including your funds. "
                   "It’s like a secret code used to access your entire wallet.\n\n"
                   "You must keep your seed phrase secret and safe. If someone gets your seed phrase, they’ll gain control over your accounts.\n\n"
                   "Save it in a place where only you can access. If you lose it, not even MetaMask can help you recover it!",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 281,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBFFF08),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                        ),
                        onPressed
                            : () {
                                setModalState(
                                    () => _isSecondSheetLoading = true);

                                // simulate API process
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    setModalState(
                                        () => _isSecondSheetLoading = false);
                                         Navigator.pop(context);
                                           Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SaveSeedPhraseScreen(),
                                      ),
                                        (route) => false,
                                    );
                                  
                                  }
                                });
                              },
                        child: _isSecondSheetLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black),
                              )
                            : const Text("Understood"),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// 🔹 Blur Background
Widget _blurBackground({required Widget child}) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
    child: child,
    );
  }
}
