import 'dart:convert';
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
        filteredCoins = coins; // search ke liye copy
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
  backgroundColor: Colors.grey[850], // 🔹 Grey background
  centerTitle: true,
  elevation: 0, // shadow hata diya clean look ke liye]
  leading: IconButton(
    icon: Icon(
      Icons.arrow_back_ios_new, // 🔹 Custom back icon
      color: Colors.white,      // icon ka color
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: const Text(
    " Send",
    style: TextStyle(
      fontWeight: FontWeight.bold, // 🔹 Bold text
      color: Colors.white,         // text ka color
      fontSize: 20,                // thoda bada size
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
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔄 Loading / List
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.green, // ✅ Green Progress
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCoins.length,
                    itemBuilder: (context, index) {
                      final coin = filteredCoins[index];
                      final priceChange = coin['price_change_percentage_24h'] ?? 0.0;

                      return Card(
                        color: Colors.grey[900],
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
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "\$${coin['high_24h'].toStringAsFixed(4)}  \$${coin['low_24h'].toStringAsFixed(4)}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "\$${coin['current_price']}",
                                style: const TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min, // ✅ Fix row
                                children: [
                                  Text(
                                    "${priceChange.toStringAsFixed(2)}%",
                                    style: TextStyle(
                                      color: priceChange >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    coin['symbol'].toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
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


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class TokensScreen extends StatefulWidget {
//   const TokensScreen({super.key});

//   @override
//   State<TokensScreen> createState() => _TokensScreenState();
// }

// class _TokensScreenState extends State<TokensScreen> {
//   List coins = [];
//   bool isLoading = true;

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
//         isLoading = false;
//       });
//     } else {
//       throw Exception("Failed to load tokens");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Tokens"),
//         backgroundColor: Colors.black,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: coins.length,
//               itemBuilder: (context, index) {
//                 final coin = coins[index];
//                 final priceChange = coin['price_change_24h'] ?? 0.0;

//                 return Card(
//                   color: Colors.grey[900],
//                   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                   child: ListTile(
//                     leading: Image.network(
//                       coin['image'],
//                       width: 40,
//                       height: 40,
//                     ),
//                     title: Text(
//                       coin['name'],
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
                       
//                         Text(
//                           "\$${coin['high_24h'].toStringAsFixed(3)}  \$${coin['low_24h']}",
//                           style: const TextStyle(color: Colors.grey, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                     trailing: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "\$${coin['current_price']}",
//                           style: const TextStyle(
//                               color: Colors.yellowAccent,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "${priceChange.toStringAsFixed(2)}%",
//                               style: TextStyle(
//                                 color: priceChange >= 0 ? Colors.green : Colors.red,
//                                 fontSize: 12,
//                               ),
//                             ),
//                              Text(
//                           coin['symbol'].toUpperCase(),
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
