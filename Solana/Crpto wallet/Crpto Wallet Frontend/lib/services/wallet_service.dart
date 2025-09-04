// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class WalletService {
//   static const _base = "http://192.168.18.119:8082";

//   static Future<Map<String, dynamic>> createWallet({
//     required String password,
//     required String confirmPassword,
//   }) async {
//     final uri = Uri.parse("$_base/create_wallet");
//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json", "Accept": "application/json"},
//       body: jsonEncode({
//         "password": password,
//         "confirm_password": confirmPassword,
//       }),
//     );
//     Map<String, dynamic> body = {};
//     try { body = jsonDecode(res.body) as Map<String, dynamic>; } catch (_) {}

//     if (res.statusCode == 200) {
//       return body; 
//     } else {
//       final msg = body['message']?.toString() ?? "Server Error: ${res.statusCode}";
//       throw Exception(msg);
//     }
//   }
//   static Future<Map<String, dynamic>> importWallet({
//     required String seedPhrase,
//     required String privatekey,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     final uri = Uri.parse("$_base/import_wallet");
//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json", "Accept": "application/json"},
//       body: jsonEncode({
//         "seed_phrase": seedPhrase,
//         "private_key": privatekey,
//         "password": password,
//         "confirm_password": confirmPassword,
//       }),
//     );
//     Map<String, dynamic> body = {};
//     try { body = jsonDecode(res.body) as Map<String, dynamic>; } catch (_) {}

//     if (res.statusCode == 200) {
//       return body; 
//     } else {
//       final msg = body['message']?.toString() ?? "Server Error: ${res.statusCode}";
//       throw Exception(msg);
//     }
//   }
//   static Future<Map<String,dynamic>> unlockWallet({
//     required String password,
//   }) async {
//     final uri = Uri.parse("$_base/unlock_wallet");
//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json", "Accept": "application/json"},
//       body: jsonEncode({
//         "password": password,
//       }),
//     );
//     Map<String, dynamic> body = {};
//     try { body = jsonDecode(res.body) as Map<String, dynamic>; } catch (_) {}

//     if (res.statusCode == 200) {
//       return body;
//     } else {
//       final msg = body['message']?.toString() ?? "Server Error: ${res.statusCode}";
//       throw Exception(msg);
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class WalletService {
  static const _base = "http://192.168.18.119:8082";

  // 🔹 Create Wallet
  static Future<Map<String, dynamic>> createWallet({
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse("$_base/create_wallet");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({
        "password": password,
        "confirm_password": confirmPassword,
      }),
    );

    return _handleResponse(res);
  }

  // 🔹 Import Wallet (seed phrase OR private key dono ka support)
  static Future<Map<String, dynamic>> importWallet({
    String? seedPhrase,
    String? privateKey,
    required String password,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse("$_base/import_wallet");

    // ✅ body me sirf wahi field bhejni jo fill ki gayi ho
    final Map<String, dynamic> body = {
      "password": password,
      "confirm_password": confirmPassword,
    };
    if (seedPhrase != null && seedPhrase.isNotEmpty) {
      body["mnemonic"] = seedPhrase; // 🔹 API me mnemonic field use hoti hai
    }
    if (privateKey != null && privateKey.isNotEmpty) {
      body["private_key"] = privateKey;
    }

    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  // 🔹 Unlock Wallet
  static Future<Map<String, dynamic>> unlockWallet({
    required String password,
  }) async {
    final uri = Uri.parse("$_base/unlock_wallet");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"password": password}),
    );

    return _handleResponse(res);
  }

 // 🔹 Get Balance
static Future<Map<String, dynamic>> getBalance(String address) async {
  final uri = Uri.parse("$_base/sol_balance");
  final res = await http.post(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode({"address": address}),
  );

  if (res.statusCode == 200) {
    // Response text ko trim karo
    final raw = res.body.trim();

    // Agar "Balance: 2.5 SOL" format hai
    if (raw.startsWith("Balance")) {
      final parts = raw.split(":");
      final value = parts.length > 1 ? parts[1].trim() : "0 SOL";
      return {"balance": value}; // ✅ always return as map
    }

    // Agar JSON hai to normal decode
    try {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return {"balance": raw};
    }
  } else {
    throw Exception("Server Error: ${res.statusCode}");
  }
}
static Future<Map<String, dynamic>> receiveWallet({
    required String address,
  }) async {
    final uri = Uri.parse("$_base/receive");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({
        "public_address": address,
      }),
    );

    return _handleResponse(res);
  }
static Future<Map<String, dynamic>> sendSol({
  required String privateKey,
  required String toAddress,
  required double amount,
}) async {
  final uri = Uri.parse("$_base/sol_send");
  final res = await http.post(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode({
      "private_key": privateKey,
      "to_address": toAddress,
      "amount": amount,
    }),
  );

  if (res.statusCode == 200) {
    try {
      // ✅ Try JSON parse first
      final body = jsonDecode(res.body);

      return {
        "status": body["status"] ?? "success",
        "signature": body["signature"] ?? "",
      };
    } catch (_) {
      // ✅ If not JSON, parse text response
      final raw = res.body.trim();

      String signature = "";
      if (raw.contains("Tx Success:")) {
        signature = raw.split("Tx Success:").last.trim();
      }

      return {
        "status": "success",
        "signature": signature,
      };
    }
  } else {
    throw Exception("Server Error: ${res.statusCode}");
  }
}


  // 🔹 Common Response Handler
  static Map<String, dynamic> _handleResponse(http.Response res) {
    Map<String, dynamic> body = {};
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {}

    if (res.statusCode == 200) {
      return body;
    } else {
      final msg = body['message']?.toString() ?? "Server Error: ${res.statusCode}";
      throw Exception(msg);
    }
  }
}
