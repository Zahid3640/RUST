import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NFTsScreen extends StatefulWidget {
  const NFTsScreen({super.key});

  @override
  State<NFTsScreen> createState() => _NFTsScreenState();
}

class _NFTsScreenState extends State<NFTsScreen> {
  Map<String, dynamic>? nftData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNFTs();
  }

  Future<void> fetchNFTs() async {
    final url =
        "https://api.coingecko.com/api/v3/nfts/bored-ape-yacht-club"; // ✅ CoinGecko NFT API
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        nftData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load NFTs");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "NFTs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.green, // ✅ green indicator
              ),
            )
          : nftData == null
              ? const Center(
                  child: Text(
                    "No NFTs found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: Image.network(
                          nftData!['image']['small'], // NFT image
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          nftData!['name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          nftData!['symbol'] ?? "",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          "\$${nftData!['floor_price']['usd'].toString()}",
                          style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
