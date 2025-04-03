import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyCLYFmTzQHOwsqEkLKKAWwIisZd46j6D-Q',
    authDomain: 'style-hive-3b54b.firebaseapp.com',
    projectId: 'style-hive-3b54b',
    storageBucket: 'style-hive-3b54b.appspot.com',
    messagingSenderId: '157870663802',
    appId: '1:157870663802:android:4ab039409aca0705a833c3',
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}