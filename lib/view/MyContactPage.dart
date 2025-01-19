import 'dart:convert';
import 'package:contact_plus_apk/view/add_contact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyContactPage extends StatefulWidget {
  final User user;

  MyContactPage({super.key, required this.user});

  @override
  _MyContactPageState createState() => _MyContactPageState();
}

class _MyContactPageState extends State<MyContactPage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  late User currentUser;
  String? _base64Image;
  // late Map<String, dynamic>? userData;
  late Map<String, dynamic>? userData = {};
  bool isLoading = true;

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

  // Function to fetch image from Firestore
  Future<void> fetchImageFromFirestore(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('user').doc(userId).get();

    if (doc.exists && doc.data()?['profile_picture'] != null) {
      // Only update the image if valid base64 string is fetched
      setState(() {
        _base64Image = doc.data()?['profile_picture'];
      });
    }
  }

  // Function to check if the user is logged in
  void _checkCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      fetchImageFromFirestore(user.uid); // Fetch image when user is logged in
    } else {
      Navigator.pushReplacementNamed(context, 'login_screen');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   currentUser = widget.user;
  //   _searchController.addListener(() {
  //     setState(() {
  //       _searchText = _searchController.text;
  //     });
  //   });
  //   fetchUserData();
  //   _checkCurrentUser(); // Check current user and fetch image
  // }

  @override
  void initState() {
    super.initState();

    // Validasi user untuk memastikan tidak null
    if (widget.user != null) {
      currentUser = widget.user;
      _searchController.addListener(() {
        setState(() {
          _searchText = _searchController.text;
        });
      });
      fetchUserData();
      _checkCurrentUser(); // Check current user and fetch image
    } else {
      // Handle the case where the user is null (throw error or navigate to login)
      Navigator.pushReplacementNamed(context, 'login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (userData == null) {
      return Center(child: Text('Data not available'));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      drawer: Drawer(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'profile_pages',
                    arguments: currentUser);
              },
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF23253A),
                ),
                accountName: Text(
                  userData!['nama'] ?? 'N/A',
                  style: const TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  userData!['email'] ?? "Email Tidak Tersedia",
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: _base64Image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            MemoryImage(base64Decode(_base64Image!)),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child:
                            Icon(Icons.person, size: 50, color: Colors.white),
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
                Navigator.pushReplacementNamed(context, 'login_screen');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Text("My Contact+", style: TextStyle(color: Colors.white)),
            SizedBox(width: 8),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AddContact(user: currentUser),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(3.0, 2.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: const Color(0xFF23253A), boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(1)),
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
                GButton(icon: LineIcons.home, text: 'Semua'),
                GButton(icon: LineIcons.userFriends, text: 'Teman'),
                GButton(icon: LineIcons.faceWithoutMouth, text: 'Keluarga'),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
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
                      final kategori = contact['catatan'] ?? '';
                      final searchLower = _searchText.toLowerCase();

                      final isVisible = (_selectedIndex == 0) ||
                          (_selectedIndex == 1 && kategori == 'teman') ||
                          (_selectedIndex == 2 && kategori == 'keluarga');

                      return isVisible &&
                          ((contact['nama'] ?? '')
                                  .toLowerCase()
                                  .contains(searchLower) ||
                              (contact['nomor'] ?? '')
                                  .toLowerCase()
                                  .contains(searchLower) ||
                              (contact['email'] ?? '')
                                  .toLowerCase()
                                  .contains(searchLower) ||
                              (contact['alamat'] ?? '')
                                  .toLowerCase()
                                  .contains(searchLower));
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
                            trailing: SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.black),
                                    onPressed: () async {
                                      bool? confirmDelete =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Konfirmasi Penghapusan'),
                                            content: const Text(
                                                'Apakah Anda yakin ingin menghapus kontak ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('contact')
                                              .doc(contact.id)
                                              .delete();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Kontak berhasil dihapus'),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Gagal menghapus kontak'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),

                                   IconButton(
                                  icon: Icon(
                                    contact['status'] == 'favorit'
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: contact['status'] == 'favorit'
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    final newStatus =
                                        contact['status'] == 'favorit'
                                            ? 'no fav'
                                            : 'favorit';

                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('contact')
                                          .doc(contact.id)
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
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'detail_contact',
                                arguments: contact.id,
                              );
                            },
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
