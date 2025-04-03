import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_details.dart';
import 'navig.dart';
import 'profile_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;

  final List<String> _genders = ["Male", "Female", "Other"];
  String _selectedCountryCode = '+91';
  final List<String> _countryCodes = ['+91', '+1', '+44', '+61'];

  File? _profileImage = currentUser.imagePath.isNotEmpty ? File(currentUser.imagePath) : null;

  Future<void> _fetchUserData() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          // If the document exists, set the controller text values
          var userData = userDoc.data() as Map<String, dynamic>;

          setState(() {
            _nameController = TextEditingController(text: userData['fullName'] ?? '');
            _phoneController = TextEditingController(text: userData['phone'] ?? '');
            _genderController = TextEditingController(text: userData['gender'] ?? '');
            _profileImage = userData['imagePath'] != null ? File(userData['imagePath']) : null;
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _genderController = TextEditingController();

    // Fetch the user data from Firestore
    _fetchUserData();
  }

  @override
  void dispose() {
    // Don't forget to dispose of the controllers
    _nameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      print("Selected image path: ${image.path}");
      setState(() {
        _profileImage = File(image.path);
      });
    } else {
      print("No image selected");
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            padding: EdgeInsets.all(10),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text(
                    'Pick from Gallery',
                    style: TextStyle(
                        fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text(
                    'Take a Photo',
                    style: TextStyle(
                        fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGenderDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: _genders.map((gender) {
              return ListTile(
                title: Text(
                  gender,
                  style: TextStyle(
                      fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 16),
                ),
                onTap: () {
                  setState(() {
                    _genderController.text = gender;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Update the global currentUser details.
  Future<void> _saveChanges(BuildContext context) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.brown,
        content: Text('User not logged in'),
      ));
      return;
    }

    // Get reference to the user's document
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      // Fetch the current user data
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.brown,
          content: Text('User profile not found in database'),
        ));
        return;
      }

      Map<String, dynamic> currentData = userSnapshot.data() as Map<String, dynamic>;

      // Prepare only the new fields to be added
      Map<String, dynamic> updatedData = {};

      if (_nameController.text.isNotEmpty && _nameController.text != currentData["fullName"]) {
        updatedData["fullName"] = _nameController.text;
      }

      if (_phoneController.text.isNotEmpty && _phoneController.text != currentData["phone"]) {
        updatedData["phone"] = _phoneController.text;
      }

      if (_genderController.text.isNotEmpty && _genderController.text != currentData["gender"]) {
        updatedData["gender"] = _genderController.text;
      }

      if (_profileImage?.path != null && _profileImage?.path != currentData["imagePath"]) {
        updatedData["imagePath"] = _profileImage!.path;
      }

      updatedData["updatedAt"] = FieldValue.serverTimestamp(); // Track last update

      // Only update if there's new data
      if (updatedData.isNotEmpty) {
        await userDoc.update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Profile updated successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Text('No changes detected'),
        ));
      }

      // Navigate to ProfileScreen after successful update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Navig(index: 3,),
        ),
      );

      print("Updated user details in Firestore: $updatedData");

    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to update profile. Please try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Edit Your Profile',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 20),
                      // Profile Picture Section
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
                          Positioned(
                            bottom: 10,
                            right: 13,
                            child: GestureDetector(
                              onTap: _showImagePickerOptions,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.brown,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.white, width: 2)),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Phone',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              DropdownButton<String>(
                                value: _selectedCountryCode,
                                underline: SizedBox(),
                                items: _countryCodes.map((code) {
                                  return DropdownMenuItem<String>(
                                    value: code,
                                    child: Text(
                                      code,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newCode) {
                                  if (newCode != null) {
                                    setState(() {
                                      _selectedCountryCode = newCode;
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 2),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Phone Number',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _showGenderDropdown(),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _genderController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Select your gender',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down,
                                    color: Colors.brown, size: 50),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () async {
                            await _saveChanges(context);
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.brown)),
                      child: Icon(
                        size: 30,
                        Icons.arrow_back,
                        color: Colors.brown,
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
