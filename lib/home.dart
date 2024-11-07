import 'package:flutter/material.dart';
//import 'package:stage_app/explore.dart';
import 'package:stage_app/intro.dart';
import 'package:stage_app/methods.dart';
import 'package:stage_app/signin.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/back.png'), // Replace with your image path
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 300.0),
            child: Column(
              children: [
                Text(
                  'Olive Leaf Disease',
                  style: TextStyle(
                    fontSize: 44.0,
                    fontFamily: 'titre',
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Detector',
                      style: TextStyle(
                        fontSize: 44.0,
                        fontFamily: 'titre',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Image.asset(
                      'assets/loop.png', // Replace with your image path
                      height: 50.0, // Set the desired height of the image
                      width: 50.0, // Set the desired width of the image
                    ),
                  ],
                ),
                SizedBox(height: 160.0),
                ElevatedButton(
                  onPressed: () => press(context, OnboardingScreen()),
                  child: Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: Color.fromARGB(255, 228, 241, 228),
                        width: 1.0,
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                  ),
                ),
                SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () => press(context, SignIn()),
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontFamily: 'ecriture',
                      fontSize: 26.0,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: Color.fromARGB(255, 228, 241, 228),
                        width: 1.0,
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
