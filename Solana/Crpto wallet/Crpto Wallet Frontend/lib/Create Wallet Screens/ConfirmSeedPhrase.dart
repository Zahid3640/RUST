import 'dart:math';
import 'package:crpto_wallet/Token/Home/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';

class ConfirmSeedPhraseScreen extends StatefulWidget {
  const ConfirmSeedPhraseScreen({super.key});

  @override
  State<ConfirmSeedPhraseScreen> createState() =>
      _ConfirmSeedPhraseScreenState();
}

class _ConfirmSeedPhraseScreenState extends State<ConfirmSeedPhraseScreen> {
  final Map<int, String?> userSelection = {};
  final Map<int, String> correctAnswers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateRandomQuestions();
    });
  }

  void _generateRandomQuestions() {
    final wallet = context.read<WalletProvider>();
    final phrase = wallet.seedPhrase ?? "";
    final words = phrase.split(" ");

    if (words.length < 12) return; // ✅ safety

    // Randomly select 3 positions
    final rand = Random();
    final selectedIndexes = <int>{};
    while (selectedIndexes.length < 3) {
      selectedIndexes.add(rand.nextInt(words.length));
    }

    for (var idx in selectedIndexes) {
      correctAnswers[idx + 1] = words[idx]; // store word with position
      userSelection[idx + 1] = null;
    }

    setState(() {});
  }

  void selectPhrase(int position, String phrase) {
    setState(() {
      userSelection[position] = phrase;
    });
  }

  Widget buildTextField(int number) {
    final isSelected = userSelection[number] != null;
    final isCorrect = userSelection[number] == correctAnswers[number];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? (isCorrect ? const Color(0xFFBFFF08) : Colors.red)
              : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "${number}. ${userSelection[number] ?? ""}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildOptionsRow(int number, List<String> options) {
    return Wrap(
      spacing: 10,
      children: options.map((phrase) {
        final isSelected = userSelection[number] == phrase;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? const Color(0xFFBFFF08)
                : Colors.grey.shade800,
            foregroundColor: isSelected ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () => selectPhrase(number, phrase),
          child: Text(phrase),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();
    final phrase = wallet.seedPhrase ?? "";
    final words = phrase.split(" ");

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
      body: correctAnswers.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Seed Phrase",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Select the correct words for the positions below.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Build dynamic questions
                  for (var entry in correctAnswers.entries) ...[
                    buildTextField(entry.key),
                    const SizedBox(height: 10),
                    buildOptionsRow(
                      entry.key,
                      _generateOptions(words, entry.value),
                    ),
                    const SizedBox(height: 30),
                  ],

                  const SizedBox(height: 20),

                  // 🔹 Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userSelection.keys.every(
                          (key) => userSelection[key] == correctAnswers[key],
                        )
                            ? const Color(0xFFBFFF08)
                            : Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                              final allCorrect = userSelection.keys.every(
                                  (key) =>
                                      userSelection[key] ==
                                      correctAnswers[key]);

                              setState(() => _isLoading = true);

                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() => _isLoading = false);
                                if (allCorrect) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content:
                                  //         //Text("Seed phrase confirmed ✅"),
                                  //     //backgroundColor:const Color(0xFFBFFF08),
                                  //   ),
                                  // );
                                  Navigator.pop(context);
                                           Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             TokenHomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Some seed phrases are wrong ❌"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              });
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Confirm",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Step 2/2",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
    );
  }

  // 🔹 Generate random options (1 correct + 2 random)
  List<String> _generateOptions(List<String> allWords, String correct) {
    final rand = Random();
    final options = <String>{correct};

    while (options.length < 3) {
      options.add(allWords[rand.nextInt(allWords.length)]);
    }

    return options.toList()..shuffle();
  }
}
