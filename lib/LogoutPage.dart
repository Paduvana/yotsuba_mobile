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

//Function that picks an image
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
//image picker
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
        title: const Text('設定'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null ? const Icon(Icons.camera_alt, size: 30) : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 295,
                    height:90, // Space between avatar and button
                    child:
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // Change the radius here
                        ),
                        elevation: 0, //no shadow
                      ),
                      child: const Text(
                        '画像をアップロードする',
                        style: TextStyle(color: Colors.black,
                            fontSize: 17),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '名前',  // "Name" in Japanese
                    style: TextStyle(
                      fontSize: 18,  // Adjust the font size if needed
                      color: Colors.black,  // Adjust the text color
                    ),
                  ),
                  const SizedBox(height: 8),  // Spacing between the label and the TextField
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'あなたの名前を入力してください',  // "Enter your name"
                      labelStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _userName = value; // Update the username when typed
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'メールアドレス',  // "Email Address"
                    style: TextStyle(
                      fontSize: 16,  // Adjust the font size as needed
                      color: Colors.black,  // Adjust the color as needed
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'email@domain.com',
                      labelStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value; // Update the email when typed
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'パスワード',  // "password"
                    style: TextStyle(
                      fontSize: 16,  // Adjust the font size as needed
                      color: Colors.black,  // Adjust the color as needed
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '*********  ',
                      labelStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true, // Hide the password input
                    onChanged: (value) {
                      setState(() {
                        _password = value; // Update the password when typed
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 52),
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
            ]
        ),
      ),
    );
  }
}
