import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yotsuba_mobile/screens/Login.dart';
import 'package:yotsuba_mobile/widgets/CustomAppBar.dart';
import 'package:yotsuba_mobile/services/UserProfileService.dart';
import '../widgets/BottomNavBar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? _image;
  final picker = ImagePicker();
  final _userProfileService = UserProfileService();
  
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final int _selectedIndex = 3;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

Future<void> _loadUserData() async {
  try {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userData = await _userProfileService.fetchUserProfileData(context);
    setState(() {
      print(userData);
      _nameController.text = userData['name'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _passwordController.clear(); // Clear password field
      
      final avatar = userData['avatar'];
      if (avatar != null && avatar.toString().isNotEmpty) {
      }
      
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
      _errorMessage = e.toString();
    });
  }
}

Widget _buildAvatar() {
  return CircleAvatar(
    radius: 35,
    backgroundImage: _image != null 
        ? FileImage(_image!) 
        : null,
    child: _image == null
        ? const Icon(Icons.camera_alt, size: 30)
        : null,
  );
}

Future<void> _updateUserInfo() async {
  try {
    setState(() {
      _isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Call the update profile method
    await _userProfileService.updateUserProfile(
      context,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
      avatar: _image,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }

    setState(() {
      _passwordController.clear();
      _isLoading = false;
    });

    if (mounted) {
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
                    _loadUserData();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal,
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
  } catch (e) {
    if (mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('更新に失敗しました: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: const CustomAppBar(title: '設定', hideBackButton: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('エラーが発生しました: $_errorMessage'),
              ElevatedButton(
                onPressed: _loadUserData,
                child: const Text('再試行'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '設定', hideBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: _buildAvatar()
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 295,
                  height: 90,
                  child: ElevatedButton(
                    onPressed: _showImageSourceDialog,
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
            _buildTextField('名前', 'あなたの名前を入力してください', _nameController),
            const SizedBox(height: 28),
            _buildTextField('メールアドレス', 'email@domain.com', _emailController),
            const SizedBox(height: 28),
            _buildTextField('パスワード', '*********', _passwordController, obscureText: true),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: _updateUserInfo,
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
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
        selectedIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
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
          controller: controller,
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: const TextStyle(color: Colors.black45),
            border: const OutlineInputBorder(),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () {
                _pickImage(ImageSource.camera); 
                Navigator.of(context).pop();
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }
    Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
