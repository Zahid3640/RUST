// import 'dart:io';
// import 'package:crpto_wallet/NFT/Success%20Nft.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:crpto_wallet/state/wallet_provider.dart';
// import 'package:crpto_wallet/services/wallet_service.dart';

// class CreateNft extends StatefulWidget {
//   const CreateNft({super.key});

//   @override
//   State<CreateNft> createState() => _CreateNftState();
// }

// class _CreateNftState extends State<CreateNft> {
//   bool isLoading = false;

//   // 🔹 Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _symbolController = TextEditingController();
//   final TextEditingController _linkController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   File? _selectedImage;

//   bool get _isFormValid {
//     return _nameController.text.isNotEmpty &&
//         _symbolController.text.isNotEmpty &&
//         _linkController.text.isNotEmpty &&
//         _descriptionController.text.isNotEmpty &&
//         _selectedImage != null;
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _createNft() async {
//     if (!_isFormValid) return;

//     setState(() => isLoading = true);

//     try {
//       // ✅ WalletProvider se keys
//       final wallet = Provider.of<WalletProvider>(context, listen: false);
//       if (wallet.privateKey == null || wallet.publicKey == null) {
//         throw Exception("Wallet not initialized");
//       }

//       // ✅ Backend API call
//       final result = await WalletService.createNftMultipart(
//         privateKey: wallet.privateKey!,
//         name: _nameController.text,
//         symbol: _symbolController.text,
//         description: _descriptionController.text,
//         externalUrl: _linkController.text,
//         imageFile: _selectedImage!,
//       );

//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Successnft(
//               data: result, // 🔥 backend se aayi NFT details
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
//       );
//       print("Error creating NFT: $e");
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _symbolController.dispose();
//     _linkController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   InputDecoration _buildInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.grey),
//       enabledBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.grey),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Color(0xFFBFFF08)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: const Text("Create NFT", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   height: 200,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[850],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey, width: 1),
//                   ),
//                   child: _selectedImage != null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.file(_selectedImage!, fit: BoxFit.cover),
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.photo_library,
//                                 color: Colors.white, size: 50),
//                             SizedBox(height: 10),
//                             Text(
//                               "Upload a picture:\n(File Type: PNG, JPG, Max: 10 MB)",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: Colors.white70, fontSize: 13),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               TextField(
//                 controller: _nameController,
//                 decoration: _buildInputDecoration("Enter Name"),
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: (_) => setState(() {}),
//               ),
//               const SizedBox(height: 12),

//               TextField(
//                 controller: _symbolController,
//                 decoration: _buildInputDecoration("Enter Symbol"),
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: (_) => setState(() {}),
//               ),
//               const SizedBox(height: 12),

//               TextField(
//                 controller: _linkController,
//                 decoration: _buildInputDecoration("Enter External Link"),
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: (_) => setState(() {}),
//               ),
//               const SizedBox(height: 12),

//               TextField(
//                 controller: _descriptionController,
//                 maxLines: 3,
//                 decoration: _buildInputDecoration("Enter Description"),
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: (_) => setState(() {}),
//               ),

//               const SizedBox(height: 40),

//               SizedBox(
//                 width: 281,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFBFFF08),
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   onPressed: _isFormValid ? _createNft : null,
//                   child: isLoading
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.black,
//                           ),
//                         )
//                       : const Text(
//                           "Create NFT",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:crpto_wallet/NFT/Home/Nft%20Home%20Screen.dart';
import 'package:crpto_wallet/NFT/Create/Nft%20Create%20Successfully.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:crpto_wallet/state/wallet_provider.dart';
import 'package:crpto_wallet/services/wallet_service.dart';

class CreateNft extends StatefulWidget {
  const CreateNft({super.key});

  @override
  State<CreateNft> createState() => _CreateNftState();
}

class _CreateNftState extends State<CreateNft> {
  bool isLoading = false;

  // 🔹 Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _symbolController.text.isNotEmpty &&
        _linkController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedImage != null;
  }

  Future<void> _pickImage() async {
    if (isLoading) return; // prevent picking image while loading
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _createNft() async {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields & upload image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final wallet = Provider.of<WalletProvider>(context, listen: false);
      if (wallet.privateKey == null || wallet.publicKey == null) {
        throw Exception("Wallet not initialized");
      }

      final result = await WalletService.createNftMultipart(
        privateKey: wallet.privateKey!,
        name: _nameController.text,
        symbol: _symbolController.text,
        description: _descriptionController.text,
        externalUrl: _linkController.text,
        imageFile: _selectedImage!,
        walletProvider: wallet, // ✅ pass WalletProvider instance
      );
      wallet.addTransaction(
        TransactionModel(
          type: "NFT CREATED",
          subtitle: "Mint: ${result["mint_address"] ?? "N/A"}", // ✅ mint address save
    amount: "1",
    token: _symbolController.text,
    date: DateTime.now().toIso8601String(),
  ),
);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Successnft(data: result),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
      print("Error creating NFT: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _linkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFBFFF08)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child:Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
         leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: isLoading ? null : () => Navigator.push(context, MaterialPageRoute(builder: (context) => NftHomeScreen())),
        ),
        title: const Text("Create NFT", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: isLoading, // ✅ disable clicks while loading
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child:
                                Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.photo_library,
                                  color: Colors.white, size: 50),
                              SizedBox(height: 10),
                              Text(
                                "Upload a picture:\n(File Type: PNG, JPG, Max: 10 MB)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _nameController,
                  decoration: _buildInputDecoration("Enter Name"),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _symbolController,
                  decoration: _buildInputDecoration("Enter Symbol"),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _linkController,
                  decoration: _buildInputDecoration("Enter External Link"),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _buildInputDecoration("Enter Description"),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: 281,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBFFF08),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus(); // 🔹 Focus remove
                      _createNft();
                    },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            "Create NFT",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

