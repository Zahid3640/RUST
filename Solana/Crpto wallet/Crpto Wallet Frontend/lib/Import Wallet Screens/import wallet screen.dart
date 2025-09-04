import 'package:crpto_wallet/Create%20Wallet%20Screens/createpassword.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/import%20from%20private%20key.dart';
import 'package:crpto_wallet/Import%20Wallet%20Screens/import%20from%20seed%20phrase.dart';
import 'package:crpto_wallet/Unlock%20Wallett/Unlock%20Screen.dart';
import 'package:flutter/material.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  State<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  bool isImportLoading = false; 
  bool isUnlockLoading = false;

  bool get isAnyLoading =>  isImportLoading || isUnlockLoading;

  
  void _seedPressed() {
    if (isAnyLoading && !isImportLoading) return; // ❌ block other buttons

    setState(() => isImportLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isImportLoading = false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ImportSeedPhraseScreen()),
        (route) => false,
      );
    });
  }

  void _privatePressed() {
    if (isAnyLoading && !isUnlockLoading) return; // ❌ block other buttons

    setState(() => isUnlockLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isUnlockLoading = false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ImportPrivateKeyScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _seedPressed,
                  child: isImportLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFBFFF08),
                          ),
                        )
                      : const Text(
                          "Import Using Seed Phrase",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Unlock Wallet Button
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
                  onPressed: _privatePressed,
                  child: isUnlockLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFBFFF08),
                          ),
                        )
                      : const Text(
                          " Through Private Key",
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
