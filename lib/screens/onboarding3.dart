import 'package:flutter/material.dart';

import 'sign_in.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 60,),
              Container(
                height:250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/black_shoes.png'),
                    )
                ),
              ),
              Container(
                height: 350,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only( topRight: Radius.circular(40), topLeft: Radius.circular(40))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0 , left: 10, right: 10),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: 'Swift ',
                                style: TextStyle(color: Colors.brown, fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900),
                                children: [
                                  TextSpan(
                                    text: 'And ',
                                    style: TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(
                                    text: 'Reliable ',
                                    style: TextStyle(color: Colors.brown, fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900),
                                  ),
                                  TextSpan(
                                    text: '\nDelivery ',
                                    style: TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900),
                                  ),
                                ]
                            ) ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          'Step into style and explore the latest trends curated just for you. Elevate your wardrobe with effortless fashion at your fingertips!',
                          style: TextStyle(fontSize: 14,fontFamily: 'Inter', color: Colors.grey, fontWeight: FontWeight.w300),
                        ),
                      ),
                      SizedBox(height: 60,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.brown, width: 2)),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.brown,
                                  size: 30,
                                ),
                              )),
                          Row(
                            spacing: 4,
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.brown,
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn(),));
                              },
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.brown,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.brown, width: 2)),
                                child: Icon(
                                  size: 30,
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
