import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crpto_wallet/Create%20Wallet%20Screens/ConfirmSeedPhrase.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';

class SaveSeedPhraseScreen extends StatefulWidget {
  const SaveSeedPhraseScreen({super.key});

  @override
  State<SaveSeedPhraseScreen> createState() => _SaveSeedPhraseScreen();
}

class _SaveSeedPhraseScreen extends State<SaveSeedPhraseScreen> {
  bool _copied = false;
  bool _hidden = false; // 🔹 toggle ke liye
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final phrase = wallet.seedPhrase ?? "";
    final words = phrase.isEmpty ? <String>[] : phrase.split(" ");

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBFFF08), width: 3),
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
                itemCount: words.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    child: Text(
                      _hidden
                          ? "${index + 1}. ●●●" // 🔹 hide state
                          : "${index + 1}. ${words[index]}", // 🔹 show state
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Copy to Clipboard + Hide/Show
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: words.join(" ")));
                        setState(() {
                          _copied = true; // ✅ copied hone ke baad tick show hoga
                        });
                      },
                      icon: Icon(
                        _copied ? Icons.check_circle : Icons.copy,
                        color: _copied ? const Color(0xFFBFFF08) : Colors.white,
                      ),
                    ),
                    Text(
                      _copied ? "Copied!" : "Copy to Clipboard",
                      style: TextStyle(
                        color: _copied ? const Color(0xFFBFFF08) : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // 🔹 Hide / Show Toggle
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hidden = !_hidden;
                    });
                  },
                child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      _hidden ? Icons.visibility_off : Icons.visibility,
      color: _hidden ? Colors.grey : Colors.white, // ✅ fixed here
    ),
    const SizedBox(width: 6),
    Text(
      _hidden ? "Show Phrase" : "Hide Phrase",
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ),
  ],
),


                ),
              ],
            ),

            const SizedBox(height: 80),

            // 🔹 Continue Button with Loading
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
                  setState(() {
                    _isLoading = true;
                  });

                        // simulate API call or delay
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                           
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ConfirmSeedPhraseScreen(),
                              ),
                            );
                          }
                        });
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
