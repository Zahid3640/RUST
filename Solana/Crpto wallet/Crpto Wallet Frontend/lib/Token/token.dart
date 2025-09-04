import 'dart:convert';
import 'package:crpto_wallet/Token/send%20token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TokensScreen extends StatefulWidget {
  const TokensScreen({super.key});

  @override
  State<TokensScreen> createState() => _TokensScreenState();
}

class _TokensScreenState extends State<TokensScreen> {
  List coins = [];
  List filteredCoins = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTokens();
  }

  Future<void> fetchTokens() async {
    final url =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        coins = jsonDecode(response.body);
        filteredCoins = coins; // ✅ Search ke liye copy
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load tokens");
    }
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCoins = coins;
      });
    } else {
      setState(() {
        filteredCoins = coins
            .where((coin) =>
                coin['name'].toLowerCase().contains(query.toLowerCase()) ||
                coin['symbol'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Send",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),

      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Token...",
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          // 🔄 Loading / List
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFBFFF08),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCoins.length, // ✅ Search ke liye filteredCoins use kiya
                    itemBuilder: (context, index) {
                      final coin = filteredCoins[index];
                      final priceChange =
                          coin['price_change_percentage_24h'] ?? 0.0;

                      return Column(
                        children: [
                          Card(
                            color: Colors.black,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: ListTile(
                              leading: Image.network(
                                coin['image'],
                                width: 40,
                                height: 40,
                              ),
                              title: Text(
                                coin['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    "\$${(coin['high_24h'] ?? 0.0).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${priceChange.toStringAsFixed(2)}%",
                                    style: TextStyle(
                                      color: priceChange >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              trailing:FittedBox(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "\$${coin['current_price']}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${priceChange.toStringAsFixed(2)}%",
            style: TextStyle(
              color: priceChange >= 0 ? const Color.fromARGB(255, 42, 78, 43) : Colors.red,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            coin['symbol'].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ],
  ),
),

                              // ✅ Click par next screen
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SendTokenScreenn(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 0.5,
                            indent: 30,
                            endIndent: 30,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ✅ Next screen (detail page)
class TokenDetailScreen extends StatelessWidget {
  final Map coin;
  const TokenDetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(coin['name'], style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(coin['image'], width: 80, height: 80),
            const SizedBox(height: 20),
            Text(
              coin['name'],
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: \$${coin['current_price']}",
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Symbol: ${coin['symbol'].toUpperCase()}",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class TokensSendScreen extends StatefulWidget {
//   const TokensSendScreen({super.key});

//   @override
//   State<TokensSendScreen> createState() => _TokensSendScreenState();
// }

// class _TokensSendScreenState extends State<TokensSendScreen> {
//   List coins = [];
//   List filteredCoins = [];
//   bool isLoading = true;
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchTokens();
//   }

//   Future<void> fetchTokens() async {
//     final url =
//         "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd";
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       setState(() {
//         coins = jsonDecode(response.body);
//         filteredCoins = coins; // search ke liye copy
//         isLoading = false;
//       });
//     } else {
//       throw Exception("Failed to load tokens");
//     }
//   }

//   void filterSearch(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredCoins = coins;
//       });
//     } else {
//       setState(() {
//         filteredCoins = coins
//             .where((coin) =>
//                 coin['name'].toLowerCase().contains(query.toLowerCase()) ||
//                 coin['symbol'].toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//   backgroundColor: Colors.grey[850], // 🔹 Grey background
//   centerTitle: true,
//   elevation: 0, // shadow hata diya clean look ke liye]
//   leading: IconButton(
//     icon: Icon(
//       Icons.arrow_back_ios_new, // 🔹 Custom back icon
//       color: Colors.white,      // icon ka color
//     ),
//     onPressed: () {
//       Navigator.pop(context);
//     },
//   ),
//   title: const Text(
//     " Send",
//     style: TextStyle(
//       fontWeight: FontWeight.bold, // 🔹 Bold text
//       color: Colors.white,         // text ka color
//       fontSize: 20,                // thoda bada size
//     ),
//   ),
// ),

//       body: Column(
//         children: [
//           // 🔍 Search Bar
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: filterSearch,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: "Search Token...",
//                 hintStyle: const TextStyle(color: Colors.white),
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//                 filled: true,
//                 fillColor: Colors.grey[850],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),

//           // 🔄 Loading / List
//           Expanded(
//             child: isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       color: const Color(0xFFBFFF08), // ✅ Green Progress
//                     ),
//                   )
//                   : ListView.builder(
//                         itemCount: coins.length,
//                         itemBuilder: (context, index) {
//                           final coin = coins[index];
//                           final priceChange =
//                               coin['price_change_percentage_24h'] ?? 0.0;

//                           return Column(
//                             children: [
//                               Card(
//                                 color: Colors.black,
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 6),
//                                 child: ListTile(
//                                   leading: Image.network(
//                                     coin['image'],
//                                     width: 40,
//                                     height: 40,
//                                   ),
//                                   title: Text(
//                                     coin['name'],
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   subtitle: Row(
//                                     children: [
//                                       Text(
//                                         "\$${(coin['high_24h'] ?? 0.0).toStringAsFixed(2)}",
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Text(
//                                         "${priceChange.toStringAsFixed(2)}%",
//                                         style: TextStyle(
//                                           color: priceChange >= 0
//                                               ? Colors.green
//                                               : Colors.red,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   trailing: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "\$${coin['current_price']}",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             "\$${(coin['low_24h'] ?? 0.0).toStringAsFixed(2)}",
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 5),
//                                           Text(
//                                             coin['symbol'].toUpperCase(),
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               const Divider(
//                                 color: Colors.white,
//                                 thickness: 0.5,
//                                 indent: 30,
//                                 endIndent: 30,
//                               ),
//                             ],
//                           );
//                         },
//                       )
//           ),
//         ],
//       ),
//     );
//   }
// }