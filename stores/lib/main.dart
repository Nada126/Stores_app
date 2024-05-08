import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores/blocs/distance_bloc.dart';
import 'screens/signup.dart';  
import 'screens/home_screen.dart';
import 'providers/store_provider.dart';
import 'screens/login.dart';  
import 'providers/position_provider.dart'; // Import the PositionProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => PositionProvider()), // Provide the PositionProvider
        Provider(create: (_) => DistanceBloc()),
      ],
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