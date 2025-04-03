import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'new_password.dart';

class ForgotPassword extends StatefulWidget {
  final String email;

  const ForgotPassword({super.key, required this.email});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _otpControllers = List<TextEditingController>.generate(
    4,
        (index) => TextEditingController(),
  );
  bool isLoading = false;
  String? generatedOTP;

  @override
  void initState() {
    super.initState();
    sendOTP(); // 🔹 Auto-send OTP when user enters page
  }

  // 🔹 Generate a Random 4-digit OTP
  String generateOTP() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  // 🔹 Store OTP in Firestore and Send Email
  Future<void> sendOTP() async {
    setState(() => isLoading = true);
    String otp = generateOTP();
    DateTime expiresAt = DateTime.now().add(Duration(minutes: 5)); // Expires in 5 mins

    try {
      await FirebaseFirestore.instance.collection('password_resets').doc(widget.email).set({
        'otp': otp,
        'expiresAt': expiresAt.toIso8601String(),
      });

      // 🔹 Call Firebase Function to Send Email
      await FirebaseFunctions.instance.httpsCallable('sendOtpEmail').call({
        'email': widget.email,
        'otp': otp,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('OTP sent to ${widget.email}'),
      ));
    } catch (e) {
      print("Error sending OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to send OTP'),
      ));
    }

    setState(() => isLoading = false);
  }

  // 🔹 Verify OTP Function (Same as before)
  Future<bool> verifyOTP(String enteredOtp) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('password_resets').doc(widget.email).get();

      if (!snapshot.exists) return false;

      String storedOtp = snapshot.get('otp');
      DateTime expiresAt = DateTime.parse(snapshot.get('expiresAt'));

      if (DateTime.now().isAfter(expiresAt)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text('OTP expired')));
        return false;
      }

      return enteredOtp == storedOtp;
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }

  // 🔹 Handle OTP Verification
  void handleVerifyOTP() async {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text('Enter a 4-digit OTP')));
      return;
    }

    setState(() => isLoading = true);

    bool isValid = await verifyOTP(otp);

    setState(() => isLoading = false);

    if (isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPassword(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.brown, width: 2),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.brown),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Verify Code",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Please enter the code sent to your email",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                      color: Colors.brown,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(4, (index) {
                return _buildOTPField(index);
              }),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: handleVerifyOTP,
              child: Container(
                width: 240,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 40,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
