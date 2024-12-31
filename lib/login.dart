import 'package:contact_plus_apk/MyContactPage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance FirebaseAuth
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar ikon kunci
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Image.asset(
                  'assets/images/Key opening a lock.png',
                  width: 200,
                  height: 200,
                ),
              ),
              // Teks Login
              Text(
                "Login",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                "Please Sign In to continue",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              // TextField Email
              _buildTextField(
                controller: _emailController,
                hintText: "Email",
                icon: Icons.email,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              // TextField Password
              _buildTextField(
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              // Tombol Sign In
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login, // Call login function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A89D5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Teks untuk Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman register
                      Navigator.pushNamed(context, 'register_screen');
                    },
                    child: Text(
                      "Sign Up",
                      style: const TextStyle(
                        color: Color(0xFF3A89D5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi login dengan Firebase
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Melakukan login menggunakan Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Jika login berhasil, arahkan ke MyContactPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyContactPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Menangani kesalahan login
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage =
            'Tidak ada pengguna yang ditemukan untuk email tersebut.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password yang dimasukkan salah.';
      } else {
        errorMessage = 'Login gagal. Coba lagi.';
      }
      // Tampilkan pesan kesalahan
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Widget untuk membangun TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool obscureText,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFF383B4E),
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              Icon(icon, color: Colors.white54),
              const SizedBox(width: 10),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
