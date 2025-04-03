import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? selectedRole; // Selected role
  List<String> roles = ['User', 'Admin']; // Available roles
  bool _termsAndCon = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser() async {
    final String fullName = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a role'),
        backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_termsAndCon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must accept the Terms & Conditions'),
        backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // 🔹 Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // 🔹 Add user details & role to Firestore in 'users' collection
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'role': selectedRole.toString().toLowerCase(), // Store the selected role
          'createdAt': FieldValue.serverTimestamp(),
        });

        // 🔹 Create 'wishlist' & 'cart' subcollections under user's document
        await _firestore.collection('users').doc(user.uid).collection('wishlist').doc('init').set({});
        await _firestore.collection('users').doc(user.uid).collection('cart').doc('init').set({});
        await _firestore.collection('users').doc(user.uid).collection('address').doc('init').set({});

        // 🔹 Show success message & navigate to Sign In
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Successful! Please Sign In')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                'Create Account',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
              Text(
                'Fill your information or register with your social media account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    fontSize: 14),
              ),
              SizedBox(height: 40),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  )),
              SizedBox(height: 10),
              _buildTextField(_nameController, 'Full Name'),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  )
              ),
              SizedBox(height: 10),
              _buildTextField(_emailController, 'example@gmail.com'),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  )),
              SizedBox(height: 10),
              _buildPasswordField(),
              SizedBox(height: 20,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Role',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  )
              ),
              SizedBox(height: 10,),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  labelText: "Select Role",
                  labelStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 1), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey), // Grey border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey, width: 1), // Grey border when focused
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red), // Red border on error
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.red, width: 1), // Red border when error & focused
                  ),
                ),
                value: selectedRole,
                items: roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                    ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    shape: RoundedRectangleBorder(),
                    activeColor: Colors.brown,
                    value: _termsAndCon,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAndCon = value!;
                      });
                    },
                  ),
                  Text('Agree with ', style: TextStyle(fontWeight: FontWeight.w500)),
                  GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: registerUser, // 🔹 Call the function here
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignIn()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable function for text fields
  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none),
        ),
      ),
    );
  }

  // 🔹 Password field with visibility toggle
  Widget _buildPasswordField() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4),
        child: TextField(
          controller: _passwordController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            hintText: '***********',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
