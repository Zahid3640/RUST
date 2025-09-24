import 'dart:async';
import 'package:crpto_wallet/Unlock%20Wallett/Unlock%20Screen.dart';
import 'package:crpto_wallet/services/wallet_storage.dart';
import 'package:flutter/material.dart';
import 'Create Wallet Screens/wallet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkWallet(); // 🔹 jaise hi splash load ho, check chal jaye
  }

  Future<void> _checkWallet() async {
    await Future.delayed(const Duration(seconds: 2)); // thoda delay splash ke liye

    final walletJson = await WalletStorage.loadWallet();

    if (!mounted) return;

    if (walletJson == null) {
      // 🔹 Wallet nahi hai → Create/Import screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CryptoWalletScreen()),
      );
    } else {
      // 🔹 Wallet mila → Unlock screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UnlockWalletScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Stack(
        children: [
          // 🔹 Center Logo
          Center(
            child: Image.asset(
              "assets/images/logo1.png",
              width: 182,
              height: 200.38,
            ),
          ),

          // 🔹 Bottom Text
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: const Text(
              "© 2024 Crypto Wallet. All Rights Reserved.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
