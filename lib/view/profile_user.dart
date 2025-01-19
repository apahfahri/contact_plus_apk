import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ProfileUser extends StatefulWidget {
  final User user;
  const ProfileUser({super.key, required this.user});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  File? _imageFile;

  late User currentUser;

  @override
  void initState() {
    _checkCurrentUser();
    currentUser = widget.user;
    super.initState();
  }

  // Mengunggah gambar
  Future<void> _uploadImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  void _checkCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
    } else {
      // Jika tidak ada pengguna yang login, arahkan ke halaman login
      Navigator.pushReplacementNamed(context, 'login_page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Profile User', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, 'login_screen');
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
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
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
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
                  child: const Text("Upload Image",
                      style: TextStyle(color: Colors.white)),
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
              ],
            ),
          )),
    );
  }
}
