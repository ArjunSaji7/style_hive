import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'checkout_screen.dart';
import 'navig.dart';
import 'product_details.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double deliveryFee = 50;
  double discount = 50;
  final _promoController = TextEditingController();
  ValueNotifier<double> subTotalNotifier = ValueNotifier<double>(0.0);


  bool isSelected = false;
  int productNumber = 1;


  void _calculateSubTotal(List<QueryDocumentSnapshot> cartDocs) {
    double total = 0.0;

    for (var item in cartDocs) {
      var product = item.data() as Map<String, dynamic>?;
      if (product != null && product.containsKey('price') && product.containsKey('quantity')) {
        total += (product['price'] ?? 0) * (product['quantity'] ?? 1);
      }
    }

    subTotalNotifier.value = total; // ✅ Update subtotal without triggering build
  }

  void _fetchInitialSubTotal() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    _calculateSubTotal(snapshot.docs); // Set initial subtotal
  }

  Future<bool> isCartEmpty() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return true;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .where(FieldPath.documentId, isNotEqualTo: 'init') // Exclude 'init' doc
          .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print("Error checking cart: $e");
      return true; // Assume empty in case of an error
    }
  }


  void removeItem(String docId) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cart')
          .doc(docId)
          .delete();
      _fetchInitialSubTotal();

    } catch (e) {
      print("Error removing item: $e");
    }
  }

  void updateCartItemQuantity(String docId, int newQuantity) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      if (newQuantity >= 1) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('cart')
            .doc(docId)
            .update({'quantity': newQuantity});

        _fetchInitialSubTotal();
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchInitialSubTotal(); // Fetch subtotal when screen opens
  }


  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Center(child: Text("User not logged in"));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 10, bottom: 300),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'My Cart',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('cart')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.where((doc) => doc.id != 'init').isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_shopping_cart,
                                    size: 80, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  "Your cart is empty",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        }


                        var cartItems = snapshot.data!.docs
                            .where((doc) => doc.id != 'init')
                            .toList();

                        // Schedule subtotal calculation after the build is complete
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _calculateSubTotal(cartItems);
                        });

                        return ListView.separated(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            var cartItem = cartItems[index].data() as Map<String, dynamic>;
                            return CartItem(
                              cartItem: cartItem,
                              docId: cartItems[index].id,
                              updateQuantity: (docId, newQuantity) {
                                updateCartItemQuantity(docId, newQuantity);

                              },
                              removeItem: (docId) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 250,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 5),
                                            Text(
                                              'Remove from cart?',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Divider(
                                              color: Colors.grey[300],
                                              thickness: 1,
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Image.network(
                                                      cartItem['image'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      cartItem['name'],
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      'Size: ${cartItem['selectedSize']}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '₹${cartItem['price'].toString()}',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  spacing: 10,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Image.asset(
                                                            'assets/minus-sign (1).png',
                                                            height: 30,
                                                            width: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      cartItem['quantity'].toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                          color: Colors.brown,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: .45 * MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
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
                                                    removeItem(cartItems[index].id);
                                                    Navigator.pop(context);

                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    width: .45 * MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.brown,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Yes, Remove',
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
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.grey,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
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
                height: 320,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    border: Border(top: BorderSide(color: Colors.grey))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder(
                      valueListenable: subTotalNotifier,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            SizedBox(height: 5),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10),
                                    child: SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: TextFormField(
                                        controller: _promoController,
                                        cursorColor: Colors.brown,
                                        decoration: InputDecoration(
                                          hintText: 'Promo Code',
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: 44,
                                        width: 80,
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
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sub total',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '₹${subTotalNotifier.value}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Fee',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '₹$deliveryFee',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '₹$discount',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Cost',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '₹${(subTotalNotifier.value + deliveryFee) - discount}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                if(await isCartEmpty()){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.brown,
                                      content: Text('Your cart is empty.'),
                                    ),
                                  );
                                }else{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(),
                                      ));

                                }
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.brown,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    'Proceed to Checkout',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 70),
                          ],
                        );
                      },
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

class CartItem extends StatefulWidget {
  final Map<String, dynamic> cartItem;
  final String docId;
  final Function(String, int) updateQuantity;
  final Function(String) removeItem;

  const CartItem({
    Key? key,
    required this.cartItem,
    required this.docId,
    required this.updateQuantity,
    required this.removeItem,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  double _slideOffset = 0.0;
  bool _showDeleteButton = false;

  void _onSlideUpdate(DragUpdateDetails details) {
    setState(() {
      _slideOffset += details.delta.dx;
      _slideOffset = _slideOffset.clamp(-100.0, 0.0);
    });
  }

  void _onSlideEnd(DragEndDetails details) {
    if (_slideOffset < -50) {
      setState(() {
        _slideOffset = -100.0;
        _showDeleteButton = true;
      });
    } else {
      setState(() {
        _slideOffset = 0.0;
        _showDeleteButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 100,
            color: Colors.red[100],
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 35,
              ),
              onPressed: () {
                widget.removeItem(widget.docId);
                _slideOffset = 0;
              },
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragUpdate: _onSlideUpdate,
          onHorizontalDragEnd: _onSlideEnd,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            transform: Matrix4.translationValues(_slideOffset, 0, 0),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to product details if needed
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.cartItem['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.cartItem['name'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Size: ${widget.cartItem['selectedSize']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '₹${widget.cartItem['price'].toString()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.cartItem['quantity'] > 1) {
                            widget.updateQuantity(widget.docId, widget.cartItem['quantity'] - 1);
                          }
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              'assets/minus-sign (1).png',
                              height: 30,
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.cartItem['quantity'].toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.updateQuantity(widget.docId, widget.cartItem['quantity'] + 1);
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}