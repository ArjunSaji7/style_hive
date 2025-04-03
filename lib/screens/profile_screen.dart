import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_details.dart';
import 'edit_profile.dart';
import 'home_screen.dart';
import 'navig.dart';
import 'payment_methods.dart';
import 'sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    fetchUserDetails();
    super.initState();
  }

  String email = '';
  String name = '';
  String imagePath = '';

  Future<void> fetchUserDetails() async {
    // Get the current user's UID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // If no user is logged in, print an error message and return
      print("No user logged in");
      return;
    }

    try {
      // Fetch the user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        // Retrieve user data from the document
        var userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          email = userData['email'] ?? '';
          name = userData['fullName'] ?? '';
          imagePath = userData['imagePath'] ?? '';
        });
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
    print(imagePath);
  }

  final File? _profileImage = currentUser.imagePath.isNotEmpty ? File(currentUser.imagePath) : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text('Profile',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10,),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 80,
                        )
                            : null,
                      ),
                      // Positioned(
                      //   bottom: 10,
                      //   right: 13,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //
                      //     },
                      //     child: Container(
                      //       height: 40,
                      //       width: 40,
                      //       decoration:BoxDecoration(
                      //         color: Colors.brown,
                      //         borderRadius: BorderRadius.circular(30),
                      //         border: Border.all(color: Colors.white, width: 2)
                      //       ),
                      //       child: Icon(Icons.edit, color: Colors.white,),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(name,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                  Text(email,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(),));

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person_outline,
                              color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Your Profile',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentMethods(),));

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.credit_card_rounded,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Payment Methods',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.list_alt,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('My Orders',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.settings,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Settings',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Help Center',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock_outlined,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Privacy Policy',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_add_alt_1_outlined,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Invite Friends',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(context: context,
                        builder: (context) {
                          return Container(
                            height: 220,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                boxShadow:[
                                  BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      blurRadius: 4
                                  )
                                ]
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20, bottom: 30),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text('Logout',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 5,),
                                      Divider(
                                        color: Colors.grey[300],
                                        thickness: 1,
                                      ),
                                      SizedBox(height: 5,),
                                      Text('Are you sure you want to logout?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 30,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              height: 50,
                                              width: .42 * MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: BorderRadius.circular(20)),
                                              child: Center(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.brown,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              logout(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: .42 * MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.brown,
                                                  borderRadius: BorderRadius.circular(20)),
                                              child: Center(
                                                child: Text(
                                                  'Yes, Logout',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2, color: Colors.grey[300]!,))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.logout_outlined,
                                color: Colors.brown,
                                size: 30,
                              ),
                              SizedBox(width: 10,),
                              Text('Log Out',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          Icon(Icons.arrow_forward_ios, size: 30, color: Colors.brown,)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 70,)

                ],

              ),
            ),
          ),
        ),
      ),
    );
  }

}

Future<void> logout(BuildContext context) async {
  try {
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear(); // Clears all saved preferences

    await FirebaseAuth.instance.signOut(); // Sign out from Firebase

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
          (route) => false, // Removes all previous routes from the stack
    );
  } catch (e) {
    print('Error during logout: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logout failed. Please try again.')),
    );
  }
}

