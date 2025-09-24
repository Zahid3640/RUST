import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WalletStorage {
  static Future<void> saveWallet(String walletJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("wallet", walletJson);
  }

  static Future<String?> loadWallet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("wallet"); // String milega
  }
  
  static Future<void> clearWallet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("wallet"); // 👈 local storage se remove karega
  }
  }
 
