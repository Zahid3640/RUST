// import 'package:flutter/material.dart';

// class NftDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> nft;

//   const NftDetailScreen({super.key, required this.nft});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("NFT Detail",style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.black,
//         centerTitle: true,
//           leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 nft["image"] ?? "",
//                 height: 250,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text("Name: ${nft["name"] ?? "Unnamed"}",
//                 style: const TextStyle(color: Colors.white, fontSize: 18)),
//             Text("Symbol: ${nft["symbol"] ?? ""}",
//                 style: const TextStyle(color: Colors.white70)),
//             const SizedBox(height: 10),
//             Text("Description: ${nft["description"] ?? ""}",
//                 style: const TextStyle(color: Colors.white70)),
//             const SizedBox(height: 10),
//             Text("Mint: ${nft["mint"]}",
//                 style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
//             const SizedBox(height: 10),
//             Text("Metadata URI: ${nft["metadata_uri"]}",
//                 style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
//             const SizedBox(height: 10),
//             Text("Owner ATA: ${nft["owner_ata"]}",
//                 style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NftDetailScreen extends StatelessWidget {
  final Map<String, dynamic> nft;

  const NftDetailScreen({super.key, required this.nft});

  String shortenAddress(String address) {
    if (address.isEmpty) return "";
    if (address.length <= 10) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
  }

  Widget buildCopyRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "$label: ${shortenAddress(value)}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 16, color: Color(0xFFBFFF08)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label copied ✅")),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final description = nft["description"]?.toString().trim() ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("NFT Detail", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                nft["image"] ?? "",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[800],
                  alignment: Alignment.center,
                  child: const Text("No Image",
                      style: TextStyle(color: Colors.white70)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Name: ${nft["name"] ?? "Unnamed"}",
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text("Symbol: ${nft["symbol"] ?? ""}",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 10),

            // ✅ Description scrollable
            if (description.isNotEmpty)
              Text(
                "Description: $description",
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                "No description available",
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),

            const SizedBox(height: 20),

            // ✅ Shorten + Copy rows
            buildCopyRow(context, "Mint", nft["mint"] ?? ""),
            buildCopyRow(context, "Metadata URI", nft["metadata_uri"] ?? ""),
            buildCopyRow(context, "Owner ATA", nft["owner_ata"] ?? ""),
          ],
        ),
      ),
    );
  }
}
