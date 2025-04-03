import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:style_hive/screens/sign_in.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.brown,
            title: const Text(
              'Admin Dashboard',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: () {
                logOut();
              }, icon: Icon(Icons.logout, color: Colors.white,size: 30,))

            ],
            bottom: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 4,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Products'),
                Tab(text: 'Users'),
              ],
            ),
          ),
        body: TabBarView(children: [
          _buildProductGrid(),
          Text('users')
        ]),

      ),
    );
  }

  Future logOut(){
    return
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

  Widget _buildProductGrid() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20), // Add some spacing at the top
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(), // Listen to Firestore updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No Products Available'));
                  }

                  // Fetch Firestore documents
                  var products = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 220, // Increased height for icons
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: products.length + 1, // Add 1 for the "Add New Product" card
                    itemBuilder: (context, index) {
                      // Check if it's the last item for the "Add New Product" card
                      if (index == products.length) {
                        return GestureDetector(
                          onTap: () {
                            _showAddProductBottomSheet(context);
                          },
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Add new product',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.brown,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: Colors.brown,
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      var product = products[index].data() as Map<dynamic, dynamic>;
                      var productId = products[index].id; // Document ID for update/delete

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Product Image
                              Container(
                                height: 120,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product['image'] ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('Image load error: $error');
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Failed to load image',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Product Name
                              Text(
                                product['name'] ?? 'No Name',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              // Product Price
                              Text(
                                '₹${product['price'] ?? 'N/A'}',
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              // Edit and Delete Icons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Edit Icon
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.brown),
                                    onPressed: () {
                                      _showEditBottomSheet(
                                        context,
                                        'products',
                                        productId,
                                        product['image'],
                                        product['name'],
                                        product['price'],
                                      );
                                    },
                                  ),
                                  // Delete Icon
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                        context,
                                        'products',
                                        productId,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductBottomSheet(BuildContext context) {
    TextEditingController imageController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController detailsController = TextEditingController();
    TextEditingController sizeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: 'Product Details',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                maxLines: 3,
              ),
              TextField(
                controller: sizeController,
                decoration: const InputDecoration(
                  labelText: 'Available Sizes (comma-separated)',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  List<String> sizes = sizeController.text
                      .split(',')
                      .map((size) => size.trim())
                      .toList();

                  FirebaseFirestore.instance.collection('products').add({
                    'image': imageController.text,
                    'name': nameController.text,
                    'price': int.parse(priceController.text),
                    'category': categoryController.text,
                    'details': detailsController.text,
                    'size': sizes, // Store sizes as an array
                    'rating': 2.0,
                    'addedAt': FieldValue.serverTimestamp(),
                  }).then((_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added successfully')),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add product: $error')),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(70, 30),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditBottomSheet(
      BuildContext context,
      String collectionName,
      String productId,
      String imageUrl,
      String name,
      int price,
      ) {
    TextEditingController imageController = TextEditingController(text: imageUrl);
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController priceController = TextEditingController(text: price.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL',labelStyle: TextStyle( fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name',labelStyle: TextStyle( fontWeight: FontWeight.bold)),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price',labelStyle: TextStyle( fontWeight: FontWeight.bold)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Update the product in Firestore
                  FirebaseFirestore.instance
                      .collection(collectionName)
                      .doc(productId)
                      .update({
                    'image': imageController.text,
                    'name': nameController.text,
                    'price': int.parse(priceController.text),
                  }).then((_) {
                    Navigator.pop(context); // Close the bottom sheet
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product updated successfully')),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update product: $error')),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(70, 30),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showDeleteConfirmationDialog(
      BuildContext context,
      String collectionName,
      String productId,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product', style:  TextStyle(fontWeight: FontWeight.bold),),
          content: const Text('Are you sure you want to delete this product?', style: TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                // Delete the product from Firestore
                FirebaseFirestore.instance
                    .collection(collectionName)
                    .doc(productId)
                    .delete()
                    .then((_) {
                  Navigator.pop(context); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product deleted successfully')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete product: $error')),
                  );
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }


}
