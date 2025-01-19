import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContact extends StatefulWidget {
  final User user;

  const AddContact({super.key, required this.user});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User currentUser;

  @override
  void initState() {
    currentUser = widget.user;
    super.initState();
  }

  @override
  void dispose() {
    namaController.dispose();
    nomerController.dispose();
    emailController.dispose();
    alamatController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void onSave() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> contactData = {
        'uid_user': currentUser.uid,
        'nama': namaController.text,
        'nomor': nomerController.text,
        'email': emailController.text,
        'alamat': alamatController.text,
        'catatan': noteController.text,
        'status': 'no fav',
      };

      try {
        await FirebaseFirestore.instance.collection('contact').add(contactData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );

        namaController.clear();
        nomerController.clear();
        emailController.clear();
        alamatController.clear();
        noteController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        title: const Text(
          'Add My Contact+',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tambah Kontak',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Input Fields
                _buildInputField(
                  controller: namaController,
                  hintText: 'Nama',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: nomerController,
                  hintText: 'Telepon',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    } else if (!RegExp(r'^[0-9]{11,}$').hasMatch(value)) {
                      return 'Data harus berupa angka minimal 11 angka';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Masukkan format email yang benar';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: alamatController,
                  hintText: 'Alamat',
                  icon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                _buildInputField(
                  controller: noteController,
                  hintText: 'Notes',
                  icon: Icons.note,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Tambah',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          fillColor: const Color(0xFFEEEEEE),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
