import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_dashboard.dart';
import 'navig.dart';
import 'onboarding1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer( Duration(seconds: 3), () {
      getLoginDetails(context);
    },);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
            ),
            child:Align(
                alignment: Alignment.center,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(backgroundColor: Colors.brown, radius: 30, child: Text('f', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 44, fontFamily: 'Schyler'),),),
                    SizedBox(width: 10,),
                    Text('StyleHive', style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.black, fontSize: 44, fontWeight: FontWeight.bold,  ),
                    ),
                    Text('.', style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.brown, fontSize: 44, fontWeight: FontWeight.bold,  ),
                    )
                  ],
                )
            )
          ),
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 1
                )
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.grey,
                      width: 1
                  )
              ),
            ),
          )
        ],
      )
    );
  }
}

Future<void> getLoginDetails(BuildContext context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  if (user == null) {
    // No user signed in, navigate to onboarding
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding1()));
    return;
  }

  try {
    // 🔹 Fetch user role from Firestore
    DocumentSnapshot<Map<String, dynamic>> userDoc =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (userDoc.exists && userDoc.data() != null) {
      String role = userDoc.data()!['role'] ?? 'user'; // Default to 'user' if role is missing

      print('User role: $role'); // Debugging: Check the role in logs

      if (role.toLowerCase() == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navig()));
      }
    } else {
      print('User document does not exist or has no data'); // Debugging
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navig()));
    }
  } catch (e) {
    print('Error fetching user role: $e'); // Debugging
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navig()));
  }
}
