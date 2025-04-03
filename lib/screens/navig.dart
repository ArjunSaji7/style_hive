import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'screen_cart.dart';
import 'screen_wishlist.dart';

class Navig extends StatefulWidget {
  final int index;

  const Navig({super.key, this.index = 0});

  @override
  State<Navig> createState() => _NavigState();
}

class _NavigState extends State<Navig> {
  late int _curint; // Current selected index

  @override
  void initState() {
    super.initState();
    _curint = widget.index;
  }

  void setIndex(int index) {
    setState(() {
      _curint = index;
    });
  }

  // Define pages/screens
  final List<Widget> pages = [
    HomeScreen(),
    Wishlist(),
    CartScreen(),
    ProfileScreen(),
  ];

  // Icon List for Navigation Bar
  final List<IconData> _icons = [
    Icons.home,
    Icons.favorite,
    Icons.shopping_cart_outlined,
    Icons.person_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            pages[_curint], // Current page

            /// **Custom Navigation Bar**
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(54, 69, 79, 1), // Background color
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_icons.length, (index) {
                    return GestureDetector(
                      onTap: () => setIndex(index),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _curint == index ? Colors.white : Colors.transparent,
                        ),
                        child: Center(
                          child: Icon(
                            _icons[index],
                            size: 34,
                            color: _curint == index ? Colors.brown : Colors.grey[400],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
