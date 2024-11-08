import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_booking_app/screens/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 62, 92),
      body: Center(
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(10),
              child: Image(image: AssetImage('assets/karte-dribbble.jpg')),),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'T i c k e t  Please',
                  style: TextStyle(
                      color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                      
                )
              ),
              Text('It All Starts Here!',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28,))
            ],
          ),
          

          
          
        
        
      ),
    );
  }
}
