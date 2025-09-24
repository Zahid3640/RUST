import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/unlockfile.dart';
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
  bool _hidden = true; // 🔹 toggle ke liye
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
  final wallet = context.watch<WalletProvider>();
final phrase = wallet.seedPhrase ?? "";
final privateKey = wallet.privateKey ?? "";
    final words = phrase.isEmpty ? <String>[] : phrase.split(" ");
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
            Navigator.pop(context,);
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
              "Your Seed Phrase & Private Key",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "This is your seed phrase and private key. Save it in a safe location.You’ll be asked to re-enter this phrase (in asked order) on\nthe next step.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
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
              ],
            ),
            const SizedBox(height: 10),
Container(
  margin: const EdgeInsets.symmetric(vertical: 10),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    border: Border.all(color: const Color(0xFFBFFF08), width: 2),
    borderRadius: BorderRadius.circular(16),
    color: Colors.black,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Private Key",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),

      // 🔹 Private Key + Show/Hide
      Row(
        children: [
          Expanded(
            child: Text(
              _hidden
                  ? "●●●●●●●●●●●●●●●●●●●" // hide mode
                  : privateKey, // show mode
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Color(0xFFBFFF08)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: privateKey));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Private Key copied ✅"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    ],
  ),
),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

