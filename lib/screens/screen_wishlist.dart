import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import 'product_details.dart';
import 'navig.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch user's wishlist from Firebase
  Future<QuerySnapshot> fetchWishlist() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        QuerySnapshot wishlistSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('wishlist')
            .where(FieldPath.documentId, isNotEqualTo: "init") // Exclude "init"
            .get();

        // Debug: Print the number of filtered documents retrieved
        print(
            "Filtered Wishlist data fetched: ${wishlistSnapshot.docs.length} items");

        return wishlistSnapshot; // Return the filtered QuerySnapshot
      } catch (e) {
        print("Error fetching wishlist: $e");
        rethrow; // Propagate the error
      }
    } else {
      print("No user is logged in.");
      throw Exception("No user is logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<WishlistProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'My Wishlist',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SortOptions(
                      titles: [
                        "All",
                        "Newest",
                        "Popular",
                        "Man",
                        "Woman",
                        "Kids"
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: p.fav1.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              mainAxisExtent: 230,
                              maxCrossAxisExtent: 230, // Adjust width per item
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio:
                                  0.8, // Adjust height to width ratio (optional)
                            ),
                            itemCount: p.fav1.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        productId: p.productIdList[index]),
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image with placeholder fallback
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: p.fav1[index].isNotEmpty
                                                ? Image.network(
                                                    height: 150,
                                                    width: 230,
                                                    p.fav1[index],
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/placeholder_image.png',
                                                    width: double.infinity,
                                                    height: 160,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                p.toggleFavorite(
                                                  p.productIdList[index],
                                                  p.fav1[index],
                                                  p.fav2[index],
                                                  p.fav3[index],
                                                  p.fav4[index],
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "Item removed from wishlist."),
                                                    backgroundColor:
                                                        Colors.brown,
                                                    duration: Duration(
                                                        milliseconds: 900),
                                                  ),
                                                );
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors
                                                    .grey[300]!
                                                    .withOpacity(.6),
                                                child: Icon(
                                                  p.symbol(p
                                                          .productIdList[index])
                                                      ? Icons.favorite
                                                      : Icons.favorite_outline,
                                                  color: Colors.brown,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.fav3[index],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '₹ ${p.fav2[index]}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.yellow),
                                                    Text(
                                                      p.fav4[index].toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border,
                                    size: 80, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  "Your wishlist is empty",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Navig()));
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.brown),
                  ),
                  child: Icon(
                    size: 30,
                    Icons.arrow_back,
                    color: Colors.brown,
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

class SortOptions extends StatefulWidget {
  final List<String> titles;

  const SortOptions({
    Key? key,
    required this.titles,
  }) : super(key: key);

  @override
  State<SortOptions> createState() => _SortOptionsState();
}

class _SortOptionsState extends State<SortOptions> {
  int selectedIndex = 0;

  void onOptionSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.titles.length, (index) {
          return GestureDetector(
            onTap: () => onOptionSelected(index),
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
                widget.titles[index],
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
