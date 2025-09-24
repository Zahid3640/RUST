// import 'package:crpto_wallet/mainwalletscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class Tokensendsuccessfully extends StatefulWidget {
//   final double amount;
//   final double usdValue;
//   final String toAddress;
//   final String signature;
//   final double networkFeeMin;
//   final double networkFeeMax;

//   const Tokensendsuccessfully({
//     super.key,
//     required this.amount,
//     required this.usdValue,
//     required this.toAddress,
//     required this.signature,
//     required this.networkFeeMin,
//     required this.networkFeeMax,
//   });

//   @override
//   State<Tokensendsuccessfully> createState() => _TokensendsuccessfullyState();
// }

// class _TokensendsuccessfullyState extends State<Tokensendsuccessfully> {
//   bool copiedAddress = false;
//   bool copiedSignature = false;
//   bool isLoading = false;

//   void copyToClipboard(String text, bool isAddress) {
//     Clipboard.setData(ClipboardData(text: text));
//     setState(() {
//       if (isAddress) {
//         copiedAddress = true;
//         Future.delayed(const Duration(seconds: 2), () {
//           setState(() => copiedAddress = false);
//         });
//       } else {
//         copiedSignature = true;
//         Future.delayed(const Duration(seconds: 2), () {
//           setState(() => copiedSignature = false);
//         });
//       }
//     });
//   }

//   String getShortAddress(String address) {
//     if (address.isEmpty) return "N/A";
//     if (address.length <= 10) return address;
//     return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
//   }

//   String getShortSignature(String sig) {
//     if (sig.isEmpty) return "N/A";
//     if (sig.length <= 20) return sig;
//     return "${sig.substring(0, 12)}...${sig.substring(sig.length - 10)}";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasSignature = widget.signature.isNotEmpty && widget.signature != "N/A";

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset("assets/images/Success.png", height: 120),
//                 const SizedBox(height: 10),

//                 const Text(
//                   "Sol Sent!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 5),
//                 Text(
//                   "${widget.amount} SOL",
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 1),
//                 Text(
//                   "US\$${widget.usdValue.toStringAsFixed(2)}",
//                   style: const TextStyle(color: Colors.grey, fontSize: 16),
//                 ),

//                 const SizedBox(height: 5),

//                 // Address Row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       child: SelectableText(
//                         "ToAdd: ${getShortAddress(widget.toAddress)}",
//                         style: const TextStyle(color: Colors.white, fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => copyToClipboard(widget.toAddress, true),
//                       icon: Icon(
//                         copiedAddress ? Icons.check : Icons.copy,
//                         color: copiedAddress ?  const Color(0xFFBFFF08) : Colors.white70,
//                       ),
//                       tooltip: copiedAddress ? "Copied!" : "Copy Address",
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 5),

//                 // ✅ Signature Section
//                if (hasSignature) ...[
//   const Text("Signature",
//       style: TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.bold)),
//   Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Flexible(
//         child: Text(
//           getShortSignature(widget.signature),
//           style: const TextStyle(
//               color: Colors.grey, fontSize: 14),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       IconButton(
//         onPressed: () =>
//             copyToClipboard(widget.signature, false),
//         icon: Icon(
//           copiedSignature ? Icons.check : Icons.copy,
//           color: copiedSignature
//               ? const Color(0xFFBFFF08)
//               : Colors.white70,
//         ),
//       ),
//     ],
//   ),
// ] else ...[
//   const Text(
//     "⚠️ Signature not available",
//     style: TextStyle(color: Colors.red, fontSize: 14),
//   ),
// ],


//                 const SizedBox(height: 10),

//                 const Text("Network fee",
//                     style: TextStyle(color: Colors.grey, fontSize: 14)),
//                 Text(
//                   "US\$${widget.networkFeeMin.toStringAsFixed(2)} - US\$${widget.networkFeeMax.toStringAsFixed(2)}",
//                   style: const TextStyle(color: Colors.white, fontSize: 16),
//                 ),

//                 const SizedBox(height: 30),
//                 SizedBox(
//                   width: 281,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFBFFF08),
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 15, horizontal: 40),
//                     ),
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WalletHomeScreen()),
//                       );
//                     },
//                     child: const Text(
//                       "Go Back",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:crpto_wallet/Token/Home/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tokensendsuccessfully extends StatefulWidget {
  final double amount;
  final double usdValue;
  final String toAddress;
  final String signature;
   final double feeSol;        // ✅ add
  final String network;
  

  const Tokensendsuccessfully({
    super.key,
    required this.amount,
    required this.usdValue,
    required this.toAddress,
    required this.signature,
    required this.feeSol,        // ✅ add
    required this.network,
    
  });

  @override
  State<Tokensendsuccessfully> createState() => _TokensendsuccessfullyState();
}

class _TokensendsuccessfullyState extends State<Tokensendsuccessfully> {
  bool copiedAddress = false;
  bool copiedSignature = false;
  bool isLoading = false; // ✅ loading state

  void copyToClipboard(String text, bool isAddress) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      if (isAddress) {
        copiedAddress = true;
        Future.delayed(const Duration(seconds: 2), () {
          setState(() => copiedAddress = false);
        });
      } else {
        copiedSignature = true;
        Future.delayed(const Duration(seconds: 2), () {
          setState(() => copiedSignature = false);
        });
      }
    });
  }

  String getShortAddress(String address) {
    if (address.isEmpty) return "N/A";
    if (address.length <= 10) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
  }

  String getShortSignature(String sig) {
    if (sig.isEmpty) return "N/A";
    if (sig.length <= 20) return sig;
    return "${sig.substring(0, 12)}...${sig.substring(sig.length - 10)}";
  }

  @override
  Widget build(BuildContext context) {
    final hasSignature = widget.signature.isNotEmpty && widget.signature != "N/A";

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/Success.png", height: 120),
                const SizedBox(height: 10),

                const Text(
                  "Sol Sent!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),
                Text(
                  "${widget.amount} SOL",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),
                Text(
                  "US\$${widget.usdValue.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 5),

                // Address Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SelectableText(
                        "ToAdd: ${getShortAddress(widget.toAddress)}",
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () => copyToClipboard(widget.toAddress, true),
                      icon: Icon(
                        copiedAddress ? Icons.check : Icons.copy,
                        color: copiedAddress ? const Color(0xFFBFFF08) : Colors.white70,
                      ),
                      tooltip: copiedAddress ? "Copied!" : "Copy Address",
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // ✅ Signature Section
                if (hasSignature) ...[
                  const Text("Signature",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          getShortSignature(widget.signature),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => copyToClipboard(widget.signature, false),
                        icon: Icon(
                          copiedSignature ? Icons.check : Icons.copy,
                          color: copiedSignature
                              ? const Color(0xFFBFFF08)
                              : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const Text(
                    "⚠️ Signature not available",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],

                const SizedBox(height: 10),

                const Text("Network fee",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(
                  "${widget.feeSol.toStringAsFixed(6)} SOL",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),

                const Text("Network",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text(
                  "${widget.network}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: 281,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBFFF08),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                    ),
                    onPressed: () {
                      setState(() => isLoading = true);

                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TokenHomeScreen()),
                              );
                            });
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Go Back",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
