import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yotsuba_mobile/screens/Dashboard.dart';
import '../widgets/BottomNavBar.dart';  // Import the BottomNavBar widget

class UserProfile extends StatefulWidget {
  const UserProfile({super.key}); // Constructor

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _image;
  final picker = ImagePicker();
  String _userName = '';
  String _email = '';
  String _password = '';
  final int _selectedIndex = 3; // Track the selected index for BottomNavBar

  // Function to pick an image
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text('設定'), // Title of the page
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceDialog(), // Show dialog to choose image source
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.camera_alt, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 295,
                  height: 90,
                  child: ElevatedButton(
                    onPressed: _showImageSourceDialog, // Show dialog to choose image source
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '画像をアップロードする',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 28),
            _buildTextField('名前', 'あなたの名前を入力してください', (value) {
              _userName = value;
            }),
            const SizedBox(height: 28),
            _buildTextField('メールアドレス', 'email@domain.com', (value) {
              _email = value;
            }),
            const SizedBox(height: 28),
            _buildTextField('パスワード', '*********', (value) {
              _password = value;
            }, obscureText: true),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _updateUserInfo, // Call the update function
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('アップデート'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.logout, color: Colors.black),
                  SizedBox(width: 12),
                  Text('サインアウト', style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex, // Pass the selected index
      ),
    );
  }

  // Function to show image source dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                _pickImage(ImageSource.camera); // Pick image from camera
                Navigator.of(context).pop();
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                _pickImage(ImageSource.gallery); // Pick image from gallery
                Navigator.of(context).pop();
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  // Function to update user information
  void _updateUserInfo() {
    // Here you would typically send the data to an API or local storage.
    // For now, just showing a confirmation dialog.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          content: const SizedBox(
            width: 400,
            height: 100,
            child: Center(
              child: Text(
                "更新されました",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("OK"),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      Function(String) onChanged, {
        bool obscureText = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: const TextStyle(color: Colors.black45),
            border: const OutlineInputBorder(),
          ),
          obscureText: obscureText,
          onChanged: onChanged,
        ),
      ],
    );
  }
}