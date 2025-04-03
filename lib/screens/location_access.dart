import 'package:flutter/material.dart';

import 'enter_location.dart';

class LocationAccess extends StatefulWidget {
  const LocationAccess({super.key});

  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Color.fromRGBO(211,211,211,1),
            child: Icon(Icons.location_on,
            size: 60,
              color: Colors.brown,
            ),
          ),
          SizedBox(height: 10,),
          Text('What is your location?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 24),
          ),
          SizedBox(height: 10,),
          Text(
            'We need to know your location in order to suggest nearby services.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                fontSize: 14),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {

              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                      "Allow Location Access",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    )),
              ),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EnterLocation()));
            },
            child: Text(
              'Enter Location Manually',
              style: TextStyle(
                  color: Colors.brown,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  decorationColor: Colors.brown),
            ),
          )


        ],
      ),
    );
  }
}
