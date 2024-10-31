import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hideBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.hideBackButton =
        false, // Optional parameter to control back button visibility
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading:
          !hideBackButton, // Set to false to remove back button
      centerTitle: true,
      backgroundColor: Colors.teal,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, // Set text color to white
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
