import 'dart:convert';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
import 'package:crpto_wallet/NFT/Create/Create%20Nft.dart';
import 'package:crpto_wallet/NFT/Send/Nft%20screen.dart';
import 'package:crpto_wallet/NFT/Home/NFT%20Detail%20Screen.dart';
import 'package:crpto_wallet/Token/Receive/receive%20token.dart';
import 'package:crpto_wallet/Token/Home/Token%20Home%20Screen.dart';
import 'package:crpto_wallet/Token/Send/send%20token.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/transaction%20screen.dart';
import 'package:crpto_wallet/services/wallet_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:http/http.dart' as http;
class NftHomeScreen extends StatefulWidget {
  @override
  _NftHomeScreenState createState() => _NftHomeScreenState();
}
class _NftHomeScreenState extends State<NftHomeScreen> {
   List<Map<String, dynamic>> nfts = [];
  List coins = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  int _tabIndex = 0; // 0 = Tokens, 1 = NFTs
  bool showBalance = false;
  bool _isBalanceLoading = false; 
  bool copied = false;
  bool isLoadingg = false;

   @override
  void initState() {
    super.initState();
    _fetchNfts();
  }
   Future<void> _fetchNfts() async {
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    if (wallet.publicKey == null) return;

    try {
      final fetched = await WalletService.getNfts(wallet.publicKey!);
      setState(() {
        nfts = fetched; 
        isLoading = false;
      });
    } catch (e) {
        setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching NFTs: $e")),
      );
    }
  } 

  void _onContinuePressed() {
    setState(() {
      isLoadingg = true; // ✅ Show loader
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoadingg = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNft(),
        ),
      );
    });
  }
