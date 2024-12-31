import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // Controllers untuk TextField
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Key untuk Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Fungsi untuk validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  // Fungsi untuk validasi nomor telepon
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number cannot be empty";
    }
    if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
      return "Phone number must contain only digits";
    }
    return null;
  }

  // Fungsi untuk validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Fungsi untuk validasi username
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username cannot be empty";
    }
    if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)) {
      return "Username can only contain letters and numbers";
    }
    return null;
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Semua validasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigasi ke halaman login setelah berhasil
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, 'login_screen');
      });
    } else {
      // Pesan jika validasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23253A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gambar ikon buku
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    'assets/images/contacts icon.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                // Teks Register
                Text(
                  "Register",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please register to login",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                // TextField Username
                _buildTextField(
                  hintText: "Username",
                  icon: Icons.person,
                  controller: _usernameController,
                  validator: _validateUsername,
                ),
                const SizedBox(height: 20),
                // TextField Email
                _buildTextField(
                  hintText: "Email",
                  icon: Icons.email,
                  controller: _emailController,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                // TextField Phone Number
                _buildTextField(
                  hintText: "Phone Number",
                  icon: Icons.phone,
                  controller: _phoneController,
                  validator: _validatePhone,
                ),
                const SizedBox(height: 20),
                // TextField Password
                _buildTextField(
                  hintText: "Password",
                  icon: Icons.lock,
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 30),
                // Tombol Sign Up
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A89D5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account? ",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'login_screen');
                      },
                      child: Text(
                        "Sign In",
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
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFF383B4E),
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white54),
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
