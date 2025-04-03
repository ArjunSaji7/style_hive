import 'package:flutter/material.dart';

import 'product_details.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Text('Search',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.brown,
                          ),
                          Container(
                            width: 200,
                            child: Text('Jacket',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Result for "Jacket"',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ),
                      Text('4 found',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      )
                    ],
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
                        'imagePath': 'assets/11254.jpg',
                        'name': 'Brown Suite',
                        'rating': 4.9,
                        'price': 1499
                      },),
              
                    ],
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
                        'imagePath': 'assets/11254.jpg',
                        'name': 'Brown Suite',
                        'rating': 4.9,
                        'price': 1499
                      },),
              
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 20,
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
                      border: Border.all(
                          color: Colors.brown
                      )
                  ),
                  child: Icon(
                    size: 30,
                    Icons.arrow_back,
                    color: Colors.brown,
                  ),
                )
            ),
          ),
        ],
      )),
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
