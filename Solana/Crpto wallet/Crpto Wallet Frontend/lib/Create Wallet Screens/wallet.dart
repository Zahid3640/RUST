import 'package:crpto_wallet/Create%20Wallet%20Screens/create%20wallet.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/Seed%20Phrase/import%20from%20seed%20phrase.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/import%20wallet%20screen.dart';
import 'package:crpto_wallet/Unlock%20Wallett/Unlock%20Screen.dart';
import 'package:flutter/material.dart';

class CryptoWalletScreen extends StatefulWidget {
  const CryptoWalletScreen({super.key});

  @override
  State<CryptoWalletScreen> createState() => _CryptoWalletScreenState();
}

class _CryptoWalletScreenState extends State<CryptoWalletScreen> {
  bool isCreateLoading = false;
  bool isImportLoading = false;

  bool get isAnyLoading => isCreateLoading || isImportLoading ;

  void _onCreatePressed() {
    if (isAnyLoading && !isCreateLoading) return; // ❌ block other buttons

    setState(() => isCreateLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isCreateLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePasswordScreen()),
      );
    });
  }

  void _onImportPressed() {
    if (isAnyLoading && !isImportLoading) return; 

    setState(() => isImportLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isImportLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ImportWalletScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    backgroundColor: const Color(0xFFBFFF08),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _onCreatePressed,
                  child: isCreateLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
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
                    side: const BorderSide(color: Color(0xFFBFFF08)),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _onImportPressed,
                  child: isImportLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xFFBFFF08),
                          ),
                        )
                      : const Text(
                          "Import Wallet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
