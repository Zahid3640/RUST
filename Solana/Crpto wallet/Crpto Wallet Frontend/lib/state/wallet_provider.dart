// // wallet_provider.dart
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// class WalletProvider with ChangeNotifier {
//   String? privateKey;
//   String? publicKey;
//   String? seedPhrase;
//   String? status;
//   String? _balance;
//   String? get balance => _balance;

//   List<Map<String, dynamic>> nfts = [];
//   final List<TransactionModel> _transactions = [];
//   List<TransactionModel> get transactions => _transactions;

//   // ✅ Update wallet data from API response
//   void setWalletData(Map<String, dynamic> data) {
//     // backend sometimes wraps in "payload"
//     final payload = data["payload"] ?? data["wallet"] ?? data;

//     privateKey  = payload['private_key'] as String?;
//     publicKey   = payload['public_key'] as String?;
//     seedPhrase  = payload['seed_phrase'] as String?;
//     status      = data['status'] as String? ?? payload['status'] as String?;
//     notifyListeners();
//   }

//   void clear() {
//     privateKey = publicKey = seedPhrase = status = _balance = null;
//     nfts.clear();
//     _transactions.clear();
//     notifyListeners();
//   }

//   void setBalance(String bal) {
//     _balance = bal;
//     notifyListeners();
//   }

//   void addTransaction(TransactionModel tx) {
//     _transactions.insert(0, tx);
//     notifyListeners();
//   }

//   Future<void> addNft(Map<String, dynamic> nft) async {
//     String? name;
//     String? image;

//     final metaUri = nft["metadata_uri"]?.toString();
//     if (metaUri != null && metaUri.isNotEmpty) {
//       try {
//         final res = await http.get(Uri.parse(metaUri));
//         if (res.statusCode == 200) {
//           final meta = jsonDecode(res.body) as Map<String, dynamic>;
//           debugPrint("📥 Metadata: $meta");
//           name  = (meta["name"]  as String?)?.trim();
//           image = (meta["image"] as String?)?.trim();
//         }
//       } catch (e) {
//         debugPrint("❌ Metadata fetch error: $e");
//       }
//     }

//     if (image != null && image.startsWith("ipfs://")) {
//       image = image.replaceFirst("ipfs://", "https://gateway.pinata.cloud/ipfs/");
//     }

//     if (name == null || name.isEmpty) {
//       name = (nft["name"] as String?)?.trim() ?? "Unnamed NFT";
//     }
//     if (image == null || image.isEmpty) {
//       image = (nft["image_url"] as String?)?.trim() ?? "";
//     }

//     final nftData = Map<String, dynamic>.from(nft)
//       ..["name"] = name
//       ..["image_url"] = image;

//     nfts.add(nftData);
//     debugPrint("🎉 NFT Added: $nftData");
//     notifyListeners();
//   }

//   Future<Map<String, dynamic>> sendNft({
//     required String receiver,
//     required String mint,
//   }) async {
//     if (privateKey == null) {
//       throw Exception("❌ Wallet is locked. Private key not found.");
//     }

//     // TODO: WalletService.sendNft bana hua hai to call karna hoga
//     // final result = await WalletService.sendNft(...);

//     nfts.removeWhere((nft) => nft["mint"] == mint);

//     addTransaction(TransactionModel(
//       type: "SENT",
//       subtitle: "NFT Sent to $receiver",
//       amount: "1",
//       token: "NFT",
//       date: DateTime.now().toIso8601String(),
//     ));

//     notifyListeners();
//     return {"status": "success"};
//   }
// }

// class TransactionModel {
//   final String type;
//   final String subtitle;
//   final String amount;
//   final String token;
//   final String date;

//   TransactionModel({
//     required this.type,
//     required this.subtitle,
//     required this.amount,
//     required this.token,
//     required this.date,
//   });
// }



