import 'package:flutter/material.dart';

class EnterLocation extends StatefulWidget {
  const EnterLocation({super.key});

  @override
  State<EnterLocation> createState() => _EnterLocationState();
}

class _EnterLocationState extends State<EnterLocation> {
  var _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
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
                        size: 30,
                        Icons.arrow_back,
                        color: Colors.brown,
                      ),
                    )),
              ),
              Text(
                "Enter Your Location",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700, fontSize: 18),
              ),
              SizedBox(height: 20,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.grey
                    )
                ),
                child:Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                      size: 30,
                      color: Colors.brown,
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: 'Search Location',
                            hintStyle: TextStyle(color: Colors.grey,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14
                            ),
                              border:InputBorder.none
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _locationController.text = '';
                          });
                        },
                        child: Icon(Icons.close,
                          size: 30,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: GestureDetector(
                  onTap: () {
          
                  },
                  child: Row(
                    children: [
                      Icon(Icons.my_location,
                        size: 30,
                        color: Colors.brown,
                      ),
                      SizedBox(width: 5,),
                      Text('Use my current location',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('SEARCH RESULT',
                  style: TextStyle(
                    color: Colors.grey,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 150,
                  width: 200,
                  child:Column(
                    children: [
                      Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.location_searching,
                            size: 30,
                            color: Colors.brown,
                          ),
                          Text('Golden Avenue',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          )
                        ],
                      ),
                      Text('8502 Preston Rd. Ingl....',
                        style: TextStyle(
                          color: Colors.grey,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
