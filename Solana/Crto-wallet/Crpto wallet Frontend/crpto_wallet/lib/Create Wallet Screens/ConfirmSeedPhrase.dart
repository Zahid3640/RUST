import 'package:flutter/material.dart';

class ConfirmSeedPhraseScreen extends StatefulWidget {
  const ConfirmSeedPhraseScreen({super.key});

  @override
  State<ConfirmSeedPhraseScreen> createState() =>
      _ConfirmSeedPhraseScreenState();
}

class _ConfirmSeedPhraseScreenState extends State<ConfirmSeedPhraseScreen> {
  // ✅ Example (API ke actual phrases se replace karna)
  final Map<int, String> correctAnswers = {
    3: "vote",
    7: "house",
    11: "bird",
  };

  final Map<int, String?> userSelection = {
    3: null,
    7: null,
    11: null,
  };

  void selectPhrase(int position, String phrase) {
    setState(() {
      userSelection[position] = phrase;
    });

    // ✅ Check user input with correct answer
    if (phrase != correctAnswers[position]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong seed phrase! Try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildTextField(int number) {
    final isSelected = userSelection[number] != null;
    final isCorrect = userSelection[number] == correctAnswers[number];

    return Container(
      width: double.infinity, // ✅ Fix width (full width)
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((phrase) {
        final isSelected = userSelection[number] == phrase;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? const Color.fromARGB(255, 248, 248, 247) : Colors.grey.shade800,
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
              "Confirm Seed Phrase",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Enter each word in the order it was\npresented to you.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // 🔹 Field 1
            buildTextField(3),
            const SizedBox(height: 10),
            buildOptionsRow(3, ["car", "vote", "jump"]),

            const SizedBox(height: 30),

            // 🔹 Field 2
            buildTextField(7),
            const SizedBox(height: 10),
            buildOptionsRow(7, ["tree", "house", "river"]),

            const SizedBox(height: 30),

            // 🔹 Field 3
            buildTextField(11),
            const SizedBox(height: 10),
            buildOptionsRow(11, ["bird", "stone", "fish"]),

            const SizedBox(height: 50),

            // 🔹 Continue Button (Always enabled ✅)
          // 🔹 Continue Button (Always enabled ✅)
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: userSelection.keys.every(
        (key) => userSelection[key] == correctAnswers[key],
      )
          ? const Color(0xFFBFFF08) // ✅ All correct → Light Color
          : const Color.fromARGB(255, 137, 158, 46), // ❌ Wrong → Dark Color
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
    ),
    onPressed: () {
      // ✅ Final check on Continue
      final allCorrect = userSelection.keys.every(
          (key) => userSelection[key] == correctAnswers[key]);

      if (allCorrect) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Seed phrase confirmed ✅"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Some seed phrases are wrong ❌"),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    child: const Text(
      "Confirm",
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



// import 'dart:math';
// import 'package:flutter/material.dart';

// class ConfirmSeedPhraseScreen extends StatefulWidget {
//   const ConfirmSeedPhraseScreen({super.key});

//   @override
//   State<ConfirmSeedPhraseScreen> createState() => _ConfirmSeedPhraseScreenState();
// }

// class _ConfirmSeedPhraseScreenState extends State<ConfirmSeedPhraseScreen> {
//   // ✅ Original 12 seed phrases (API se aayengi)
//   final List<String> seedPhrases = [
//     "car", "jump", "vote",
//     "river", "moon", "tree",
//     "glass", "house", "fish",
//     "stone", "bird", "light",
//   ];

//   // ✅ User ko in specific indexes ko confirm karna hoga
//   final List<int> indexesToConfirm = [2, 5, 9]; // e.g. 3rd, 6th, 10th word

//   // ✅ User selection store karne ke liye
//   Map<int, String?> selectedWords = {};

//   // ✅ Random shuffled words (for buttons)
//   late List<String> shuffledWords;

//   @override
//   void initState() {
//     super.initState();
//     shuffledWords = List.from(seedPhrases)..shuffle(Random());
//   }

//   void onWordSelected(String word) {
//     // Find next empty textfield
//     for (var idx in indexesToConfirm) {
//       if (selectedWords[idx] == null) {
//         setState(() {
//           selectedWords[idx] = word;
//         });
//         break;
//       }
//     }
//   }

//   void onContinue() {
//     bool allCorrect = true;

//     for (var idx in indexesToConfirm) {
//       if (selectedWords[idx] != seedPhrases[idx]) {
//         allCorrect = false;
//         break;
//       }
//     }

//     if (allCorrect) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("✅ Seed phrase confirmed!"), backgroundColor: Colors.green),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("❌ Wrong order! Please try again."), backgroundColor: Colors.red),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),

//             const Text(
//               "Confirm Seed Phrase",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 8),

//             const Text(
//               "Select each word in the order it was presented to you.",
//               style: TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),

//             const SizedBox(height: 30),

//             // 🔹 Textfields for confirmation
//             Column(
//               children: indexesToConfirm.map((idx) {
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFFBFFF08), width: 2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         "${idx + 1}. ",
//                         style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         selectedWords[idx] ?? "",
//                         style: const TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),

//             const SizedBox(height: 20),

//             // 🔹 Buttons for shuffled words
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: shuffledWords.map((word) {
//                 bool isSelected = selectedWords.containsValue(word);
//                 return ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isSelected ? Colors.grey : const Color(0xFFBFFF08),
//                     foregroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: isSelected ? null : () => onWordSelected(word),
//                   child: Text(word, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 );
//               }).toList(),
//             ),

//             const SizedBox(height: 40),

//             // 🔹 Continue Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFBFFF08),
//                   foregroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                 ),
//                 onPressed: onContinue,
//                 child: const Text(
//                   "Continue",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             const Text(
//               "Step 2/2",
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// class ConfirmSeedPhraseScreen extends StatefulWidget {
//   const ConfirmSeedPhraseScreen({super.key});

//   @override
//   State<ConfirmSeedPhraseScreen> createState() => _ConfirmSeedPhraseScreen();
// }

// class _ConfirmSeedPhraseScreen extends State<ConfirmSeedPhraseScreen> {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),

//             const Text(
//               "Confirm Seed Phrase",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 8),

//             const Text(
//               "Select each word in the order it was\n presented to you.",
//               style: TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),

//             const SizedBox(height: 30),
//             TextField(
//               style: const TextStyle(color: Colors.white),
//               onChanged: (_) => setState(() {}),
//             ),
//             const SizedBox(height: 130),

//             // 🔹 Continue Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFBFFF08),
//                   foregroundColor: Colors.black,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                 ),
//                 onPressed: () {
//                         Navigator.pop(
//                   context 
//                   // MaterialPageRoute(
//                   //   builder: (context) => const ConfirmScreen(),
//                   // ),
//                 );
//                   },
//                 child: const Text(
//                   "Continue",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 12),

//             const Text(
//               "Step 2/2",
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }}