import 'package:crpto_wallet/NFT/Home/Nft%20Home%20Screen.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Successnft extends StatefulWidget {
  final Map<String, dynamic> data; // ✅ Data from API

  const Successnft({super.key, required this.data});

  @override
  State<Successnft> createState() => _SuccessnftState();
}

class _SuccessnftState extends State<Successnft> {
  bool isLoading = false;
  String? copiedKey;

  void _onContinuePressed() {
    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);


       // ✅ pass everything you got back (has metadata_uri, tx, mint, etc.)
Provider.of<WalletProvider>(context, listen: false).addNft({
  ...widget.data,
});


     Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) {
      return NftHomeScreen();
    },
  ),
);
    });
  }

  // 🔹 Shorten address for display
  String shortAddress(String address) {
    if (address.length <= 12) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 6)}";
  }

  // 🔹 Copy to clipboard with snackbar + check icon
  void copyToClipboard(String key, String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => copiedKey = key);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   // SnackBar(
    //   //   content: Text("$key copied!"),
    //   //   backgroundColor: Colors.black87,
    //   //   duration: const Duration(seconds: 1),
    //   // ),
    // );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => copiedKey = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mint = widget.data["mint_address"] ?? "";
    final ata = widget.data["owner_ata"] ?? "";
    final signature = widget.data["tx_signature"] ?? "";
    final metadataUri = widget.data["metadata_uri"] ?? "";

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // ✅ handle overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/Success.png"),
                const SizedBox(height: 10),

                const Text(
                  "Success!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Congratulations! Your NFT has been\nsuccessfully created.",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // 🔹 Show Details (Mint, ATA, Signature, Metadata)
                infoRow("Mint Address", mint, "Mint"),
                infoRow("Owner ATA", ata, "ATA"),
                infoRow("Signature", signature, "Signature"),
                infoRow("Metadata URI", metadataUri, "Metadata"),

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
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _onContinuePressed,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            "View NFT",
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
      ),
    );
  }

  // 🔹 Custom row with copy button
  Widget infoRow(String title, String value, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Tooltip(
                    message: value, // show full value on long press/hover
                    child: Text(
                      shortAddress(value),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    copiedKey == key ? Icons.check_circle : Icons.copy,
                    color: copiedKey == key
                        ? const Color(0xFFBFFF08)
                        : Colors.white,
                    size: 20,
                  ),
                  onPressed: () => copyToClipboard(key, value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
