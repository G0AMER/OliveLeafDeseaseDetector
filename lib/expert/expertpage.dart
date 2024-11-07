import 'package:flutter/material.dart';
import '../signin.dart';
import 'experthomepage.dart';
import 'expertleavespage.dart';
import 'expertrequestpage.dart';
import 'package:stage_app/methods.dart';

void main() {
  runApp(ExpertApp());
}

class ExpertApp extends StatelessWidget {
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
      home: ExpertPage(_currentIndex),
    );
  }
}

class ExpertPage extends StatefulWidget {
  ExpertPage(int _currentIndex);

  @override
  _ExpertPageState createState() => _ExpertPageState();
}

int _currentIndex = 0;

class _ExpertPageState extends State<ExpertPage> {
  final List<Widget> _pages = [
    ExpertHomePage(),
    RequestPage(),
    ExpertLeavesPage(),
  ];
  final List<String> titles = [
    "Home Page",
    'Request Page',
    'Leaves Page',
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
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_rounded),
            label: 'Requests',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_rounded),
            label: 'Leaves',
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
