import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiModel {
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double? priceChangePercentage24h;

  ApiModel({
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble(),
    );
  }
}

class MainWallett extends StatefulWidget {
  const MainWallett({Key? key}) : super(key: key);

  @override
  State<MainWallett> createState() => _MainWallettState();
}

class _MainWallettState extends State<MainWallett> {
  TextEditingController searchController = TextEditingController();
  List<ApiModel> postList = [];
  List<ApiModel> filteredList = [];

  Future<List<ApiModel>> getApi() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=tether,shiba-inu,chainlink&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        postList = data.map((coinData) => ApiModel.fromJson(coinData)).toList();
        return postList;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 🔹 Full screen black
      appBar: AppBar(
        automaticallyImplyLeading: false, // 🔹 Remove back icon
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30.0, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  filteredList = postList
                      .where((coin) =>
                          coin.name.toLowerCase().contains(query.toLowerCase()) ||
                          coin.symbol.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                });
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                labelText: 'Search by Token',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Colors.green, width: 3.0),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(strokeWidth: 5, color: Colors.white),
                    );
                  } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                    return Center(
                      child: Text('Error loading data', style: TextStyle(color: Colors.white)),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: filteredList.isEmpty ? postList.length : filteredList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final coin = filteredList.isEmpty ? postList[index] : filteredList[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.network(coin.image.toString()),
                          ),
                          title: Text(coin.name, style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                            "${coin.priceChangePercentage24h?.toStringAsFixed(3)}%",
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('\$${coin.currentPrice.toString()}',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 5),
                              Text(coin.symbol.toUpperCase(), style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          onTap: () {},
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // 🔹 Grey navbar
        selectedItemColor: const Color(0xFFBFFF08),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.lock_clock), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ApiModel {
//   final String name;
//   final String symbol;
//   final String image;
//   final double currentPrice;
//   final double? priceChangePercentage24h;

//   ApiModel({
//     required this.name,
//     required this.symbol,
//     required this.image,
//     required this.currentPrice,
//     required this.priceChangePercentage24h,
//   });

//   factory ApiModel.fromJson(Map<String, dynamic> json) {
//     return ApiModel(
//       name: json['name'],
//       symbol: json['symbol'],
//       image: json['image'],
//       currentPrice: json['current_price'].toDouble(),
//       priceChangePercentage24h: json['price_change_percentage_24h'],
//     );
//   }
// }

// class MainWallett extends StatefulWidget {
//   const MainWallett({Key? key}) : super(key: key);

//   @override
//   State<MainWallett> createState() => _MainWallettState();
// }

// class _MainWallettState extends State<MainWallett> {
//   TextEditingController searchController = TextEditingController();
//   List<ApiModel> postList = [];
//   List<ApiModel> filteredList = [];
//   List<ApiModel> watchlist = [];

//   Future<List<ApiModel>> getApi() async {
//     final response = await http.get(Uri.parse(
//         //'https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'
//         'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&symbols=usdt,shib,link&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en&include_tokens=all'));

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);

//       if (data is List) {
//         postList = data.map((coinData) => ApiModel.fromJson(coinData)).toList();
//         return postList;
//       } else {
//         return [];
//       }
//     } else {
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: Icon(Icons.account_circle, size: 30.0),
//             onPressed: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context)=>loginscreen()));
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: searchController,
//               onChanged: (query) {
//                 setState(() {
//                   filteredList = postList
//                       .where((coin) =>
//                           coin.name
//                               .toLowerCase()
//                               .contains(query.toLowerCase()) ||
//                           coin.symbol
//                               .toLowerCase()
//                               .contains(query.toLowerCase()))
//                       .toList();
//                 });
//               },
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 labelText: 'Search by Coin',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(40),
//                   borderSide: BorderSide(
//                     color: Colors.green,
//                     width: 3.0,
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder(
//                 future: getApi(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 5,
//                       ),
//                     );
//                   } else if (!snapshot.hasData) {
//                     return Center(
//                       child: Text('Error loading data'),
//                     );
//                   } else {
//                     return ListView.builder(
//                       itemCount: filteredList.isEmpty
//                           ? postList.length
//                           : filteredList.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final coin = filteredList.isEmpty
//                             ? postList[index]
//                             : filteredList[index];
//                         return ListTile(
//                           leading: GestureDetector(
//                             onTap: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //     builder: (context) => CoinDetailScreen(coin: coin),
//                               //   ),
//                               // );
//                             },
//                             child: CircleAvatar(
//                               child: Image.network(coin.image.toString()),
//                             ),
//                           ),
//                           title: Text(coin.name.toString()),
//                           subtitle: Text(
//                               "${coin.priceChangePercentage24h?.toStringAsFixed(3)}%"),
//                           trailing: Column(
//                             children: [
//                               Text('\$${coin.currentPrice.toString()}'),
//                               SizedBox(height: 5),
//                               Text(coin.symbol.toString().toUpperCase()),
//                             ],
//                           ),
//                           onTap: () {
//                             // Handle tap on coin (e.g., navigate to coin details)
//                           },
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.lock_clock),
//             label: 'Transactions',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Notifications',
//           ),
//            BottomNavigationBarItem(
//             icon: Icon(Icons.portable_wifi_off_outlined),
//             label: 'Profile',
//           ),
//         ],
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               break;
//             case 1:
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => transactionScreen()),
//               // );
//               break;
//             case 2:
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => notificationsScreen()),
//               // );
//               break;
//               case 3:
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => profileScreen()),
//               // );
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
