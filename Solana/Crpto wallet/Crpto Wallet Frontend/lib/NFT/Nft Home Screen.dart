import 'dart:convert';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
import 'package:crpto_wallet/NFT/Create%20Nft.dart';
import 'package:crpto_wallet/Receive/receive%20token.dart';
import 'package:crpto_wallet/Token/Token%20Home%20Screen.dart';
import 'package:crpto_wallet/Token/send%20token.dart';
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
  List coins = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  int _tabIndex = 0; // 0 = Tokens, 1 = NFTs
  bool showBalance = false;
  bool _isBalanceLoading = false; 
  bool copied = false;
  bool isLoadingg = false;
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
        elevation: 0,
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
                    _walletButton(Icons.arrow_downward, "Send", SendTokenScreenn()),
                    _walletButton(Icons.arrow_upward, "Receive", ReceiveScreen()),
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
          // 🔹 List Section
          
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



