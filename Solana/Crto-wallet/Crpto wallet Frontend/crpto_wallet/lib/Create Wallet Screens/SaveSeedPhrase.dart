import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crpto_wallet/Create%20Wallet%20Screens/ConfirmSeedPhrase.dart';

class SaveSeedPhraseScreen extends StatefulWidget {
  const SaveSeedPhraseScreen({super.key});

  @override
  State<SaveSeedPhraseScreen> createState() => _SaveSeedPhraseScreen();
}

class _SaveSeedPhraseScreen extends State<SaveSeedPhraseScreen> {
  // ✅ Example data (yeh tum API se replace karoge)
  final List<String> seedPhrases = [
    "car", "jump", "vote",
    "river", "moon", "tree",
    "glass", "house", "fish",
    "stone", "bird", "light",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const Text(
              "Save Your Seed Phrase",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "This is your seed phrase. Save it in a\nsafe location. You’ll be asked to re-\nenter this phrase (in asked order) on\nthe next step.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // 🔹 Seed Phrase Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBFFF08), width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.5,
                ),
                itemCount: seedPhrases.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "${index + 1}. ${seedPhrases[index]}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Copy to Clipboard Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: seedPhrases.join(" ")));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Seed phrase copied to clipboard!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, color: Colors.white),
                ),
                const Text(
                  "Copy to Clipboard",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 80),

            // 🔹 Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBFFF08),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ConfirmSeedPhraseScreen()),
                  );
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Step 2/2",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


