import 'package:flutter/material.dart';

import 'onboarding2.dart';
import 'sign_in.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
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
              Padding(
                padding: const EdgeInsets.only(top: 40.0, right: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text('Skip', style: TextStyle(color:  Colors.white, fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w500),)),
                ),
              ),
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
                            text: 'Seamless ',
                            style: TextStyle(color: Colors.brown, fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900),
                            children: [
                              TextSpan(
                                text: 'Shopping Experience ',
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
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.brown,
                              ),
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),CircleAvatar(
                                radius: 4,
                                backgroundColor: Colors.grey,
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Onboarding2(),));
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
