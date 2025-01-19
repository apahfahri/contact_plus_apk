import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProfileUser extends StatefulWidget {
  final User user;
  const ProfileUser({super.key, required this.user});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final ImagePicker _picker = ImagePicker();
  String? _base64Image;
  late User currentUser;
  bool isLoading = true;

  late Map<String, dynamic>? userData = {};

  Future<void> fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>?;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
      saveToFirestore(currentUser.uid);
    }
  }

  Future<void> saveToFirestore(String userId) async {
    if (_base64Image != null) {
      await FirebaseFirestore.instance.collection('user').doc(userId).set({
        'profile_picture': _base64Image,
      }, SetOptions(merge: true));
      print("Image saved successfully!");
    }
  }

  Future<void> fetchImageFromFirestore(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get();
    if (doc.exists && doc.data()?['profile_picture'] != null) {
      setState(() {
        _base64Image = doc.data()?['profile_picture'];
      });
    }
  }

   Future<void> exportDataToPDF() async {
    try {
      final pdf = pw.Document();

      final data = await FirebaseFirestore.instance.collection('contact').where('uid_user',isEqualTo: currentUser.uid).get();


      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Daftar kontak dari akun ${currentUser.displayName}',
                    style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 16),
                pw.Table.fromTextArray(

                  headers: ['ID', 'Nama', 'Nomor Telepon', 'Email', 'Alamat', 'Sebagai'],
                  data: data.docs.map((doc) {
                    final d = doc.data();
                    return [
                      doc.id,
                      d['nama'] ?? '-',
                      d['nomor'] ?? '-',
                      d['email'] ?? '-',
                      d['alamat'] ?? '-',
                      d['catatan'] ?? '-',
                    ];
                  }).toList(),
                )
              ]);
        },
      ));

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'Daftar Kontak_${currentUser.displayName}.pdf',
      );
    } catch (e) {
      print('Error exproting PDF: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    _checkCurrentUser();
    fetchUserData();
    super.initState();
  }

  void _checkCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      fetchImageFromFirestore(user.uid);
    } else {
      Navigator.pushReplacementNamed(context, 'login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
           IconButton(
            onPressed: exportDataToPDF,
            icon: const Icon(Icons.import_export, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _base64Image != null
                              ? MemoryImage(base64Decode(_base64Image!))
                              : null,
                          backgroundColor: Colors.grey[800],
                          child: _base64Image == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        FloatingActionButton(
                          mini: true,
                          backgroundColor: const Color(0xFF3A89D5),
                          onPressed: pickImage,
                          child: const Icon(Icons.camera_alt, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // User Data
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E2F38),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                userData?['nama'] ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white38),
                          Row(
                            children: [
                              const Icon(Icons.email, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                userData?['email'] ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white38),
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                userData?['phone'] ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
