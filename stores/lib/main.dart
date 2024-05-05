import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/signup.dart';  
import 'screens/home_screen.dart';
import 'providers/store_provider.dart';
import 'screens/login.dart';  

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StoreProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SignupPage(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const Login(),
          
        },
      ),
    );
  }
}