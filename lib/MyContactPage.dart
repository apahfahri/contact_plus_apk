import 'package:flutter/material.dart';

class MyContactPage extends StatelessWidget {
  const MyContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("My Contact+"),
            const SizedBox(width: 8),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              // Logika untuk ikon info
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Logika untuk menu
          },
        ),
      ),
      body: Column(
        children: [
          // Input pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF383B4E),
                hintText: "Cari Kontak...",
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildContactCard("Deddy Corbuzier"),
                _buildContactCard("Rina Nose"),
                _buildContactCard("Fajar Sadboy"),
                _buildContactCard("Vidi Aldiano"),
              ],
            ),
          ),
          // Tombol Tambah Kontak
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Logika untuk menambahkan kontak
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A89D5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Tambah Kontak",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Navigasi bawah
          Container(
            color: const Color(0xFF383B4E),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    // Logika navigasi ke halaman kontak
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.white),
                  onPressed: () {
                    // Logika navigasi ke halaman favorit
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat card kontak
  Widget _buildContactCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF383B4E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF3A89D5),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {
                // Logika untuk menambahkan ke favorit
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
