
import 'package:flutter/material.dart';

import 'onboarding1.dart';
import 'sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.grey,
                      width: 1
                  )
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 170,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          image: DecorationImage(image: AssetImage('assets/welcome_img1.jpg'), fit: BoxFit.fill)
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        children: [
                          Container(
                            width: 140,
                            height: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                image: DecorationImage(image: AssetImage('assets/close-up-indoor-studio-fashion.jpg'), fit: BoxFit.cover)
                            ),
                          ),
                          SizedBox(height: 15,),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/model-posing-with-chair.jpg'),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(text: TextSpan(
                        text: 'The ',
                          style: TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900),
                        children: [
                          TextSpan(
                            text: 'Fashion App ',
                            style: TextStyle(color: Colors.brown, fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900),
                          ),
                          TextSpan(
                            text: 'That Make You Look Your Best',
                            style: TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900),
                          )
                        ]
                      ) ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Step into style and explore the latest trends curated just for you. Elevate your wardrobe with effortless fashion at your fingertips!',
                            style: TextStyle(fontSize: 14,fontFamily: 'Inter', color: Colors.grey, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Onboarding1()));
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration:BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(20)
                        ),
                       child: Center(child: Text("Let's Get Started",
                         style: TextStyle(
                             fontSize: 16,
                             color: Colors.white,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w500),
                       )),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          )
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                        },
                        child: Text('Sign In',
                          style: TextStyle(
                              color: Colors.brown,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.brown),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: -70,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.grey,
                      width: 1
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
