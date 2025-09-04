import 'package:flutter/material.dart';
class AboutCryptoWalletScreen extends StatefulWidget {
  const AboutCryptoWalletScreen({super.key});

  @override
  State<AboutCryptoWalletScreen> createState() => _AboutCryptoWalletScreenState();
}

class _AboutCryptoWalletScreenState extends State<AboutCryptoWalletScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
         centerTitle: true,
        title: const Text(
          "About Crypto Wallet",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Lorem ipsum dolor sit amet consectetur. Turpis\net iaculis hendrerit lacinia massa.",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.left,
            ),
             const SizedBox(height: 8),
            const Text(
              "Lacus varius ultricies nec euismod vitae risus\nnon sit. Ullamcorper erat eu velit tincidunt\nmalesuada vel. Placerat pulvinar pellentesque id\nsit nec turpis scelerisque purus id.",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.left,
            ),
          const SizedBox(height: 8),
            const Text(
              "Elit eleifend et vulputate vestibulum ut. Auctor\namet pretium pulvinar pellentesque commodo\nultrices mattis quam bibendum. Ante interdum\nsed adipiscing a habitant libero sit sed pretium.\nMaecenas arcu pulvinar et turpis nunc quis ut.\nAdipiscing cras ut tortor non euismod pretium\ntellus. Sed bibendum libero in commodo tellus\ntincidunt dictum. Quis porttitor hac cursus\nsagittis.",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.left,
            ),
         const SizedBox(height: 8),
            const Text(
              "Mattis semper mus donec tortor aliquam urna\nfaucibus faucibus. Donec netus sed molestie\nvel. Ut fusce adipiscing elit amet est arcu. Leo\nnisl neque nulla diam purus volutpat. ",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.left,
            ),
            


            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}