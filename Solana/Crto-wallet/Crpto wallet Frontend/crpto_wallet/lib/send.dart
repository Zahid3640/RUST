import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendTokenScreen extends StatefulWidget {
  const SendTokenScreen({super.key});

  @override
  State<SendTokenScreen> createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  bool isLoading = false;
  String? responseMsg;

  Future<void> sendToken() async {
    setState(() => isLoading = true);

    final url = "https://jsonplaceholder.typicode.com/posts"; // mock API
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "to": _addressController.text,
        "amount": _amountController.text,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        responseMsg = "✅ Transaction Successful!";
        isLoading = false;
      });
    } else {
      setState(() {
        responseMsg = "❌ Transaction Failed!";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Send Token")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Receiver Address"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: sendToken,
                    child: const Text("Send"),
                  ),
            if (responseMsg != null) ...[
              const SizedBox(height: 20),
              Text(responseMsg!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ]
          ],
        ),
      ),
    );
  }
}
