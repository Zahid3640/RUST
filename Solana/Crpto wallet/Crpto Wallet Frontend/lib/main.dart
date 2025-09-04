// import 'package:crpto_wallet/Create%20Wallet%20Screens/splash_screen.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// void main() {
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

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor:  Color(0xFFBFFF08)),
//       ),
//        debugShowCheckedModeBanner: false,
//       home:  SplashScreen(),
//     );
//   }
// }

import 'package:crpto_wallet/Create%20Wallet%20Screens/splash_screen.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ ye import add karo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Orientation fix: sirf portrait mode allow hoga
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletProvider()),
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
