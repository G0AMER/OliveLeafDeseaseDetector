import 'package:flutter/material.dart';
import 'package:stage_app/admin/adminhome.dart';
import 'package:stage_app/expert/expertpage.dart';
import 'package:stage_app/farmer/farmernavbuttombar.dart';
import 'package:stage_app/home.dart';
import 'package:stage_app/signup.dart';
import 'package:stage_app/methods.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = FlutterSecureStorage();

  late Widget champsEmail;
  late Widget champsPassword;

  @override
  void initState() {
    super.initState();
    champsEmail = CustomTextField1(
      hintText: 'Email',
      obscureText: false,
      controlleur: emailController,
    );

    champsPassword = CustomTextField1(
      hintText: 'Password',
      obscureText: true,
      controlleur: passwordController,
    );
  }

  void signin(BuildContext context) async {
    try {
      String email = emailController.text;
      String password = passwordController.text;
      // Call the backend API to authenticate the user
      var url = Path.globalpath + '/signin'; // Replace with your server URL

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var isAdmin = responseBody['role'];
        print(isAdmin);

        if (isAdmin == 'admin') {
          // Store the information
          if (isChecked) {
            storage.write(key: 'email', value: email);
            storage.write(key: 'password', value: password);
            storage.write(key: 'role', value: isAdmin);
          } else {
            storage.deleteAll();
          }
          press(context, Homeadmin());
        } else if (isAdmin == 'farmer') {
          // Store the information
          if (isChecked) {
            storage.write(key: 'email', value: email);
            storage.write(key: 'password', value: password);
            storage.write(key: 'role', value: isAdmin);
          } else {
            storage.deleteAll();
          }
          press(context, FarmerPage(0));
        } else {
          // Store the information
          if (isChecked) {
            storage.write(key: 'email', value: email);
            storage.write(key: 'password', value: password);
            storage.write(key: 'role', value: isAdmin);
          } else {
            storage.deleteAll();
          }
          press(context, ExpertApp());
        }
      } else if (response.statusCode == 400) {
        // User authentication failed
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              title: 'Authentication Failed',
              contentText: 'Invalid email or password.',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Error',
            contentText: 'An error occurred during the authentication process.',
            onOkPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    Widget check = Container(
      child: Checkbox(
        value: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
        },
        activeColor: AppColors.vertnormal,
        checkColor: Colors.black,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.vertclaire,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            press(context, HomeScreen());
          },
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  press(context, SignIn());
                },
              ),
              Text(
                'Sign In',
                style: TextStyle(
                  fontFamily: 'ecriture',
                  fontSize: 16.0,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.person_add),
                onPressed: () {
                  press(context, SignUp());
                },
              ),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontFamily: 'ecriture',
                  fontSize: 16.0,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: AppColors.vertclaire,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 30)),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 44.0,
                        fontFamily: 'titre',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'ecriture',
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 30)),
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
                        champsPassword,
                        SizedBox(height: 20),
                        Row(
                          children: [
                            check,
                            Expanded(
                              child: Text(
                                'Keep me logged in',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'ecriture',
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            signin(context);
                          },
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
                            primary: AppColors.vertclaire,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(
                                color: AppColors.vertclaire,
                                width: 1.0,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
