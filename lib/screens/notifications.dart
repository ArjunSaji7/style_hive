import 'package:flutter/material.dart';

import 'navig.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0,),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
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
                    Text('Notifications',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700),
          
                    ),
                    Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.brown
                      ),
                      child: Center(
                        child: Text('2 New',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TODAY',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
                    Text('Mark all as read',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Message(notificationData: {
                  'icon' : Icons.fire_truck,
                  'title': 'Order Delivered',
                  'message': 'Your order #[Order Number] has been delivered. We hope you enjoy your [product name(s)]! Need help? Contact us at [contact email/phone number].Thank you for shopping with [Your Business Name]!',
                  'time': '1h'
                }),
                Message(notificationData: {
                  'icon' : Icons.fire_truck,
                  'title': 'Order Delivered',
                  'message': 'Your order #[Order Number] has been delivered. We hope you enjoy your [product name(s)]! Need help? Contact us at [contact email/phone number].Thank you for shopping with [Your Business Name]!',
                  'time': '1h'
                }),Message(notificationData: {
                  'icon' : Icons.fire_truck,
                  'title': 'Order Delivered',
                  'message': 'Your order #[Order Number] has been delivered. We hope you enjoy your [product name(s)]! Need help? Contact us at [contact email/phone number].Thank you for shopping with [Your Business Name]!',
                  'time': '1h'
                }),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('YESTERDAY',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
                    Text('Mark all as read',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Message(notificationData: {
                  'icon' : Icons.fire_truck,
                  'title': 'Order Delivered',
                  'message': 'Your order #[Order Number] has been delivered. We hope you enjoy your [product name(s)]! Need help? Contact us at [contact email/phone number].Thank you for shopping with [Your Business Name]!',
                  'time': '36h'
                }),
                Message(notificationData: {
                  'icon' : Icons.fire_truck,
                  'title': 'Order Delivered',
                  'message': 'Your order #[Order Number] has been delivered. We hope you enjoy your [product name(s)]! Need help? Contact us at [contact email/phone number].Thank you for shopping with [Your Business Name]!',
                  'time': '36h'
                }),Message(notificationData: {
                  'icon' : Icons.fire_truck,
                  'title': 'Order Delivered',
                  'message': 'Your order #[Order Number] has been delivered. We hope you enjoy your [product name(s)]! Need help? Contact us at [contact email/phone number].Thank you for shopping with [Your Business Name]!',
                  'time': '36h'
                }),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Message extends StatefulWidget {
  final Map<String, dynamic> notificationData;


  const Message({
    Key? key,
    required this.notificationData,
}): super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Color containerColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          containerColor = Colors.grey[200]!;

        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: containerColor,
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey[200]!))
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: Icon(widget.notificationData['icon'],
                color: Colors.brown,
                  size: 30,
                ),
              ),
            ),
            Column(
              children: [
                Text(widget.notificationData['title'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500),

                ),
                Container(
                  width: MediaQuery.of(context).size.width-120,
                  child: Text(widget.notificationData['message'],
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300),

                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(widget.notificationData['time'],
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300),
              ),
            )
          ],

        )
      ),
    );
  }
}
