import 'package:flutter/material.dart';

import 'navig.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  double _minPrice = 100;
  double _maxPrice = 10000;

  bool review5 = true;
  bool review4 = false;
  bool review3 = false;
  bool review2 = false;
  bool review1 = false;
  bool review0 = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),
                      Text('Filter',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('Brands',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                  
                        ),
                      ),
                      SizedBox(height: 10,),
                      FilterOptions(titles: [
                        'All',
                        'Nike',
                        'Adidas',
                        'Levis',
                        'Puma',
                        'Allen Solly'
                      ],),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('Gender',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                  
                        ),
                      ),
                      SizedBox(height: 10,),
                      FilterOptions(titles: [
                        'All',
                        'Men',
                        'Women',
                        'Kids'
                      ],),
                      SizedBox(height: 20,),Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text('Sort By',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                  
                        ),
                      ),
                      SizedBox(height: 10,),
                      FilterOptions(titles: [
                        'Most Recent',
                        'Popular',
                        'Price High',
                        'Price Low',
                      ],),
                      SizedBox(height: 20,),
                  
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Price Range',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          // Display the selected range
                          Text(
                            '₹${_minPrice.round()} - ₹${_maxPrice >= 10000 ? '10,000+' : _maxPrice.round()}',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          // Range Slider
                          RangeSlider(
                            activeColor: Colors.brown,
                            inactiveColor: Colors.grey,
                            values: RangeValues(_minPrice, _maxPrice),
                            min: 100,
                            max: 11000, // Setting the maximum slightly above 10,000
                            divisions: 100,
                            labels: RangeLabels(
                              '₹${_minPrice.round()}',
                              _maxPrice >= 10000 ? '₹10,000+' : '₹${_maxPrice.round()}',
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _minPrice = values.start;
                                _maxPrice = values.end > 10000 ? 10000 : values.end;
                              });
                            },
                          ),
                          SizedBox(height: 5),
                          // Price labels below the slider
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('₹100', style: TextStyle(fontSize: 12)),
                                Text('₹2,500', style: TextStyle(fontSize: 12)),
                                Text('₹5,000', style: TextStyle(fontSize: 12)),
                                Text('₹7,500', style: TextStyle(fontSize: 12)),
                                Text('₹10,000+', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            'Reviews',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          SizedBox(height: 10,),
                          Column(
                            spacing: 5,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('4.5 and above',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.brown,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ) // rating
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        review5 = !review5;
                                        review4 = false;
                                        review3 = false;
                                        review2 = false;
                                        review1 = false;
                                        review0 = false;
                  
                  
                                      });
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.brown, width: 2),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: review5 ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('4.0 - 4.5',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.brown,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ) // rating
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        review4 = !review4;
                                        review5 = false;
                                        review3 = false;
                                        review2 = false;
                                        review1 = false;
                                        review0 = false;
                  
                  
                                      });
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.brown, width: 2),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: review4 ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('3.5 - 4.0',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.brown,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ) // rating
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        review3 = !review3;
                                        review5 = false;
                                        review4 = false;
                                        review2 = false;
                                        review1 = false;
                                        review0 = false;
                  
                  
                                      });
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.brown, width: 2),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: review3 ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('3.0 - 3.5',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.brown,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ) // rating
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        review2 = !review2;
                                        review5 = false;
                                        review4 = false;
                                        review3 = false;
                                        review1 = false;
                                        review0 = false;


                                      });
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.brown, width: 2),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: review2 ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('2.5 - 3.0',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.brown,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ) // rating
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        review1 = !review5;
                                        review5 = false;
                                        review4 = false;
                                        review3 = false;
                                        review2 = false;
                                        review0 = false;


                                      });
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.brown, width: 2),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: review1 ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.yellow,),
                                      Text('2.5 and below',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.brown,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ) // rating
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        review0 = !review0;
                                        review5 = false;
                                        review4 = false;
                                        review3 = false;
                                        review2 = false;
                                        review1 = false;


                                      });
                                    },
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.brown, width: 2),
                                            borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                                color: review0 ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 100,),
                  
                  
                  
                        ],
                      ),
                  
                  
                  
                    ],
                  
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Navig(),));
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
              Positioned(
                bottom: 0,
                child: Container(
                  height: 100,
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
                    padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            height: 50,
                            width: .45 * MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                'Reset Filter',
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Navig(),));
                          },
                          child: Container(
                            height: 50,
                            width: .45 * MediaQuery.of(context).size.width,
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
                      ],
                    )
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

class FilterOptions extends StatefulWidget {
  final List<String> titles;

  const FilterOptions({
    Key? key,
    required this.titles,
  }) : super(key: key);

  @override
  State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
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
                  fontWeight: FontWeight.w700,),
              ),
            ),
          );
        }),
      ),
    );
  }
}

