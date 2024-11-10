import 'dart:convert';

import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/admin/requests.dart';
import 'package:stage_app/admin/trees.dart';
import 'package:stage_app/admin/users.dart';
import 'package:stage_app/methods.dart';

class formulaire extends StatefulWidget {
  @override
  formulairepage createState() => formulairepage();
}

class formulairepage extends State<formulaire> {
  List<String> farmers = [];

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  late Widget champsEmail;
  late Widget champsname;
  late Widget champspassword;

  List<dynamic> adminList = [];

  void fetchadmin() async {
    try {
      var url =
          '${Path.globalpath}/get_admin'; // Replace with your server URL or API endpoint

      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var admin =
            data as List<dynamic>; // Update here to access the array directly

        setState(() {
          adminList = admin;

          print(adminList);
        });
      } else {
        print('failed to get admin email');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
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
    fetchadmin();
  }

  @override
  Widget build(BuildContext context) {
    void sendEmail(String expertEmail) async {
      try {
        await EmailJS.send(
          'service_enyog9s',
          'template_0sb6e5s',
          {
            'expert_username': namecontroller.text,
            'user_email': expertEmail,
            'password': passwordcontroller.text,
          },
          const Options(
            publicKey: 'fLHQEuMDcSNX2lIB5',
            privateKey: 'Icmh8PoaoTw4h_Kex9_Gx',
          ),
        );
        print('SUCCESS!');
      } catch (error) {
        if (error is EmailJSResponseStatus) {
          print('ERROR... ${error.status}: ${error.text}');
        }
        print(error.toString());
      }
    }

    void signUp() async {
      String name = namecontroller.text;
      String email = emailcontroller.text;
      String password = passwordcontroller.text;
      var url = Path.globalpath + '/addfarmer';
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'User created successefully',
              onOkPressed: () {
                press(context, Users());
              },
            );
          },
        );
      } else {
        var errorMessage = 'Failed to create a new user.';
        if (response.statusCode == 400) {
          var body = jsonDecode(response.body);
          if (body.containsKey('message')) {
            var message = body['message'];
            if (message == 'Email already exists') {
              errorMessage = 'User already exists with this email.';
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

    void signUpexpert() async {
      String name = namecontroller.text;
      String email = emailcontroller.text;
      String password = passwordcontroller.text;
      var url = Path.globalpath + '/add-expert';

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Success',
              contentText: 'User created successfully',
              onOkPressed: () {
                press(context, Users());
              },
            );
          },
        );
      } else {
        var errorMessage = 'Failed to create a new user.';
        if (response.statusCode == 400) {
          var body = jsonDecode(response.body);
          if (body.containsKey('message')) {
            var message = body['message'];
            if (message == 'Email already exists') {
              errorMessage = 'User already exists with this email.';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.topbar,
        automaticallyImplyLeading: false,
        leading: Container(width: 16),
        iconTheme: IconThemeData(
          color: AppColors.vertnormal,
        ),
        title: Text(
          'Add new user',
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
                TwoButtonRow(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedButton == 1) {
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
                        } else
                          signUp();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'Obligation',
                              contentText:
                                  'You must give all the information. ',
                              onOkPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      }
                    } else if (selectedButton == 2) {
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
                          if (mounted) {
                            signUpexpert();
                            sendEmail(emailcontroller.text);
                          }
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: 'Obligation',
                              contentText:
                                  'You must give all the information. ',
                              onOkPressed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      }
                    }
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

int selectedButton = 1;

class TwoButtonRow extends StatefulWidget {
  @override
  _TwoButtonRowState createState() => _TwoButtonRowState();
}

class _TwoButtonRowState extends State<TwoButtonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedButton = 1;
            });
          },
          child: Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: selectedButton,
                activeColor: AppColors.vertnormal,
                onChanged: (value) {
                  setState(() {
                    selectedButton = value!;
                  });
                },
              ),
              Text(
                'farmer',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedButton = 2;
            });
          },
          child: Row(
            children: [
              Radio<int>(
                value: 2,
                groupValue: selectedButton,
                activeColor: AppColors.vertnormal,
                onChanged: (value) {
                  setState(() {
                    selectedButton = value!;
                  });
                },
              ),
              Text(
                'expert',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'ecriture',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
