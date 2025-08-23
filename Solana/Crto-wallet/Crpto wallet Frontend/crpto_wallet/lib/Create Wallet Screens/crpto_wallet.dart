
import 'package:crpto_wallet/Create%20Wallet%20Screens/createpassword.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/import%20from%20seed%20phrase.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/wallet%20import%20successfully.dart';
import 'package:crpto_wallet/mainwalletscreen.dart';
import 'package:crpto_wallet/nft.dart';
import 'package:crpto_wallet/send.dart';
import 'package:crpto_wallet/token.dart';
import 'package:flutter/material.dart';

class CryptoWalletScreen extends StatelessWidget {
  const CryptoWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔹 Logo / Wallet Image
              Image.asset(
                "assets/images/crpto_wallet.png",
                width: 300,
                height: 342,
              ),

              const SizedBox(height: 120),

              // 🔹 Create Wallet Button
              SizedBox(
                width: 281,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBFFF08), // ✅ Button color
                    foregroundColor: Colors.black, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // ✅ Rounded button
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePasswordScreen(),
                  ),
                );
                  },
                  child: const Text(
                    "Create New Wallet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Import Wallet Button
              SizedBox(
                width: 281,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: const Color(0xFFBFFF08),),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const  NFTsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Import Using Seed Phrase",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
