import 'package:flutter/material.dart';

class Forminput extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController nomerController;
  final TextEditingController emailController;
  final TextEditingController alamatController;
  final TextEditingController noteController;
  final VoidCallback onSave;

  const Forminput({
    super.key,
    required this.namaController,
    required this.nomerController,
    required this.emailController,
    required this.alamatController,
    required this.noteController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Nama
        TextFormField(
          controller: namaController,
          decoration: InputDecoration(
            labelText: 'Nama',
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.person), // Ikon untuk nama
          ),
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nama tidak boleh kosong';
            }
            // Nama boleh huruf dan angka
            if (!RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(value)) {
              return 'Nama hanya boleh huruf dan angka';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Input Nomor Telepon
        TextFormField(
          controller: nomerController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Nomor Telepon',
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.phone), // Ikon untuk nomor telepon
          ),
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nomor telepon tidak boleh kosong';
            }
            // Nomor telepon harus angka dan minimal 11 digit
            if (!RegExp(r'^[0-9]{11,}$').hasMatch(value)) {
              return 'Nomor telepon harus berupa angka dan minimal 11 digit';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Input Email
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.email), // Ikon untuk email
          ),
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email tidak boleh kosong';
            }
            // Validasi email
            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(value)) {
              return 'Email tidak valid';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Input Alamat
        TextFormField(
          controller: alamatController,
          decoration: InputDecoration(
            labelText: 'Alamat',
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.location_on), // Ikon untuk alamat
          ),
          style: const TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Alamat tidak boleh kosong';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Input Catatan
        TextFormField(
          controller: noteController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Catatan',
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 16),

        // Tombol Simpan
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(color: Colors.black), // Perbaikan warna teks
          ),
        ),
      ],
    );
  }
}
