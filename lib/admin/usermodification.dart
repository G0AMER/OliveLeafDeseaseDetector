import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/methods.dart';

class Modification extends StatefulWidget {
  final String userName;

  const Modification({required this.userName});

  @override
  _ModificationState createState() => _ModificationState();
}

class _ModificationState extends State<Modification> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  late Widget champsEmail;
  late Widget champsname;
  late Widget champspassword;
  @override
  void initState() {
    super.initState();
    emailcontroller.text = widget.userName;
    champsEmail = CustomTextField1(
      hintText: 'Email',
      obscureText: false,
      controlleur: emailcontroller,
    );
    champsname = CustomTextField1(
      hintText: 'Name',
      obscureText: false,
      controlleur: namecontroller,
    );
    champspassword = CustomTextField1(
      hintText: 'Password',
      obscureText: true,
      controlleur: passwordcontroller,
    );
  }

  int n = 0;
  Future<void> updateFarmerNameByEmail(String email, String name) async {
    final url = Uri.parse(Path.globalpath + '/update-farmer-name');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'name': name});
    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        //Farmer name updated successfully
        n = 0;
      } else if (response.statusCode == 404) {
        //Farmer not found
        n = 1;
      } else {
        //Failed to update farmer name
        n = 2;
      }
    } catch (error) {
      //An error occurred
      n = 3;
    }
  }

  int em = 0;
  Future<void> updateFarmerEmail() async {
    final String url = Path.globalpath +
        '/update-farmer-email'; // Replace with your server's endpoint
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> data = {
      'currentEmail': widget.userName,
      'newEmail': emailcontroller.text,
    };
    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        //success
        em = 0;
      } else if (response.statusCode == 404) {
        //Farmer not found
        em = 1;
      } else if (response.statusCode == 409) {
        //Email already exists for another user
        em = 2;
      } else {
        //An error occurred while updating farmer email.'),
        em = 3;
      }
    } catch (e) {
      //An error occurred while updating farmer email
      em = 4;
    }
  }

  int p = 0;
  Future<void> updateFarmerPassword() async {
    final String url = Path.globalpath +
        '/update-farmer-password'; // Replace with your server's endpoint

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> data = {
      'email': widget.userName,
      'newPassword': passwordcontroller.text,
    };

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        //success
        p = 0;
      } else if (response.statusCode == 404) {
        //Farmer not found
        p = 1;
      } else {
        //An error occurred while updating farmer password
        p = 2;
      }
    } catch (e) {
      //An error occurred while updating farmer password.
      p = 3;
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
          'Modification',
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
                  press(context, Users());
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
                    'Username',
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
                    'Email Address',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                champsEmail,
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                champspassword,
                SizedBox(height: 20),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (emailcontroller.text.trim().isNotEmpty &&
                        namecontroller.text.trim().isNotEmpty &&
                        passwordcontroller.text.trim().isNotEmpty) {
                      if (!isEmailValid(emailcontroller.text)) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'Obligation',
                              contentText:
                                  'This form of email is not available.',
                              onOkPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      } else {
                        updateFarmerNameByEmail(
                            widget.userName, namecontroller.text);

                        if (n == 0) {
                          updateFarmerEmail();
                        }
                        if (em == 0) {
                          updateFarmerPassword();
                        }
                        if ((em == 0) && (p == 0) && (n == 0)) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: 'Success',
                                contentText: 'User modified successfully',
                                onOkPressed: () {
                                  press(context, Users());
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('An error !'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            title: 'Obligation',
                            contentText: 'You must give all the information. ',
                            onOkPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    'modify',
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
                )
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
                      Icon(Icons.person, color: AppColors.vertnormal),
                      Text(
                        "Users",
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