Future<void> fetchBalance() async {
  final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    setState(() {
      _isBalanceLoading = true; 
    });
 
  if (walletProvider.publicKey == null) return;

  try {
    final balMap = await WalletService.getBalance(walletProvider.publicKey!);

    final bal = balMap["balance"].toString(); 
    walletProvider.setBalance(bal);
  } catch (e) {
    debugPrint("Balance fetch error: $e");
  }
   setState(() {
      _isBalanceLoading = false; 
    });
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push( 
          context, MaterialPageRoute(builder: (context) => TransactionsScreen()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
  }
 
  @override
  Widget build(BuildContext context) {
   final walletProvider = Provider.of<WalletProvider>(context);
  final publicKey = walletProvider.publicKey ?? "";

  // ✅ Agar empty hai (api ne load nahi kiya)
  if (publicKey.isEmpty) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          "No Wallet Found",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // ✅ Address short karna (jaise wallet me hota hai)
  String shortAddress =
      "${publicKey.substring(0, 6)}...${publicKey.substring(publicKey.length - 4)}";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),

      body: Column(
        children: [
          // 🔹 Balance Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                      GestureDetector(
                  onTap: fetchBalance, 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _isBalanceLoading
                        ? const SizedBox(
                            height: 28,
                            width: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color:const Color(0xFFBFFF08),
                            ),
                          )
                        : Text(
                            walletProvider.balance ?? "Balance",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
  onTap: () async {
    await Clipboard.setData(ClipboardData(text: publicKey));
    setState(() {
      copied = true;
    });
    // ✅ 5 sec baad wapis copy icon show kar do
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          copied = false;
        });
      }
    });
  },
   splashColor: Colors.transparent,   // 👈 disable splash
  highlightColor: Colors.transparent, // 👈 disable highlight
  overlayColor: WidgetStateProperty.all(Colors.transparent),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        shortAddress,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 4),
      Icon(
        copied ? Icons.check_circle : Icons.copy,
        size: 23,
        color: copied ? const Color(0xFFBFFF08): Colors.grey,
      ),
    ],
  ),
),
                SizedBox(height: 20),
                // 🔹 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _walletButton(Icons.arrow_upward, "Send", NftScreen()),
                    _walletButton(Icons.arrow_downward, "Receive", ReceiveScreen()),
                    _walletButton(Icons.add, "Buy",NftScreen()),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    GestureDetector(
      onTap: () {
        // ✅ Token screen khol do
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TokenHomeScreen()),
        );
      },
      child: Column(
        children: [
          Text(
            "Token",
            style: TextStyle(
              color: Colors.grey, // hamesha white rakho since new screen open ho rahi
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    
    SizedBox(width: 15),
    GestureDetector(
      onTap: () => setState(() => _tabIndex = 0),
      child: Column(
        children: [
          Text(
            "NFTs",
            style: TextStyle(
              color: _tabIndex == 0 ? Colors.white : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_tabIndex == 0)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 50,
              color: Colors.white,
            ),
        ],
      ),
    ),
  ],
),
SizedBox(height: 20),
          SizedBox(height: 20),
              SizedBox(
                width: 281,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBFFF08), // ✅ Button color
                    foregroundColor: Colors.black, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _onContinuePressed,
                  child: isLoadingg
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          "Create NFT",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
          SizedBox(height: 10,),
       Expanded(
  child: Consumer<WalletProvider>(
    builder: (context, walletProvider, child) {
      // ✅ Jab tak loading ho raha hai tab circular loader dikhana
      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFBFFF08),
            strokeWidth: 2.5,
          ),
        );
      }

      // ✅ Agar API ka response empty hai to default NFTs show karo
      if (nfts.isEmpty) {
        final defaultNfts = [
          {"name": "Monk", "image": "assets/images/nft1.png"},
          {"name": "Monk", "image": "assets/images/nft2.png"},
          {"name": "Monk", "image": "assets/images/nft3.png"},
          {"name": "Monk", "image": "assets/images/nft4.png"},
        ];

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: defaultNfts.length,
          itemBuilder: (context, index) {
            final nft = defaultNfts[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 170,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFFBFFF08), width: 2), // Border
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(nft["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      nft["name"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      // ✅ Agar API ka data mila to NFTs show karo
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: nfts.length,
        itemBuilder: (context, index) {
          final nft = nfts[index];
          return GestureDetector(
            onDoubleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NftDetailScreen(nft: Map<String, dynamic>.from(nft)),
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
                            color: const Color(0xFFBFFF08), width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        image: nft["image"] != null &&
                                nft["image"].toString().isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(nft["image"].toString()),
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
                        nft["name"]?.toString() ?? "Unnamed NFT",
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
      );
    },
  ),
),



        ],
      ),
      // 🔹 Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  child:BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFBFFF08),
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_clock_outlined), label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notification_add_outlined), label: "Notification"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),)
    );
  }

  // 🔹 Wallet Button with navigation
  Widget _walletButton(IconData icon, String label, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFFBFFF08),
            child: Icon(icon, color: Colors.black, size: 28),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

// 🔹 Dummy Screens
class SendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Send")),
        body: Center(child: Text("Send Screen")),
      );
}
class BuyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Buy")),
        body: Center(child: Text("Buy Screen")),
      );
}






// import 'dart:convert';
// import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
// import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
// import 'package:crpto_wallet/NFT/Create%20Nft.dart';
// import 'package:crpto_wallet/NFT/Nft%20screen.dart';
// import 'package:crpto_wallet/Receive/receive%20token.dart';
// import 'package:crpto_wallet/Token/Token%20Home%20Screen.dart';
// import 'package:crpto_wallet/Token/send%20token.dart';
// import 'package:crpto_wallet/Botton%20Navigation%20Bar/transaction%20screen.dart';
// import 'package:crpto_wallet/services/wallet_service.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:http/http.dart' as http;
// class NftHomeScreen extends StatefulWidget {
//   @override
//   _NftHomeScreenState createState() => _NftHomeScreenState();
// }
// class _NftHomeScreenState extends State<NftHomeScreen> {
//   List coins = [];
//   bool isLoading = true;
//   int _selectedIndex = 0;
//   int _tabIndex = 0; // 0 = Tokens, 1 = NFTs
//   bool showBalance = false;
//   bool _isBalanceLoading = false; 
//   bool copied = false;
//   bool isLoadingg = false;
//   void _onContinuePressed() {
//     setState(() {
//       isLoadingg = true; // ✅ Show loader
//     });
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         isLoadingg = false;
//       });
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CreateNft(),
//         ),
//       );
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//   }
// Future<void> fetchBalance() async {
//   final walletProvider = Provider.of<WalletProvider>(context, listen: false);

//     setState(() {
//       _isBalanceLoading = true; // 🔄 Jab balance fetch ho jaye to show karo
//     });

//   if (walletProvider.publicKey == null) return;

//   try {
//     final balMap = await WalletService.getBalance(walletProvider.publicKey!);

//     final bal = balMap["balance"].toString(); 
//     walletProvider.setBalance(bal);
//   } catch (e) {
//     debugPrint("Balance fetch error: $e");
//   }
//    setState(() {
//       _isBalanceLoading = false; 
//     });
// }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     if (index == 1) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => TransactionsScreen()));
//     } else if (index == 2) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
//     } else if (index == 3) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => ProfileScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//    final walletProvider = Provider.of<WalletProvider>(context);
//   final publicKey = walletProvider.publicKey ?? "";

//   // ✅ Agar empty hai (api ne load nahi kiya)
//   if (publicKey.isEmpty) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: const Center(
//         child: Text(
//           "No Wallet Found",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }

//   // ✅ Address short karna (jaise wallet me hota hai)
//   String shortAddress =
//       "${publicKey.substring(0, 6)}...${publicKey.substring(publicKey.length - 4)}";
//     return Scaffold(
//       backgroundColor: Colors.black,

//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//       ),

//       body: Column(
//         children: [
//           // 🔹 Balance Section
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                       GestureDetector(
//                   onTap: fetchBalance, 
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: _isBalanceLoading
//                         ? const SizedBox(
//                             height: 28,
//                             width: 28,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2.5,
//                               color:const Color(0xFFBFFF08),
//                             ),
//                           )
//                         : Text(
//                             walletProvider.balance ?? "Balance",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 InkWell(
//   onTap: () async {
//     await Clipboard.setData(ClipboardData(text: publicKey));
//     setState(() {
//       copied = true;
//     });
//     // ✅ 5 sec baad wapis copy icon show kar do
//     Future.delayed(const Duration(seconds: 5), () {
//       if (mounted) {
//         setState(() {
//           copied = false;
//         });
//       }
//     });
//   },
//    splashColor: Colors.transparent,   // 👈 disable splash
//   highlightColor: Colors.transparent, // 👈 disable highlight
//   overlayColor: WidgetStateProperty.all(Colors.transparent),
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Text(
//         shortAddress,
//         style: const TextStyle(
//           color: Colors.grey,
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       const SizedBox(width: 4),
//       Icon(
//         copied ? Icons.check_circle : Icons.copy,
//         size: 23,
//         color: copied ? const Color(0xFFBFFF08): Colors.grey,
//       ),
//     ],
//   ),
// ),
//                 SizedBox(height: 20),
//                 // 🔹 Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _walletButton(Icons.arrow_downward, "Send", NftScreen()),
//                     _walletButton(Icons.arrow_upward, "Receive", ReceiveScreen()),
//                     _walletButton(Icons.add, "Buy",NftScreen()),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     GestureDetector(
//       onTap: () {
//         // ✅ Token screen khol do
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => TokenHomeScreen()),
//         );
//       },
//       child: Column(
//         children: [
//           Text(
//             "Token",
//             style: TextStyle(
//               color: Colors.grey, // hamesha white rakho since new screen open ho rahi
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     ),
    
