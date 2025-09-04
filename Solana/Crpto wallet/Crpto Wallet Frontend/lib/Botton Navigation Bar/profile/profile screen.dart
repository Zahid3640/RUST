import 'dart:io';
import 'dart:ui';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/notification.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/transaction%20screen.dart';
import 'package:crpto_wallet/Create%20Wallet%20Screens/crpto_wallet.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/Help%20and%20support.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/about%20crpto%20wallett.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/security%20and%20privacy.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/seed%20phrase.dart';
import 'package:crpto_wallet/Botton%20Navigation%20Bar/profile/term%20&%20condition.dart';
import 'package:crpto_wallet/Token/Token%20Home%20Screen.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  int _selectedIndex = 3; // Profile tab selected by default

  // Image Picker
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TransactionsScreen()));
    } else if (index == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CryptoWalletScreen()));
    } else if (index == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
    }
  }

  Widget buildMenuItem(String title, VoidCallback onTap) {
    
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Colors.white, size: 16),
          onTap: onTap,
        ),
        const Divider(
          color: Colors.white,
          thickness: 0.5,
          indent: 17,
          endIndent: 30,
        ),
      ],
    );
  }

  // 🔹 Show Logout Dialog with Blur
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // backdrop click se band na ho
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Dialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFBFFF08), width: 2),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        "Are you sure you want to\n log out?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFBFFF08),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        // 👇 Wallet clear karna
        Provider.of<WalletProvider>(context, listen: false).clear();

        // 👇 Navigate to CryptoWalletScreen and remove all previous routes
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CryptoWalletScreen()),
        );
      },
      child: const Text("Yes"),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("No"),
    ),
  ],
),


                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // ❌ Close Icon (Top Right)
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
     resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[800],
                    image: DecorationImage(
                      image: _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage("assets/images/profile.png")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Menu Items
            buildMenuItem("Seed Phrase", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SeedPhraseScreen()));
            }),
            buildMenuItem("Terms and Conditions", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const Termandconditionscreen()));
            }),
            buildMenuItem("Security & Privacy", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const Securityandprivacyscreen()));
            }),
            buildMenuItem("Help & Support", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const HelpAndSupportScreen()));
            }),
            buildMenuItem("About Crypto Wallet", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AboutCryptoWalletScreen()));
            }),

            const SizedBox(height: 20),

            // Logout
            ListTile(
              title: const Text(
                "Log Out",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.grey[900],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: const Color(0xFFBFFF08),
      //   unselectedItemColor: Colors.white,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.lock_clock_outlined), label: "Transactions"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.notifications_none), label: "Notification"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
        
      // ),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: "Transactions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 3, // Profile active
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TokenHomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionsScreen()),
            );
          }
        }),)
    );
  }
}
