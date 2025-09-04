import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NftGridScreen extends StatefulWidget {
  const NftGridScreen({super.key});

  @override
  State<NftGridScreen> createState() => _NftGridScreenState();
}

class _NftGridScreenState extends State<NftGridScreen> {
  List<String> nftImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNfts();
  }

  Future<void> fetchNfts() async {
    const apiKey = "👉 Yahan apni Moralis API Key daalo 👈";

    try {
      // Example: Fetch NFTs from Ethereum (BAYC contract address)
      final response = await http.get(
        Uri.parse(
          "https://deep-index.moralis.io/api/v2/nft/0xbc4ca0eda7647a8ab7c2061c2e118a18a936f13d?chain=eth&format=decimal&limit=20",
        ),
        headers: {
          "X-API-Key": apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List<String> images = [];
        for (var nft in data["result"]) {
          try {
            var metadata = jsonDecode(nft["metadata"]);
            if (metadata != null && metadata["image"] != null) {
              // replace ipfs:// links with gateway
              String imageUrl = metadata["image"]
                  .toString()
                  .replaceAll("ipfs://", "https://ipfs.io/ipfs/");
              images.add(imageUrl);
            }
          } catch (e) {
            print("Metadata parse error: $e");
          }
        }

        setState(() {
          nftImages = images;
          isLoading = false;
        });
      } else {
        print("Error: ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching NFTs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFT Gallery")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 NFTs per row
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: nftImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      nftImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
