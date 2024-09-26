import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  File? _image;
  final picker = ImagePicker();
  String _userName = '';
  String _email = '';
  String _password = '';

  Future<void> _pickImage() async {
    final pickedFile = await showDialog<XFile>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                Navigator.of(context).pop(pickedFile);
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop(pickedFile);
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? const Icon(Icons.camera_alt, size: 50) : null,
                  ),
                ),
                const SizedBox(width: 44), // Space between avatar and button
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload Image'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _userName = value; // Update the username when typed
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value; // Update the email when typed
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Hide the password input
              onChanged: (value) {
                setState(() {
                  _password = value; // Update the password when typed
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle update action (e.g., save user info)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white),
              child: const Text('Update'),
            ),
            const Spacer(), // Push the Logout button to the bottom
            ElevatedButton(
              onPressed: () {
                // Handle logout action (e.g., save data)
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.logout, color: Colors.black), // Logout icon
                  SizedBox(width: 8), // Space between icon and text
                  Text('Logout', style: TextStyle(color: Colors.black)), // Logout text
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}