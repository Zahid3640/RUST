import 'package:flutter/foundation.dart';

class WalletProvider with ChangeNotifier {
  String? privateKey;
  String? publicKey;
  String? seedPhrase;
  String? status;
  String? _balance;
  String? get balance => _balance;

  void setWalletData(Map<String, dynamic> data) {
    privateKey  = data['private_key'] as String?;
    publicKey   = data['public_key'] as String?;
    seedPhrase  = data['seed_phrase'] as String?;
    status      = data['status'] as String?;
    notifyListeners();
  }

  void setBalance(String bal) {
    _balance = bal;
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


// class WalletProvider with ChangeNotifier {
//   String? privateKey;
//   String? publicKey;
//   String? seedPhrase;
//   String? status; 

//   /// Common method for create / import / unlock
//   void setWalletData(Map<String, dynamic> data) {
//     privateKey  = data['private_key'] as String?;
//     publicKey   = data['public_key'] as String?;
//     seedPhrase  = data['seed_phrase'] as String?; // may be null in unlock
//     status      = data['status'] as String?;
//     notifyListeners();
//   }

//   /// For create wallet (seed phrase must be there)
//   void setCreatedWallet(String private, String public, String seed, String stat) {
//     privateKey = private;
//     publicKey  = public;
//     seedPhrase = seed;
//     status     = stat;
//     notifyListeners();
//   }

//   /// For import wallet (seed phrase available)
//   void setImportedWallet(String private, String public, String seed, String stat) {
//     privateKey = private;
//     publicKey  = public;
//     seedPhrase = seed;
//     status     = stat;
//     notifyListeners();
//   }

//   /// For unlock wallet (only private & public key mostly)
//   void setUnlockedWallet(String private, String public, String stat) {
//     privateKey = private;
//     publicKey  = public;
//     seedPhrase = null; // unlock usually doesn’t return it
//     status     = stat;
//     notifyListeners();
//   }

//   void clear() {
//     privateKey = publicKey = seedPhrase = status = null;
//     notifyListeners();
//   }
// }
