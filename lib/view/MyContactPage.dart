import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

//firebase packages
import 'package:cloud_firestore/cloud_firestore.dart';

class MyContactPage extends StatefulWidget {
  const MyContactPage({super.key});

  @override
  _MyContactPageState createState() => _MyContactPageState();
}

class _MyContactPageState extends State<MyContactPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Row(
          children: [
            Text(
              "My Contact+",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 8),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'add_contact');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: const Color(0xFF23253A), boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(1),
          ),
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.white,
              tabs: const [
                // GButton untuk dashboard_user
                GButton(
                  icon: LineIcons.phone,
                  text: 'Contact',
                ),
                // GButton untuk favorite_pages
                GButton(
                  icon: LineIcons.heart,
                  text: 'Favorite',
                ),
                // GButton untuk profile_pages
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, 'dashboard_user');
                    break;
                  case 1:
                    Navigator.pushNamed(context, 'favorite_pages');
                    break;
                  case 2:
                    Navigator.pushNamed(context, 'profile_pages');
                    break;
                }
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Card(
              color: const Color(0xFF383B4E),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: StreamBuilder<QuerySnapshot>(
                  // Ambil data dari koleksi 'contact'
                  stream: FirebaseFirestore.instance
                      .collection('contact')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Periksa apakah ada data atau error
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Terjadi kesalahan saat mengambil data'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada kontak yang ditemukan',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    // Ambil data dari snapshot
                    final contacts = snapshot.data!.docs;

                    // Periksa apakah data kosong
                    if (contacts.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada pengajuan bimbingan.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final nama = contact['nama'] ??
                            'Nama tidak tersedia'; // Ambil field 'nama'

                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(nama),
                            onTap: () {
                              final contactId = contact
                                  .id; // Get the contact ID from the Firestore document
                              Navigator.pushNamed(
                                context,
                                'detail_contact',
                                arguments:
                                    contactId, // Pass the contact ID as the argument
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite_border,
                                      color: Colors.black),
                                  onPressed: () {
                                    // Logika untuk menambahkan ke favorit
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black),
                                  onPressed: () async {
                                    // Hapus kontak berdasarkan ID dokumen
                                    await FirebaseFirestore.instance
                                        .collection('contact')
                                        .doc(contact.id)
                                        .delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Kontak berhasil dihapus'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  // Daftar kontak
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 children: [
//                   _buildContactCard("Deddy Corbuzier"),
//                   _buildContactCard("Rina Nose"),
//                   _buildContactCard("Fajar Sadboy"),
//                   _buildContactCard("Vidi Aldiano"),
//                 ],
//               ),
//             ),
//             // Tombol Tambah Kontak
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//             ),

// Widget _buildContactCard(String name) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF383B4E),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ListTile(
//         leading: const CircleAvatar(
//           backgroundColor: Color(0xFF3A89D5),
//           child: Icon(Icons.person, color: Colors.white),
//         ),
//         title: Text(
//           name,
//           style: const TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.favorite_border, color: Colors.white),
//               onPressed: () {
//                 // Logika untuk menambahkan ke favorit
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.white),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }