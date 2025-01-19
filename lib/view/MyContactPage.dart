import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyContactPage extends StatefulWidget {
  final User user;
  const MyContactPage({super.key, required this.user});

  @override
  _MyContactPageState createState() => _MyContactPageState();
}

class _MyContactPageState extends State<MyContactPage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  late User currentUser;

  @override
  void initState() {
    _checkCurrentUser();
    currentUser = widget.user;
    _searchController.addListener(() {
      setState(() {});
      _searchText = _searchController.text;
    });
    super.initState();
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
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF3A89D5),
              ),
              accountName: Text(
                currentUser.displayName ?? "Nama Pengguna",
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                currentUser.email ?? "Email Tidak Tersedia",
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  (currentUser.displayName != null &&
                          currentUser.displayName!.isNotEmpty)
                      ? currentUser.displayName![0].toUpperCase()
                      : "?",
                  style:
                      const TextStyle(fontSize: 40, color: Color(0xFF3A89D5)),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushNamed(context, 'dashboard_user');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorit"),
              onTap: () {
                Navigator.pushNamed(context, 'favorite_pages',
                    arguments: currentUser);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, 'login_page');
              },
            ),
          ],
        ),
      ),
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
              Navigator.pushNamed(context, 'add_contact',
                  arguments: currentUser);
            },
            icon: const Icon(Icons.add, color: Colors.white),
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
                GButton(
                  icon: LineIcons.phone,
                  text: 'Contact',
                ),
                GButton(
                  icon: LineIcons.heart,
                  text: 'Favorite',
                ),
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
                    Navigator.pushNamed(context, 'favorite_pages',
                        arguments: currentUser);
                    break;
                  case 2:
                    Navigator.pushNamed(context, 'profile_pages',
                        arguments: currentUser);
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
                controller: _searchController,
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
                  stream: FirebaseFirestore.instance
                      .collection('contact')
                      .where('uid_user', isEqualTo: currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
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

                    final contacts = snapshot.data!.docs;
                    final filteredContacts = contacts.where((contact) {
                      final nama = contact['nama'] ?? '';
                      final nomorTelepon = contact['nomor'] ?? '';
                      final email = contact['email'] ?? '';
                      final alamat = contact['alamat'] ?? '';
                      final catatan = contact['catatan'] ?? '';
                      final searchLower = _searchText.toLowerCase();
                      return nama.toLowerCase().contains(searchLower) ||
                          nomorTelepon.toLowerCase().contains(searchLower) ||
                          email.toLowerCase().contains(searchLower) ||
                          alamat.toLowerCase().contains(searchLower) ||
                          catatan.toLowerCase().contains(searchLower);
                    }).toList();

                    if (filteredContacts.isEmpty) {
                      return const Center(
                        child: Text(
                          'Kontak tidak ditemukan.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        final id = contact.id;
                        final nama = contact['nama'] ?? 'Nama tidak tersedia';
                        final no = contact['nomor'] ?? 'nomor tidak tersedia';

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
                            subtitle: Text(no),
                            onTap: () {
                              final contactId = contact.id;
                              Navigator.pushNamed(
                                context,
                                'detail_contact',
                                arguments: contactId,
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    contact['status'] == 'favorit'
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: contact['status'] == 'favorit'
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  onPressed: () async {
                                    final newStatus =
                                        contact['status'] == 'favorit'
                                            ? 'no fav'
                                            : 'favorit';

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('contact')
                                          .doc(id)
                                          .update({'status': newStatus});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            newStatus == 'favorit'
                                                ? 'Kontak ditambahkan ke favorit'
                                                : 'Kontak dihapus dari favorit',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Gagal memperbarui status favorit'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black),
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('contact')
                                          .doc(contact.id)
                                          .delete();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Kontak berhasil dihapus'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Gagal menghapus kontak'),
                                        ),
                                      );
                                    }
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
