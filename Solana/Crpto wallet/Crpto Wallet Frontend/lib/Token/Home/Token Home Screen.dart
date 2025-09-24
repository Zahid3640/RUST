import 'dart:convert';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
import 'package:crpto_wallet/NFT/Home/Nft%20Home%20Screen.dart';
import 'package:crpto_wallet/Token/Receive/receive%20token.dart';
import 'package:crpto_wallet/Token/Send/send%20token.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/transaction%20screen.dart';
import 'package:crpto_wallet/services/wallet_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:http/http.dart' as http;
class TokenHomeScreen extends StatefulWidget {
  @override
  _TokenHomeScreenState createState() => _TokenHomeScreenState();
}

class _TokenHomeScreenState extends State<TokenHomeScreen> {
  List coins = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  int _tabIndex = 0; // 0 = Tokens, 1 = NFTs
  bool showBalance = false;
  bool _isBalanceLoading = false; 
  bool copied = false;

  @override
  void initState() {
    super.initState();
    fetchTokens();
  }
Future<void> fetchBalance() async {
  final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    setState(() {
      _isBalanceLoading = true; // 🔄 Jab balance fetch ho jaye to show karo
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
  Future<void> fetchTokens() async {
    final url =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&symbols=usdt,shib,link&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en&include_tokens=all";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        coins = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load tokens");
    }
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
 // 🔹 Balance Section
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
                    _walletButton(Icons.arrow_upward, "Send", SendTokenScreenn()),
                    _walletButton(Icons.arrow_downward, "Receive", ReceiveScreen()),
                    _walletButton(Icons.swap_horiz, "Swap", SwapScreen()),
                    _walletButton(Icons.add, "Buy", BuyScreen()),
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
      onTap: () => setState(() => _tabIndex = 0),
      child: Column(
        children: [
          Text(
            "Tokens",
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
    SizedBox(width: 15),
    GestureDetector(
      onTap: () {
        // ✅ NFT screen khol do
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NftHomeScreen()),
        );
      },
      child: Column(
        children: [
          Text(
            "NFTs",
            style: TextStyle(
              color: Colors.grey, // hamesha white rakho since new screen open ho rahi
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ],
),

          SizedBox(height: 20),

          // 🔹 List Section
          Expanded(
            child: _tabIndex == 0
                ? isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFFBFFF08),
                        ),
                      )
                    : ListView.builder(
                        itemCount: coins.length,
                        itemBuilder: (context, index) {
                          final coin = coins[index];
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
                                      SizedBox(width: 8),
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
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "\$${coin['current_price']}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "\$${(coin['low_24h'] ?? 0.0).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            coin['symbol'].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                      )
                    : const SizedBox(),
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


class SwapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Swap")),
        body: Center(child: Text("Swap Screen")),
      );
}

class BuyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Buy")),
        body: Center(child: Text("Buy Screen")),
      );
}



