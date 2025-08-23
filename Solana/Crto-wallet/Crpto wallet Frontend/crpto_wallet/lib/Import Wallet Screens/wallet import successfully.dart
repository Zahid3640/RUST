
import 'package:flutter/material.dart';

class Walletimportsuccessfullyy extends StatelessWidget {
  const Walletimportsuccessfullyy({super.key});

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
                //  width: 270,
                //  height: 200,
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
              "You’ve successfully imported your\n wallet using the seed phrase.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
              const SizedBox(height: 240),
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
                //         Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CreatePasswordScreen(),
                //   ),
                // );
                  },
                  child: const Text(
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
