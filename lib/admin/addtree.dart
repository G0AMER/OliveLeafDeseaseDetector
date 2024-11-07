import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/methods.dart';

class addtree extends StatefulWidget {
  @override
  formulairetreepage createState() => formulairetreepage();
}

class formulairetreepage extends State<addtree> {
  List<String> farmers = [];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController typecontroller = TextEditingController();
  TextEditingController linecontrolleur = TextEditingController();
  TextEditingController columncontrolleur = TextEditingController();

  late Widget champstype;
  late Widget champsname;

  @override
  void initState() {
    super.initState();
    champstype = CustomTextField1(
      hintText: 'type',
      obscureText: false,
      controlleur: typecontroller,
    );
    champsname = CustomTextField1(
      hintText: 'Name',
      obscureText: false,
      controlleur: namecontroller,
    );
  }

  void treeadd() async {
    String name = namecontroller.text;
    String column = columncontrolleur.text;
    String line = linecontrolleur.text;
    String type = typecontroller.text;

    var url = Path.globalpath + '/addtree';
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'type': type,
        'column': column,
        'line': line,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Success',
            contentText: 'Tree created successefully',
            onOkPressed: () {
              press(context, treeadmin());
            },
          );
        },
      );
    } else {
      var errorMessage = 'Failed to create a new tree.';

      if (response.statusCode == 400) {
        var body = jsonDecode(response.body);

        if (body.containsKey('message')) {
          var message = body['message'];

          if (message == 'Line and column combination already exists') {
            errorMessage =
                'Tree already exists with this combination of line and column.';
          } else if (message == 'Tree name already exists') {
            errorMessage = 'Tree with this name already exists.';
          }
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'User Creation Failed',
            contentText: errorMessage,
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

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
          'Add new Tree',
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
                icon: Icon(Icons.close),
                onPressed: () {
                  press(context, treeadmin());
                },
              ),
              Text(
                'Close',
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
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tree Name',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                champsname,
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tree Type',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                champstype,
                SizedBox(height: 10),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Line',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'ecriture',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: linecontrolleur,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'column',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'ecriture',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: columncontrolleur,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    treeadd();
                  },
                  child: Text(
                    'add',
                    style: TextStyle(
                      fontFamily: 'ecriture',
                      fontSize: 26.0,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.vertclaire,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(
                        color: AppColors.vertclaire,
                        width: 1.0,
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
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
                      Icon(Icons.home, color: Colors.grey),
                      Text(
                        "Home",
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
                        color: AppColors.vertnormal,
                      ),
                      Text(
                        "Trees",
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
            ],
          ),
        ),
      ),
    );
  }
}
