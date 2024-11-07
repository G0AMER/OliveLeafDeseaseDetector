import 'package:flutter/material.dart';
import 'package:stage_app/home.dart';
import 'package:stage_app/signup.dart';
import 'package:stage_app/methods.dart';

class Explore extends StatelessWidget {
  final Widget signup = Button(contenu: 'Sign Up', destinationPage: SignUp());
  final Widget content = SizedBox(
    height: 600.0, // Set the desired fixed height
    child: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Text(
              '\nWelcome to our Olive Leaf Disease Detector application, designed specifically for farmers like you. '
              'Our primary goal is to simplify your farming activities by providing a reliable tool to detect diseases in your olive tree leaves. '
              'To access our services, you need to sign in to our application, which offers three user classes:\n\n',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'ecriture',
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
                children: [
                  TextSpan(
                    text: '1. Admin:',
                    style: TextStyle(color: Colors.green, fontFamily: 'titre'),
                  ),
                  TextSpan(
                    text:
                        ' As an admin, you have the privilege to manage and perform CRUD (Create, Read, Update, Delete) operations for farmers and their trees. '
                        'This includes maintaining farmer profiles, managing tree information, and making necessary updates as required.\n\n',
                  ),
                  TextSpan(
                    text: '2. Farmer:',
                    style: TextStyle(color: Colors.green, fontFamily: 'titre'),
                  ),
                  TextSpan(
                    text:
                        ' As a farmer, you can perform CRUD operations on your own leaves. '
                        'This means you can create, view, update, and delete leaf records. '
                        'You also have the option to upload images of leaves from your gallery or directly from your camera. '
                        'Our application utilizes these images to predict whether the leaves are healthy or affected by diseases. '
                        'Additionally, you can access information about your trees through the application.\n\n',
                  ),
                  TextSpan(
                    text: '3. Expert:',
                    style: TextStyle(color: Colors.green, fontFamily: 'titre'),
                  ),
                  TextSpan(
                    text:
                        ' The expert user class is responsible for viewing the uploaded leaves and providing expert insights. '
                        'They have the ability to add comments to the leaves, sharing their expertise and advice regarding the identified diseases. '
                        'They can also add new leaves to the system when necessary.\n\n'
                        'By offering these functionalities, our application aims to empower farmers in diagnosing and managing diseases in olive tree leaves effectively. '
                        'We are dedicated to supporting you throughout your farming journey and ensuring the health and productivity of your olive trees.\n'
                        'If you are interested in our application, we invite you to sign up and become a valued member of our community.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget contentContainer = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      child: content,
    );
    Widget finalContainerWithSpacing = Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 228, 241, 228),
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: EdgeInsets.all(15.0),
      child: contentContainer,
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              press(context, HomeScreen());
            },
          ),
          title: Text(
            'About Us',
            style: TextStyle(
              fontSize: 30.0,
              fontFamily: 'titre',
              color: Colors.black,
              decoration:
                  TextDecoration.none, // Set the desired color for the text
            ),
          ),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  finalContainerWithSpacing,
                  SizedBox(height: 10.0),
                  signup,
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ]),
        ));
  }
}
