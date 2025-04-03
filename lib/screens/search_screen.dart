import 'package:flutter/material.dart';

import 'search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    // Clean up the controller and focus node
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body:SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
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
                              child: TextFormField(
                                onFieldSubmitted: (value) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResults(),));
                
                                },
                                controller: _searchController,
                                focusNode: _focusNode,
                                cursorColor: Colors.brown,
                                decoration: InputDecoration(
                                    hintText: 'Search ',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                ),
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
                        Text('Recent',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700),
                        ),
                        Text('Clear All',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.brown,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Brown jacket',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                
                        ),
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.brown,
                                width: 2
                              )
                            ),
                            child: Icon(Icons.close, color: Colors.brown, size: 15,))
                      ],
                    ),
                    SizedBox(height: 10,),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Brown jacket',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                
                        ),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.brown,
                                    width: 2
                                )
                            ),
                            child: Icon(Icons.close, color: Colors.brown, size: 15,))
                      ],
                    ),
                    SizedBox(height: 10,),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Brown jacket',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                
                        ),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.brown,
                                    width: 2
                                )
                            ),
                            child: Icon(Icons.close, color: Colors.brown, size: 15,))
                      ],
                    ),
                    SizedBox(height: 10,),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Brown jacket',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                
                        ),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.brown,
                                    width: 2
                                )
                            ),
                            child: Icon(Icons.close, color: Colors.brown, size: 15,))
                      ],
                    ),
                    SizedBox(height: 10,),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Brown jacket',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500),
                
                        ),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.brown,
                                    width: 2
                                )
                            ),
                            child: Icon(Icons.close, color: Colors.brown, size: 15,))
                      ],
                    )
                
                
                
                
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
        )
      ),
    );
  }
}
