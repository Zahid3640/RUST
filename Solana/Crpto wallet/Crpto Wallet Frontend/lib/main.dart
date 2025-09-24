// import 'package:crpto_wallet/services/wallet_storage.dart';
// import 'package:crpto_wallet/splash_screen.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // ✅ Orientation fix: sirf portrait mode allow hoga
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   // ✅ Init wallet storage (SharedPreferences singleton)
//   await WalletStorage.init();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => WalletProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Crypto Wallet',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBFFF08)),
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const SplashScreen(),
//     );
//   }
// }

import 'package:crpto_wallet/splash_screen.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ ye import add karo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    final walletProvider = WalletProvider();
  await walletProvider.loadWallet();

  // ✅ Orientation fix: sirf portrait mode allow hoga
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => walletProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBFFF08)),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
