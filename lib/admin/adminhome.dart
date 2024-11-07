import 'package:flutter/material.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/methods.dart';
import 'package:stage_app/signin.dart';

class Homeadmin extends StatefulWidget {
  @override
  Homeadminpage createState() => Homeadminpage();
}

class Homeadminpage extends State<Homeadmin> {
  List<String> farmers = [];
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
                    style: TextStyle(
                        color: AppColors.vertnormal, fontFamily: 'titre'),
                  ),
                  TextSpan(
                    text:
                        ' As an admin, you have the privilege to manage and perform CRUD (Create, Read, Update, Delete) operations for farmers and their trees. '
                        'This includes maintaining farmer profiles, managing tree information, and making necessary updates as required.\n\n',
                  ),
                  TextSpan(
                    text: '2. Farmer:',
                    style: TextStyle(
                        color: AppColors.vertnormal, fontFamily: 'titre'),
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
                    style: TextStyle(
                        color: AppColors.vertnormal, fontFamily: 'titre'),
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
        color: AppColors.vertclaire,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: EdgeInsets.all(15.0),
      child: contentContainer,
    );
    //Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.topbar,
        automaticallyImplyLeading: false,
        leading: Container(width: 16),
        iconTheme: IconThemeData(
          color: AppColors.vertnormal,
        ),
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'titre',
            color: AppColors.vertnormal,
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  storage.deleteAll();
                  press(context, SignIn());
                },
              ),
              Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'ecriture',
                  fontSize: 16.0,
                  color: AppColors.vertnormal,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
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
                //signup,
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: AppColors.navbar,
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, Homeadmin());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: AppColors.vertnormal),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: AppColors.vertnormal,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, FarmerListPage());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.notifications, color: Colors.grey),
                      Text(
                        "Notification",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, Users());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Colors.grey),
                      Text(
                        "Users",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    press(context, treeadmin());
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.forest,
                        color: Colors.grey,
                      ),
                      Text(
                        "Trees",
                        style: TextStyle(
                          fontFamily: 'ecriture',
                          fontSize: Size.navbar,
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
