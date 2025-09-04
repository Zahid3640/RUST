// import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
// import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
// import 'package:crpto_wallet/mainwalletscreen.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class TransactionsScreen extends StatelessWidget {
//   const TransactionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Transactions",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // SENT
//           _buildTransactionCard(
//             title: "SENT",
//             subtitle: "To: 0xFaa...893E",
//             amount: "1.4532",
//             token: "ETH",
//             date: "Nov 23, 2024  11.20 A.M",
//           ),
//           const Divider(color: Colors.white24),

//           // RECEIVED
//           _buildTransactionCard(
//             title: "RECEIVED",
//             subtitle: "From: 0xFaa...893E",
//             amount: "1.4532",
//             token: "USDT",
//             date: "Nov 20, 2024  10:00 P.M",
//           ),
//           const Divider(color: Colors.white24),

//           // SWAPPED
//           _buildSwapTransactionCard(
//             from: "0xFaa...893E",
//             to: "0x2sa...R635",
//             amountFrom: "1.4532",
//             tokenFrom: "ETH",
//             amountTo: "0.3426",
//             tokenTo: "USDT",
//             date: "Nov 23, 2024  11.20 A.M",
//           ),
//           const Divider(color: Colors.white24),

//           // BOUGHT
//           _buildBuyTransactionCard(
//             title: "BOUGHT",
//             amount: "4000 USDT",
//             paid: "34435.2 \$",
//             fee: "1.232 \$",
//             received: "234.4 \$",
//             date: "Nov 23, 2024  11.20 A.M",
//           ),
//         ],
//       ),

//       // ✅ Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         selectedItemColor: const Color(0xFFBFFF08),
//         unselectedItemColor: Colors.white70,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.history), label: "Transactions"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.notifications), label: "Notifications"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//         currentIndex: 1, // Transactions active
//         onTap: (index) {
//           if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => NotificationsScreen()),
//             );
//           } else if (index == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => WalletHomeScreen()),
//             );
//           } else if (index == 3) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ProfileScreen()),
//             );
//           }
//         }),
//     );
//   }

//   // 🔹 Sent / Received
//   Widget _buildTransactionCard({
//     required String title,
//     required String subtitle,
//     required String amount,
//     required String token,
//     required String date,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   color: Color(0xFFBFFF08),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(subtitle,
//                   style: const TextStyle(color: Colors.white, fontSize: 14)),
//               Text("Date",
//                   style: const TextStyle(color: Colors.grey, fontSize: 14)),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Amount",
//                   style: const TextStyle(color: Colors.grey, fontSize: 14)),
//               Text(date,
//                   style: const TextStyle(color: Colors.white, fontSize: 14)),
//             ],
//           ),
//           const SizedBox(height: 2),
//           Text(
//             "$amount  $token",
//             style: const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔹 Swapped
//   Widget _buildSwapTransactionCard({
//     required String from,
//     required String to,
//     required String amountFrom,
//     required String tokenFrom,
//     required String amountTo,
//     required String tokenTo,
//     required String date,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("SWAPPED",
//               style: TextStyle(
//                   color: Color(0xFFBFFF08),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("From: $from",
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 14)),
//                     Text("$amountFrom $tokenFrom",
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 16)),
//                   ],
//                 ),
//               ),
//               const Icon(Icons.swap_horiz, color: Colors.white, size: 28),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text("To: $to",
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 14)),
//                     Text("$amountTo $tokenTo",
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 16)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text("Date: $date",
//               style: const TextStyle(color: Colors.grey, fontSize: 14)),
//         ],
//       ),
//     );
//   }

//   // 🔹 Bought
//   Widget _buildBuyTransactionCard({
//     required String title,
//     required String amount,
//     required String paid,
//     required String fee,
//     required String received,
//     required String date,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   color: Color(0xFFBFFF08),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(amount,
//               style: const TextStyle(color: Colors.white, fontSize: 16)),
//           const SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Paid\n$paid",
//                   style: const TextStyle(color: Colors.white, fontSize: 14)),
//               Text("Received\n$received",
//                   textAlign: TextAlign.right,
//                   style: const TextStyle(color: Colors.white, fontSize: 14)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text("Fee: $fee",
//               style: const TextStyle(color: Colors.grey, fontSize: 14)),
//           const SizedBox(height: 6),
//           Text("Date: $date",
//               style: const TextStyle(color: Colors.grey, fontSize: 14)),
//         ],
//       ),
//     );
//   }
// }
// class TransactionsScreen extends StatelessWidget { 
//   const TransactionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final transactions = context.watch<WalletProvider>().transactions;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: const Text("Transactions", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: transactions.isEmpty
//           ? const Center(
//               child: Text("No transactions yet",
//                   style: TextStyle(color: Colors.grey)))
//           : ListView.separated(
//               padding: const EdgeInsets.all(16),
//               itemCount: transactions.length,
//               separatorBuilder: (_, __) =>
//                   const Divider(color: Colors.white24),
//               itemBuilder: (context, index) {
//                 final tx = transactions[index];
//                 return _buildTransactionCard(
//                   title: tx.type,
//                   subtitle: tx.subtitle,
//                   amount: tx.amount,
//                   token: tx.token,
//                   date: tx.date,
//                 );
//               },
//             ),
//     );
//   }

//   Widget _buildTransactionCard({
//     required String title,
//     required String subtitle,
//     required String amount,
//     required String token,
//     required String date,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   color: Color(0xFFBFFF08),
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(subtitle, style: const TextStyle(color: Colors.white)),
//           const SizedBox(height: 4),
//           Text("$amount $token",
//               style: const TextStyle(color: Colors.white, fontSize: 16)),
//           const SizedBox(height: 4),
//           Text(date, style: const TextStyle(color: Colors.grey, fontSize: 14)),
//         ],
//       ),
//     );
//   }
// }
import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/profile%20screen.dart';
import 'package:crpto_wallet/Token/Token%20Home%20Screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../state/wallet_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  String formatDate(String date) {
    final dt = DateTime.parse(date);
    return DateFormat("dd MMM yyyy, hh:mm:ss a").format(dt);
  }

  String shortAddress(String address) {
    if (address.length <= 10) return address;
    return "${address.substring(0, 6)}...${address.substring(address.length - 4)}";
  }

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<WalletProvider>().transactions;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Transactions",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text("No transactions yet",
                  style: TextStyle(color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Colors.grey, thickness: 0.5), // ✅ grey line
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _buildTransactionCard(
                  title: tx.type,
                  subtitle: shortAddress(tx.subtitle), // ✅ short address
                  amount: tx.amount,
                  token: tx.token,
                  date: formatDate(tx.date), // ✅ formatted date
                );
              },
            ),

      /// ✅ Bottom Navigation Bar
      bottomNavigationBar: ClipRRect(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  child: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: const Color(0xFFBFFF08),
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Transactions active
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TokenHomeScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
      ),)
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required String subtitle,
    required String amount,
    required String token,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// First Row: Title & Short Address
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Color(0xFFBFFF08),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.white)),
            ],
          ),

          const SizedBox(height: 10),

          /// Second Row: Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Amount",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text("Date",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            ],
          ),

          const SizedBox(height: 2),

          /// Third Row: Amount & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$amount $token",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text(date,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}