import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:style_hive/screens/payment_methods.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  bool saveCard = false;

  @override
  void dispose() {
    cardHolderController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Form(
              key: _formKey, // Assign form key
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Add Card',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              Container(
                                height: 240,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/crediCard.png'),
                                        fit: BoxFit.fill)),
                              ),
                              Positioned(
                                  bottom: 60,
                                  left: 30,
                                  child: Column(
                                    children: [
                                      Text(
                                        cardNumberController.text,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Positioned(
                                  bottom: 20,
                                  left: 30,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Card Holder Name',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10),
                                      ),
                                      Text(
                                        cardHolderController.text,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ],
                                  )),
                              Positioned(
                                  bottom: 20,
                                  right: 120,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Expiry Date',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10),
                                      ),
                                      Text(
                                        expiryDateController.text,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Card Holder Name
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: cardHolderController,
                                  decoration: inputDecoration('Card Holder Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Card holder name is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),

                                // Card Number
                                TextFormField(
                                  controller: cardNumberController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CardNumberFormatter(),
                                  ],
                                  decoration: inputDecoration('Card Number'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Card number is required';
                                    }
                                    String cleanedValue = value.replaceAll(' ', '');
                                    if (cleanedValue.length != 16) {
                                      return 'Card number must be 16 digits';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 15),

                                Row(
                                  children: [
                                    // Expiry Date
                                    Expanded(
                                      child: TextFormField(
                                        controller: expiryDateController,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                        inputDecoration('Expiry Date (MM/YY)'),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          ExpiryDateInputFormatter(),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Expiry date is required';
                                          }
                                          if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$')
                                              .hasMatch(value)) {
                                            return 'Enter valid expiry (MM/YY)';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // CVV
                                    Expanded(
                                      child: TextFormField(
                                        controller: cvvController,
                                        keyboardType: TextInputType.number,
                                        obscureText: true,
                                        decoration: inputDecoration('CVV'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'CVV is required';
                                          }
                                          if (value.length != 3) {
                                            return 'CVV must be 3 digits';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // Save Card Checkbox
                                Row(
                                  children: [
                                    Checkbox(
                                      value: saveCard,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          saveCard = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Save Card',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30,)
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),

                ],
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
                    BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 4),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      onSaveCardPressed(cardNumberController,
                          cardHolderController, expiryDateController, saveCard);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Add Card',
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
            ),
            Positioned(
              left: 10,
              top: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PaymentMethods(),
                  ));
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.brown),
                  ),
                  child: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.brown),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
    );
  }

  void onSaveCardPressed(
      TextEditingController cardNumberController,
      TextEditingController cardHolderController,
      TextEditingController expiryController,
      bool isSaveChecked) {
    saveCardDetails(
      cardNumber: cardNumberController.text
          .replaceAll(' ', ''), // Remove spaces before saving
      cardHolderName: cardHolderController.text,
      expiryDate: expiryController.text,
      saveCard: isSaveChecked, // Pass checkbox status
    );
  }

  Future<void> saveCardDetails({
    required String cardNumber,
    required String cardHolderName,
    required String expiryDate,
    required bool saveCard, // Checkbox status
  }) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user logged in.");
      return; // Stop execution if no user is logged in
    }

    // Only save card if the checkbox is checked
    if (!saveCard) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.brown,
          content: Text('Please select Save Card option'),
        ),
      );
      print("Save Card option not selected.");
      return;
    }

    try {
      // Reference to the user's 'card' subcollection
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      CollectionReference cardCollection = userDocRef.collection('card');

      // Check if the card already exists
      QuerySnapshot existingCards = await cardCollection
          .where('cardNumber', isEqualTo: cardNumber)
          .get();

      if (existingCards.docs.isNotEmpty) {
        // Card already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('This card is already saved.'),
          ),
        );
        print("Card already exists.");
        return;
      }

      // Add the card details if it doesn't exist
      await cardCollection.add({
        'cardNumber': cardNumber, // Store raw number without spaces
        'cardHolderName': cardHolderName,
        'expiryDate': expiryDate,
        'timestamp': FieldValue.serverTimestamp(), // For sorting
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Card added successfully!'),
        ),
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PaymentMethods(),
      ));

      print("Card details uploaded successfully!");
    } catch (e) {
      print("Error uploading card details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error saving card. Please try again.'),
        ),
      );
    }
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters

    if (text.length > 4) {
      text = text.substring(0, 4); // Limit input to MMYY
    }

    String formattedText = text;
    if (text.length >= 3) {
      formattedText =
          '${text.substring(0, 2)}/${text.substring(2)}'; // Insert '/'
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Limit to 16 digits
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    // Add spaces after every 4 digits
    String formattedText = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += digitsOnly[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
