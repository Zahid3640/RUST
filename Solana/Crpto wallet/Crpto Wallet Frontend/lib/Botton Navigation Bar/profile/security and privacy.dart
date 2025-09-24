


import 'package:flutter/material.dart';
class Securityandprivacyscreen extends StatefulWidget {
  const Securityandprivacyscreen({super.key});

  @override
  State<Securityandprivacyscreen> createState() => _SecurityandprivacyscreenState();
}

class _SecurityandprivacyscreenState extends State<Securityandprivacyscreen> {
  bool _useFaceId = false;

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
          "Security & Privacy",
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
      body:  Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Use Face ID",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  Switch(
                    value: _useFaceId,
                    activeColor: const Color(0xFFBFFF08),
                    onChanged: (val) => setState(() => _useFaceId = val),
                  ),
                ],
              ),
              
      ),

    );
  }
}
