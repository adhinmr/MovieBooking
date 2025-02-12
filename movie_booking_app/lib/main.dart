import 'package:flutter/material.dart';
import 'package:movie_booking_app/provider/moviebooking_provider.dart';
import 'package:movie_booking_app/screens/splash.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieBookingProvider(), // Initialize your provider
      child: const MainApp(),
      ),
    ) ;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
    
  }
}