//     SizedBox(width: 15),
//     GestureDetector(
//       onTap: () => setState(() => _tabIndex = 0),
//       child: Column(
//         children: [
//           Text(
//             "NFTs",
//             style: TextStyle(
//               color: _tabIndex == 0 ? Colors.white : Colors.grey,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           if (_tabIndex == 0)
//             Container(
//               margin: EdgeInsets.only(top: 4),
//               height: 2,
//               width: 50,
//               color: Colors.white,
//             ),
//         ],
//       ),
//     ),
//   ],
// ),
// SizedBox(height: 20),
//           SizedBox(height: 20),
//               SizedBox(
//                 width: 281,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFBFFF08), // ✅ Button color
//                     foregroundColor: Colors.black, // text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   onPressed: _onContinuePressed,
//                   child: isLoadingg
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.black,
//                           ),
//                         )
//                       : const Text(
//                           "Create NFT",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//           SizedBox(height: 10,),
//          Expanded(
//   child: Consumer<WalletProvider>(
//     builder: (context, walletProvider, child) {
//       final nftList = walletProvider.nfts;

//       // ✅ Default NFTs jab empty ho
//       if (nftList.isEmpty) {
//         final defaultNfts = [
//           {"name": "Monk", "image": "assets/images/nft1.png"},
//           {"name": "Monk", "image": "assets/images/nft2.png"},
//           {"name": "Monk", "image": "assets/images/nft3.png"},
//           {"name": "Monk", "image": "assets/images/nft4.png"},
//         ];

//        return GridView.builder(
//   padding: const EdgeInsets.all(16),
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 12,
//     mainAxisSpacing: 12,
//     childAspectRatio: 0.8,
//   ),
//   itemCount: defaultNfts.length,
//   itemBuilder: (context, index) {
//     final nft = defaultNfts[index];
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 170,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(color: const Color(0xFFBFFF08), width: 2), // Border
//               borderRadius: BorderRadius.circular(16),
//               image: DecorationImage(
//                 image: AssetImage(nft["image"]!), // 👈 Image inside border
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 3),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               nft["name"]!,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   },
// );
//   }

//      return GridView.builder(
//   padding: const EdgeInsets.all(16),
//   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 12,
//     mainAxisSpacing: 12,
//     childAspectRatio: 0.8,
//   ),
//   itemCount: nftList.length,
//   itemBuilder: (context, index) {
//     final nft = nftList[index];
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 170,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(color: const Color(0xFFBFFF08), width: 2),
//               borderRadius: BorderRadius.circular(16),
//               image: nft["image_url"] != null && nft["image_url"] != ""
//                   ? DecorationImage(
//                       image: NetworkImage(nft["image_url"]),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: nft["image_url"] == null || nft["image_url"] == ""
//                 ? const Center(
//                     child: Icon(Icons.image, color: Colors.white, size: 40),
//                   )
//                 : null,
//           ),
//           const SizedBox(height: 5),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Text(
//               nft["name"] ?? "Unnamed NFT",   // ✅ yahan sahi key use karo
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   },
// );



//     },
//   ),
// ),


//         ],
//       ),
//       // 🔹 Bottom Navigation Bar
//       bottomNavigationBar: ClipRRect(
//   borderRadius: const BorderRadius.only(
//     topLeft: Radius.circular(20),
//     topRight: Radius.circular(20),
//   ),
//   child:BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.grey[900],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color(0xFFBFFF08),
//         unselectedItemColor: Colors.white,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.lock_clock_outlined), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.notification_add_outlined), label: "Notification"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),)
//     );
//   }

//   // 🔹 Wallet Button with navigation
//   Widget _walletButton(IconData icon, String label, Widget screen) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
//       },
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 25,
//             backgroundColor: const Color(0xFFBFFF08),
//             child: Icon(icon, color: Colors.black, size: 28),
//           ),
//           SizedBox(height: 5),
//           Text(label, style: TextStyle(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// }

// // 🔹 Dummy Screens
// class SendScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(title: Text("Send")),
//         body: Center(child: Text("Send Screen")),
//       );
// }
// class BuyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(title: Text("Buy")),
//         body: Center(child: Text("Buy Screen")),
//       );
// }



