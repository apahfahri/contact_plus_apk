import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteContact extends StatefulWidget {
  final User user;
  const FavoriteContact({super.key, required this.user});

  @override
  State<FavoriteContact> createState() => _FavoriteContactState();
}

class _FavoriteContactState extends State<FavoriteContact> {
  late User currentUser;

  final TextEditingController _searchController = TextEditingController();
  final String _searchText = "";

  @override
  void initState() {
    _checkCurrentUser();
    currentUser = widget.user;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF23253A),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Favorite Contact',
          style: TextStyle(color: Colors.white),
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
                      .where('status', isEqualTo: 'favorit')
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
