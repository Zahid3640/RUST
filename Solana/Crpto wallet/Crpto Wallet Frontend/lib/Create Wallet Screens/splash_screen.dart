import 'dart:async';
import 'package:flutter/material.dart';
import 'crpto_wallet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 5 second baad navigation
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CryptoWalletScreen()),
      );
    });
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
            child: Text(
              "© 2024 Crypto Wallet. All Rights Reserved.",
              style: const TextStyle(
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
