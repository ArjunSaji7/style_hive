import 'package:flutter/material.dart';

import 'sign_in.dart';

class NewPassword extends StatefulWidget {
  final String email; // Pass email from previous screen

  const NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.brown, width: 2)),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.brown,
                      ),
                    )),
              ),
              SizedBox(height: 20,),
              Text(
                "New Password",
                style: TextStyle(
                  fontFamily: 'Inter',
                    fontWeight: FontWeight.w700, fontSize: 24),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Your new password must be different from previously used passwords",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500, fontSize: 14),
                  )),
              SizedBox(height: 10,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: '***********',
                      hintStyle: TextStyle(color: Colors.grey),
                      border:InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText1
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText1,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Confirm Password',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500, fontSize: 14),
                  )),
              SizedBox(height: 10,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4),
                  child: TextField(
                    controller: _confirmPassController,
                    decoration: InputDecoration(
                      hintText: '***********',
                      hintStyle: TextStyle(color: Colors.grey),
                      border:InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText2
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText2,
                  ),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  if(_passwordController.text.isNotEmpty && _confirmPassController.text.isNotEmpty && _passwordController.text == _confirmPassController.text ){
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.brown,
                            content: Text('Password changed successfully')));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.brown,
                            content: Text('Password not matching')));
                  }
                },
                child: Container(
                  width: 240,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Color.fromRGBO(69, 123, 140, 10),
                          width: 1)),
                  child: Center(
                    child: Text(
                      "Create New Password",
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
        ),
      )
    );
  }
}
