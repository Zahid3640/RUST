import 'package:crpto_wallet/NFT/Home/Nft%20Home%20Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Nftsendsuccessfully extends StatefulWidget {
  final String signature;
  final String network;
  final double feeSol;

  const Nftsendsuccessfully({
    super.key,
    required this.signature,
    required this.network,
    required this.feeSol,
  });

  @override
  State<Nftsendsuccessfully> createState() => _NftsendsuccessfullyState();
}

class _NftsendsuccessfullyState extends State<Nftsendsuccessfully> {
  bool copiedSignature = false;
  bool isLoading = false;

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() {
      copiedSignature = true;
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => copiedSignature = false);
      });
    });
  }

  String getShortSignature(String sig) {
    if (sig.isEmpty) return "N/A";
    if (sig.length <= 20) return sig;
    return "${sig.substring(0, 12)}...${sig.substring(sig.length - 10)}";
  }

  @override
  Widget build(BuildContext context) {
    final hasSignature =
        widget.signature.isNotEmpty && widget.signature != "N/A";

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
                  "NFT Sent!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),
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
                              color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => copyToClipboard(widget.signature),
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

                // ✅ Show Network
                Text(
                  "Network",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text("${widget.network} ",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 15),

                // ✅ Show Fee
                const Text("Network Fee",
                    style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold)),
                Text(
                  "${widget.feeSol} SOL",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 40),

                // ✅ Back Button 
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
                              builder: (context) => NftHomeScreen()),
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
