import 'package:flutter/material.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';

import 'package:stage_app/methods.dart';
import 'package:stage_app/signin.dart';

void main() {
  runApp(Homeadmin());
}

class FarmerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer App',
      theme: ThemeData(
        primaryColor: Colors.green[900], // Dark green color for the app bar
        hintColor: Colors.green[500], // Light green color for buttons
        scaffoldBackgroundColor:
            Color.fromARGB(248, 255, 255, 255), // Background color for the app
      ),
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _adminPageState createState() => _adminPageState();
}

class _adminPageState extends State<AdminPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Homeadmin(),
    FarmerListPage(),
    Users(),
    treeadmin(),
  ];
  final List<String> titles = [
    "Home Page",
    'Predict Page',
    'Trees Monitoring',
    'Recommendations'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.topbar,
        automaticallyImplyLeading: false,
        leading: Container(width: 16),
        iconTheme: IconThemeData(
          color: AppColors.vertnormal,
        ),
        title: Text(
          titles[_currentIndex],
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
      body: Container(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.navbar,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forest),
            label: 'Trees',
            backgroundColor: Colors.white,
          ),
        ],
        selectedItemColor: AppColors.vertnormal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'ecriture',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'ecriture',
          fontSize: 14,
        ),
      ),
    );
  }
}
