import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crpto_wallet/Create%20Wallet%20Screens/ConfirmSeedPhrase.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';

class SeedPhraseScreen extends StatefulWidget {
  const SeedPhraseScreen({super.key});

  @override
  State<SeedPhraseScreen> createState() => _SeedPhraseScreen();
}

class _SeedPhraseScreen extends State<SeedPhraseScreen> {
  bool _copied = false;
  bool _hidden = false; // 🔹 toggle ke liye
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final phrase = wallet.seedPhrase ?? "";
    final words = phrase.isEmpty ? <String>[] : phrase.split(" ");
   // final walletProvider = Provider.of<WalletProvider>(context);
  final privateKey = wallet.privateKey ?? "";

  // ✅ Agar empty hai (api ne load nahi kiya)
  if (privateKey.isEmpty) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          "No Wallet Found",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

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
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      childAspectRatio: 2.5,
    ),
    // ✅ agar words empty hain to 12 fixed cells dikhao
    itemCount: words.isEmpty ? 12 : words.length,
    itemBuilder: (context, index) {
      final text = words.isEmpty
          ? "" // Agar seed phrase available nahi hai -> empty
          : (_hidden
              ? "${index + 1}. ●●●" // hide mode
              : "${index + 1}. ${words[index]}"); // show mode

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
//const SizedBox(height: 10),

                // 🔹 Wallet Address (Copyable)
                // InkWell(
                //   onTap: () {
                //     Clipboard.setData(ClipboardData(text: privateKey));
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text("Address copied to clipboard ✅"),
                //         backgroundColor: Colors.green,
                //       ),
                //     );
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const Icon(Icons.account_balance_wallet,
                //           color: Colors.grey, size: 18),
                //       const SizedBox(width: 6),
                //       Text(
                //         privateKey,
                //         style: const TextStyle(
                //             color: Colors.grey,
                //             fontSize: 14,
                //             fontWeight: FontWeight.w200),
                //       ),
                //       const SizedBox(width: 4),
                //       const Icon(Icons.copy,
                //           size: 16, color: Colors.grey),
                //     ],
                //   ),
                // ),