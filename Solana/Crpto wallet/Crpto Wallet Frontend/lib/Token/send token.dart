import 'package:crpto_wallet/services/wallet_service.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:crpto_wallet/Token/tokensentsuccessfully.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SendTokenScreenn extends StatefulWidget {
  const SendTokenScreenn({super.key});

  @override
  State<SendTokenScreenn> createState() => _SendTokenScreennState();
}

class _SendTokenScreennState extends State<SendTokenScreenn> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  double availableBalance = 0.0;
  double selectedAmount = 0.0; // always in SOL
  double solPriceUsd = 0.0;
  double networkFeeMin = 0.91;
  double networkFeeMax = 1.50;

  bool isLoading = true;
  bool showUsd = false; // false = SOL mode, true = USD mode
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    try {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);
      final address = walletProvider.publicKey;

      if (address != null) {
        final balanceRes = await WalletService.getBalance(address);
        final balString =
            balanceRes["balance"].toString().replaceAll("SOL", "").trim();
        final bal = double.tryParse(balString.split(" ").first) ?? 0.0;

        final priceRes = await http.get(Uri.parse(
            "https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd"));
        final priceData = jsonDecode(priceRes.body);
        final price = priceData["solana"]["usd"] * 1.0;

        setState(() {
          availableBalance = bal;
          selectedAmount = 0.0;
          solPriceUsd = price;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading wallet data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendSol() async {
    if (_addressController.text.isEmpty || selectedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid address and amount")),
      );
      return;
    }

    try {
      setState(() => isSending = true);

      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      final res = await WalletService.sendSol(
        privateKey: walletProvider.privateKey!,
        toAddress: _addressController.text,
        amount: selectedAmount,
      );

      setState(() => isSending = false);
      final String signature = res["signature"] ?? "N/A";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Tokensendsuccessfully(
            amount: selectedAmount,
            usdValue: (selectedAmount * solPriceUsd),
            toAddress: _addressController.text,
            signature: signature,
            networkFeeMin: networkFeeMin,
            networkFeeMax: networkFeeMax,
          ),
        ),
      );
    } catch (e) {
      setState(() => isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
walletProvider.addTransaction(
  TransactionModel(
    type: "SENT",
    subtitle: "To: ${_addressController.text}",
    amount: selectedAmount.toStringAsFixed(4),
    token: "SOL",
    date: DateTime.now().toString(), // format properly if needed
  ),
);
  }

  /// ✅ Update selectedAmount according to mode
  void _updateAmountFromInput(String value) {
    final entered = double.tryParse(value) ?? 0.0;
    setState(() {
      if (showUsd) {
        // Entered USD → convert to SOL
        selectedAmount = entered / solPriceUsd;
      } else {
        // Entered SOL
        selectedAmount = entered;
      }
    });
  }

  /// ✅ Swap between USD <-> SOL
  void _swapCurrency() {
    setState(() {
      if (showUsd) {
        // USD → SOL
        double usd = double.tryParse(_amountController.text) ?? 0.0;
        double sol = usd / solPriceUsd;
        _amountController.text = sol.toStringAsFixed(4);
        selectedAmount = sol;
        showUsd = false;
      } else {
        // SOL → USD
        double sol = double.tryParse(_amountController.text) ?? 0.0;
        double usd = sol * solPriceUsd;
        _amountController.text = usd.toStringAsFixed(2);
        selectedAmount = sol;
        showUsd = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final usdValue = (selectedAmount * solPriceUsd).toStringAsFixed(2);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Send", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFBFFF08)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  const Text(
                    "Enter the Address and Amount in the below fields to send tokens.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Address input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFBFFF08), width: 1.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _addressController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "To: Enter SOL address",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text(
                    "$availableBalance SOL available",
                    style: const TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Amount Row
                  Row(
                    children: [
                      // ✅ Max Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAmount = availableBalance;
                            if (showUsd) {
                              _amountController.text =
                                  (selectedAmount * solPriceUsd)
                                      .toStringAsFixed(2);
                            } else {
                              _amountController.text =
                                  selectedAmount.toStringAsFixed(4);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBFFF08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Max",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Spacer(),

                      // ✅ Amount Input Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 140,
                            child: TextField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: showUsd ? "0.0 USD" : "0.0 SOL",
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                              onChanged: _updateAmountFromInput,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            showUsd
                                ? "${selectedAmount.toStringAsFixed(4)} SOL"
                                : "US\$$usdValue",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // ✅ Swap Icon
                      GestureDetector(
                        onTap: _swapCurrency,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: showUsd
                                ? const Color(0xFFBFFF08)
                                : Colors.grey[700],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.swap_vert,
                              color: showUsd ? Colors.black : Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Text("Network fee",
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    "US\$${networkFeeMin.toStringAsFixed(2)} - US\$${networkFeeMax.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 90),

                  // ✅ Send Button
                 SizedBox(
  width: 281,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFBFFF08),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    onPressed: _sendSol, // disable while sending
    child: isSending
        ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2,
            ),
          )
        : const Text(
            "Send Sol",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
  ),
),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
