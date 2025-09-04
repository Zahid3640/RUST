import 'package:crpto_wallet/NFT/Nft%20Home%20Screen.dart';
import 'package:crpto_wallet/Token/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';

class Successnft extends StatefulWidget {
  const Successnft({super.key});

  @override
  State<Successnft> createState() => _SuccessnftState();
}

class _SuccessnftState extends State<Successnft> {
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
          builder: (context) => NftHomeScreen(),
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
                "Congratulations! Your NFT has been\nsuccessfully created. Start\nshowcasing or trading it now!",
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
                          "View NFT",
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
