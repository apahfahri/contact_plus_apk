import 'package:flutter/material.dart';
import 'package:contact_plus_apk/widget/formInput_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  // Inisialisasi TextEditingController
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    // Bersihkan controller saat widget dihancurkan
    namaController.dispose();
    nomerController.dispose();
    emailController.dispose();
    alamatController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void onSave() async {
  // Data yang akan disimpan
  final Map<String, dynamic> contactData = {
    'nama': namaController.text,
    'nomor': nomerController.text,
    'email': emailController.text,
    'alamat': alamatController.text,
    'catatan': noteController.text,
  };

  try {
    // Menyimpan data ke koleksi 'contact'
    await FirebaseFirestore.instance.collection('contact').add(contactData);

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data berhasil disimpan ')),
    );

    // Bersihkan field setelah menyimpan data
    namaController.clear();
    nomerController.clear();
    emailController.clear();
    alamatController.clear();
    noteController.clear();
  } catch (e) {
    // Tampilkan pesan error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
  }
}

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
          'Add Contact',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    Card(
      color: const Color(0xFF383B4E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Container dengan ikon user berbentuk lingkaran di tengah
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20), // Memberikan jarak antara icon dan form
            // Forminput di bawah icon
            Forminput(
              namaController: namaController,
              nomerController: nomerController,
              emailController: emailController,
              alamatController: alamatController,
              noteController: noteController,
              onSave: onSave,
            ),
          ],
        ),
      ),
    ),
  ],
),

    );
  }
}

// Widget Forminput tetap sama seperti yang telah Anda berikan sebelumnya.
