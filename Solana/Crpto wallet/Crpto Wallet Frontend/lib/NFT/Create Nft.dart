import 'dart:io';
import 'package:crpto_wallet/NFT/Success%20Nft.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateNft extends StatefulWidget {
  const CreateNft({super.key});

  @override
  State<CreateNft> createState() => _CreateNftState();
}

class _CreateNftState extends State<CreateNft> {
  bool isLoading = false;

  // 🔹 Controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _symbolController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage; // ✅ Selected image from gallery

  // ✅ Check if all fields are filled
  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _symbolController.text.isNotEmpty &&
        _linkController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedImage != null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _onContinuePressed() {
    if (!_isFormValid) return; // ❌ Prevent click when form invalid

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Successnft(),
        ),
      );
    });
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Create NFT", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Image Upload Container
              GestureDetector(
                onTap: _pickImage, // ✅ Open gallery
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
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
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

              // 🔹 Name
              TextField(
                controller: _nameController,
                decoration: _buildInputDecoration("Enter Name"),
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // 🔹 Symbol
              TextField(
                controller: _symbolController,
                decoration: _buildInputDecoration("Enter Symbol"),
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // 🔹 External Link
              TextField(
                controller: _linkController,
                decoration: _buildInputDecoration("Enter External Link"),
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // 🔹 Description
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _buildInputDecoration("Enter Description"),
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 40),

            // 🔹 Create NFT Button
SizedBox(
  width: 281,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFBFFF08), // ✅ Always same color
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
    ),
    onPressed: () {
      if (_isFormValid) {
        _onContinuePressed(); // ✅ Run only if form valid
      } else {
        // ❌ Do nothing (or show SnackBar if you want feedback)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill all fields and upload image."),
            backgroundColor: Colors.red,
          ),
        );
      }
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
