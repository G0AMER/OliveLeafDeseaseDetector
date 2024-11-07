import 'package:flutter/material.dart';
import 'package:stage_app/explore.dart';

class leaves extends StatelessWidget {
  void _press(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Explore()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      /*appBar: AppBar(
          title: Text('Leaves'),
          centerTitle: true,
        ),
        body: Center(
          //centre widget which contain child: Text
          child: Text('Hello dear farmers.'),
        )*/
    ]);
  }
}
/*import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  void _press() {
    //print('Button 1 pressed!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Padding(
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
                Text(
                  'Detector',
                  style: TextStyle(
                    fontSize: 44.0,
                    fontFamily: 'titre',
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: _press,
              child: Text(
                'Explore',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF0EDED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                fixedSize: Size(140, 50),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: _press,
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'ecriture',
                  fontSize: 30.0,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF0EDED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                fixedSize: Size(140, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
