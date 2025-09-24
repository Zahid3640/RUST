import 'dart:convert';
import 'dart:io';
import 'package:crpto_wallet/services/wallet_storage.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:flutter/material.dart';
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
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    },
    body: jsonEncode({
      "password": password,
      "confirm_password": confirmPassword,
    }),
  );

  final data = _handleResponse(res);

  if (data["wallet"] != null) {
    // 👇 Save as String
    await WalletStorage.saveWallet(jsonEncode(data["wallet"]));
  }

  return data;
}
 static Future<Map<String, dynamic>> unlockWallet({
    required String password,
  }) async {
    final encrypted = await WalletStorage.loadWallet(); // String milega

    if (encrypted == null) {
      throw Exception("⚠️ No wallet found. Please create/import first.");
    }

    final uri = Uri.parse("$_base/unlock_wallet");

    final res = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "password": password,
        "wallet": jsonDecode(encrypted), // 👈 String ko JSON me decode karna hai
      }),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;  
    } else {
      throw Exception("Unlock failed: ${res.body}");
    }
  }
static Future<Map<String, dynamic>> exportWallet({
  required String password,
}) async {
  final encrypted = await WalletStorage.loadWallet();
  if (encrypted == null) {
    throw Exception("⚠️ No wallet found. Please create/import first.");
  }

  final uri = Uri.parse("$_base/export_wallet");
  final res = await http.post(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode({
      "password": password,
      "wallet": jsonDecode(encrypted),
    }),
  );

  final data = _handleResponse(res);
  print("🔹 Raw export_wallet response: $data");

  if (data["payload"] is Map<String, dynamic>) {
    // ✅ sirf payload return karna hai
    return Map<String, dynamic>.from(data["payload"]);
  } else {
    throw Exception("❌ Unexpected server response: $data");
  }
}

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

  final data = _handleResponse(res);

  // ✅ agar import successful hua to wallet local me save karo
  if (data["status"] == "success" && data.containsKey("wallet")) {
    final walletJson = jsonEncode(data["wallet"]);
    await WalletStorage.saveWallet(walletJson);
  }

  return data;
}
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
      final body = jsonDecode(res.body);

      return {
        "status": "success",
        "signature": body["signature"] ?? "",
        "fee_sol": (body["fee_sol"] as num?)?.toDouble() ?? 0.0, // ✅ safe cast
        "network": body["network"] ?? "",
      };
    } catch (e) {
      final raw = res.body.trim();
      String signature = "";
      if (raw.contains("Tx Success:")) {
        signature = raw.split("Tx Success:").last.trim();
      }

      return {
        "status": "success",
        "signature": signature,
        "fee_sol": 0.0,
        "network": "Unknown",
      };
    }
  } else {
    throw Exception("Server Error: ${res.statusCode}");
  }
}

    static Future<Map<String, dynamic>> createNftMultipart({
    required String privateKey,
    required String name,
    required String symbol,
    required String description,
    required String externalUrl,
    required File imageFile,
    required WalletProvider walletProvider, 
  }) async {
    final uri = Uri.parse("$_base/create_nft");
    var request = http.MultipartRequest("POST", uri);

    // fields
    request.fields["private_key"] = privateKey;
    request.fields["name"] = name;
    request.fields["symbol"] = symbol;
    request.fields["description"] = description;
    request.fields["external_url"] = externalUrl;

    // file
    request.files.add(await http.MultipartFile.fromPath("file", imageFile.path));

    print("📤 Sending request to $uri");
    print("Fields: ${request.fields}");
    print("File: ${imageFile.path}");

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);

    print("🔵 Status Code: ${res.statusCode}");
    print("🔵 Body: ${res.body}");

    if (res.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);

      // 🔹 Metadata fetch
      String? metadataUri = responseData["metadata_uri"];
      Map<String, dynamic>? metadata;
      if (metadataUri != null && metadataUri.isNotEmpty) {
        try {
          final metaRes = await http.get(Uri.parse(metadataUri));
          if (metaRes.statusCode == 200) {
            metadata = jsonDecode(metaRes.body);
            print("📥 Metadata: $metadata");
          } else {
            print("⚠️ Metadata fetch failed: ${metaRes.statusCode}");
          }
        } catch (e) {
          print("❌ Metadata fetch error: $e");
        }
      }
      return {
        ...responseData, // backend response
        "metadata": metadata, // name, symbol, desc, image from metadata.json
      };
    } else {
      throw Exception("❌ Failed: ${res.statusCode} -> ${res.body}");
    }

  }
  static Future<List<Map<String, dynamic>>> getNfts(String publicKey) async {
  final uri = Uri.parse("$_base/get_nfts");
  final res = await http.post(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode({"public_key": publicKey}),
  );

  if (res.statusCode == 200) {
    final List<dynamic> body = jsonDecode(res.body);

    List<Map<String, dynamic>> finalNfts = [];

    for (var e in body) {
      final nft = Map<String, dynamic>.from(e);

      // Default description blank
      String description = "";

      // Agar metadata_uri mila hai to uska JSON fetch karo
      if (nft["metadata_uri"] != null && nft["metadata_uri"].toString().isNotEmpty) {
        try {
          final metaRes = await http.get(Uri.parse(nft["metadata_uri"]));
          if (metaRes.statusCode == 200) {
            final metaData = jsonDecode(metaRes.body);
            description = metaData["description"] ?? "";
          }
        } catch (err) {
          debugPrint("⚠️ Metadata fetch error: $err");
        }
      }

      // NFT object me description add karo
      nft["description"] = description;

      finalNfts.add(nft);
    }

    return finalNfts;
  } else {
    throw Exception("❌ Failed to fetch NFTs: ${res.statusCode}");
  }
}


  
  // inside WalletService class
