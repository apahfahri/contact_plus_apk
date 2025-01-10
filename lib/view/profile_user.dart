import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ProfileUser extends StatefulWidget {
  final User user;
  const ProfileUser({super.key, required this.user});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _username;
  String? _email;
  String? _phone;
  File? _imageFile;

  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _fetchUserData();
  }

  // Mengambil data pengguna dari Firestore
  Future<void> _fetchUserData() async {
    // Misalkan kita menggunakan ID pengguna 'user_id' untuk mengambil data
    DocumentSnapshot userDoc = await _firestore.collection('users').doc('user_id').get();
    setState(() {
      _username = userDoc['username'];
      _email = userDoc['email'];
      _phone = userDoc['phone'];
      // Jika ada URL gambar, Anda bisa mengaturnya di sini
    });
  }

  // Mengunggah gambar
  Future<void> _uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
      // Anda bisa menambahkan logika untuk meng-upload gambar ke Firebase Storage di sini
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Menampilkan gambar profil jika ada
            _imageFile != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage(_imageFile!),
                  )
                : const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A89D5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Upload Image", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
            // Menampilkan data pengguna
            Text(
              'Username: ${currentUser.displayName ?? "nama pengguna"}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${currentUser.email ?? "email pengguna"}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone: ${currentUser.phoneNumber ?? "nomor telepon"}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            // Text(
            //   'Username: ${_username ?? "Loading..."}',
            //   style: const TextStyle(color: Colors.white, fontSize: 18),
            // ),
            // const SizedBox(height: 10),
            // Text(
            //   'Email: ${_email ?? "Loading..."}',
            //   style: const TextStyle(color: Colors.white, fontSize: 18),
            // ),
            // const SizedBox(height: 10),
            // Text(
            //   'Phone: ${_phone ?? "Loading..."}',
            //   style: const TextStyle(color: Colors.white, fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}