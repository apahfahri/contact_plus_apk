import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailContact extends StatefulWidget {
  final String contactId;
  const DetailContact({super.key, required this.contactId});

  @override
  State<DetailContact> createState() => _DetailContactState();
}

class _DetailContactState extends State<DetailContact> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController notesController;

  Future<Map<String, dynamic>?> fetchContactDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('contact')
        .doc(widget.contactId)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null; // Menangani jika data tidak ada
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    notesController = TextEditingController();
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
          'Detail Contact',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'edit_contact', arguments: {
                'id': widget.contactId,
                'nama': nameController.text,
                'nomor': phoneController.text,
                'email': emailController.text,
                'alamat': addressController.text,
                'catatan': notesController.text,
              });
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchContactDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Menampilkan indikator loading saat data sedang dimuat
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Menampilkan error jika terjadi kesalahan
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Data berhasil dimuat, menampilkan UI
            final data = snapshot.data;
            nameController.text = data?['nama'] ?? '';
            phoneController.text = data?['nomor'] ?? '';
            emailController.text = data?['email'] ?? '';
            addressController.text = data?['alamat'] ?? '';
            notesController.text = data?['catatan'] ?? '';

            return Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 18),
                    Card(
                      color: const Color(0xFF383B4E),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
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
                            const SizedBox(height: 16),
                            // Menampilkan data dengan TextEditingController
                            _buildDetailCard('Nama', nameController),
                            _buildDetailCard('Nomor Telepon', phoneController),
                            _buildDetailCard('Email', emailController),
                            _buildDetailCard('Alamat', addressController),
                            _buildDetailCard('Catatan', notesController),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Data tidak ditemukan'));
          }
        },
      ),
    );
  }

  Widget _buildDetailCard(String title, TextEditingController controller) {
    return Card(
      color: const Color(0xFF4A4E69),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              '$title: ${controller.text}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