static Future<Map<String, dynamic>> sendNft({
  required String senderPrivateKey,
  required String receiverAddress,
  required String mintAddress,
}) async {
  final uri = Uri.parse("$_base/send_nft");
  final res = await http.post(
    uri,
    headers: {"Content-Type": "application/json", "Accept": "application/json"},
    body: jsonEncode({
      "sender_private_key": senderPrivateKey,
      "receiver_address": receiverAddress,
      "mint_address": mintAddress,
    }),
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body) as Map<String, dynamic>;
  } else {
    throw Exception("❌ NFT Send Failed: ${res.statusCode} -> ${res.body}");
  }
}

  }
  
  Map<String, dynamic> _handleResponse(http.Response res) {
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

// import 'dart:convert';
// import 'dart:io';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class WalletService {
//   static const _base = "http://192.168.18.119:8082";

//   // 🔹 Create Wallet
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

//     return _handleResponse(res);
//   }

//   // 🔹 Import Wallet (seed phrase OR private key dono ka support)
//   static Future<Map<String, dynamic>> importWallet({
//     String? seedPhrase,
//     String? privateKey,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     final uri = Uri.parse("$_base/import_wallet");

//     // ✅ body me sirf wahi field bhejni jo fill ki gayi ho
//     final Map<String, dynamic> body = {
//       "password": password,
//       "confirm_password": confirmPassword,
//     };
//     if (seedPhrase != null && seedPhrase.isNotEmpty) {
//       body["mnemonic"] = seedPhrase; // 🔹 API me mnemonic field use hoti hai
//     }
//     if (privateKey != null && privateKey.isNotEmpty) {
//       body["private_key"] = privateKey;
//     }

//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json", "Accept": "application/json"},
//       body: jsonEncode(body),
//     );

//     return _handleResponse(res);
//   }

//   // 🔹 Unlock Wallet
//   static Future<Map<String, dynamic>> unlockWallet({
//     required String password,
//   }) async {
//     final uri = Uri.parse("$_base/unlock_wallet");
//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json", "Accept": "application/json"},
//       body: jsonEncode({"password": password}),
//     );

//     return _handleResponse(res);
//   }

//  // 🔹 Get Balance
// static Future<Map<String, dynamic>> getBalance(String address) async {
//   final uri = Uri.parse("$_base/sol_balance");
//   final res = await http.post(
//     uri,
//     headers: {"Content-Type": "application/json", "Accept": "application/json"},
//     body: jsonEncode({"address": address}),
//   );

//   if (res.statusCode == 200) {
//     // Response text ko trim karo
//     final raw = res.body.trim();

//     // Agar "Balance: 2.5 SOL" format hai
//     if (raw.startsWith("Balance")) {
//       final parts = raw.split(":");
//       final value = parts.length > 1 ? parts[1].trim() : "0 SOL";
//       return {"balance": value}; // ✅ always return as map
//     }

//     // Agar JSON hai to normal decode
//     try {
//       return jsonDecode(res.body) as Map<String, dynamic>;
//     } catch (_) {
//       return {"balance": raw};
//     }
//   } else {
//     throw Exception("Server Error: ${res.statusCode}");
//   }
// }
// static Future<Map<String, dynamic>> receiveWallet({
//     required String address,
//   }) async {
//     final uri = Uri.parse("$_base/receive");
//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json", "Accept": "application/json"},
//       body: jsonEncode({
//         "public_address": address,
//       }),
//     );

//     return _handleResponse(res);
//   }

// static Future<Map<String, dynamic>> sendSol({
//   required String privateKey,
//   required String toAddress,
//   required double amount,
// }) async {
//   final uri = Uri.parse("$_base/sol_send");
//   final res = await http.post(
//     uri,
//     headers: {"Content-Type": "application/json", "Accept": "application/json"},
//     body: jsonEncode({
//       "private_key": privateKey,
//       "to_address": toAddress,
//       "amount": amount,
//     }),
//   );

//   if (res.statusCode == 200) {
//     try {
//       final body = jsonDecode(res.body);

//       return {
//         "status": "success",
//         "signature": body["signature"] ?? "",
//         "fee_sol": (body["fee_sol"] as num?)?.toDouble() ?? 0.0, // ✅ safe cast
//         "network": body["network"] ?? "",
//       };
//     } catch (e) {
//       final raw = res.body.trim();
//       String signature = "";
//       if (raw.contains("Tx Success:")) {
//         signature = raw.split("Tx Success:").last.trim();
//       }

//       return {
//         "status": "success",
//         "signature": signature,
//         "fee_sol": 0.0,
//         "network": "Unknown",
//       };
//     }
//   } else {
//     throw Exception("Server Error: ${res.statusCode}");
//   }
// }

//     static Future<Map<String, dynamic>> createNftMultipart({
//     required String privateKey,
//     required String name,
//     required String symbol,
//     required String description,
//     required String externalUrl,
//     required File imageFile,
//     required WalletProvider walletProvider, 
//   }) async {
//     final uri = Uri.parse("$_base/create_nft");
//     var request = http.MultipartRequest("POST", uri);

//     // fields
//     request.fields["private_key"] = privateKey;
//     request.fields["name"] = name;
//     request.fields["symbol"] = symbol;
//     request.fields["description"] = description;
//     request.fields["external_url"] = externalUrl;

//     // file
//     request.files.add(await http.MultipartFile.fromPath("file", imageFile.path));

//     print("📤 Sending request to $uri");
//     print("Fields: ${request.fields}");
//     print("File: ${imageFile.path}");

//     final streamedRes = await request.send();
//     final res = await http.Response.fromStream(streamedRes);

//     print("🔵 Status Code: ${res.statusCode}");
//     print("🔵 Body: ${res.body}");

//     if (res.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(res.body);

//       // 🔹 Metadata fetch
//       String? metadataUri = responseData["metadata_uri"];
//       Map<String, dynamic>? metadata;
//       if (metadataUri != null && metadataUri.isNotEmpty) {
//         try {
//           final metaRes = await http.get(Uri.parse(metadataUri));
//           if (metaRes.statusCode == 200) {
//             metadata = jsonDecode(metaRes.body);
//             print("📥 Metadata: $metadata");
//           } else {
//             print("⚠️ Metadata fetch failed: ${metaRes.statusCode}");
//           }
//         } catch (e) {
//           print("❌ Metadata fetch error: $e");
//         }
//       }
//       return {
//         ...responseData, // backend response
//         "metadata": metadata, // name, symbol, desc, image from metadata.json
//       };
//     } else {
//       throw Exception("❌ Failed: ${res.statusCode} -> ${res.body}");
//     }

//   }
//   static Future<List<Map<String, dynamic>>> getNfts(String publicKey) async {
//   final uri = Uri.parse("$_base/get_nfts");
//   final res = await http.post(
//     uri,
//     headers: {"Content-Type": "application/json", "Accept": "application/json"},
//     body: jsonEncode({"public_key": publicKey}),
//   );

//   if (res.statusCode == 200) {
//     final List<dynamic> body = jsonDecode(res.body);

//     List<Map<String, dynamic>> finalNfts = [];

//     for (var e in body) {
//       final nft = Map<String, dynamic>.from(e);

//       // Default description blank
//       String description = "";

//       // Agar metadata_uri mila hai to uska JSON fetch karo
//       if (nft["metadata_uri"] != null && nft["metadata_uri"].toString().isNotEmpty) {
//         try {
//           final metaRes = await http.get(Uri.parse(nft["metadata_uri"]));
//           if (metaRes.statusCode == 200) {
//             final metaData = jsonDecode(metaRes.body);
//             description = metaData["description"] ?? "";
//           }
//         } catch (err) {
//           debugPrint("⚠️ Metadata fetch error: $err");
//         }
//       }

//       // NFT object me description add karo
//       nft["description"] = description;

//       finalNfts.add(nft);
//     }

//     return finalNfts;
//   } else {
//     throw Exception("❌ Failed to fetch NFTs: ${res.statusCode}");
//   }
// }


  
//   // inside WalletService class
// static Future<Map<String, dynamic>> sendNft({
//   required String senderPrivateKey,
//   required String receiverAddress,
//   required String mintAddress,
// }) async {
//   final uri = Uri.parse("$_base/send_nft");
//   final res = await http.post(
//     uri,
//     headers: {"Content-Type": "application/json", "Accept": "application/json"},
//     body: jsonEncode({
//       "sender_private_key": senderPrivateKey,
//       "receiver_address": receiverAddress,
//       "mint_address": mintAddress,
//     }),
//   );

//   if (res.statusCode == 200) {
//     return jsonDecode(res.body) as Map<String, dynamic>;
//   } else {
//     throw Exception("❌ NFT Send Failed: ${res.statusCode} -> ${res.body}");
//   }
// }

//   }
  
//   Map<String, dynamic> _handleResponse(http.Response res) {
//     Map<String, dynamic> body = {};
//     try {
//       body = jsonDecode(res.body) as Map<String, dynamic>;
//     } catch (_) {}

//     if (res.statusCode == 200) {
//       return body;
//     } else {
//       final msg = body['message']?.toString() ?? "Server Error: ${res.statusCode}";
//       throw Exception(msg);
//     }
//   }

