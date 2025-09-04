// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import '../services/wallet_service.dart';




// class ReceiveScreen extends StatefulWidget {
//   const ReceiveScreen({super.key});

//   @override
//   State<ReceiveScreen> createState() => _ReceiveScreenState();
// }

// class _ReceiveScreenState extends State<ReceiveScreen> {
//   String? qrSvg;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchReceiveData();
//   }

//   Future<void> _fetchReceiveData() async {
//     setState(() => isLoading = true);
//     try {
//       final walletProvider = Provider.of<WalletProvider>(context, listen: false);
//       if (walletProvider.publicKey == null) {
//         throw Exception("Public key not found!");
//       }

//       final res = await WalletService.receiveWallet(address: walletProvider.publicKey!);

//       setState(() {
//         qrSvg = res['qr_code_svg_base64'];
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final walletProvider = Provider.of<WalletProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Receive"),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator(color: Color(0xFFBFFF08))
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (qrSvg != null)
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       color: Colors.white,
//                       child: SvgPicture.string(
//                         utf8.decode(base64Decode(qrSvg!)),
//                         width: 200,
//                         height: 200,
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                   Text(
//                     walletProvider.publicKey ?? "No Address",
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFBFFF08),
//                       foregroundColor: Colors.black,
//                     ),
//                     onPressed: () {
//                       _fetchReceiveData(); // refresh QR
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text("Refresh QR"),
//                   )
//                 ],
//               ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  String? qrSvg;
  bool isLoading = false;
  bool copied = false; // ✅ Copy state

  @override
  void initState() {
    super.initState();
    _fetchReceiveData();
  }

  Future<void> _fetchReceiveData() async {
    setState(() => isLoading = true);
    try {
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      if (walletProvider.publicKey == null) {
        throw Exception("Public key not found!");
      }

      final res = await WalletService.receiveWallet(
        address: walletProvider.publicKey!,
      );

      setState(() {
        qrSvg = res['qr_code_svg_base64'];
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  String getShortAddress(String address) {
    if (address.length <= 10) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final address = walletProvider.publicKey ?? "No Address";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receive"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: isLoading
              ? const CircularProgressIndicator(   // ✅ Jab tak data load ho raha hai
          color: Color(0xFFBFFF08),
        ) // ✅ Circular progress remove kar diya
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (qrSvg != null)
                    Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.black,
                      child: SvgPicture.string(
                        utf8.decode(base64Decode(qrSvg!)),
                        width: 250,
                        height: 250,
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Your Wallet Address",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    getShortAddress(address),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // ✅ Buttons
                  Column(
                    children: [
                      // Copy Button
                      SizedBox(
                        width: 281,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBFFF08),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: address),
                            );
                            setState(() => copied = true);

                            // 3 sec baad icon wapas copy ho jaye
                            Future.delayed(const Duration(seconds: 3), () {
                              if (mounted) {
                                setState(() => copied = false);
                              }
                            });
                          },
                          icon: Icon(
                            copied ? Icons.check_circle : Icons.copy,
                            color: Colors.black,
                          ),
                          label: Text(copied ? "Copied" : "Copy"),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Close Button
                      SizedBox(
                        width: 281,
                        height: 50,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFBFFF08)),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, color: Color(0xFFBFFF08)),
                          label: const Text(
                            "Close",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBFFF08),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
