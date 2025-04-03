import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'product_details.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Text('Jacket',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),

                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Products( productData: {
                        'imagePath': 'assets/close-up-indoor-studio-fashion.jpg',
                        'name': 'Brown Jacket ddddddddddd',
                        'rating': 4.5,
                        'price': 899
                      },),
                      Products( productData: {
                        'imagePath': 'assets/close-up-indoor-studio-fashion.jpg',
                        'name': 'Brown Jacket ddddddddddd',
                        'rating': 4.5,
                        'price': 899
                      },),

                    ],
                  ),

                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                },
                icon: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black45
                      )
                  ),
                  child: Icon(
                    size: 30,
                    Icons.arrow_back,
                    color: Colors.brown,
                  ),
                )),
          ),
        ],
      )
    );
  }
}

class Products extends StatefulWidget {
  final Map<String, dynamic> productData; // Map containing product details

  const Products({
    Key? key,
    required this.productData,
  }) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool isSelected = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(

      ),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(),));
                },
                child: Container(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(widget.productData['imagePath'],
                        fit: BoxFit.cover,)
                  ),//product image
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300]!.withOpacity(.6),
                    child: Icon(
                      isSelected ? Icons.favorite : Icons.favorite_outline, // Icon changes
                      color: Colors.brown,
                      size: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 90,
                child: Text(widget.productData['name'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,),
                  overflow: TextOverflow.ellipsis,

                ),
              ),// product name
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow,),
                  Text(widget.productData['rating'].toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ) // rating
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('₹ ${widget.productData['price'].toString()}',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700),

            ),//price
          )

        ],
      ),
    );
  }
}
