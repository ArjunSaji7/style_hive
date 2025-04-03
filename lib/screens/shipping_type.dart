import 'package:flutter/material.dart';

import 'checkout_screen.dart';

class ShippingType extends StatefulWidget {
  const ShippingType({super.key});

  @override
  State<ShippingType> createState() => _ShippingTypeState();
}

class _ShippingTypeState extends State<ShippingType> {

  bool _shippingEconomy = true;
  bool _shippingRegular = false;
  bool _shippingCargo = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Choose Shipping',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 30,),
                        Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                    child: Image.asset('assets/express-delivery.png', height: 30, width: 30,),
                                  )
                              ),
                              SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 80,
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Economy",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text('Estimated Arrival 20 Feb 2025',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 30,),
                              SizedBox(
                                width: 50,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _shippingEconomy = !_shippingEconomy;
                                        _shippingRegular = false;
                                        _shippingCargo = false;
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
                                                color: _shippingEconomy ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                    child: Image.asset('assets/express-delivery.png', height: 30, width: 30,),
                                  )),
                              SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 80,
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Regular",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text('Estimated Arrival 17 Feb 2025',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 30,),
                              SizedBox(
                                width: 50,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _shippingRegular = !_shippingRegular;
                                        _shippingEconomy = false;
                                        _shippingCargo = false;
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
                                                color: _shippingRegular ? Colors.brown : Colors.transparent,
                                                border: Border.all(color: Colors.transparent, width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                    child: Image.asset('assets/express-delivery.png', height: 30, width: 30,),
                                  )),
                              SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 80,
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Cargo",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text('Estimated Arrival 15 Feb 2025',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300),

                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 30,),
                              SizedBox(
                                width: 50,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _shippingCargo = !_shippingCargo;
                                        _shippingEconomy = false;
                                        _shippingRegular = false;
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
                                            color: _shippingCargo ? Colors.brown : Colors.transparent,
                                              border: Border.all(color: Colors.transparent, width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                        ),
                                                                      ),
                                      )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(),));

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 30),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
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
                ),
              )

            ],
          )
      ),
    );
  }
}
