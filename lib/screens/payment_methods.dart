import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:style_hive/screens/add_card.dart';
import 'package:style_hive/screens/checkout_screen.dart';
import 'package:style_hive/screens/navig.dart';
import 'package:style_hive/screens/screen_cart.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {

  String? latestCardNumber; // Store the latest card number
  bool isLoading = true; // Loading state

  final List<Map<String, dynamic>> paymentOptions = [
    {"leading": "assets/apple.png", "title": "Apple Pay"},
    {"leading": "assets/paypal.png", "title": "Paypal"},
    {"leading": "assets/google-pay.png", "title": "Google Pay"},
  ];

  int? selectedIndex; // Track the selected index

  @override
  void initState() {
    super.initState();
    fetchLatestCard();
  }

  String formatCardNumber(String cardNumber) {
    if (cardNumber.length < 16) return cardNumber; // Ensure card number is valid
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  Future<void> fetchLatestCard() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        latestCardNumber = null;
        isLoading = false;
      });
      return;
    }

    try {
      QuerySnapshot cardSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('card')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (cardSnapshot.docs.isNotEmpty) {
        setState(() {
          latestCardNumber = formatCardNumber(cardSnapshot.docs.first['cardNumber']);
          isLoading = false;
        });
      } else {
        setState(() {
          latestCardNumber = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching card: $e");
      setState(() {
        latestCardNumber = null;
        isLoading = false;
      });
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Payment Methods',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Credit & Debit Card',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const AddCard()),
                      );
                      fetchLatestCard(); // Refresh after returning
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator() // Show loader while fetching
                            : ListTile(
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                          title: Text(
                            latestCardNumber ?? 'Add Card',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: const Icon(Icons.credit_card_rounded,
                              color: Colors.brown, size: 30),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.brown, size: 30),
                        ),
                      ),
                    ),
                  ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'More Payment Options',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ListView.separated(
                          itemCount: paymentOptions.length,
                          itemBuilder: (context, index) {
                            bool isSelected = selectedIndex == index;
                            return ListTile(
                              leading: Image.asset(paymentOptions[index]['leading'] , height: 40, width: 40,),
                              title: Text(paymentOptions[index]['title'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index; // Update selection
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.brown, width: 2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.brown : Colors.transparent,
                                        border: Border.all(color: Colors.transparent, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedIndex = index; // Update selection on tap
                                });
                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(color: Colors.grey[300], thickness: 1),
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckoutScreen(),));
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.brown),
                  ),
                  child: const Icon(Icons.arrow_back, size: 30, color: Colors.brown),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, spreadRadius: 2, blurRadius: 4),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    if (selectedIndex != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected: ${paymentOptions[selectedIndex!]['title']}')),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 30),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Confirm Payment',
                          style: TextStyle(
                              fontSize: 16, color: Colors.white, fontFamily: 'Inter', fontWeight: FontWeight.w500),
                        ),
                      ),
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
}
