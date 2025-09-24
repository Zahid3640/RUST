import 'package:crpto_wallet/NFT/Send/NFT%20Sent%20Successfully.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../state/wallet_provider.dart';

class NftSendScreen extends StatefulWidget {
  final Map<String, dynamic> nft;
  const NftSendScreen({super.key, required this.nft});
  @override
  State<NftSendScreen> createState() => _NftSendScreenState();
}
class _NftSendScreenState extends State<NftSendScreen> {
  final TextEditingController _receiverController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;

  Future<void> _sendNft() async { 
    final receiver = _receiverController.text.trim();
      FocusScope.of(context).unfocus();
    if (receiver.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠ Please enter receiver address")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      final response = await walletProvider.sendNft(
        receiver: receiver,
        mint: widget.nft["mint"],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Nftsendsuccessfully(
            signature: response["signature"] ?? "N/A",
            network: response["network"] ?? "Unknown",
            feeSol: (response["fee_sol"] is num)
                ? (response["fee_sol"] as num).toDouble()
                : double.tryParse(response["fee_sol"].toString()) ?? 0.0,
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ NFT send error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String shorten(String address) {
    if (address.isEmpty) return "N/A";
    if (address.length <= 10) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
  }

  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$label copied to clipboard ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nft = widget.nft;

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ adjust screen when keyboard opens
      appBar: AppBar(
        title: const Text("Send", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // ✅ tap anywhere to dismiss keyboard
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Receiver Address Field
              // Receiver Address Field
IgnorePointer(
  ignoring: _isLoading, // ✅ true hone pr click/typing disable ho jayega
  child: TextField(
    controller: _receiverController,
    focusNode: _focusNode,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: "Enter receiver address...",
      hintStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.black,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: _focusNode.hasFocus  
                ? const Color(0xFFBFFF08)
                : Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBFFF08)),
      ),
    ),
  ),
),
              const SizedBox(height: 40),

              // NFT Image with Yellow Border
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFBFFF08), width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    nft["image_url"] ?? nft["image"] ?? "",
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text("${nft["name"] ?? "Unnamed"}",
                  style: const TextStyle(color: Colors.white, fontSize: 18)),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => copyToClipboard(nft["mint"], "Mint Address"),
                child: Text("Mint Address:                     ${shorten(nft["mint"])}",
                    style: const TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => copyToClipboard(nft["owner_ata"], "Owner ATA"),
                child: Text("Owner ATA Address:          ${shorten(nft["owner_ata"])}",
                    style: const TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline)),
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: 281,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBFFF08),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _sendNft,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Send NFT",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:crpto_wallet/NFT/NFT%20Sent%20Successfully.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../state/wallet_provider.dart';

// class NftSendScreen extends StatefulWidget {
//   final Map<String, dynamic> nft;

//   const NftSendScreen({super.key, required this.nft});

//   @override
//   State<NftSendScreen> createState() => _NftSendScreenState();
// }

// class _NftSendScreenState extends State<NftSendScreen> {
//   final TextEditingController _receiverController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _sendNft() async {
//     final receiver = _receiverController.text.trim();
//     if (receiver.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠ Please enter receiver address")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final walletProvider =
//           Provider.of<WalletProvider>(context, listen: false);

//       // 👇 ab response return ho raha hai
//       final response = await walletProvider.sendNft(
//         receiver: receiver,
//         mint: widget.nft["mint"],
//       );

//     Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(
//     builder: (_) => Nftsendsuccessfully(
//       signature: response["signature"] ?? "N/A",
//       network: response["network"] ?? "Unknown",
//       feeSol: (response["fee_sol"] is num) 
//           ? (response["fee_sol"] as num).toDouble() 
//           : double.tryParse(response["fee_sol"].toString()) ?? 0.0,
//     ),
//   ),
// );

//     } catch (e) {
//       debugPrint("❌ NFT send error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final nft = widget.nft;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Send",style: const TextStyle(color: Colors.white),),
//         centerTitle: true,
//          elevation: 0,
//          leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _receiverController,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Enter receiver address...",
//                 hintStyle: const TextStyle(color: Colors.white70),
//                 filled: true,
//                 fillColor: Colors.grey[800],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 nft["image_url"] ?? nft["image"] ?? "",
//                 height: 250,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text("${nft["name"] ?? "Unnamed"}",
//                 style: const TextStyle(color: Colors.white, fontSize: 18)),
//             const SizedBox(height: 30),
//             Text("Mint Address: ${nft["mint"]}",
//                 style: const TextStyle(color: Colors.white70),
//                 overflow: TextOverflow.ellipsis),
//             const SizedBox(height: 10),
//             Text("Owner ATA Address: ${nft["owner_ata"]}",
//                 style: const TextStyle(color: Colors.white70),
//                 overflow: TextOverflow.ellipsis),
          
//             const SizedBox(height: 50),

//             // ✅ Send Button
//             SizedBox(
//               width: 281,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFBFFF08),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed:  _sendNft, // disable while sending
//                 child: _isLoading
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(
//                           color: Colors.black,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         "Send NFT",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


