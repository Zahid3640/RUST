import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:crpto_wallet/services/wallet_service.dart';
import 'package:crpto_wallet/NFT/Send/Send%20Nft%20Screen.dart'; // make sure file name me space na ho

class NftScreen extends StatefulWidget {
  const NftScreen({super.key});

  @override
  State<NftScreen> createState() => _NftScreenState();
}

class _NftScreenState extends State<NftScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> nfts = [];
  List<Map<String, dynamic>> filteredNfts = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNfts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredNfts = nfts
          .where((nft) =>
              (nft["name"] ?? "").toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _fetchNfts() async {
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    if (wallet.publicKey == null) return;

    try {
      final fetched = await WalletService.getNfts(wallet.publicKey!);
      setState(() {
        nfts = fetched;
        filteredNfts = fetched;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching NFTs: $e")),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: isLoading ? null: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              readOnly: isLoading,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "NFT Search by name...",
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.black,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white))
                : filteredNfts.isEmpty
                    ? const Center(
                        child: Text("No NFTs Found",
                            style: TextStyle(color: Colors.white)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: filteredNfts.length,
                        itemBuilder: (context, index) {
                          final nft = filteredNfts[index];
                          return GestureDetector(
                            onDoubleTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NftSendScreen(
                                    nft: Map<String, dynamic>.from(nft),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFFBFFF08),
                                            width: 2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        image: nft["image"] != null &&
                                                nft["image"].toString().isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  nft["image"].toString(),
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: nft["image"] == null ||
                                              nft["image"].toString().isEmpty
                                          ? const Center(
                                              child: Icon(Icons.broken_image,
                                                  color: Colors.white, size: 40),
                                            )
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        nft["name"]?.toString() ??
                                            "Unnamed NFT",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:crpto_wallet/services/wallet_service.dart';
// import 'package:crpto_wallet/NFT/Nft_Detail_Screen.dart'; // make sure file name me space na ho

// class NftScreen extends StatefulWidget {
//   const NftScreen({super.key});

//   @override
//   State<NftScreen> createState() => _NftScreenState();
// }

// class _NftScreenState extends State<NftScreen> {
//   bool isLoading = true;
//   List<Map<String, dynamic>> nfts = [];
//   List<Map<String, dynamic>> filteredNfts = [];

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _fetchNfts();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }


//   Future<void> _fetchNfts() async {
//     final wallet = Provider.of<WalletProvider>(context, listen: false);
//     if (wallet.publicKey == null) return;

//     try {
//       final fetched = await WalletService.getNfts(wallet.publicKey!);
//       setState(() {
//         nfts = fetched;
//         filteredNfts = fetched;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error fetching NFTs: $e")),
//       );
//     }
//   } 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: isLoading ? null: () => Navigator.pop(context),
//         ),
//       ),
//       backgroundColor: Colors.black,
//       body: Column(
//         children: [
//           Expanded(
//             child: isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(color: Colors.white))
//                 : filteredNfts.isEmpty
//                     ? const Center(
//                         child: Text("No NFTs Found",
//                             style: TextStyle(color: Colors.white)))
//                     : GridView.builder(
//                         padding: const EdgeInsets.all(12),
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisSpacing: 12,
//                           childAspectRatio: 0.8,
//                         ),
//                         itemCount: filteredNfts.length,
//                         itemBuilder: (context, index) {
//                           final nft = filteredNfts[index];
//                           return GestureDetector(
//                             onDoubleTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => NftDetailScreen(
//                                     nft: Map<String, dynamic>.from(nft),
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                             color: const Color(0xFFBFFF08),
//                                             width: 2),
//                                         borderRadius: const BorderRadius.all(
//                                             Radius.circular(12)),
//                                         image: nft["image"] != null &&
//                                                 nft["image"].toString().isNotEmpty
//                                             ? DecorationImage(
//                                                 image: NetworkImage(
//                                                   nft["image"].toString(),
//                                                 ),
//                                                 fit: BoxFit.cover,
//                                               )
//                                             : null,
//                                       ),
//                                       child: nft["image"] == null ||
//                                               nft["image"].toString().isEmpty
//                                           ? const Center(
//                                               child: Icon(Icons.broken_image,
//                                                   color: Colors.white, size: 40),
//                                             )
//                                           : null,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8, vertical: 6),
//                                     child: Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         nft["name"]?.toString() ??
//                                             "Unnamed NFT",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

