import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:style_hive/providers/wishlist_provider.dart';

import 'categories.dart';
import 'filter_screen.dart';
import 'location_access.dart';
import 'notifications.dart';
import 'product_details.dart';
import 'search_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController(); // Use the correct controller
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(0); // Use ValueNotifier instead of setState
  final ValueNotifier<String> _searchTextNotifier = ValueNotifier<String>('Fashion for men'); // Use ValueNotifier instead of setState



  int selectedIndex = 0; // Default selection (All)
  List<String> sortOptionsList = ["All", "Newest", "Popular", "Man", "Woman", "Kids"];

  int hours = 2;
  int minutes = 12;
  int seconds = 56;

  late Timer _textTimer;

  // List of texts to cycle through
  final List<String> texts = [
    'Fashion for men',
    'Fashion for women',
    'Fashion for kids',
    'Shoes',
  ];

  final List<Map<String, dynamic>> slides = [
    {
      "image": 'assets/slide1.jpg',
      "title": "Slide 1 Title",
      "subtitle": "This is the subtitle for Slide 1",
      "buttonText": "Learn More",
    },
    {
      "image": 'assets/slide2.jpg',
      "title": "Slide 2 Title",
      "subtitle": "This is the subtitle for Slide 2",
      "buttonText": "Get Started",
    },
    {
      "image": 'assets/slide3.jpg',
      "title": "Slide 3 Title",
      "subtitle": "This is the subtitle for Slide 3",
      "buttonText": "Explore",
    },
    {
      "image": 'assets/slide4.jpg',
      "title": "Slide 4 Title",
      "subtitle": "This is the subtitle for Slide 4",
      "buttonText": "Explore",
    },
    {
      "image": 'assets/slide5.png',
      "title": "Slide 5 Title",
      "subtitle": "This is the subtitle for Slide 5",
      "buttonText": "Explore",
    },
  ];

  // late Timer timer;

  @override
  void initState() {
    super.initState();

    // Start the timer to cycle through texts every 3 seconds
    _textTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _searchTextNotifier.value = texts[timer.tick % texts.length];
    });
    //startCountdown();
  }

  // void startCountdown() {
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (seconds > 0) {
  //         seconds--;
  //       } else {
  //         if (minutes > 0) {
  //           minutes--;
  //           seconds = 59;
  //         } else if (hours > 0) {
  //           hours--;
  //           minutes = 59;
  //           seconds = 59;
  //         } else {
  //           timer.cancel(); // Stop the timer when the countdown reaches 0
  //         }
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    // timer.cancel();
    _textTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Location and Notification Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.brown,
                              size: 30,
                            ),
                            Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationAccess(),
                                  ),
                                );
                              },
                              child: Icon(Icons.keyboard_arrow_down, size: 34),
                            )
                          ],
                        )
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Color.fromRGBO(211, 211, 211, 1),
                      radius: 22,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Notifications(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // Search and Filter Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _searchTextNotifier,
                      builder: (context, value, child) {
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.brown,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SearchScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 150,
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 700), // Duration for the animation
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(_searchTextNotifier.value,
                                          key: ValueKey<String>(_searchTextNotifier.value), // Key to trigger animation
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
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
                      },
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.brown,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterScreen(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/filter_icon.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // // Carousel Slider
                Column(
                  children: [
                    // Carousel Slider
                    CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        viewportFraction: 1,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 600),
                        pauseAutoPlayOnTouch: true,
                        onPageChanged: (index, reason) {
                          _currentIndexNotifier.value = index; // Update the notifier instead of using setState
                        },
                      ),
                      items: slides.map((slide) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(slide['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      slide['title']!,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      slide['subtitle']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.brown,
                                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        slide['buttonText']!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    // Dotted Indicator - ValueListenableBuilder
                    ValueListenableBuilder<int>(
                      valueListenable: _currentIndexNotifier,
                      builder: (context, currentIndex, child) {
                        return AnimatedSmoothIndicator(
                          activeIndex: currentIndex,
                          count: slides.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: Colors.brown,
                            dotColor: Colors.grey,
                          ),
                          onDotClicked: (index) {
                            _carouselController.animateToPage(index);
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),

                SizedBox(
                  height: 20,
                ),
                // Flash Sale Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flash Sale',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Closing in',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(' : '),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 235, 215, 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '$hours'.padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Text(' : '),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 235, 215, 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '$minutes'.padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Text(' : '),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(250, 235, 215, 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '$seconds'.padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                // Sort Options
                Align(
                  alignment: Alignment.centerLeft,
                  child: sortOptions( sortOptionsList),
                ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: getFilteredAndSortedItems(),
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 210,
                        maxCrossAxisExtent: 150, // Adjust width per item
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            0.7, // Adjust height to width ratio (optional)
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          productId: product.id,
                          image: product['image'] ?? '',
                          name: product['name'] ?? 'Unnamed Product',
                          price: product['price'].toString(),
                          rating: product['rating']?.toString() ?? '0.0',
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget sortOptions (List titles){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(titles.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
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

  Stream<QuerySnapshot> getFilteredAndSortedItems() {
    Query query = FirebaseFirestore.instance.collection('products'); // Change to your collection name

    // Sorting & Filtering logic
    if (sortOptionsList[selectedIndex] == "Newest") {
      query = query.orderBy('addedAt', descending: true); // Recently added first
    } else if (sortOptionsList[selectedIndex] == "Popular") {
      query = query.orderBy('rating', descending: true); // Sort by popularity
    } else if (sortOptionsList[selectedIndex] == "Man") {
      query = query.where('category', isEqualTo: "Man");
    } else if (sortOptionsList[selectedIndex] == "Woman") {
      query = query.where('category', isEqualTo: "Woman");
    } else if (sortOptionsList[selectedIndex] == "Kids") {
      query = query.where('category', isEqualTo: "Kids");
    }

    return query.snapshots(); // Real-time Firestore stream
  }
}

class ProductCard extends StatefulWidget {
  final String productId;
  final String image;
  final String name;
  final String price;
  final String rating;

  ProductCard({
    required this.productId,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<WishlistProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetails(productId: widget.productId)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.image.isNotEmpty
                      ? Image.network(
                    widget.image,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/placeholder_image.png',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      p.toggleFavorite(
                        widget.productId,
                        widget.image,
                        widget.price,
                        widget.name,
                        widget.rating,
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300]!.withOpacity(.6),
                      child: Icon(
                        p.symbol(widget.productId) ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.brown,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹ ${widget.price}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(
                            widget.rating,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
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
  }
}

//

// class WishlistButton extends StatefulWidget {
//   final String productId;
//   final String productName;
//   final num price;
//   final double rating;
//   final String image;
//
//   const WishlistButton({
//     required this.productId,
//     required this.productName,
//     required this.price,
//     required this.rating,
//     required this.image,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _WishlistButtonState createState() => _WishlistButtonState();
// }
//
// class _WishlistButtonState extends State<WishlistButton> {
//   bool isWishlisted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkWishlistStatus(); // Check if the product is already in wishlist
//   }
//
//   Future<void> _checkWishlistStatus() async {
//     isWishlisted = await isProductWishlisted(widget.productId);
//     if (mounted) setState(() {}); // Update UI
//   }
//
//   Future<void> _toggleWishlist() async {
//     if (isWishlisted) {
//       await removeFromWishlist(widget.productId);
//     } else {
//       await addToWishlist(widget.productId, widget.productName, widget.price, widget.rating, widget.image);
//     }
//     setState(() {
//       isWishlisted = !isWishlisted; // Toggle UI instantly
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 10,
//       right: 10,
//       child: GestureDetector(
//         onTap: _toggleWishlist,
//         child: CircleAvatar(
//           radius: 20,
//           backgroundColor: Colors.grey[300]!.withOpacity(.6),
//           child: Icon(
//             isWishlisted ? Icons.favorite : Icons.favorite_outline,
//             color: Colors.brown,
//             size: 25,
//           ),
//         ),
//       ),
//     );
//   }
//   Future<void> addToWishlist(String productId, String productName, num price, double rating, String image) async {
//     try {
//       // Get the current user
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception("User not logged in");
//       }
//
//       // Reference to the user's wishlist subcollection
//       DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//       DocumentReference wishlistItem = userDoc.collection('wishlist').doc(productId);
//
//       // Check if the product already exists in the wishlist
//       DocumentSnapshot docSnapshot = await wishlistItem.get();
//
//       if (!docSnapshot.exists) {
//         // Add product to wishlist with the same product ID
//         await wishlistItem.set({
//           'name': productName,
//           'price': price,
//           'image': image,
//           'rating': rating,
//           'addedAt': FieldValue.serverTimestamp(), // Timestamp for sorting
//         });
//
//         print("Product added to wishlist with ID: $productId");
//       } else {
//         print("Product already in wishlist");
//       }
//     } catch (e) {
//       print("Error adding to wishlist: $e");
//     }
//   }
//
//
//   Future<bool> isProductWishlisted(String productId) async {
//     try {
//       // Get current user's ID
//       String? userId = FirebaseAuth.instance.currentUser?.uid;
//
//       if (userId == null) {
//         return false; // No user logged in
//       }
//
//       // Reference to Firestore wishlist subcollection
//       DocumentSnapshot productDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('wishlist')
//           .doc(productId)
//           .get();
//
//       return productDoc.exists; // Returns true if the product exists in the wishlist
//     } catch (e) {
//       print('Error checking wishlist status: $e');
//       return false; // Return false in case of an error
//     }
//   }
// // ✅ Remove product from wishlist
//   Future<void> removeFromWishlist(String productId) async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('wishlist')
//         .doc(productId) // Remove product using its ID
//         .delete();
//   }
// }