import 'dart:convert';
import 'package:crpto_wallet/services/wallet_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WalletProvider with ChangeNotifier {
  String? privateKey;
  String? publicKey;
  String? seedPhrase;
  String? status;
  String? _balance;
  String? get balance => _balance;
  List<Map<String, dynamic>> nfts = [];
Future<void> addNft(Map<String, dynamic> nft) async {
  String? name;
  String? image;

  // 1) Try to read metadata JSON first
  final metaUri = nft["metadata_uri"]?.toString();
  if (metaUri != null && metaUri.isNotEmpty) {
    try {
      final res = await http.get(Uri.parse(metaUri));
      if (res.statusCode == 200) {
        final meta = jsonDecode(res.body) as Map<String, dynamic>;
        debugPrint("📥 Metadata: $meta");

        name  = (meta["name"]  as String?)?.trim();
        image = (meta["image"] as String?)?.trim();
      } else {
        debugPrint("❌ Metadata HTTP ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      debugPrint("❌ Metadata fetch error: $e");
    }
  }

  // 2) Normalize ipfs://
  if (image != null && image.startsWith("ipfs://")) {
    image = image.replaceFirst("ipfs://", "https://gateway.pinata.cloud/ipfs/");
  }

  // 3) Fallbacks (handle NULL **and** EMPTY)
  if (name == null || name.isEmpty) {
    final fromNft = (nft["name"] as String?)?.trim();
    if (fromNft != null && fromNft.isNotEmpty) {
      name = fromNft;
    }
  }
  if (name == null || name.isEmpty) {
    name = "Unnamed NFT";
  }

  if (image == null || image.isEmpty) {
    image = (nft["image_url"] as String?)?.trim() ?? "";
  }

  final nftData = Map<String, dynamic>.from(nft)
    ..["name"] = name
    ..["image_url"] = image;

  nfts.add(nftData);
  debugPrint("🎉 NFT Added: $nftData");
  notifyListeners();
}
  void setWalletData(Map<String, dynamic> data) {
    privateKey  = data['private_key'] as String?;
    publicKey   = data['public_key'] as String?;
    seedPhrase  = data['seed_phrase'] as String?;
    status      = data['status'] as String?;
     if (data.containsKey("wallet")) { 
      publicKey = (data["wallet"] as Map<String, dynamic>)["public_key"] as String?;
    } else {
      publicKey = data["public_key"] as String?;
    }
    notifyListeners();
  }
  Future<Map<String, dynamic>> sendNft({
    required String receiver,
    required String mint,
  }) async {
    if (privateKey == null) {
      throw Exception("❌ Wallet is locked. Private key not found.");
    }

    final result = await WalletService.sendNft(
      senderPrivateKey: privateKey!,
      receiverAddress: receiver,
      mintAddress: mint,
    );

    // ✅ NFT list se remove
    nfts.removeWhere((nft) => nft["mint"] == mint);
     // ✅ Add transaction
    addTransaction(TransactionModel(
      type: "SENT",
      subtitle: "NFT Sent to $receiver",
      amount: "1",
      token: "NFT",
      date: DateTime.now().toIso8601String(),
    ));

    notifyListeners();
    return result;
  }

  void setBalance(String bal) {
    _balance = bal;
    notifyListeners();
  }
   Future<void> loadWallet() async {
    final prefs = await SharedPreferences.getInstance();
    publicKey = prefs.getString("public_Key") ?? "";
    notifyListeners();
  }
    final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  // ✅ Add transaction
  void addTransaction(TransactionModel tx) {
    _transactions.insert(0, tx); // latest on top
    notifyListeners();
  }
  void clear() {
    privateKey = publicKey = seedPhrase = status = _balance = null;
    notifyListeners();
  }
}
class TransactionModel {
  final String type; // SENT, RECEIVED, SWAPPED, BOUGHT
  final String subtitle;
  final String amount;
  final String token;
  final String date;

  TransactionModel({
    required this.type,
    required this.subtitle,
    required this.amount,
    required this.token,
    required this.date,
  });
}



