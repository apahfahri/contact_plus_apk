import 'package:flutter/material.dart';

class FavoriteContact extends StatefulWidget {
  const FavoriteContact({super.key});

  @override
  State<FavoriteContact> createState() => _FavoriteContactState();
}

class _FavoriteContactState extends State<FavoriteContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Favorite Contact',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}