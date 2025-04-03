import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'checkout_screen.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  String? selectedAddressId;

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Shipping Address',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 30),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('address')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Something went wrong. Please try again."));
                      }

                      // Filter out the "init" document
                      var addresses = snapshot.data?.docs.where((doc) => doc.id != 'init').toList() ?? [];

                      if (addresses.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              "No addresses found",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          var doc = addresses[index];
                          String docId = doc.id;
                          String type = doc['type'] ?? 'Unknown';
                          String address =
                              "${doc['address'] ?? ''}, ${doc['pin'] ?? ''}, ${doc['state'] ?? ''}, ${doc['country'] ?? ''}";
                          bool isSelected = doc['isSelected'] ?? false;

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_outlined, color: Colors.brown, size: 30),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          type,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          address,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                                GestureDetector(
                                  onTap: () async {
                                    await _updateSelectedAddress(uid, docId);
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.brown, width: 2),
                                        borderRadius: BorderRadius.circular(30)),
                                    child: Center(
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                            color: isSelected ? Colors.brown : Colors.transparent,
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.brown, width: 1),
                          ),
                          child: TextButton(
                            onPressed: () {
                              _showAddAddressBottomSheet(context, uid);
                            },
                            child: Text(
                              '+ Add New Shipping Address',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
            Positioned(
              bottom: 0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 4)
                    ]),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateSelectedAddress(String uid, String selectedId) async {
    var addressCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('address');

    var batch = FirebaseFirestore.instance.batch();

    // Get all addresses and set isSelected to false
    QuerySnapshot snapshot = await addressCollection.get();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isSelected': doc.id == selectedId});
    }

    await batch.commit();
  }

  void _showAddAddressBottomSheet(BuildContext context, String uid) {
    TextEditingController addressController = TextEditingController();
    TextEditingController countryController = TextEditingController();
    TextEditingController pinController = TextEditingController();
    TextEditingController stateController = TextEditingController();
    TextEditingController typeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: typeController, decoration: InputDecoration(labelText: "Type (e.g. Home, Office)")),
              TextField(controller: addressController, decoration: InputDecoration(labelText: "Address")),
              TextField(controller: pinController, decoration: InputDecoration(labelText: "Pin")),
              TextField(controller: stateController, decoration: InputDecoration(labelText: "State")),
              TextField(controller: countryController, decoration: InputDecoration(labelText: "Country")),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (addressController.text.isEmpty ||
                      pinController.text.isEmpty ||
                      stateController.text.isEmpty ||
                      countryController.text.isEmpty ||
                      typeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                    return;
                  }

                  await FirebaseFirestore.instance.collection('users').doc(uid).collection('address').add({
                    "type": typeController.text,
                    "address": addressController.text,
                    "pin": pinController.text,
                    "state": stateController.text,
                    "country": countryController.text,
                    "isSelected": true
                  });

                  Navigator.pop(context);
                },
                child: Text("Add Address"),
              ),
            ],
          ),
        );
      },
    );
  }


}
