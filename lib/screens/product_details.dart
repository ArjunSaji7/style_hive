import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style_hive/screens/screen_cart.dart';

import '../providers/wishlist_provider.dart';
import 'navig.dart';

class ProductDetails extends StatefulWidget {
  final String productId;
  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? productDetails;
  bool isSelected = false;
  bool isLoading = true; // Add a loading state
  String selectedSize = 'S';

  @override
  void initState() {
    super.initState();
    fetchAndDisplayProductDetails();
  }

  // Function to fetch and display product details
  void fetchAndDisplayProductDetails() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productSnapshot.exists) {
        setState(() {
          productDetails = productSnapshot.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        print("Product not found!");
        setState(() {
          productDetails = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching product details: $e");
      setState(() {
        productDetails = null;
        isLoading = false;
      });
    }
  }

  Future<void> addToCart(String productId, String name, String image,
      int price, String selectedSize) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("User not logged in");
        return;
      }

      String userId = user.uid;
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      // Check if the product with the same size is already in the cart
      QuerySnapshot existingProduct = await cartRef
          .where('productId', isEqualTo: productId)
          .where('selectedSize', isEqualTo: selectedSize)
          .get();

      if (existingProduct.docs.isNotEmpty) {
        // If the product with the same size is already in the cart, update the quantity
        DocumentSnapshot cartItem = existingProduct.docs.first;
        int currentQuantity = cartItem['quantity'] ?? 1;

        await cartRef
            .doc(cartItem.id)
            .update({'quantity': currentQuantity + 1});
        print("Updated product quantity in cart");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Navig(index: 2,),
        ));
      } else {
        // If not, add the product as a new entry
        await cartRef.add({
          'productId': productId,
          'name': name,
          'image': image,
          'price': price,
          'selectedSize': selectedSize, // Store selected size
          'quantity': 1,
          'addedAt': Timestamp.now(), // Optional: Track when added
        });
        print("Product added to cart");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Navig(index: 2,),
        ));
      }
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<WishlistProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (productDetails != null) ...[
                  Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      productDetails?['image'] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20.0, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Female's Style",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text(
                                  productDetails?['rating']?.toString() ??
                                      'N/A',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.brown,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            )
                          ],
                        ),
                        Text(
                          productDetails?['name'] ?? 'Loading...',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Details',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                            ExpandableText(
                                text: productDetails?['details'] ??
                                    'No details available'),
                            Divider(color: Colors.grey, thickness: 1)
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Select Size',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 10),
                        selectSize(productDetails!['size']),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                              text: 'Select Color: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700),
                              children: [
                                TextSpan(
                                  text: 'Brown',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.brown,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                )
                              ]),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 100)
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Navig(),
                            ));
                      },
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          size: 30,
                          Icons.arrow_back,
                          color: Colors.brown,
                        ),
                      )),
                ),
                if (!isLoading && productDetails != null)
                  Text(
                    'Product Details',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                if (isLoading || productDetails == null)
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width- 100,
                    child: Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                if (!isLoading && productDetails != null)
                  GestureDetector(
                    onTap: () {
                      p.toggleFavorite(
                        widget.productId,
                        productDetails?['image'],
                        productDetails!['price'].toString(),
                        productDetails?['name'],
                        productDetails!["rating"].toString(),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors
                          .grey[300]!
                          .withOpacity(.6),
                      child: Icon(
                        p.symbol(widget.productId)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: Colors.brown,
                        size: 25,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isLoading && productDetails != null)
            Positioned(
              bottom: -1,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "₹${productDetails?['price']?.toString() ?? 'N/A'}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add to Cart logic
                          addToCart(
                              widget.productId,
                              productDetails!['name'],
                              productDetails!['image'],
                              productDetails!['price'],
                              selectedSize);
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Add to Cart',
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
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  int selectedIndex = 0;
  Widget selectSize(List titles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(titles.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                selectedSize = titles[selectedIndex];
                print(selectedSize);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: selectedIndex == index ? Colors.brown : Colors.grey[200],
                border: Border.all(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                titles[index],
                style: TextStyle(
                  fontSize: 14,
                  color: selectedIndex == index ? Colors.white : Colors.black,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isLongText = widget.text.length > 100;
    String displayText = isExpanded || !isLongText
        ? widget.text
        : '${widget.text.substring(0, 100)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300),
        ),
        if (isLongText) // Only show "Read More/Less" if text is long
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "Read Less" : "Read More",
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.brown,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.brown,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }
}


class WishlistButton extends StatefulWidget {
  final String productId;
  final String productName;
  final num price;
  final double rating;
  final String image;

  const WishlistButton({
    required this.productId,
    required this.productName,
    required this.price,
    required this.rating,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  _WishlistButtonState createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus(); // Check if the product is already in wishlist
  }

  Future<void> _checkWishlistStatus() async {
    isWishlisted = await isProductWishlisted(widget.productId);
    if (mounted) setState(() {}); // Update UI
  }

  Future<void> _toggleWishlist() async {
    if (isWishlisted) {
      await removeFromWishlist(widget.productId);
    } else {
      await addToWishlist(widget.productId, widget.productName, widget.price, widget.rating, widget.image);
    }
    setState(() {
      isWishlisted = !isWishlisted; // Toggle UI instantly
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleWishlist,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[300]!.withOpacity(.6),
        child: Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_outline,
          color: Colors.brown,
          size: 25,
        ),
      ),
    );
  }
  Future<void> addToWishlist(String productId, String productName, num price, double rating, String image) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Reference to the user's wishlist subcollection
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentReference wishlistItem = userDoc.collection('wishlist').doc(productId);

      // Check if the product already exists in the wishlist
      DocumentSnapshot docSnapshot = await wishlistItem.get();

      if (!docSnapshot.exists) {
        // Add product to wishlist with the same product ID
        await wishlistItem.set({
          'name': productName,
          'price': price,
          'image': image,
          'rating': rating,
          'addedAt': FieldValue.serverTimestamp(), // Timestamp for sorting
        });

        print("Product added to wishlist with ID: $productId");
      } else {
        print("Product already in wishlist");
      }
    } catch (e) {
      print("Error adding to wishlist: $e");
    }
  }


  Future<bool> isProductWishlisted(String productId) async {
    try {
      // Get current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        return false; // No user logged in
      }

      // Reference to Firestore wishlist subcollection
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .get();

      return productDoc.exists; // Returns true if the product exists in the wishlist
    } catch (e) {
      print('Error checking wishlist status: $e');
      return false; // Return false in case of an error
    }
  }
// ✅ Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(productId) // Remove product using its ID
        .delete();
  }
}
