import 'package:crpto_wallet/Token/Home/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';

class Walletimportsuccessfullyyy extends StatefulWidget {
  const Walletimportsuccessfullyyy({super.key});

  @override
  State<Walletimportsuccessfullyyy> createState() => _WalletimportsuccessfullyyyState();
}

class _WalletimportsuccessfullyyyState extends State<Walletimportsuccessfullyyy> {
  bool isLoading = false;

  void _onContinuePressed() {
    setState(() {
      isLoading = true; // ✅ Show loader
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TokenHomeScreen(),
        ),
      );
    });
  }

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
                "assets/images/Success.png",
              ),
              const SizedBox(height: 20),
              const Text(
                "Success!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "You’ve successfully imported your\nwallet using the private key.",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 240),

              // 🔹 Continue Button with Loader
              SizedBox(
                width: 281,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBFFF08), // ✅ Button color
                    foregroundColor: Colors.black, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _onContinuePressed,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "Continue",
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
