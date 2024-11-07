import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:stage_app/intro.dart';
import 'package:stage_app/leaves.dart';
import 'package:stage_app/signin.dart';
import 'package:stage_app/methods.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Widget signupfarmer = Button(contenu: 'Farmer', destinationPage: leaves());
  Widget signupexpert = Button(contenu: 'Expert', destinationPage: leaves());
  Widget signupadmin = Button(contenu: 'Admin', destinationPage: leaves());

  Widget termsAndConditionsText = RichText(
    textAlign: TextAlign.left,
    text: TextSpan(
      style: TextStyle(
        fontSize: 15.0,
        fontFamily: 'ecriture',
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      children: [
        TextSpan(
          text: 'By signing up you agree to our ',
        ),
        TextSpan(
          text: 'conditions',
          style: TextStyle(
            fontFamily: 'titre',
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: ' and ',
        ),
        TextSpan(
          text: 'privacy policy',
          style: TextStyle(
            fontFamily: 'titre',
            color: Colors.black,
          ),
        ),
      ],
    ),
  );

  bool isChecked = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  late Widget champsEmail;
  late Widget champsname;
  late Widget champspassword;

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
  }

  bool isEmailInvalid = false;
  @override
  Widget build(BuildContext context) {
    /**********/

    bool isEmailValid(String email) {
      print(email);
      // Email regex pattern for basic validation
      final RegExp emailRegex =
          RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$');

      return emailRegex.hasMatch(email);
    }

    void signUp(BuildContext context) async {
      String name = namecontroller.text;
      String email = emailcontroller.text;
      String password = passwordcontroller.text;

      // Call the backend API to create a new user
      var url = Path.globalpath + '/signup'; // Replace with your server URL

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
              title: 'User Creation done',
              contentText:
                  'User created successfully. Please wait for Admin decesion.',
              onOkPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        // User creation failed
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

    /************* */
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
            press(context, OnboardingScreen());
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
                  decoration: TextDecoration.none,
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
                  decoration: TextDecoration.underline,
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
                child: Column(children: [
                  Text(
                    'Hey, get on board',
                    style: TextStyle(
                      fontSize: 44.0,
                      fontFamily: 'titre',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Sign up to continue',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'ecriture',
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ]),
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
                        Row(
                          children: [
                            check,
                            Expanded(
                              child: termsAndConditionsText,
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            /*if (!isEmailValid(emailcontroller.text)) {
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
                            } else if (emailcontroller.text.trim().isNotEmpty &&
                                namecontroller.text.trim().isNotEmpty &&
                                passwordcontroller.text.trim().isNotEmpty) {
                              if (isChecked) {
                                signUp(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      title: 'Obligation',
                                      contentText:
                                          'Without accepting our conditions and privacy policy you can'
                                          't sign up to our application. ',
                                      onOkPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
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
                            }*/
                            ///////////////
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
                              } else if (isChecked) {
                                signUp(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      title: 'Obligation',
                                      contentText:
                                          'Without accepting our conditions and privacy policy you can'
                                          't sign up to our application. ',
                                      onOkPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
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
                          },
                          child: Text(
                            'Sign Up',
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
                                vertical: 2.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
