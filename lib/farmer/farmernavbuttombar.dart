import 'package:flutter/material.dart';
import 'package:stage_app/farmer/farmerhome.dart';
import 'package:stage_app/farmer/farmertree.dart';
import 'package:stage_app/farmer/predict.dart';
import 'package:stage_app/farmer/recommanded.dart';

import 'package:stage_app/methods.dart';

import '../signin.dart';
/*import 'farmerhomepage.dart';
import 'farmerpredictpage.dart';
import 'farmerrecommendpage.dart';
import 'farmertreepage.dart';
import 'home.dart';
import 'methods.dart';*/

void main() {
  runApp(FarmerApp());
}

class FarmerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer App',
      theme: ThemeData(
        primaryColor: Color(0xFF2B664F), // Dark green color for the app bar
        hintColor: Color(0xFF349E74), // Light green color for buttons
        scaffoldBackgroundColor:
            Color.fromARGB(248, 255, 255, 255), // Background color for the app
      ),
      home: FarmerPage(_currentIndex),
    );
  }
}

class FarmerPage extends StatefulWidget {
  FarmerPage(int _currentIndex);

  @override
  _FarmerPageState createState() => _FarmerPageState();
}

int _currentIndex = 0;

class _FarmerPageState extends State<FarmerPage> {
  final List<Widget> _pages = [
    FarmerHomePage(),
    PredictPage(),
    LeavesPage(),
    RecommendPage(),
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
            fontSize: 29.0,
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
                  _currentIndex = 0;

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
        color: Color.fromARGB(255, 228, 241, 228),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30.0),
            ),
            //SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0.0),
                  ),
                ),
                child: _pages[_currentIndex],
              ),
            ),
          ],
        ),
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
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Predict',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_rounded),
            label: 'Trees',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommend',
            backgroundColor: Colors.white,
          ),
        ],
        selectedItemColor: AppColors.vertnormal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 18,
          decoration: TextDecoration.underline,
          fontFamily: 'ecriture',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'ecriture',
          fontSize: 18,
        ),
      ),
    );
  }
}
