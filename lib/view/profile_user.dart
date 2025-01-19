import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: exportDataToPDF,
            icon: const Icon(Icons.import_export,)
          ),
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
